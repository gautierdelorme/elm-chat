module Chat.Types exposing (..)

import Material


type Msg
  = Input String
  | Pseudo String
  | Send
  | Receive String
  | Mdl (Material.Msg Msg)


type alias Messages =
  List String


type alias Model =
  { input : String
  , pseudo : String
  , messages : Messages
  , mdl : Material.Model
  }
