module Page.Home.View exposing (view)

-- Standard Packages
import Html exposing (Html, div, br, text, h2)
import Html.Attributes exposing (href, class)

import Types exposing (Msg)

view : Html Msg
view =
    div [ class "page page--home"]  
        [ h2 [] [ text "Welcome to InstaElm" ] 
        , div [ class "h4"] [ text "Share your photos with millions of users"]
        , br [] []
        , div [ class "photo-grids" ] []
        ]

