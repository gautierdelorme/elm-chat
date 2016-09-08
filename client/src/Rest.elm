module Rest exposing (send, listen)

import Types exposing (..)
import WebSocket


server : String
server =
  "ws://localhost:3000"


send : String -> Cmd Msg
send msg =
  WebSocket.send server msg


listen : (String -> Msg) -> Sub Msg
listen =
  WebSocket.listen server
