module View exposing (view)

import Types exposing (..)
import String
import Html exposing (..)
import Material.Scheme
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Layout as Layout
import Material.Color as Color
import Material.Options as Options
import Material.Typography as Typo
import Material.Icon as Icon
import Material.List as List
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
      chatView model


chatView : Model -> Html Msg
chatView model =
  Options.div
    [ css "display" "flex"
    , css "flex-direction" "column"
    , css  "flex" "1"
    ]
    [ viewMessages model
    , Options.div
      [ css "display" "flex"
      , css  "margin" "0 10px 0 10px"
      ]
      [ Textfield.render Mdl [0] model.mdl
        [ Textfield.label "Write something..."
        , Textfield.floatingLabel
        , Textfield.value model.input
        , Textfield.onInput Input
        , css "flex" "1"
        ]
      , Button.render Mdl [0] model.mdl
        [ Button.colored
        , Button.onClick Send
        , css "margin-top" "15px"
        ]
        [ Icon.i "send" ]
      ]
    ]

viewMessages : Model -> Html msg
viewMessages model =
  List.reverse model.messages
  |> List.map (viewMessage model)
  |> List.ul
    [ css "overflow-y" "scroll"
    , css  "flex" "1"
    ]

viewMessage : Model -> String -> Html msg
viewMessage model msg =
  List.li [ List.withBody ]
    [ Options.div
      [ Options.center
      , Color.background (Color.color Color.Amber Color.S500)
      , Color.text Color.accentContrast
      , Typo.title
      , css "width" "36px"
      , css "height" "36px"
      , css "margin-right" "2rem"
      ]
      [ String.left 1 model.pseudo
        |> String.toUpper
        |> text
      ]
    , List.content []
      [ text model.pseudo
      , List.body [] [ text msg ]
      ]
    ]

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
