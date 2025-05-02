import express from 'express'
import {kanjiAnywhere, readingBeginning, setup as setupJmdict} from 'jmdict-simplified-node'
const app = express()

const jmdictPromise = setupJmdict('jmdict_db', 'jmdicten.json')

const {db} = await jmdictPromise

app.get('/', (req, res) => res.send("This server only provides APIs for the dictionary app."))

app.get('/search/reading/:reading', async (req, res) => {
   var w = req.params['reading']
   var results = await readingBeginning(db, w)
   res.json(results)
})

app.get('/search/english/:english', async (req, res) => {
   var w = req.params['english']
   //for
   res.send("This operation is not supported yet.")
})

app.get('/search/kanji/:kanji', async (req, res) => {
   var w = req.params['kanji']
   var results = await kanjiAnywhere(db, w)
   res.json(results)
})

app.get('/dictionary/complete', (req, res) => res.sendFile("jmdicten.json", {root: import.meta.dirname}))

app.get('/dictionary/common', (req, res) => res.sendFile("jmdictcommon.json", {root: import.meta.dirname}))

app.listen(5000, () => {
   console.log("Server running.")
})