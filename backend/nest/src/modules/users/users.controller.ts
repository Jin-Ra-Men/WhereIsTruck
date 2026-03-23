import {
  Body,
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  Patch,
  Post,
  UseGuards,
} from '@nestjs/common';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { RequestUser } from '../../common/interfaces/request-user.interface';
import { FirebaseAuthGuard } from '../auth/firebase-auth.guard';
import { CreateFavoriteDto } from './dto/create-favorite.dto';
import { UpdateMeDto } from './dto/update-me.dto';
import { UsersService } from './users.service';

@Controller()
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('users/me')
  @UseGuards(FirebaseAuthGuard)
  async getMe(@CurrentUser() user: RequestUser) {
    return this.usersService.getMe(user.id);
  }

  @Patch('users/me')
  @UseGuards(FirebaseAuthGuard)
  async updateMe(
    @CurrentUser() user: RequestUser,
    @Body() dto: UpdateMeDto,
  ) {
    return this.usersService.updateMe(user.id, dto);
  }

  @Get('favorites')
  @UseGuards(FirebaseAuthGuard)
  async getFavorites(@CurrentUser() user: RequestUser) {
    return this.usersService.getFavorites(user.id);
  }

  @Post('favorites')
  @UseGuards(FirebaseAuthGuard)
  async addFavorite(
    @CurrentUser() user: RequestUser,
    @Body() dto: CreateFavoriteDto,
  ) {
    return this.usersService.addFavorite(user.id, dto);
  }

  @Delete('favorites/:truckId')
  @UseGuards(FirebaseAuthGuard)
  async removeFavorite(
    @CurrentUser() user: RequestUser,
    @Param('truckId', ParseIntPipe) truckId: number,
  ) {
    return this.usersService.removeFavorite(user.id, truckId);
  }
}
