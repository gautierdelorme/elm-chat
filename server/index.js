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


wss.connectedClients = {}

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
      wss.processLogout(ws)
      break
    case 'newMessage':
      wss.broadcast(message)
      break
    default:
      console.log(message)
  }
}

wss.broadcast = function(data) {
  _.map(wss.connectedClients, function(c) {
    c.ws.send(data)
  })
}


// PROCESSING


wss.processLogin = function(ws, pseudo) {
  var accepted = pseudo.length > 0 && wss.verifyPseudo(pseudo) && wss.verifyKey(ws)
  if (accepted) {
    wss.processNewUser(pseudo)
    wss.connectedClients[wss.keyFor(ws)] = {
      pseudo: pseudo,
      ws: ws
    }
    wss.registerOnCloseFor(ws)
    wss.processListUsers(ws)
  }
  ws.send(JSON.stringify({
    type: 'loginResponse',
    accepted: accepted
  }))
}

wss.processLogout = function(ws) {
  ws.close()
}

wss.processListUsers = function(ws) {
  ws.send(JSON.stringify({
    type: 'newUsersList',
    users: _.map(wss.connectedClients, function(c){return c.pseudo})
  }))
}

wss.processNewUser = function(pseudo) {
  wss.broadcast(JSON.stringify({
    type: 'newUser',
    pseudo: pseudo
  }))
}

wss.processFormerUser = function(pseudo) {
  wss.broadcast(JSON.stringify({
    type: 'formerUser',
    pseudo: pseudo
  }))
}


// HELPERS


wss.registerOnCloseFor = function(ws) {
  ws.on('close', function() {
    var pseudo = wss.connectedClients[wss.keyFor(this)].pseudo
    delete wss.connectedClients[wss.keyFor(this)]
    wss.processFormerUser(pseudo)
  })
}

wss.keyFor = function(ws) {
  return ws.upgradeReq.headers['sec-websocket-key']
}

wss.verifyKey = function(ws) {
  return wss.keyFor(ws) != null && wss.keyFor(ws) != undefined && !_.some(wss.connectedClients,function(_,k){return k == wss.keyFor(ws)})
}

wss.verifyPseudo = function(pseudo) {
  return !_.some(wss.connectedClients, function(c) { return c.pseudo == pseudo })
}
