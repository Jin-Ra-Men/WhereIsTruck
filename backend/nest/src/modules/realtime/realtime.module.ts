import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Location, Truck, User } from '../../entities';
import { RealtimeGateway } from './realtime.gateway';

@Module({
  imports: [TypeOrmModule.forFeature([Truck, Location, User])],
  providers: [RealtimeGateway],
})
export class RealtimeModule {}
