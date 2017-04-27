module Atom.Comment exposing (..)


import Types exposing (..)
import Html exposing (Html, div, input)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onInput)


comment_box : String -> Html Msg
comment_box model =
    div [] [
        input [ placeholder "Enter comment here", value model, onInput OnChange ] []
    ]