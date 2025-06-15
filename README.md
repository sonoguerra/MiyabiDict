# Miyabi
Miyabi è un dizionario online che permette di ottenere le definizioni inglesi di parole giapponesi.\
La PWA è stata realizzata come progetto finale del corso di Programmazione di Sistemi Embedded da Coletto Damiano, Guerra Thomas e Pinzan Davide.


## Utilizzo
### Dizionario
La funzionalità principale della PWA è quella del dizionario, accessibile dalla seconda tab di navigazione.\
Selezionando l'icona della bandiera giapponese si possono immettere parole in romaji (alfabeto latino, si noti che scrivere in maiuscolo viene interpretato come katakana), kanji (caratteri tradizionali cinesi) e kana (sillabario giapponese). È possibile testare la funzionalità usando le seguenti parole:\
koromo (vestiti), KONEKO (gattino), 果実 (frutto), ひみつ (segreto), ピアノ (piano), 結ぶ (collegare).\
Selezionando invece la bandiera inglese si potranno ricercare termini inglesi e ottenere come risultato i lemmi giapponesi nelle cui definizioni tali termini cercati appaiono.\
Un doppio tocco sulla barra di ricerca aprirà la cronologia delle ricerche passate che, se eseguite in presenza di connettività, corrisponderanno ai risultati in cache.
Cliccando su uno dei risultati si aprirà la pagina corrispondente al termine, listando le definizioni legate e informazioni relative, e mostrando un'icona che permette di salvare (o rimuovere) una parola nella propria collezione.
### Collezione
La collezione è accessibile solo se si è autenticati nell'applicazione, poiché la sua funzione è principalmente quella di sincronizzare i termini che un utente vuole memorizzare su più dispositivi (è possibile, nel caso non si voglia eseguire il login con email e password, entrare come ospite).
### Matching
Un semplice gioco in stile quiz a risposta multipla in cui si deve associare la parola a schermo con la sua definizione corretta. Ogni partita si compone di 10 turni.

## Offline
L'applicazione è utilizzabile completamente offline: su Android e Desktop questo significa che l'applicazione può essere avviata anche in assenza di connessione, mentre iOS richiede almeno di essere online durante l'avvio, dopodiché l'applicazione è utilizzabile in caso di perdita di segnale.\
La completa funzionalità non è garantita se non è stato possibile cacheare le risorse per intero (per esempio, se non si è mai provato ad accedere alle proprie parole salvate in presenza di connessione); anche la funzionalità di ricerca nel dizionario sarà conseguentemente limitata alle ricerche cacheate se non è stato installato il dizionario localmente (nel cui caso non sarà possibile nemmeno giocare al matching poiché non dispone dei dati completi).
L'installazione del dizionario è possibile premendo sulla rotellina e successivamente sul tasto di download. Dopodiché sarà possibile effettuare le ricerche (e anche giocare al Matching) sul dizionario nella sua interezza.