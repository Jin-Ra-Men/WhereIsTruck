import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AdminModule } from './modules/admin/admin.module';
import { AuthModule } from './modules/auth/auth.module';
import { LocationsModule } from './modules/locations/locations.module';
import { RealtimeModule } from './modules/realtime/realtime.module';
import { TrucksModule } from './modules/trucks/trucks.module';
import { UsersModule } from './modules/users/users.module';
import {
  AuditLog,
  Favorite,
  Location,
  OwnerPaymentRequest,
  OwnerRecommendationRequest,
  Review,
  Truck,
  User,
} from './entities';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      url: process.env.DATABASE_URL,
      entities: [
        User,
        Truck,
        Location,
        Favorite,
        Review,
        OwnerRecommendationRequest,
        OwnerPaymentRequest,
        AuditLog,
      ],
      synchronize: false, // 스키마는 scripts/migrations/001_initial_schema.sql 로 적용
      logging: process.env.NODE_ENV === 'development',
    }),
    AdminModule,
    AuthModule,
    TrucksModule,
    LocationsModule,
    UsersModule,
    RealtimeModule,
  ],
})
export class AppModule {}
