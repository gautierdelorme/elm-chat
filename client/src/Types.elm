module Types exposing (..)

import Material


type Msg
  = Pseudo String
  | Login
  | LoginSucceed
  | LoginFailed
  | Logout
  | Input String
  | Send
  | Receive String
  | MessageReceive Message
  | Mdl (Material.Msg Msg)


type MsgServer
  = LoginResponse
  | NewMessage


type Page
  = Home
  | Chat


type alias Message =
  { pseudo : String
  , content : String
  }


type alias Messages =
  List Message


type alias Model =
  { page : Page
  , pseudo : String
  , connected : Bool
  , input : String
  , messages : Messages
  , mdl : Material.Model
  }
