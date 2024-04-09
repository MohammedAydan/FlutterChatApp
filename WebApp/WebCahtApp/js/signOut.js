import { auth } from "./firebaseConfig";

export const signOut = async () => {
    try {
        await auth.signOut();
        return true;
    } catch (error) {
        console.error(error);
        return null;
    }
}