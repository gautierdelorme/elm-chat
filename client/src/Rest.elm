module Rest exposing
  ( requestLogin
  , requestLogout
  , sendMessage
  , decodeTypeServer
  , decodeLoginResponse
  , decodeNewMessage
  , decodeNewUsersList
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


logoutJSON : Encoder.Value
logoutJSON =
    Encoder.object
      [ ("type", Encoder.string "logout")
      ]


messageJSON : Message -> Encoder.Value
messageJSON msg =
    Encoder.object
      [ ("type", Encoder.string "newMessage")
      , ("pseudo", Encoder.string msg.user.pseudo)
      , ("content", Encoder.string msg.content)
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
        "newMessage" ->
          Just NewMessage
        "newUsersList" ->
          Just NewUsersList
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
    ("content" := Decoder.string)


decodeNewMessage : String -> Maybe(Message)
decodeNewMessage msg =
  case Decoder.decodeString newMessage msg of
    Err error ->
      Nothing
    Ok (pseudo, message) ->
      Just (Message (User pseudo) message)


newUsersList : Decoder.Decoder (List String)
newUsersList =
  "users" := Decoder.list Decoder.string


decodeNewUsersList : String -> Maybe(Users)
decodeNewUsersList msg =
  case Decoder.decodeString newUsersList msg of
    Err error ->
      Nothing
    Ok users ->
      List.map User users
      |> Just

-- HANDLING


requestLogin : User -> Cmd Msg
requestLogin user =
  loginJSON user.pseudo
  |> Encoder.encode 0
  |> send


requestLogout : Cmd Msg
requestLogout =
  logoutJSON
  |> Encoder.encode 0
  |> send


sendMessage : Message -> Cmd Msg
sendMessage msg =
  messageJSON msg
  |> Encoder.encode 0
  |> send


send : String -> Cmd Msg
send msg =
  WebSocket.send server msg


listen : (String -> Msg) -> Sub Msg
listen =
  WebSocket.listen server
