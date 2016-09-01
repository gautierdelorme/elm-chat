module Chat.State exposing (init, update, subscriptions)

import Chat.Types exposing (..)
import Chat.Rest as Rest


init : (Model, Cmd Msg)
init =
  ( Model "" []
  , Cmd.none
  )


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Input str ->
      ({ model | input = str }, Cmd.none)
    Send ->
      ({ model | input = "" }, Rest.send model.input)
    Receive str ->
      ({ model | messages = str :: model.messages }, Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions model =
  Rest.listen Receive
