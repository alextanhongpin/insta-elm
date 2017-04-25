module Main exposing (..)

import Html exposing (..)

import State exposing (..)
import Types exposing (..)
import View exposing (..)
import Navigation exposing (..)


-- APP


main : Program Never Model Msg
main =
  Navigation.program OnLocationChange
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }
