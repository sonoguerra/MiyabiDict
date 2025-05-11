import { initializeApp } from "firebase/app";
import { setDoc, getFirestore, doc } from "firebase/firestore";
import { createRequire } from "module";

const require = createRequire(import.meta.url);
const firebaseConfig = require("./config.json");
const app = initializeApp(firebaseConfig);
const firestore = getFirestore(app);
const dictionary = require("./jmdictcommon.json");

async function addTags() {
   for (let key in dictionary.tags) {
      try {
         await setDoc(doc(firestore, "tags", key), {
            explanation: dictionary.tags[key],
         });
      } catch (e) {
         console.error("Error: ", e);
      }
      console.log(dictionary.tags[key]);
   }
}

async function addVocabulary(start, end) {
   for (let i = start; i <= end && i < dictionary.words.length; i++) {
      var vocab = dictionary.words[i]
      /*Nested arrays are not supported in Firebase. 
      This gets rid of the only possible instances of such a thing by removing antonyms and related words, might find a way to include them in the future.*/
      for (let j = 0; j < vocab.sense.length; j++) {
         vocab.sense[j].antonym = []
         vocab.sense[j].related = []
      }
      try {
         await setDoc(doc(firestore, "vocabulary", vocab.id), vocab,  {merge: true});
         console.log(vocab.kanji[0].text)
      } catch (e) {
         console.error("Error: ", e);
      }
   }
}







addTags()

addVocabulary(process.argv[2], process.argv[3]);
