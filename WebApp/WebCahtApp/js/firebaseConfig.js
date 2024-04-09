import { initializeApp } from "firebase/app";
import { getAnalytics } from "firebase/analytics";
import { getFirestore } from "firebase/firestore/lite";
import { getAuth } from "firebase/auth";

const firebaseConfig = {
    apiKey: "AIzaSyBcy88bxwDs30ImsMvnqnX-UpwOapzqka4",
    authDomain: "blog-mag-d37a8.firebaseapp.com",
    projectId: "blog-mag-d37a8",
    storageBucket: "blog-mag-d37a8.appspot.com",
    messagingSenderId: "419151198841",
    appId: "1:419151198841:web:e8b4f2b483ad0b9470f2a8",
    measurementId: "G-V4WQLRR7SM",
  };
  
  // Initialize Firebase
  export const app = initializeApp(firebaseConfig);
  export const db = getFirestore(app);
  export const analytics = getAnalytics(app);
  export const auth = getAuth(app);