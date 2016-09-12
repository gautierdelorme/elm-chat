module State exposing (init, update, subscriptions)

import Types exposing (..)
import Rest
import Nav
import Material

-- INIT


init : Result String Page -> (Model, Cmd Msg)
init result =
  { page = Home
  , user = User ""
  , connected = False
  , input = ""
  , messages = []
  , connectedUsers = []
  , mdl = Material.model
  }
  |> Nav.urlUpdate result


-- UDPATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Mdl msg ->
      Material.update msg model
    Pseudo str ->
      let
        user = model.user
      in
        { model | user = { user | pseudo = str }
        }
      ! []
    Login ->
      model
      ! [ Rest.requestLogin model.user
        ]
    LoginSucceed ->
      { model | connected = True
      }
      ! [ Nav.goTo Chat ]
    LoginFailed ->
      model ! []
    Logout ->
      let
        user = model.user
      in
        { model | connected = False
                , user = { user | pseudo = "" }
                , messages = []
        }
      ! [ Rest.requestLogout model.user
        , Nav.goTo Home
        ]
    Input str ->
      { model | input = str
      }
      ! []
    UsersListUpdated newUsersList ->
      { model | connectedUsers = newUsersList
      }
      ! []
    Send ->
      { model | input = ""
      }
      ! [ Message model.user model.input
          |> Rest.sendMessage
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
            NewUsersList ->
              case Rest.decodeNewUsersList msg of
                Nothing ->
                  model ! []
                Just newUsersList ->
                  update (UsersListUpdated newUsersList) model
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
