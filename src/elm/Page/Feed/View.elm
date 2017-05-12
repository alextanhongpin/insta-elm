module Page.Feed.View exposing (view)


-- MOLECULE


import Molecule.Photo.Types exposing(PhotoID, Photo)


-- PAGE


import Page.Feed.Types exposing (Model, Msg(..))


-- DEPENDENCIES


import Html exposing (Html, a, br, i, button, div, text, img, input, label)
import Html.Attributes exposing (class, type_, placeholder, href, src)

import Router.Main exposing (reverseRoute, onClickPreventDefault)
import Router.Types exposing (Route(FeedRoute))

view : Model -> Html Msg
view model = 
    div [ class "page page-feed"] 
        [ div [] 
            [ a [ href (reverseRoute FeedRoute)
                , onClickPreventDefault (GoToTopic "Hello")
                ] 
                [ text "add a new post"
                , i [ class "material-icons"] [ text "add_circle_outline" ] 
                ]
            , a [] [ text "view all topics" ]      
            , input [ type_ "search", placeholder "Search for a topic" ] [] 
            ]
        , div [] 
            [ label [] [ text "create topic" ]
            , input [ type_ "text", placeholder "Enter text" ] []
            , input [ type_ "file" ] []
            , input [ type_ "text", placeholder "Photo Caption"] []
            , input [ type_ "search", placeholder "Search category" ] []
            , button [] [ text "submit" ]
            ]
        , div [ class "feed col-12" ]
            [ feedWithWrapperView
            , feedWithWrapperView
            , feedWithWrapperView
            ]
        , div [] (List.map photoThumbnailView model.photos) 
        ]


-- SUBVIEWS


feedWithWrapperView : Html Msg
feedWithWrapperView = 
    div [ class "feed-item-wrapper"] 
        [ feedView
        , div [ class "br br-200" ] []
        ]


feedView : Html Msg
feedView = 
    div [ class "feed-item" ]
        [ div [ class "feed-item__image" ] [ img [] [] ]
        , div [ class "feed-item__content" ] 
            [ a [ href (reverseRoute FeedRoute)
                , onClickPreventDefault (GoToTopic "Hello")
                , class "feed-item__content-header" ] [ text "This guy is rich. Find out why." ]
            , div [ class "feed-item__content-body" ] [ text "submitted 7 hours ago by someone to", a [] [ text "r/golang" ]]
            , div [ class "br br-100" ] []
            , div [ class "feed-item__content-footer"] [ text "100 comments | share | save"]
            ]
        ]

photoThumbnailView : (PhotoID, Photo) -> Html Msg
photoThumbnailView (id, model) =
    div []
        [ img [ src model.photoUrl, class "photo-thumbnail" ] []
        , div [] [ text model.userId ]
        , div [] [ text model.createdAt ]
        , div [] [ text model.updatedAt ]
        , div [] [ text model.displayName ]
        , div [] [ text model.userId ]
        , div [] [ text model.alt ]
        ]
