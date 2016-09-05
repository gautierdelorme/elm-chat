module Chat.Types exposing (..)


type Msg
  = Input String
  | Pseudo String
  | Send
  | Receive String


type alias Messages =
  List String


type alias Model =
  { input : String
  , pseudo : String
  , messages : Messages
  }
