{-- Email is a helper function that renders the 
input and label
--}
module Molecule.Email exposing (view)
import Html exposing (Html, div, label, text, input)
import Html.Attributes exposing (id, type_, value, placeholder, for)
import Html.Events exposing (onInput)

view : mainMsg -> msg -> String -> Html mainMsg
view mainMsg msg model = 
    div [] 
        [ div [] [ label [ for "password" ] [ text "Password" ] ]
        , div [] 
            [ input [ placeholder "Enter password"
            , id "password"
            , type_ "password"
            , onInput (mainMsg << msg)
            , value model ] [] 
            ]
    ]