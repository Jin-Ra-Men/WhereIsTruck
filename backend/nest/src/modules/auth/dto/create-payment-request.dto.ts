export class CreatePaymentRequestDto {
  plan!: string;
  amount!: number;
  currency?: string;
}
