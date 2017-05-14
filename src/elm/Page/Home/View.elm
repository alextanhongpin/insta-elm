module Page.Home.View exposing (view)

-- Standard Packages
import Html exposing (Html, div, br, text, h2)
import Html.Attributes exposing (href, class)

import Atom.Break.View exposing (br1, br2, br3)

import Types exposing (Msg)

view : Html Msg
view =
    div [ class "page page--home"]  
        [ br2
        , br2
        , h2 [] [ text "Welcome to NewsMap" ] 
        , br2
        , div [ class "h4"] [ text "Report news around your area. Share your thoughts here."]
        , br [] []
        , div [ class "photo-grids" ] []
        , br [] []
        , div [] [ text "Everyone is reading this" ]
        , br [] []
        ]