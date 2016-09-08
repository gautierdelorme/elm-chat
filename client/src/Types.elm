module Types exposing (..)

import Chat.Types as Chat
import Material

type Msg
  = Pseudo String
  | Login
  | LoginSucceed
  | LoginFailed
  | Logout
  | Mdl (Material.Msg Msg)
  | ChatMsg Chat.Msg


type Page
  = Home
  | Chat



type alias Model =
  { page : Page
  , pseudo : String
  , connected : Bool
  , mdl : Material.Model
  , chat : Chat.Model
  }
