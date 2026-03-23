import {
  Body,
  Controller,
  DefaultValuePipe,
  Get,
  ParseFloatPipe,
  ParseIntPipe,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { OwnerRoleGuard } from '../../common/guards/owner-role.guard';
import { RequestUser } from '../../common/interfaces/request-user.interface';
import { FirebaseAuthGuard } from '../auth/firebase-auth.guard';
import { CreateLocationDto } from './dto/create-location.dto';
import { LocationsService } from './locations.service';

@Controller('locations')
export class LocationsController {
  constructor(private readonly locationsService: LocationsService) {}

  @Get('nearby')
  async nearby(
    @Query('lat', ParseFloatPipe) lat: number,
    @Query('lng', ParseFloatPipe) lng: number,
    @Query('radius_km', new DefaultValuePipe(2), ParseFloatPipe) radiusKm: number,
    @Query('limit', new DefaultValuePipe(20), ParseIntPipe) limit: number,
  ) {
    return this.locationsService.findNearby(lat, lng, radiusKm, limit);
  }

  @Post()
  @UseGuards(FirebaseAuthGuard, OwnerRoleGuard)
  async create(
    @CurrentUser() user: RequestUser,
    @Body() dto: CreateLocationDto,
  ) {
    return this.locationsService.create(user.id, dto);
  }
}
