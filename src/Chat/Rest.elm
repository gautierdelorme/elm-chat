module Chat.Rest exposing (send, listen)

import Chat.Types exposing (..)
import Json.Decode exposing (..)
import WebSocket


echoServer : String
echoServer =
  "ws://echo.websocket.org"


decodeMessages : Decoder Messages
decodeMessages =
    "messages" := list string


send : String -> Cmd Msg
send msg =
  WebSocket.send echoServer msg


listen : (String -> Msg) -> Sub Msg
listen =
  WebSocket.listen echoServer
