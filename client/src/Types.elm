module Types exposing (..)

import Material


-- Update messages


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
  | UsersListReceived Users
  | UserConnected User
  | UserDisconnected User
  | Mdl (Material.Msg Msg)


-- Server messages


type MsgServer
  = LoginResponse
  | NewMessage
  | NewUsersList
  | NewUser
  | FormerUser


-- Pagination


type Page
  = Home
  | Chat


-- MODELS


type alias User =
  { pseudo : String
  }


type alias Message =
  { user : User
  , content : String
  }


type alias Messages =
  List Message

type alias Users =
  List User


type alias Model =
  { page : Page
  , user : User
  , connected : Bool
  , input : String
  , messages : Messages
  , connectedUsers : Users
  , mdl : Material.Model
  }
