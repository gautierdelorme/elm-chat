module Types exposing (Msg(ChatMsg), Model)

import Chat.Types as Chat


type Msg
  = ChatMsg Chat.Msg

type alias Model =
  { chat : Chat.Model
  }
