module Chat.State exposing (init, update, subscriptions)

import Chat.Types exposing (..)
import Chat.Rest as Rest


-- INIT


init : String -> Model
init pseudo =
  Model "" pseudo []


-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Input str ->
      { model
      | input = str
      }
      ! []
    Pseudo str ->
      { model
      | pseudo = str
      }
      ! []
    Send ->
      { model
      | input = ""
      }
      ! [ Rest.send (model.pseudo++": "++model.input)
        ]
    Receive str ->
      { model
      | messages = str :: model.messages
      }
      ! []


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Rest.listen Receive
