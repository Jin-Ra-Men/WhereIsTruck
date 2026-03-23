import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
} from '@nestjs/common';

@Injectable()
export class OwnerRoleGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    const role: string | undefined = request.user?.role;
    if (role !== 'owner') {
      throw new ForbiddenException('사장님(owner) 권한이 필요합니다.');
    }
    return true;
  }
}
