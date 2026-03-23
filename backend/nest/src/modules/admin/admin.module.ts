import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AdminRoleGuard } from '../../common/guards/admin-role.guard';
import { AuditLog, Truck, User } from '../../entities';
import { AuthModule } from '../auth/auth.module';
import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';

@Module({
  imports: [TypeOrmModule.forFeature([User, Truck, AuditLog]), AuthModule],
  controllers: [AdminController],
  providers: [AdminService, AdminRoleGuard],
  exports: [AdminService],
})
export class AdminModule {}
