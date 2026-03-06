# TypeORM 초보자 가이드

**대상:** TypeORM(또는 ORM 자체)을 처음 접하는 분.  
**목표:** “엔티티·Repository가 뭔지”, “DB 테이블과 코드가 어떻게 연결되는지” 이해하는 것.

---

## 1. TypeORM이란?

- **ORM** = Object-Relational Mapping. “객체(Object)”와 “관계형 DB 테이블”을 자동으로 매핑해 주는 도구입니다.
- **TypeORM**은 TypeScript/JavaScript용 ORM으로, **엔티티(클래스)** 하나가 **테이블 하나**에 대응합니다.
- SQL을 직접 많이 쓰지 않고, 메서드 호출(`find()`, `save()` 등)로 CRUD를 할 수 있게 해 줍니다.
- 우리 프로젝트에서는 **NestJS**와 함께 사용하고, **PostgreSQL**에 연결합니다.

---

## 2. 핵심 개념 (처음 보는 분용)

### 2.1 엔티티 (Entity)

- **DB 테이블 한 개**를 TypeScript **클래스**로 표현한 것입니다.
- 클래스의 **프로퍼티**가 **테이블의 컬럼**이 됩니다.
- `@Entity('테이블명')`, `@Column()`, `@PrimaryGeneratedColumn()` 같은 **데코레이터**로 “이게 PK”, “이건 varchar” 등을 표시합니다.

```typescript
@Entity('users')
export class User {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ type: 'varchar', length: 128, unique: true })
  firebase_uid!: string;

  @Column({ type: 'varchar', length: 20, default: 'user' })
  role!: string;
}
```

- `users` 테이블과 이 클래스가 1:1로 대응한다고 보면 됩니다.

### 2.2 Repository (리포지토리)

- “한 엔티티(테이블)에 대한 **조회·추가·수정·삭제**”를 담당하는 객체입니다.
- `repository.find()`, `repository.findOne()`, `repository.save()`, `repository.remove()` 등으로 CRUD를 합니다.
- NestJS에서는 `@InjectRepository(User)` 로 주입받아 씁니다.

```typescript
const users = await this.userRepository.find({ where: { role: 'owner' } });
const one = await this.userRepository.findOne({ where: { id: 1 } });
await this.userRepository.save({ firebase_uid: 'abc', role: 'user' });
```

### 2.3 관계 (Relation)

- 테이블 간 **1:N**, **N:M** 관계를 엔티티에 `@OneToMany`, `@ManyToOne`, `@JoinColumn` 등으로 표현합니다.
- 예: `Truck`이 `User`에 속한다 → `Truck` 엔티티에 `@ManyToOne(() => User) owner` 가 있고, DB에는 `owner_id` 컬럼이 생깁니다.

---

## 3. 이 프로젝트에서의 사용

- **엔티티 위치:** `backend/nest/src/entities/`  
  - User, Truck, Location, Favorite, Review (docs/DB-SCHEMA.md와 동일한 설계)
- **연결 설정:** `app.module.ts`의 `TypeOrmModule.forRoot()` 에서 `url: process.env.DATABASE_URL`, `entities: [...]` 로 지정합니다.
- **synchronize: false** 로 두고, 테이블 생성/변경은 **scripts/migrations/001_initial_schema.sql** 같은 SQL로 적용합니다. (자동 스키마 변경은 위험할 수 있어서 비활성화)

---

## 4. PostGIS(위치) 컬럼

- `locations.geom` 처럼 **공간 타입**은 TypeORM이 제한적으로 지원합니다.
- **반경 검색** 같은 건 **QueryBuilder**의 `raw` 또는 `repository.query()` 로 직접 SQL을 쓰는 경우가 많습니다.
- 자세한 공간 쿼리는 **docs/guides/POSTGRES-GUIDE.md**, **docs/DB-SCHEMA.md**를 참고하세요.

---

## 5. 참고 링크

- [TypeORM 공식 문서](https://typeorm.io/)
- [NestJS + TypeORM](https://docs.nestjs.com/techniques/database)
