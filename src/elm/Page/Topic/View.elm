module Page.Topic.View exposing (view)

import Html exposing (Html, div, text)

import Page.Topic.Types exposing (Model, Msg(..))

view : Model -> Html msg
view model =
    div [] [ text "topic view" ]

