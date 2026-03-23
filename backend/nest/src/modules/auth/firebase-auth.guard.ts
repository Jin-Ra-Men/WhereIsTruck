import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { AuthService } from './auth.service';

@Injectable()
export class FirebaseAuthGuard implements CanActivate {
  constructor(private readonly authService: AuthService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const authHeader: string | undefined = request.headers['authorization'];
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw new UnauthorizedException('Bearer 토큰이 필요합니다.');
    }

    const idToken = authHeader.replace('Bearer ', '').trim();
    if (!idToken) {
      throw new UnauthorizedException('유효한 토큰이 필요합니다.');
    }

    const user = await this.authService.verifyTokenAndGetOrCreateUser(idToken);
    request.user = {
      uid: user.firebase_uid,
      id: user.id,
      role: user.role,
      email: user.email ?? undefined,
      name: user.display_name ?? undefined,
    };
    return true;
  }
}
