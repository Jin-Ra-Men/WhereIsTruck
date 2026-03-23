import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { OwnerRoleGuard } from '../../common/guards/owner-role.guard';
import { Location, Truck } from '../../entities';
import { AuthModule } from '../auth/auth.module';
import { LocationsController } from './locations.controller';
import { LocationsService } from './locations.service';

@Module({
  imports: [TypeOrmModule.forFeature([Location, Truck]), AuthModule],
  controllers: [LocationsController],
  providers: [LocationsService, OwnerRoleGuard],
  exports: [LocationsService],
})
export class LocationsModule {}
