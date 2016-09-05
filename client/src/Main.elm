module App exposing (main)

import State
import View
import Nav
import Navigation

main : Program Never
main =
  Navigation.program (Navigation.makeParser Nav.hashParser)
    { init = State.init
    , view = View.view
    , update = State.update
    , urlUpdate = Nav.urlUpdate
    , subscriptions = State.subscriptions
    }
