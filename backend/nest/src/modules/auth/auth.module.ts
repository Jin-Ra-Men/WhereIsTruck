import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import {
  OwnerPaymentRequest,
  OwnerRecommendationRequest,
  User,
} from '../../entities';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { FirebaseAdminProvider } from './firebase-admin.provider';
import { FirebaseAuthGuard } from './firebase-auth.guard';

@Module({
  imports: [
    TypeOrmModule.forFeature([User, OwnerRecommendationRequest, OwnerPaymentRequest]),
  ],
  controllers: [AuthController],
  providers: [FirebaseAdminProvider, AuthService, FirebaseAuthGuard],
  exports: [AuthService, FirebaseAuthGuard],
})
export class AuthModule {}
