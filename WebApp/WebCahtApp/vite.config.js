// vite.config.js
export default {
  optimizeDeps: {
    include: [
      'firebase/app',
      'firebase/analytics',
      'firebase/firestore/lite',
    ],
  },
};
