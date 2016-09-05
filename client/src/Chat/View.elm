module Chat.View exposing (view)

import Chat.Types exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)


view : Model -> Html Msg
view model =
  div []
    [ viewMessages model.messages
    , input [ onInput Input, value model.input, placeholder "Write something..." ] []
    , button [ onClick Send ] [ text "Send" ]
    ]

viewMessages : List String -> Html msg
viewMessages messages =
  List.reverse messages
  |> List.map viewMessage
  |> div []

viewMessage : String -> Html msg
viewMessage msg =
  div [] [ text msg ]
