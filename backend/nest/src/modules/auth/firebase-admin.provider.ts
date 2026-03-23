import { Provider } from '@nestjs/common';
import * as admin from 'firebase-admin';

const normalizePrivateKey = (key: string | undefined): string | undefined => {
  if (!key) {
    return undefined;
  }
  return key.replace(/\\n/g, '\n');
};

export const FirebaseAdminProvider: Provider = {
  provide: 'FIREBASE_ADMIN',
  useFactory: () => {
    if (admin.apps.length > 0) {
      return admin.app();
    }

    const projectId = process.env.FIREBASE_PROJECT_ID;
    const clientEmail = process.env.FIREBASE_CLIENT_EMAIL;
    const privateKey = normalizePrivateKey(process.env.FIREBASE_PRIVATE_KEY);

    if (projectId && clientEmail && privateKey) {
      return admin.initializeApp({
        credential: admin.credential.cert({
          projectId,
          clientEmail,
          privateKey,
        }),
      });
    }

    // 환경 변수가 없으면 ADC로 초기화 시도 (GOOGLE_APPLICATION_CREDENTIALS 등)
    return admin.initializeApp({
      credential: admin.credential.applicationDefault(),
    });
  },
};
