import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
} from '@nestjs/common';

@Injectable()
export class AdminRoleGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const role: string | undefined = request.user?.role;
    if (role !== 'admin') {
      throw new ForbiddenException('관리자(admin) 권한이 필요합니다.');
    }
    return true;
  }
}
