module Main exposing (main)

import State exposing (init, update)
import Types exposing (Msg(OnLocationChange), Model)
import View exposing (view)
import Port exposing (subscriptions)
import Navigation

-- APP


main : Program Never Model Msg
main =
  Navigation.program OnLocationChange
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }
