import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { OwnerRoleGuard } from '../../common/guards/owner-role.guard';
import { RequestUser } from '../../common/interfaces/request-user.interface';
import { FirebaseAuthGuard } from '../auth/firebase-auth.guard';
import { CreateTruckDto } from './dto/create-truck.dto';
import { UpdateTruckDto } from './dto/update-truck.dto';
import { TrucksService } from './trucks.service';

@Controller('trucks')
export class TrucksController {
  constructor(private readonly trucksService: TrucksService) {}

  @Get()
  async findAll(
    @Query('status') status?: string,
    @Query('owner_id') ownerId?: string,
  ) {
    return this.trucksService.findAll(
      status,
      ownerId ? Number(ownerId) : undefined,
    );
  }

  @Get(':id')
  async findOne(@Param('id', ParseIntPipe) id: number) {
    return this.trucksService.findOne(id);
  }

  @Post()
  @UseGuards(FirebaseAuthGuard, OwnerRoleGuard)
  async create(
    @CurrentUser() user: RequestUser,
    @Body() dto: CreateTruckDto,
  ) {
    return this.trucksService.create(user.id, dto);
  }

  @Patch(':id')
  @UseGuards(FirebaseAuthGuard, OwnerRoleGuard)
  async update(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() user: RequestUser,
    @Body() dto: UpdateTruckDto,
  ) {
    return this.trucksService.update(id, user.id, dto);
  }

  @Delete(':id')
  @UseGuards(FirebaseAuthGuard, OwnerRoleGuard)
  async remove(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() user: RequestUser,
  ) {
    return this.trucksService.remove(id, user.id);
  }
}
