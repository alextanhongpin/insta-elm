module Molecule.Post.View exposing (view)

import Html exposing (Html, a, div, img, text)
import Html.Attributes exposing (class, href, src)

import Molecule.Post.Types exposing (Topic)
-- ROUTER


import Router.Main exposing (reverseRoute, onClickPreventDefault)
import Router.Types exposing (Route(..))


-- VIEW


view : Route -> Route -> msg -> msg -> Topic -> Html msg
view route topicRoute topicAct act model =
    div [ class "post-item" ]
        [ div [ class "post-item__image" ] [ img [ src "" ] [] ]
        , div [ class "post-item__content" ] 
            [ a [ href (reverseRoute route)
                , onClickPreventDefault act
                , class "post-item__content-header" ] [ text model.title ]

            , div [ class "post-item__content-body" ]
                [ text "submitted "
                , text model.createdAt
                , text " by "
                , text model.owner 
                , text " to "
                , a [ href (reverseRoute topicRoute)
                    , onClickPreventDefault topicAct 
                    ] [ text model.topic ]
                ]

            -- BR
            , div [ class "br br-100" ] []
            
            , div [ class "post-item__content-footer"]
                [ text ((toString model.commentCount) ++ " comments | share | save") ]
            ]
        ]