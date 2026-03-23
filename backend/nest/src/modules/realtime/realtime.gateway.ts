import {
  ConnectedSocket,
  MessageBody,
  OnGatewayConnection,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { InjectRepository } from '@nestjs/typeorm';
import * as admin from 'firebase-admin';
import { Repository } from 'typeorm';
import { Server, Socket } from 'socket.io';
import { Location, Truck, User } from '../../entities';

type OwnerEventPayload = {
  truck_id: number;
  lat?: number;
  lng?: number;
  message?: string;
};

@WebSocketGateway({
  cors: { origin: '*' },
})
export class RealtimeGateway implements OnGatewayConnection {
  @WebSocketServer()
  server!: Server;

  constructor(
    @InjectRepository(Truck)
    private readonly trucksRepository: Repository<Truck>,
    @InjectRepository(Location)
    private readonly locationsRepository: Repository<Location>,
    @InjectRepository(User)
    private readonly usersRepository: Repository<User>,
  ) {}

  async handleConnection(client: Socket) {
    // 클라이언트는 handshake.auth.token 으로 Firebase ID 토큰 전달
    const token = client.handshake?.auth?.token as string | undefined;
    if (!token) {
      return;
    }
    try {
      const decoded = await admin.auth().verifyIdToken(token);
      const user = await this.usersRepository.findOne({
        where: { firebase_uid: decoded.uid },
      });
      client.data.user = user ?? null;
    } catch {
      client.data.user = null;
    }
  }

  private async assertOwner(client: Socket, truckId: number): Promise<User> {
    const user = client.data.user as User | null | undefined;
    if (!user || user.role !== 'owner') {
      throw new Error('owner 권한이 필요합니다.');
    }
    const truck = await this.trucksRepository.findOne({ where: { id: truckId } });
    if (!truck || truck.owner_id !== user.id) {
      throw new Error('본인 트럭만 처리할 수 있습니다.');
    }
    return user;
  }

  @SubscribeMessage('truck:open')
  async truckOpen(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: OwnerEventPayload,
  ) {
    await this.assertOwner(client, payload.truck_id);
    await this.trucksRepository.update(
      { id: payload.truck_id },
      { status: 'open' },
    );
    const truck = await this.trucksRepository.findOne({
      where: { id: payload.truck_id },
    });
    this.server.emit('truck:opened', {
      truck_id: payload.truck_id,
      truck_name: truck?.name,
    });
    return { ok: true };
  }

  @SubscribeMessage('truck:close')
  async truckClose(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: OwnerEventPayload,
  ) {
    await this.assertOwner(client, payload.truck_id);
    await this.trucksRepository.update(
      { id: payload.truck_id },
      { status: 'closed' },
    );
    this.server.emit('truck:closed', { truck_id: payload.truck_id });
    return { ok: true };
  }

  @SubscribeMessage('truck:location')
  async truckLocation(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: OwnerEventPayload,
  ) {
    await this.assertOwner(client, payload.truck_id);
    if (payload.lat === undefined || payload.lng === undefined) {
      throw new Error('lat/lng 가 필요합니다.');
    }

    await this.locationsRepository.query(
      `
      INSERT INTO locations (truck_id, geom, address_text)
      VALUES (
        $1,
        ST_SetSRID(ST_MakePoint($2, $3), 4326)::geography,
        NULL
      )
      `,
      [payload.truck_id, payload.lng, payload.lat],
    );

    this.server.emit('truck:location_updated', {
      truck_id: payload.truck_id,
      lat: payload.lat,
      lng: payload.lng,
    });
    return { ok: true };
  }

  @SubscribeMessage('truck:stock_update')
  async truckStockUpdate(
    @ConnectedSocket() client: Socket,
    @MessageBody() payload: OwnerEventPayload,
  ) {
    await this.assertOwner(client, payload.truck_id);
    this.server.emit('truck:stock_announce', {
      truck_id: payload.truck_id,
      message: payload.message ?? '',
    });
    return { ok: true };
  }
}
