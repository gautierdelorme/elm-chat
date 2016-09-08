module View exposing (view)

import Types exposing (..)
import Chat.View as Chat
import Html exposing (..)
import Html.App as Html
import Material.Scheme
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Layout as Layout
import Material.Color as Color
import Material.Options as Options
import Material.Typography as Typo
import Material.Icon as Icon
import Material.Options as Options exposing (css)


view : Model -> Html Msg
view model =
  Layout.render Mdl
    model.mdl
    [ Layout.fixedHeader
    , Layout.fixedDrawer
    ]
    { header = viewHeader model
    , drawer = viewDrawer
    , tabs = ( [], [] )
    , main = [ stylesheet, viewBody model ]
    }

viewHeader : Model -> List (Html Msg)
viewHeader model =
  [ Layout.row []
    [ Layout.title [] [ text "elm-chat" ]
    , Layout.spacer
    , case model.connected of
        True ->
          viewHeaderConnected model
        False ->
          span [] []
    ]
  ]

viewDrawer : List (Html Msg)
viewDrawer =
  [ Layout.title [] [ text "Connected users" ]
  ]

viewBody : Model -> Html Msg
viewBody model =
  Options.div
    [ css "display" "flex"
    , css  "flex" "1"
    ]
    [ case model.connected of
        True ->
          span [] []
        False ->
          viewHeaderDisconnected model
    , viewPage model
    ]
  |> Material.Scheme.topWithScheme Color.Teal Color.Green


viewHeaderConnected : Model -> Html Msg
viewHeaderConnected model =
  Layout.navigation []
  [ Options.styled span [ Typo.body2 ] [ text ("Connected as "++model.pseudo) ]
  , Layout.link
    [ Layout.onClick Logout
    , Layout.href "#"
    ]
    [ Icon.i "power_settings_new" ]
  ]


viewHeaderDisconnected : Model -> Html Msg
viewHeaderDisconnected model =
  div []
  [ Textfield.render Mdl [0] model.mdl
    [ Textfield.label "Enter a pseudo"
    , Textfield.floatingLabel
    , Textfield.value model.pseudo
    , Textfield.onInput Pseudo
    ]
  , Button.render Mdl [0] model.mdl
    [ Button.colored
    , Button.onClick Login
    ]
    [ text "Login"]
  ]


viewPage : Model -> Html Msg
viewPage model =
  case model.page of
    Home ->
      div [] []
    Chat ->
      Chat.view model.chat
      |> Html.map ChatMsg


-- CSS


stylesheet : Html a
stylesheet =
  Options.stylesheet """
  .mdl-layout__content {
    height: 100%;
  }
  .mdl-layout__content > div {
    height: 100%;
    display: flex;
  }
  """
