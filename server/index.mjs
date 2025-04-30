import express from 'express'
import {kanjiAnywhere, readingBeginning, setup as setupJmdict} from 'jmdict-simplified-node'
const app = express()

const jmdictPromise = setupJmdict('jmdict_db', 'jmdicten.json')

const {db} = await jmdictPromise

app.get('/', (req, res) => {
   res.send("This server only provides APIs for the dictionary app.")
})

app.get('/search/:word', async (req, res) => {
   
   var w = req.params['word']
   var isKanji = false

   //Checks for the presence of kanji at any point of the string
   for (var i = 0; i < w.length; i++) {
      if (w.codePointAt(i) >= 0x4E00 && w.codePointAt(i) <= 0x9FFF)
         isKanji = true
   }

   var results = isKanji ? await kanjiAnywhere(db, w) : await readingBeginning(db, w)
   res.send(results)

})

app.listen(5000, () => {
   console.log("Server running.")
})