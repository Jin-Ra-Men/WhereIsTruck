import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import * as admin from 'firebase-admin';
import { Repository } from 'typeorm';
import {
  OwnerPaymentRequest,
  OwnerRecommendationRequest,
  User,
} from '../../entities';
import { CreatePaymentRequestDto } from './dto/create-payment-request.dto';
import { CreateRecommendationRequestDto } from './dto/create-recommendation-request.dto';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private readonly usersRepository: Repository<User>,
    @InjectRepository(OwnerRecommendationRequest)
    private readonly recommendationRepository: Repository<OwnerRecommendationRequest>,
    @InjectRepository(OwnerPaymentRequest)
    private readonly paymentRepository: Repository<OwnerPaymentRequest>,
  ) {}

  async verifyTokenAndGetOrCreateUser(idToken: string): Promise<User> {
    const decoded = await admin.auth().verifyIdToken(idToken);

    let user = await this.usersRepository.findOne({
      where: { firebase_uid: decoded.uid },
    });
    if (!user) {
      user = this.usersRepository.create({
        firebase_uid: decoded.uid,
        role: 'user',
        display_name: decoded.name ?? null,
        email: decoded.email ?? null,
      });
    } else {
      user.display_name = decoded.name ?? user.display_name;
      user.email = decoded.email ?? user.email;
    }
    return this.usersRepository.save(user);
  }

  async getMe(firebaseUid: string): Promise<User> {
    const user = await this.usersRepository.findOne({
      where: { firebase_uid: firebaseUid },
    });
    if (!user) {
      throw new UnauthorizedException('사용자 정보를 찾을 수 없습니다.');
    }
    return user;
  }

  async createRecommendationRequest(
    userId: number,
    dto: CreateRecommendationRequestDto,
  ): Promise<OwnerRecommendationRequest> {
    const request = this.recommendationRepository.create({
      user_id: userId,
      business_name: dto.business_name,
      description: dto.description ?? null,
      status: 'pending',
    });
    return this.recommendationRepository.save(request);
  }

  async createPaymentRequest(
    userId: number,
    dto: CreatePaymentRequestDto,
  ): Promise<OwnerPaymentRequest> {
    const request = this.paymentRepository.create({
      user_id: userId,
      plan: dto.plan,
      amount: dto.amount,
      currency: dto.currency ?? 'KRW',
      status: 'pending',
      payment_request_id: `pay_req_${Date.now()}_${Math.floor(
        Math.random() * 10000,
      )}`,
    });
    return this.paymentRepository.save(request);
  }

  async approvePaymentAndPromoteOwner(
    paymentRequestId: string,
    approved: boolean,
  ): Promise<{ payment_request_id: string; status: string; user_role?: string }> {
    const request = await this.paymentRepository.findOne({
      where: { payment_request_id: paymentRequestId },
    });
    if (!request) {
      throw new UnauthorizedException('결제 요청을 찾을 수 없습니다.');
    }

    request.status = approved ? 'paid' : 'cancelled';
    await this.paymentRepository.save(request);

    if (!approved) {
      return {
        payment_request_id: paymentRequestId,
        status: request.status,
      };
    }

    const user = await this.usersRepository.findOne({ where: { id: request.user_id } });
    if (!user) {
      throw new UnauthorizedException('사용자를 찾을 수 없습니다.');
    }
    user.role = 'owner';
    await this.usersRepository.save(user);

    return {
      payment_request_id: paymentRequestId,
      status: request.status,
      user_role: user.role,
    };
  }
}
