import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AuditLog, Truck, User } from '../../entities';

@Injectable()
export class AdminService {
  constructor(
    @InjectRepository(User)
    private readonly usersRepository: Repository<User>,
    @InjectRepository(Truck)
    private readonly trucksRepository: Repository<Truck>,
    @InjectRepository(AuditLog)
    private readonly auditLogsRepository: Repository<AuditLog>,
  ) {}

  async getUsers(
    role?: string,
    q?: string,
    limit = 20,
    offset = 0,
  ): Promise<User[]> {
    const query = this.usersRepository.createQueryBuilder('u');

    if (role) {
      query.andWhere('u.role = :role', { role });
    }
    if (q) {
      query.andWhere(
        '(u.display_name ILIKE :q OR u.email ILIKE :q OR u.firebase_uid ILIKE :q)',
        { q: `%${q}%` },
      );
    }

    return query
      .orderBy('u.created_at', 'DESC')
      .take(limit)
      .skip(offset)
      .getMany();
  }

  async updateUserRole(
    actorUserId: number,
    userId: number,
    role: 'user' | 'owner' | 'admin',
  ): Promise<User> {
    if (!['user', 'owner', 'admin'].includes(role)) {
      throw new BadRequestException('role은 user/owner/admin 중 하나여야 합니다.');
    }

    const user = await this.usersRepository.findOne({ where: { id: userId } });
    if (!user) {
      throw new NotFoundException('사용자를 찾을 수 없습니다.');
    }

    const beforeRole = user.role;
    user.role = role;
    const saved = await this.usersRepository.save(user);

    await this.auditLogsRepository.save(
      this.auditLogsRepository.create({
        actor_user_id: actorUserId,
        action: 'admin.user.role.update',
        target_type: 'user',
        target_id: userId,
        details: { beforeRole, afterRole: role },
      }),
    );

    return saved;
  }

  async getTrucks(
    status?: string,
    ownerId?: number,
    q?: string,
    limit = 20,
    offset = 0,
  ): Promise<Truck[]> {
    const query = this.trucksRepository
      .createQueryBuilder('t')
      .leftJoinAndSelect('t.owner', 'owner');

    if (status) {
      query.andWhere('t.status = :status', { status });
    }
    if (ownerId) {
      query.andWhere('t.owner_id = :ownerId', { ownerId });
    }
    if (q) {
      query.andWhere('t.name ILIKE :q', { q: `%${q}%` });
    }

    return query
      .orderBy('t.created_at', 'DESC')
      .take(limit)
      .skip(offset)
      .getMany();
  }

  async updateTruckStatus(
    actorUserId: number,
    truckId: number,
    status: 'open' | 'closed',
  ): Promise<Truck> {
    if (!['open', 'closed'].includes(status)) {
      throw new BadRequestException('status는 open/closed 중 하나여야 합니다.');
    }

    const truck = await this.trucksRepository.findOne({ where: { id: truckId } });
    if (!truck) {
      throw new NotFoundException('트럭을 찾을 수 없습니다.');
    }

    const beforeStatus = truck.status;
    truck.status = status;
    const saved = await this.trucksRepository.save(truck);

    await this.auditLogsRepository.save(
      this.auditLogsRepository.create({
        actor_user_id: actorUserId,
        action: 'admin.truck.status.update',
        target_type: 'truck',
        target_id: truckId,
        details: { beforeStatus, afterStatus: status },
      }),
    );

    return saved;
  }

  async getAuditLogs(limit = 50, offset = 0): Promise<AuditLog[]> {
    return this.auditLogsRepository.find({
      order: { created_at: 'DESC' },
      take: limit,
      skip: offset,
    });
  }
}
