import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { OwnerRoleGuard } from '../../common/guards/owner-role.guard';
import { Truck } from '../../entities';
import { AuthModule } from '../auth/auth.module';
import { TrucksController } from './trucks.controller';
import { TrucksService } from './trucks.service';

@Module({
  imports: [TypeOrmModule.forFeature([Truck]), AuthModule],
  controllers: [TrucksController],
  providers: [TrucksService, OwnerRoleGuard],
  exports: [TrucksService],
})
export class TrucksModule {}
