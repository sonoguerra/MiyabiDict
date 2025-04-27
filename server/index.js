import express from 'express'
import {readingBeginning, setup as setupJmdict} from 'jmdict-simplified-node'
const app = express()

const jmdictPromise = setupJmdict('jmdict_db', 'jmdicten.json')

const {db} = await jmdictPromise

app.get('/', (req, res) => {
   res.send("This server only provides APIs for the dictionary app.")
})

app.get('/search/:reading', async (req, res) => {
   var results = await readingBeginning(db, req.params['reading'], 3)
   res.send(results)
})

app.listen(5000, () => {
   console.log("Server running.")
})