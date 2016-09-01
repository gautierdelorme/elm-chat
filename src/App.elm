module App exposing (main)

import State
import View
import Html.App as App


main : Program Never
main =
  App.program
    { init = State.init
    , view = View.view
    , update = State.update
    , subscriptions = State.subscriptions
    }
