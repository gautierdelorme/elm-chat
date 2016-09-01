module State exposing (init, update, subscriptions)

import Types exposing (..)
import Chat.State as Chat


init : (Model, Cmd Msg)
init =
  let
    (chat, chatCmd) =
      Chat.init
  in
    ( Model chat
    , Cmd.batch
        [ Cmd.map ChatMsg chatCmd
        ]
    )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ChatMsg msg ->
      let
        (chat, chatCmd) =
          Chat.update msg model.chat
      in
        ( { model | chat = chat }, Cmd.map ChatMsg chatCmd )


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Chat.subscriptions model.chat
        |> Sub.map ChatMsg
    ]
