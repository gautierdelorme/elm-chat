module View exposing (view)

import Types exposing (..)
import Chat.View as Chat
import Html exposing (..)
import Html.App as Html
import Html.Events exposing (..)
import Html.Attributes exposing (..)


view : Model -> Html Msg
view model =
  div
    []
    [ viewHeader model
    , viewPage model
    ]

viewHeader : Model -> Html Msg
viewHeader model =
  case model.connected of
    True ->
      viewHeaderConnected model
    False ->
      viewHeaderDisconnected model


viewHeaderConnected : Model -> Html Msg
viewHeaderConnected model =
  div []
  [ span [] [ text ("Connected as "++model.pseudo) ]
  , button [ onClick Logout ] [ text "Logout" ]
  ]


viewHeaderDisconnected : Model -> Html Msg
viewHeaderDisconnected model =
  div []
  [ input [ onInput Pseudo, value model.pseudo, placeholder "Enter a pseudo" ] []
  , button [ onClick Login ] [ text "Login" ]
  ]


viewPage : Model -> Html Msg
viewPage model =
  case model.page of
    Home ->
      div [] []
    Chat ->
      Chat.view model.chat
      |> Html.map ChatMsg
