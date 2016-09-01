module Chat.Types exposing (Msg(Input, Send, Receive), Messages, Model)


type Msg
  = Input String
  | Send
  | Receive String

type alias Messages =
  List String

type alias Model =
  { input : String
  , messages : Messages
  }
