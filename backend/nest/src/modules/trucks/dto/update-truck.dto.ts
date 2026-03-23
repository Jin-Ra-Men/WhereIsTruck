export class UpdateTruckDto {
  name?: string;
  description?: string;
  status?: 'open' | 'closed';
  menu_summary?: string;
  cover_image_url?: string;
}
