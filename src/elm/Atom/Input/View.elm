module Atom.Input.View exposing (view)

import Html exposing (Html, div, input, text, label)
import Html.Attributes exposing (class, for, id, placeholder, type_, value)
import Html.Events exposing (onInput)

import Atom.Input.Types exposing (Model)
view : Model -> (String -> msg) -> String -> Html msg

view model msg value_ = 
    div [ class "input-group" ] 
        [ div [ class "br br-50" ] []
        , div []
            [ label 
                [ class "input-group__label"
                , for model.id ] 
                [ text model.label ] 
                ]
        , div [] 
            [ input 
                [ class "input-group__input"
                , placeholder model.placeholder
                , id model.id
                , type_ model.type_
                , onInput msg
                , value value_ 
                ] [] 
        ]
    ]