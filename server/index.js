var app = require('express')()
  , _ = require('lodash')
  , url = require('url')
  , server = require('http').Server(app)
  , WebSocketServer = require('ws').Server
  , wss = new WebSocketServer({ server: server })
  , port = 3000


wss.connectedUsers = []

wss.broadcast = function(data) {
  wss.clients.map(function(client) {
    client.send(data)
  })
}

wss.on('connection', function(ws) {
  ws.on('message', function(message) {
    wss.processMessage(ws, message)
  })
})

wss.processMessage = function(ws, message) {
  var json_message = JSON.parse(message)
  switch (json_message['type']) {
    case 'login':
      wss.processLogin(ws, json_message['pseudo'])
      break;
    default:
      wss.broadcast(message)
  }
}

wss.processLogin = function(ws, pseudo) {
  var accepted = pseudo.length > 0 && !_.includes(wss.connectedUsers, pseudo)
  if (accepted) {
    wss.connectedUsers.push(pseudo)
  }
  ws.send(JSON.stringify({
    type: 'loginResponse',
    accepted: accepted
  }))
}

server.listen(port, function () {
  console.log('Listening on ' + server.address().port)
})
