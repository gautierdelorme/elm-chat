module Chat.Rest exposing (send, listen)

import Chat.Types exposing (..)
import WebSocket


echoServer : String
echoServer =
  "ws://localhost:3000"


send : String -> Cmd Msg
send msg =
  WebSocket.send echoServer msg


listen : (String -> Msg) -> Sub Msg
listen =
  WebSocket.listen echoServer
