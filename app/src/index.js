import express from 'express'

const app = express()

app.get('/', (req, res) => {
    res.send('Hello World')
})

// listen on port
const port = 3000;
app.listen(port, () => {
  var listenerWelcomeMessage = `listening on ${port}`
  console.log(listenerWelcomeMessage)
})
