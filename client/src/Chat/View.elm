module Chat.View exposing (view)

import Chat.Types exposing (..)
import Html exposing (..)
import String
import Material.Button as Button
import Material.Textfield as Textfield
import Material.Icon as Icon
import Material.Options as Options exposing (css)
import Material.List as List
import Material.Color as Color
import Material.Typography as Typo


view : Model -> Html Msg
view model =
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
