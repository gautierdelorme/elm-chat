var app = require('express')()
  , server = require('http').Server(app)
  , WebSocketServer = require('ws').Server
  , wss = new WebSocketServer({ server: server })
  , port = 3000

wss.broadcast = function(data) {
  wss.clients.map(function(client) {
    client.send(data)
  })
}

wss.on('connection', function(ws) {
  ws.on('message', function(message) {
    wss.broadcast(message)
  })
})

server.listen(port, function () {
  console.log('Listening on ' + server.address().port)
})
