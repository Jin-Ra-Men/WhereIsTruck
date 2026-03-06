import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import { Truck } from './truck.entity';

/**
 * PostGIS geography(Point) 컬럼.
 * TypeORM에서 공간 타입은 raw 쿼리로 삽입/조회하는 것을 권장.
 * 좌표 넣을 때: ST_SetSRID(ST_MakePoint(경도, 위도), 4326)::geography
 */
@Entity('locations')
export class Location {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ name: 'truck_id' })
  truck_id!: number;

  @ManyToOne(() => Truck, (truck) => truck.locations, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'truck_id' })
  truck!: Truck;

  /**
   * DB에는 geography(Point). TypeORM은 geometry로 매핑.
   * 삽입/반경 검색은 repository.query() 또는 QueryBuilder raw 권장.
   */
  @Column({ type: 'geometry', nullable: false })
  geom!: string;

  @Column({ type: 'varchar', length: 255, nullable: true })
  address_text!: string | null;

  @CreateDateColumn({ type: 'timestamptz' })
  created_at!: Date;
}
