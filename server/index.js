import express from 'express'
import {kanjiAnywhere, readingBeginning, setup as setupJmdict} from 'jmdict-simplified-node'
const app = express()

const jmdictPromise = setupJmdict('jmdict_db', 'jmdicten.json')

const {db} = await jmdictPromise

app.get('/', (req, res) => res.send("This server only provides APIs for the dictionary app.\nThese results are provided using JMDICT dictionary files (in particular the json simplified version at https://github.com/scriptin/jmdict-simplified). Both original and simplified JMDICT files are made available under a CC-BY-SA 4.0 license. Refer to https://www.edrdg.org/wiki/index.php/JMdict-EDICT_Dictionary_Project for the sources and to https://creativecommons.org/licenses/by-sa/4.0/legalcode.en for the legal code of the license."))

app.get('/search/reading/:reading', async (req, res) => {
   var w = req.params['reading']
   var results = await readingBeginning(db, w)
   res.json({words: results, license: "These results are provided using JMDICT dictionary files (in particular the json simplified version at https://github.com/scriptin/jmdict-simplified). Both original and simplified JMDICT files are made available under a CC-BY-SA 4.0 license. Refer to https://www.edrdg.org/wiki/index.php/JMdict-EDICT_Dictionary_Project for the sources and to https://creativecommons.org/licenses/by-sa/4.0/legalcode.en for the legal code of the license."})
})

app.get('/search/kanji/:kanji', async (req, res) => {
   var w = req.params['kanji']
   var results = await kanjiAnywhere(db, w)
   res.json({words: results, license: "These results are provided using JMDICT dictionary files (in particular the json simplified version at https://github.com/scriptin/jmdict-simplified). Both original and simplified JMDICT files are made available under a CC-BY-SA 4.0 license. Refer to https://www.edrdg.org/wiki/index.php/JMdict-EDICT_Dictionary_Project for the sources and to https://creativecommons.org/licenses/by-sa/4.0/legalcode.en for the legal code of the license."})
})

app.get('/search/english/:english', async (req, res) => {
   res.json("This operation is not supported yet.\nThese results are provided using JMDICT dictionary files (in particular the json simplified version at https://github.com/scriptin/jmdict-simplified). Both original and simplified JMDICT files are made available under a CC-BY-SA 4.0 license. Refer to https://www.edrdg.org/wiki/index.php/JMdict-EDICT_Dictionary_Project for the sources and to https://creativecommons.org/licenses/by-sa/4.0/legalcode.en for the legal code of the license.")
})

app.get('/dictionary/complete', (req, res) => {
   res.sendFile("jmdicten.json", {root: import.meta.dirname})
})

app.get('/dictionary/common', (req, res) => {
   res.sendFile("jmdictcommon.json", {root: import.meta.dirname})
})

app.get('/dictionary', (req, res) => res.end("These results are provided using JMDICT dictionary files (in particular the json simplified version at https://github.com/scriptin/jmdict-simplified). Both original and simplified JMDICT files are made available under a CC-BY-SA 4.0 license. Refer to https://www.edrdg.org/wiki/index.php/JMdict-EDICT_Dictionary_Project for the sources and to https://creativecommons.org/licenses/by-sa/4.0/legalcode.en for the legal code of the license."))

app.listen(5000, () => {
   console.log("Server running.")
})