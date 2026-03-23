import {
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Location, Truck } from '../../entities';
import { CreateLocationDto } from './dto/create-location.dto';

@Injectable()
export class LocationsService {
  constructor(
    @InjectRepository(Location)
    private readonly locationsRepository: Repository<Location>,
    @InjectRepository(Truck)
    private readonly trucksRepository: Repository<Truck>,
  ) {}

  async findNearby(
    lat: number,
    lng: number,
    radiusKm = 2,
    limit = 20,
  ): Promise<{ data: unknown[]; total: number }> {
    const rows = await this.locationsRepository.query(
      `
      SELECT
        t.id AS truck_id,
        t.name AS truck_name,
        t.status,
        l.address_text,
        ST_Y(l.geom::geometry) AS lat,
        ST_X(l.geom::geometry) AS lng,
        ST_Distance(
          l.geom::geography,
          ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography
        ) AS distance_m
      FROM trucks t
      JOIN LATERAL (
        SELECT geom, address_text
        FROM locations
        WHERE truck_id = t.id
        ORDER BY created_at DESC
        LIMIT 1
      ) l ON true
      WHERE t.status = 'open'
        AND ST_DWithin(
          l.geom::geography,
          ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography,
          $3
        )
      ORDER BY distance_m ASC
      LIMIT $4
      `,
      [lng, lat, Math.max(radiusKm, 0.1) * 1000, Math.max(limit, 1)],
    );

    return { data: rows, total: rows.length };
  }

  async create(userId: number, dto: CreateLocationDto) {
    const truck = await this.trucksRepository.findOne({
      where: { id: dto.truck_id },
    });
    if (!truck) {
      throw new NotFoundException('트럭을 찾을 수 없습니다.');
    }
    if (truck.owner_id !== userId) {
      throw new ForbiddenException('본인 트럭 위치만 등록할 수 있습니다.');
    }

    const rows = await this.locationsRepository.query(
      `
      INSERT INTO locations (truck_id, geom, address_text)
      VALUES (
        $1,
        ST_SetSRID(ST_MakePoint($2, $3), 4326)::geography,
        $4
      )
      RETURNING id, truck_id, address_text, created_at
      `,
      [dto.truck_id, dto.lng, dto.lat, dto.address_text ?? null],
    );
    return rows[0];
  }
}
