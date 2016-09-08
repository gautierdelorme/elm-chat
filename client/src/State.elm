module State exposing (init, update, subscriptions)

import Types exposing (..)
import Rest
import Nav
import String
import Material

-- INIT


init : Result String Page -> (Model, Cmd Msg)
init result =
  Model Home "gautier" True "" [] Material.model
  |> Nav.urlUpdate result


-- UDPATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Mdl msg ->
      Material.update msg model
    Pseudo str ->
      { model
      | pseudo = str
      }
      ! []
    Login ->
      case String.isEmpty model.pseudo of
        False ->
          update LoginSucceed model
        True ->
          model
          ! []
    LoginSucceed ->
      { model
      | connected = True
      }
      ! [ Nav.goTo Chat ]
    LoginFailed ->
      model
      ! []
    Logout ->
      { model
      | connected = False
      , pseudo = ""
      }
      ! [ Nav.goTo Home ]
    Input str ->
      { model
      | input = str
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
  Sub.batch
    [ Rest.listen Receive
    , Material.subscriptions Mdl model
    ]
