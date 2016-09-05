module Types exposing (..)

import Chat.Types as Chat


type Msg
  = Pseudo String
  | Login
  | LoginSucceed
  | LoginFailed
  | Logout
  | ChatMsg Chat.Msg


type Page
  = Home
  | Chat



type alias Model =
  { page : Page
  , pseudo : String
  , connected : Bool
  , chat : Chat.Model
  }
