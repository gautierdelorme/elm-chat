module View exposing (view)

import Types exposing (..)
import Chat.View as Chat
import Html exposing (..)
import Html.App as Html


view : Model -> Html Msg
view model =
  div
    []
    [ Chat.view model.chat
        |> Html.map ChatMsg
    ]
