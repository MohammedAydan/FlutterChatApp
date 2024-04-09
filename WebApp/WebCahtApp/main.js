import "./style/style.css";
import { collection, getDocs } from "firebase/firestore/lite";
import { addVersion } from "./js/add";
import { onAuthStateChanged } from "firebase/auth";
import { signinWithGoogle } from "./js/signin";
import { signOut } from "./js/signOut";
import { auth, db } from "./js/firebaseConfig";
import googleImg from "/assets/images/google.png";

// Rest of your code
const containerVersions = document.querySelector(".container-versions");
const alertC = document.querySelector(".alert");
const versionCol = collection(db, "versions");

const getAllVersions = async () => {
  containerVersions.innerHTML = "<h3>Loading...</h3>";
  const response = await getDocs(versionCol);
  const versions = response.docs.map((doc) => doc.data());
  containerVersions.innerHTML = "";
  if (versions.length === 0)
    containerVersions.innerHTML = "<h3>No versions available</h3>";

  versions
    .sort((a, b) => a["createdAt"] - b["createdAt"])
    .forEach((version, index) => {
      const latest = index === 0 ? "Latest" : "";
      const versionItem = `
          <div class="version">
              <h3>ChatApp version: <span>${version.version} ${latest}</span></h3>
              <a href="${version.url}" target="_blank">Download</a>
          </div>
      `;
      if (version["works"] == true) {
        containerVersions.innerHTML += versionItem;
      }
    });
};

getAllVersions();

const addVersionClose = async () => {
  alertC.innerHTML = "";
};

const addVersionShow = async () => {
  alertC.innerHTML = `
      <div class="add-alert-container">
        <div class="add-alert">
          <div class="header">
            <p>App added to home screen</p>
            <button id="add-close">X</button>
          </div>
          <input type="text" placeholder="Enter version" id="version"/>
          <input type="url" placeholder="Enter url" id="version-url"/>
          <button id="add-version">Add</button>
        </div>
      </div>
    `;
  document
    .getElementById("add-close")
    .addEventListener("click", addVersionClose);
  document.getElementById("add-version").addEventListener("click", async () => {
    const res = await addVersion();
    if (res === null) {
      alert("You are not authorized to add versions");
    } else if (res == true) {
      addVersionClose();
      getAllVersions();
    } else {
      alert("Please fill all fields");
    }
  });
};

const authHeader = document.querySelector(".auth-header");

const checkAuth = async () => {
  authHeader.innerHTML = "Loading...";
  onAuthStateChanged(auth, (currentUser) => {
    if (currentUser != null) {
      if (currentUser.email == "mohammedaydan12@gmail.com") {
        authHeader.innerHTML = `
                <a id="add-show">Add</a>
                <a id="sign-out" class="sign-out">SignOut</a>
              `;
        document
          .getElementById("add-show")
          .addEventListener("click", addVersionShow);
        document
          .getElementById("sign-out")
          .addEventListener("click", async () => {
            await signOut();
            checkAuth();
          });
      } else {
        authHeader.innerHTML = `
                <a id="sign-out" class="sign-out">SignOut</a>
              `;
        document
          .getElementById("sign-out")
          .addEventListener("click", async () => {
            await signOut();
            checkAuth();
          });
      }
    } else {
      authHeader.innerHTML = `
                  <img
                    id="signin-with-google"
                    class="signin-with-google"
                    src=${googleImg}
                    alt=""
                  />
                `;
      document
        .getElementById("signin-with-google")
        .addEventListener("click", async () => {
          authHeader.innerHTML = "Loading...";
          await signinWithGoogle();
          checkAuth();
        });
    }
  });
};

checkAuth();
