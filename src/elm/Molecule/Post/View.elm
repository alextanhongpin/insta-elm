module Molecule.Post.View exposing (view)

import Html exposing (Html, a, div, img, text)
import Html.Attributes exposing (class, href)


-- ROUTER


import Router.Main exposing (reverseRoute, onClickPreventDefault)
import Router.Types exposing (Route(..))


-- VIEW


view : Route -> msg -> Html msg
view route act = 
    div [ class "post-item" ]
        [ div [ class "post-item__image" ] [ img [] [] ]
        , div [ class "post-item__content" ] 
            [ a [ href (reverseRoute route)
                , onClickPreventDefault act
                , class "post-item__content-header" ] [ text "This guy is rich. Find out why." ]
            , div [ class "post-item__content-body" ] [ text "submitted 7 hours ago by someone to", a [] [ text "r/golang" ]]
            , div [ class "br br-100" ] []
            , div [ class "post-item__content-footer"] [ text "100 comments | share | save"]
            ]
        ]