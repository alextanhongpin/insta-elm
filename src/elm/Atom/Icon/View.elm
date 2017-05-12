module Atom.Icon.View exposing (view)

import Html exposing (Html, i, text)
import Html.Attributes exposing (class)

view : String -> Html msg
view icon = 
    i [ class "material-icons" ] [ text icon ]
