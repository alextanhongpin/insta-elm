module Page.Login.View exposing (..)

import Html exposing (Html, div, form, input, text, button)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (..)
import Page.Login.Types exposing (..)

view : Model -> Html Msg
view model =
    div [] [ 
        div [] [ text "Login to Continue" ],
        form [] [
            div [] [ text "This is a form" ],
            input [ placeholder "Enter email", onInput OnInputEmail, value model.email ] [],
            input [ placeholder "Enter password" ] [],
            div [] [ text model.email ],
            button [ ] [ text "Submit" ]
        ]
    ]