import { signInWithEmailAndPassword, signInWithPopup } from "firebase/auth";
import { GoogleAuthProvider } from "firebase/auth";
import { auth } from "./firebaseConfig";

export const signin = async () => {
  const email = document.querySelector("#email").value;
  const password = document.querySelector("#password").value;
  if (!email || !password) return null;

  try {
    const res = await signInWithEmailAndPassword(auth, email, password);
    return res.user;
  } catch (error) {
    console.error(error);
    return null;
  }
};

export const signinWithGoogle = async () => {
  const provider = new GoogleAuthProvider();
  try {
    const res = await signInWithPopup(auth, provider);
    return res.user;
  } catch (error) {
    console.error(error);
    return null;
  }
};
