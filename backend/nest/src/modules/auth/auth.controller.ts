import {
  Body,
  Controller,
  Get,
  Headers,
  Post,
  UnauthorizedException,
  UseGuards,
} from '@nestjs/common';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { RequestUser } from '../../common/interfaces/request-user.interface';
import { FirebaseAuthGuard } from './firebase-auth.guard';
import { AuthService } from './auth.service';
import { ApprovePaymentDto } from './dto/approve-payment.dto';
import { CreatePaymentRequestDto } from './dto/create-payment-request.dto';
import { CreateRecommendationRequestDto } from './dto/create-recommendation-request.dto';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Get('me')
  @UseGuards(FirebaseAuthGuard)
  async getMe(@CurrentUser() user: RequestUser) {
    return this.authService.getMe(user.uid);
  }

  @Post('owner/requests/recommendation')
  @UseGuards(FirebaseAuthGuard)
  async createRecommendationRequest(
    @CurrentUser() user: RequestUser,
    @Body() dto: CreateRecommendationRequestDto,
  ) {
    return this.authService.createRecommendationRequest(user.id, dto);
  }

  @Post('owner/requests/payment')
  @UseGuards(FirebaseAuthGuard)
  async createPaymentRequest(
    @CurrentUser() user: RequestUser,
    @Body() dto: CreatePaymentRequestDto,
  ) {
    return this.authService.createPaymentRequest(user.id, dto);
  }

  @Post('owner/approve-payment')
  async approvePayment(
    @Headers('x-admin-token') adminToken: string | undefined,
    @Body() dto: ApprovePaymentDto,
  ) {
    const expected = process.env.ADMIN_API_KEY;
    if (!expected || adminToken !== expected) {
      throw new UnauthorizedException('관리자 토큰이 유효하지 않습니다.');
    }
    return this.authService.approvePaymentAndPromoteOwner(
      dto.payment_request_id,
      dto.approved,
    );
  }
}
