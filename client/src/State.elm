module State exposing (init, update, subscriptions)

import Types exposing (..)
import Chat.State as Chat
import Nav
import String


-- INIT


init : Result String Page -> (Model, Cmd Msg)
init result =
  Chat.init ""
  |> Model Home "" False
  |> Nav.urlUpdate result


-- UDPATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
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
      , chat = Chat.init model.pseudo
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
    ChatMsg msg ->
      let
        (chat, chatCmd) =
          Chat.update msg model.chat
      in
        { model
        | chat = chat
        }
        ! [ Cmd.map ChatMsg chatCmd ]


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Chat.subscriptions model.chat
      |> Sub.map ChatMsg
    ]
