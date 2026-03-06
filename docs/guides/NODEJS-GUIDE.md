# Node.js 초보자 가이드

**대상:** Node.js를 처음 접하는 분.  
**목표:** “Node.js가 뭔지”, “npm으로 뭔가 설치하고 실행하는 흐름”을 이해하는 것.

---

## 1. Node.js란?

- **JavaScript**를 **브라우저 밖(서버·PC)**에서 실행할 수 있게 해 주는 **런타임**입니다.
- 원래 JavaScript는 브라우저 안에서만 돌았는데, Node.js 덕분에 서버 프로그램·CLI 도구도 JavaScript로 짤 수 있습니다.
- 우리 프로젝트에서는 **백엔드(NestJS)**가 Node.js 위에서 동작합니다.

**다른 언어와 비교 (대략)**  
- “자바로 서버를 돌리면 JVM이 필요하다” → “JavaScript로 서버를 돌리면 Node.js가 필요하다”라고 보면 됩니다.

---

## 2. npm이란?

- **Node Package Manager**의 줄임말로, Node.js용 **패키지(라이브러리) 설치·관리 도구**입니다.
- `npm install` → `package.json`에 적힌 의존성을 받아서 `node_modules` 폴더에 넣습니다.
- `npm run start` → `package.json`의 `scripts`에 정의한 명령을 실행합니다.

**자주 쓰는 명령**

| 명령 | 설명 |
|------|------|
| `npm install` | 현재 폴더의 의존성 설치 (package.json 기준) |
| `npm run build` | 빌드 스크립트 실행 |
| `npm run start` / `npm run start:dev` | 앱 실행 (보통 서버 기동) |
| `node script.js` | JS 파일을 Node.js로 직접 실행 |

---

## 3. 모듈(require / import)

- 코드를 파일 단위로 나누고, 다른 파일의 함수·객체를 가져다 쓸 수 있게 해 주는 것이 **모듈**입니다.
- **가져오기:** `const something = require('모듈명')` (CommonJS) 또는 `import something from '모듈명'` (ES Module)
- **내보내기:** `module.exports = ...` 또는 `export default ...`
- NestJS·TypeScript 프로젝트에서는 보통 `import` / `export`를 씁니다.

---

## 4. 비동기(Async) 개념

- 서버는 “DB 조회”, “다른 API 호출”처럼 **시간이 걸리는 작업**이 많습니다.
- 그동안 다른 요청을 처리하려면 **비동기**로 처리합니다. “끝날 때까지 기다리지 않고, 끝나면 콜백/Promise로 이어서 처리”하는 방식입니다.
- **Promise**, **async/await**가 그걸 위한 문법입니다. 처음엔 “기다리는 코드를 깔끔하게 쓴다” 정도만 알면 됩니다.

```javascript
// async/await 예시 (느낌만)
const user = await userRepository.findOne({ where: { id: 1 } });
```

---

## 5. 이 프로젝트에서의 위치

- **backend/nest** 가 Node.js 프로젝트입니다.
- `npm run start:dev`로 NestJS 서버를 띄우면, 그 서버가 Node.js 위에서 돌아갑니다.
- 더 구체적인 구조는 **NESTJS-GUIDE.md**를 보면 됩니다.

---

## 6. 참고 링크

- [Node.js 공식](https://nodejs.org/)
- [npm 공식 문서](https://docs.npmjs.com/)
