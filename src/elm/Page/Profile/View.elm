module Page.Profile.View exposing (view)

import Html exposing (Html, a, b, br, div, span, text)
import Html.Attributes exposing (class, href)
import Types exposing (Msg(NavigateTo), Route(PhotoRoute))

import Routing exposing (reverseRoute, onClickPreventDefault)


-- VIEW


view : Html Msg
view =
    div [ class "page page--profile" ] 
        [ user
        ]


-- SUBVIEW


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
        , div [] (List.map grids ["1", "2", "3", "4", "5", "6"])
    ]


grids : String -> Html Msg
grids str =
    a [ class "grid"
      , href (reverseRoute (PhotoRoute str))
      , onClickPreventDefault (NavigateTo (PhotoRoute str))
     ] [ text str ]