module Molecule.Card exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Msgs exposing (..)

import Atom.Comment exposing ( comment_box )

card : String -> Html Msg
card model = 
    div [ class "card" ] [
        div [ class "card-header" ] [
            div [ class "card-header__info" ] [
                div [ class "card-header__info-user-photo" ] [],
                div [ class "card-header__info-user-name" ] [ text "john doe" ]
            ],
            div [ class "card-header__timestamp" ] [ text "1d" ]
        ],
        div [ class "card-body" ] [
            div [ class "card-body__photo" ] []
        ],
        div [ class "card-footer" ] [
            div [] [
                b [] [ text "a" ],
                b [] [ text "b" ],
                b [] [ text "c" ],
                span [] [ text "like this" ]
            ],
            div [] [
                b [] [ text "john doe" ],
                span [] [ text model ]
            ],
            comment_box model
        ]
    ]