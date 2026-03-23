# NestJS 초보자 가이드

**대상:** NestJS를 처음 접하는 분.  
**목표:** “NestJS가 뭔지”, “모듈·컨트롤러·서비스”가 어떻게 맞물리는지 이해하는 것.

---

## 1. NestJS란?

- **Node.js** 위에서 동작하는 **백엔드 프레임워크**입니다.
- **REST API**(HTTP 요청/응답), **WebSocket**(실시간 통신) 등을 **구조화된 방식**으로 만들 수 있게 해 줍니다.
- TypeScript를 기본으로 권장하고, **의존성 주입(DI)**·**모듈** 단위로 코드를 나눕니다.
- Express(Fastify)를 감싸서 쓰기 때문에, “Express보다 격식 있는 구조”라고 보면 됩니다.

---

## 2. 핵심 개념 (처음 보는 분용)

### 2.1 모듈 (Module)

- **기능 단위**로 앱을 나눈 “상자”입니다. 예: 사용자 관련은 `UsersModule`, 트럭 관련은 `TrucksModule`.
- `@Module({ imports: [...], controllers: [...], providers: [...] })` 로 정의합니다.
- **AppModule**이 루트이고, 여기서 다른 모듈들을 `imports`로 불러옵니다.

### 2.2 컨트롤러 (Controller)

- **HTTP 요청**을 받아서 **경로(URL)**별로 처리하는 클래스입니다.
- `@Controller('trucks')` → `/trucks` 로 오는 요청을 처리.
- `@Get()`, `@Post()`, `@Patch()`, `@Delete()` 등으로 메서드 하나하나가 “경로 + 메서드”에 대응합니다.

```typescript
@Controller('trucks')
export class TrucksController {
  @Get()
  findAll() {
    return []; // GET /trucks → 이 함수 실행
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return {}; // GET /trucks/1 → id는 "1"
  }
}
```

### 2.3 서비스 (Service)

- **비즈니스 로직**·**DB 접근** 등을 담는 클래스입니다.
- 컨트롤러는 “요청 받고 응답만 정리”하고, 실제 작업(DB 조회·계산 등)은 서비스에 맡깁니다.
- **의존성 주입**으로 컨트롤러가 서비스를 `constructor`에서 받아 씁니다.

```typescript
@Injectable()
export class TrucksService {
  constructor(private readonly truckRepository: Repository<Truck>) {}

  async findAll(): Promise<Truck[]> {
    return this.truckRepository.find();
  }
}
```

### 2.4 의존성 주입 (DI)

- “이 클래스가 필요로 하는 것(서비스, Repository 등)”을 **프레임워크가 알아서 넣어 준다”는 개념입니다.
- 개발자는 `constructor(private readonly trucksService: TrucksService)` 처럼 “필요한 타입”만 적어 두면, Nest가 인스턴스를 만들어서 넘겨 줍니다.
- 그래서 `new TrucksService()` 를 직접 안 써도 됩니다.

---

## 3. 폴더 구조 (이 프로젝트 기준)

```
backend/nest/src/
  app.module.ts       ← 루트 모듈 (TypeORM, 다른 모듈들 import)
  main.ts             ← 진입점 (NestFactory.create, listen)
  entities/           ← TypeORM 엔티티 (DB 테이블과 매핑)
  modules/
    users/            ← UsersModule (컨트롤러, 서비스)
    trucks/
    locations/
    auth/
    realtime/         ← Socket.io 등 실시간 처리
```

- **한 도메인(users, trucks 등)** = 한 모듈 폴더 안에 컨트롤러·서비스가 같이 있는 구조라고 보면 됩니다.

---

## 4. 요청이 들어왔을 때 흐름 (감잡기)

1. 클라이언트가 **GET /trucks** 요청을 보냄.
2. Nest가 **TrucksController**의 `findAll()` 같은 메서드를 찾아서 실행.
3. 컨트롤러가 **TrucksService**의 `findAll()`을 호출.
4. 서비스가 **TypeORM Repository**로 DB에서 트럭 목록을 가져옴.
5. 그 결과를 컨트롤러가 응답으로 돌려줌.

---

## 5. 이 프로젝트에서의 사용

- REST API: **shared/api-spec/rest-api.md** 에 정의된 경로를 Nest 컨트롤러·서비스로 구현합니다.
- DB: **TypeORM**으로 PostgreSQL에 접속합니다. (TYPEORM-GUIDE.md 참고)
- 실시간: **Socket.io**를 Nest **Gateway**로 띄웁니다. (SOCKETIO-GUIDE.md 참고)
- 인증 구현: `FirebaseAuthGuard`로 Bearer 토큰을 검증하고, `@CurrentUser()` 데코레이터로 사용자 정보를 주입해 사용합니다.
- 권한 2트랙 예시: `/auth/owner/requests/recommendation`, `/auth/owner/requests/payment`, `/auth/owner/approve-payment` 같은 API를 AuthModule에서 관리합니다.

---

## 6. 참고 링크

- [NestJS 공식 문서](https://docs.nestjs.com/)
- [NestJS 한글 문서(커뮤니티)](https://docs.nestjs.kr/) (있는 경우)
