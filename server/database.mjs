import { initializeApp } from "firebase/app";
import { getFirestore, doc, setDoc } from "firebase/firestore";
import { createRequire } from "module"

const require = createRequire(import.meta.url)
const firebaseConfing = require("./config.json")
const app = initializeApp(firebaseConfing)
const firestore = getFirestore(app)
const dictionary = require("./jmdictcommon.json")

async function addTags() {
   for (let key in dictionary.tags) {
      try {
         await setDoc(doc(firestore, "tags", key), {explanation: dictionary.tags[key]});
      } catch (e) {
         console.error("Error: ", e);
      }
     console.log(dictionary.tags[key])
   }
}

addTags()