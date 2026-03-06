import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { Favorite } from './favorite.entity';
import { Location } from './location.entity';
import { Review } from './review.entity';
import { User } from './user.entity';

@Entity('trucks')
export class Truck {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ name: 'owner_id' })
  owner_id!: number;

  @ManyToOne(() => User, (user) => user.trucks, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'owner_id' })
  owner!: User;

  @Column({ type: 'varchar', length: 100 })
  name!: string;

  @Column({ type: 'text', nullable: true })
  description!: string | null;

  @Column({ type: 'varchar', length: 20, default: 'closed' })
  status!: string; // 'open' | 'closed'

  @Column({ type: 'varchar', length: 500, nullable: true })
  menu_summary!: string | null;

  @Column({ type: 'varchar', length: 512, nullable: true })
  cover_image_url!: string | null;

  @CreateDateColumn({ type: 'timestamptz' })
  created_at!: Date;

  @UpdateDateColumn({ type: 'timestamptz' })
  updated_at!: Date;

  @OneToMany(() => Location, (location) => location.truck)
  locations!: Location[];

  @OneToMany(() => Favorite, (favorite) => favorite.truck)
  favorites!: Favorite[];

  @OneToMany(() => Review, (review) => review.truck)
  reviews!: Review[];
}
