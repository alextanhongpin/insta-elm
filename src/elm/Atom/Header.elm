module Atom.Header exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)

{-- NOTE
    * We do not use the name header to avoid namespace 
    * There's already a Html.header
--}
app_header : Html a
app_header =
    div [ class "header" ] [
        div [ class "header-brand" ] [ text "InstaElm" ],
        div [ class "header-links" ] [
            a [] [ text "Login" ],
            a [] [ text "Signup" ]
        ]
    ]