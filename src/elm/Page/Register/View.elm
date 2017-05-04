module Page.Register.View exposing (view)

import Html exposing (Html, div, text)
import Page.Register.Types exposing (Model, Msg)

view : Model -> Html Msg
view model =
    div [] [ text "Register View" ]