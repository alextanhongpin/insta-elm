module Atom.Comment exposing (..)


import Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


comment_box : String -> Html Msg
comment_box model =
    div [] [
        input [ placeholder "Enter comment here", value model, onInput OnChange ] []
    ]