import { addDoc, collection } from "firebase/firestore/lite";
import { db } from "./firebaseConfig";

export const addVersion = async () => {
  const version = document.querySelector("#version").value;
  const versionUrl = document.querySelector("#version-url").value;

  if (!version || !versionUrl) return false;

  const versionCol = collection(db, "versions");

  await addDoc(versionCol, {
    version,
    url: versionUrl,
    works: true,
    createdAt: new Date().getTime(),
  });

  return true;
};
