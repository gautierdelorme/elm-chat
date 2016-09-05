module Nav exposing (..)

import Types exposing (..)
import Navigation
import UrlParser exposing (Parser, (</>), format, int, oneOf, s, string)
import String


goTo : Page -> Cmd Msg
goTo page =
  Navigation.newUrl (toHash page)


toHash : Page -> String
toHash page =
  case page of
    Home ->
      "#home"
    Chat ->
      "#chat"


hashParser : Navigation.Location -> Result String Page
hashParser location =
  UrlParser.parse identity pageParser (String.dropLeft 1 location.hash)


pageParser : Parser (Page -> a) a
pageParser =
  oneOf
    [ format Home (s "home")
    , format Chat (s "chat")
    ]


urlUpdate : Result String Page -> Model -> (Model, Cmd Msg)
urlUpdate result model =
  case result of
    Err _ ->
      model
      ! [ Navigation.modifyUrl (toHash model.page) ]
    Ok Chat ->
      case model.connected of
        True ->
          { model
          | page = Chat
          }
          ! []
        False ->
          urlUpdate (Err "Not connected") model
    Ok page ->
      { model
      | page = page
      }
      ! []
