module Rest exposing
  ( requestLogin
  , sendMessage
  , decodeTypeServer
  , decodeLoginResponse
  , decodeNewMessage
  , listen
  )

import Types exposing (..)
import WebSocket
import Json.Encode as Encoder
import Json.Decode as Decoder exposing ((:=))

-- CONFIG

server : String
server =
  "ws://localhost:3000"


-- ENCODING


loginJSON : String -> Encoder.Value
loginJSON pseudo =
    Encoder.object
      [ ("type", Encoder.string "login")
      , ("pseudo", Encoder.string pseudo)
      ]


messageJSON : String -> String -> Encoder.Value
messageJSON pseudo msg=
    Encoder.object
      [ ("type", Encoder.string "new_message")
      , ("pseudo", Encoder.string pseudo)
      , ("message", Encoder.string msg)
      ]


-- DECODING

decode : Decoder.Decoder a -> String -> Maybe a
decode decoder msg =
  case Decoder.decodeString decoder msg of
    Err error ->
      Nothing
    Ok value ->
      Just value


typeServer : Decoder.Decoder String
typeServer =
  "type" := Decoder.string


decodeTypeServer : String -> Maybe(MsgServer)
decodeTypeServer msg =
  case Decoder.decodeString typeServer msg of
    Err error ->
      Nothing
    Ok value ->
      case value of
        "loginResponse" ->
          Just LoginResponse
        "new_message" ->
          Just NewMessage
        _ ->
          Nothing


loginResponse : Decoder.Decoder Bool
loginResponse =
  "accepted" := Decoder.bool


decodeLoginResponse : String -> Maybe(Bool)
decodeLoginResponse msg =
  decode loginResponse msg


newMessage : Decoder.Decoder (String, String)
newMessage =
  Decoder.object2 (,)
    ("pseudo" := Decoder.string)
    ("message" := Decoder.string)


decodeNewMessage : String -> Maybe(String, String)
decodeNewMessage msg =
  decode newMessage msg

-- HANDLING


requestLogin : Model -> Cmd Msg
requestLogin model =
  loginJSON model.pseudo
  |> Encoder.encode 0
  |> send


sendMessage : Model -> Cmd Msg
sendMessage model =
  messageJSON model.pseudo model.input
  |> Encoder.encode 0
  |> send


send : String -> Cmd Msg
send msg =
  WebSocket.send server msg


listen : (String -> Msg) -> Sub Msg
listen =
  WebSocket.listen server
