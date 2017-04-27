module Page.Profile.View exposing (view)

import Html exposing (Html, b, br, div, span, text)
import Html.Attributes exposing (class)
import Types exposing (Msg)

view : Html Msg
view = 
    div [ class "page page--profile" ] 
        [ user
        ]


user : Html Msg
user =
    div [ class "user" ] 
        [ br [] []
        , div [ class "user-photo" ] [ ]
        , br [] []
        , b [] [ text "John.Doe" ]
        , div [] 
            [ span [] [ text "101 Followers" ]
            , span [] [ text " " ] 
            , span [] [ text "100 Photos" ]
            ]
        , div [] (List.map grids ["photo1", "photo2", "photo3","photo4", "photo5", "photo6"])
    ]

grids : String -> Html Msg
grids str =
    div [ class "grid" ] [ text str ]