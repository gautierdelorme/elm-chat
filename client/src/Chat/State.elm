module Chat.State exposing (init, model, update, subscriptions)

import Chat.Types exposing (..)
import Chat.Rest as Rest
import String
import Material

-- INIT


init : String -> Model
init pseudo =
  Model "" pseudo [] Material.model

model : Model
model =
    Model "" "gautier" [] Material.model

-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Mdl msg ->
      Material.update msg model
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
      case String.isEmpty model.input of
        False ->
          { model
          | input = ""
          }
          ! [ Rest.send (model.pseudo++": "++model.input)
            ]
        True ->
          model
          ! []
    Receive str ->
      { model
      | messages = str :: model.messages
      }
      ! []


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Rest.listen Receive
