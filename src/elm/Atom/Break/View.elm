module Atom.Break.View exposing (br1, br2, br3)

import Html exposing (Html, div)
import Html.Attributes exposing (class)

br1 : Html msg
br1 = 
    div [ class "br br-50" ] []

br2 : Html msg
br2 = 
    div [ class "br br-100" ] []

br3 : Html msg
br3 = 
    div [ class "br br-200" ] []