import {
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Truck } from '../../entities';
import { CreateTruckDto } from './dto/create-truck.dto';
import { UpdateTruckDto } from './dto/update-truck.dto';

@Injectable()
export class TrucksService {
  constructor(
    @InjectRepository(Truck)
    private readonly trucksRepository: Repository<Truck>,
  ) {}

  async findAll(status?: string, ownerId?: number): Promise<Truck[]> {
    const where: Record<string, unknown> = {};
    if (status) {
      where.status = status;
    }
    if (ownerId) {
      where.owner_id = ownerId;
    }
    return this.trucksRepository.find({
      where,
      order: { created_at: 'DESC' },
    });
  }

  async findOne(id: number): Promise<Truck> {
    const truck = await this.trucksRepository.findOne({ where: { id } });
    if (!truck) {
      throw new NotFoundException('트럭을 찾을 수 없습니다.');
    }
    return truck;
  }

  async create(ownerId: number, dto: CreateTruckDto): Promise<Truck> {
    const truck = this.trucksRepository.create({
      owner_id: ownerId,
      name: dto.name,
      description: dto.description ?? null,
      menu_summary: dto.menu_summary ?? null,
      cover_image_url: dto.cover_image_url ?? null,
      status: 'closed',
    });
    return this.trucksRepository.save(truck);
  }

  async update(id: number, userId: number, dto: UpdateTruckDto): Promise<Truck> {
    const truck = await this.findOne(id);
    if (truck.owner_id !== userId) {
      throw new ForbiddenException('본인 트럭만 수정할 수 있습니다.');
    }

    if (dto.name !== undefined) truck.name = dto.name;
    if (dto.description !== undefined) truck.description = dto.description;
    if (dto.status !== undefined) truck.status = dto.status;
    if (dto.menu_summary !== undefined) truck.menu_summary = dto.menu_summary;
    if (dto.cover_image_url !== undefined) {
      truck.cover_image_url = dto.cover_image_url;
    }

    return this.trucksRepository.save(truck);
  }

  async remove(id: number, userId: number): Promise<{ deleted: boolean }> {
    const truck = await this.findOne(id);
    if (truck.owner_id !== userId) {
      throw new ForbiddenException('본인 트럭만 삭제할 수 있습니다.');
    }
    await this.trucksRepository.delete({ id });
    return { deleted: true };
  }
}
