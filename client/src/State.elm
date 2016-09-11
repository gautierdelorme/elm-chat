module State exposing (init, update, subscriptions)

import Types exposing (..)
import Rest
import Nav
import Material

-- INIT


init : Result String Page -> (Model, Cmd Msg)
init result =
  Model Home "" False "" [] Material.model
  |> Nav.urlUpdate result


-- UDPATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Mdl msg ->
      Material.update msg model
    Pseudo str ->
      { model | pseudo = str
      }
      ! []
    Login ->
      model
      ! [ Rest.requestLogin model
        ]
    LoginSucceed ->
      { model | connected = True
      }
      ! [ Nav.goTo Chat ]
    LoginFailed ->
      model ! []
    Logout ->
      { model | connected = False
              , pseudo = ""
              , messages = []
      }
      ! [ Rest.requestLogout model
        , Nav.goTo Home
        ]
    Input str ->
      { model | input = str
      }
      ! []
    Send ->
      { model | input = ""
      }
      ! [ Rest.sendMessage (Message model.pseudo model.input)
        ]
    Receive msg ->
      case Rest.decodeTypeServer msg of
        Nothing ->
          model ! []
        Just msg_type ->
          case msg_type of
            LoginResponse ->
              case Rest.decodeLoginResponse msg of
                Nothing ->
                  update LoginFailed model
                Just loginResponse ->
                  case loginResponse of
                    True ->
                      update LoginSucceed model
                    False ->
                      update LoginFailed model
            NewMessage ->
              case Rest.decodeNewMessage msg of
                Nothing ->
                  model ! []
                Just newMessage ->
                  update (MessageReceive newMessage) model
    MessageReceive msg ->
      { model | messages = msg :: model.messages
      }
      ! []


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Rest.listen Receive
    , Material.subscriptions Mdl model
    ]
