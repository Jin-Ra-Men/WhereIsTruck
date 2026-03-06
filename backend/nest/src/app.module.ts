import { Module } from '@nestjs/common';
import { AuthModule } from './modules/auth/auth.module';
import { LocationsModule } from './modules/locations/locations.module';
import { RealtimeModule } from './modules/realtime/realtime.module';
import { TrucksModule } from './modules/trucks/trucks.module';
import { UsersModule } from './modules/users/users.module';

@Module({
  imports: [
    AuthModule,
    TrucksModule,
    LocationsModule,
    UsersModule,
    RealtimeModule,
  ],
})
export class AppModule {}
