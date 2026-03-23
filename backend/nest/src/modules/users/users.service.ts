import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Favorite, Truck, User } from '../../entities';
import { CreateFavoriteDto } from './dto/create-favorite.dto';
import { UpdateMeDto } from './dto/update-me.dto';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly usersRepository: Repository<User>,
    @InjectRepository(Favorite)
    private readonly favoritesRepository: Repository<Favorite>,
    @InjectRepository(Truck)
    private readonly trucksRepository: Repository<Truck>,
  ) {}

  async getMe(userId: number): Promise<User> {
    const user = await this.usersRepository.findOne({ where: { id: userId } });
    if (!user) {
      throw new NotFoundException('사용자 정보를 찾을 수 없습니다.');
    }
    return user;
  }

  async updateMe(userId: number, dto: UpdateMeDto): Promise<User> {
    const user = await this.getMe(userId);
    if (dto.display_name !== undefined) user.display_name = dto.display_name;
    if (dto.profile_image_url !== undefined) {
      user.profile_image_url = dto.profile_image_url;
    }
    if (dto.fcm_token !== undefined) user.fcm_token = dto.fcm_token;
    return this.usersRepository.save(user);
  }

  async getFavorites(userId: number) {
    const rows = await this.favoritesRepository
      .createQueryBuilder('f')
      .leftJoinAndSelect('f.truck', 'truck')
      .where('f.user_id = :userId', { userId })
      .orderBy('f.created_at', 'DESC')
      .getMany();
    return { data: rows, total: rows.length };
  }

  async addFavorite(userId: number, dto: CreateFavoriteDto): Promise<Favorite> {
    const truck = await this.trucksRepository.findOne({
      where: { id: dto.truck_id },
    });
    if (!truck) {
      throw new NotFoundException('트럭을 찾을 수 없습니다.');
    }

    const exists = await this.favoritesRepository.findOne({
      where: { user_id: userId, truck_id: dto.truck_id },
    });
    if (exists) {
      throw new ConflictException('이미 찜한 트럭입니다.');
    }

    const favorite = this.favoritesRepository.create({
      user_id: userId,
      truck_id: dto.truck_id,
    });
    return this.favoritesRepository.save(favorite);
  }

  async removeFavorite(userId: number, truckId: number): Promise<{ deleted: boolean }> {
    const exists = await this.favoritesRepository.findOne({
      where: { user_id: userId, truck_id: truckId },
    });
    if (!exists) {
      throw new NotFoundException('찜 정보를 찾을 수 없습니다.');
    }
    await this.favoritesRepository.delete({ id: exists.id });
    return { deleted: true };
  }
}
