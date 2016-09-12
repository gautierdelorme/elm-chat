var app = require('express')()
  , _ = require('lodash')
  , url = require('url')
  , server = require('http').Server(app)
  , WebSocketServer = require('ws').Server
  , wss = new WebSocketServer({ server: server })
  , port = 3000


server.listen(port, function () {
  console.log('Listening on ' + server.address().port)
})


// HANDLING


wss.activeSockets = {}

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
      break
    case 'logout':
      wss.processLogout(json_message['pseudo'])
      break
    case 'newMessage':
      wss.broadcast(message)
      break
    default:
      console.log(message)
  }
}

wss.broadcast = function(data) {
  wss.clients.map(function(client) {
    client.send(data)
  })
}

wss.sendNewUsersList = function() {
  wss.broadcast(JSON.stringify({
    type: 'newUsersList',
    users: _.keys(wss.activeSockets)
  }))
}

wss.processLogin = function(ws, pseudo) {
  var accepted = pseudo.length > 0 && !_.includes(_.keys(wss.activeSockets), pseudo)
  if (accepted) {
    wss.activeSockets[pseudo] = ws
    wss.sendNewUsersList()
  }
  ws.send(JSON.stringify({
    type: 'loginResponse',
    accepted: accepted
  }))
}

wss.processLogout = function(pseudo) {
  delete wss.activeSockets[pseudo]
  wss.sendNewUsersList()
}
