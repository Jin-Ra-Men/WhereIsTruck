import {
  Column,
  CreateDateColumn,
  Entity,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { Favorite } from './favorite.entity';
import { Review } from './review.entity';
import { Truck } from './truck.entity';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ type: 'varchar', length: 128, unique: true })
  firebase_uid!: string;

  @Column({ type: 'varchar', length: 20, default: 'user' })
  role!: string; // 'user' | 'owner' | 'admin'

  @Column({ type: 'varchar', length: 100, nullable: true })
  display_name!: string | null;

  @Column({ type: 'varchar', length: 255, nullable: true })
  email!: string | null;

  @Column({ type: 'varchar', length: 512, nullable: true })
  profile_image_url!: string | null;

  @Column({ type: 'varchar', length: 512, nullable: true })
  fcm_token!: string | null;

  @CreateDateColumn({ type: 'timestamptz' })
  created_at!: Date;

  @UpdateDateColumn({ type: 'timestamptz' })
  updated_at!: Date;

  @OneToMany(() => Truck, (truck) => truck.owner)
  trucks!: Truck[];

  @OneToMany(() => Favorite, (favorite) => favorite.user)
  favorites!: Favorite[];

  @OneToMany(() => Review, (review) => review.user)
  reviews!: Review[];
}
