import {
  Body,
  Controller,
  Get,
  Param,
  ParseIntPipe,
  Patch,
  Query,
  UseGuards,
} from '@nestjs/common';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { AdminRoleGuard } from '../../common/guards/admin-role.guard';
import { RequestUser } from '../../common/interfaces/request-user.interface';
import { FirebaseAuthGuard } from '../auth/firebase-auth.guard';
import { UpdateTruckStatusDto } from './dto/update-truck-status.dto';
import { UpdateUserRoleDto } from './dto/update-user-role.dto';
import { AdminService } from './admin.service';

@Controller('admin')
@UseGuards(FirebaseAuthGuard, AdminRoleGuard)
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Get('users')
  async getUsers(
    @Query('role') role?: string,
    @Query('q') q?: string,
    @Query('limit') limit?: string,
    @Query('offset') offset?: string,
  ) {
    return this.adminService.getUsers(
      role,
      q,
      limit ? Number(limit) : 20,
      offset ? Number(offset) : 0,
    );
  }

  @Patch('users/:id/role')
  async updateUserRole(
    @CurrentUser() actor: RequestUser,
    @Param('id', ParseIntPipe) userId: number,
    @Body() dto: UpdateUserRoleDto,
  ) {
    return this.adminService.updateUserRole(actor.id, userId, dto.role);
  }

  @Get('owners')
  async getOwners(
    @Query('q') q?: string,
    @Query('limit') limit?: string,
    @Query('offset') offset?: string,
  ) {
    return this.adminService.getUsers(
      'owner',
      q,
      limit ? Number(limit) : 20,
      offset ? Number(offset) : 0,
    );
  }

  @Get('trucks')
  async getTrucks(
    @Query('status') status?: string,
    @Query('owner_id') ownerId?: string,
    @Query('q') q?: string,
    @Query('limit') limit?: string,
    @Query('offset') offset?: string,
  ) {
    return this.adminService.getTrucks(
      status,
      ownerId ? Number(ownerId) : undefined,
      q,
      limit ? Number(limit) : 20,
      offset ? Number(offset) : 0,
    );
  }

  @Patch('trucks/:id/status')
  async updateTruckStatus(
    @CurrentUser() actor: RequestUser,
    @Param('id', ParseIntPipe) truckId: number,
    @Body() dto: UpdateTruckStatusDto,
  ) {
    return this.adminService.updateTruckStatus(actor.id, truckId, dto.status);
  }

  @Get('audit-logs')
  async getAuditLogs(
    @Query('limit') limit?: string,
    @Query('offset') offset?: string,
  ) {
    return this.adminService.getAuditLogs(
      limit ? Number(limit) : 50,
      offset ? Number(offset) : 0,
    );
  }
}
