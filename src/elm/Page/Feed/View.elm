module Page.Feed.View exposing (view)


-- ATOM


import Atom.Break.View exposing (br1, br2, br3)
-- import Atom.Icon.View as Icon exposing (view)


-- MOLECULE


import Molecule.Post.View as PostView exposing (view)
import Molecule.Photo.Types exposing(PhotoID, Photo)
import Molecule.Post.Types exposing (TopicID, Topic)

-- PAGE


import Page.Feed.Types exposing (Model, Msg(..))


-- DEPENDENCIES


import Html exposing (..)
import Html.Attributes exposing (..)

-- import Router.Main exposing (reverseRoute, onClickPreventDefault)
import Router.Types exposing (Route(..))

view : Model -> Html Msg
view model = 
    div [ class "page page-feed"]
        [ div [ class "container col-8" ] 
            [ br2
            , br2
            , div [ class "page-title" ] [ text "Feed" ]
            , br2
            --, div []
            --    [ a [ href (reverseRoute FeedRoute)
            --        , onClickPreventDefault (GoToTopic "Hello")
            --        ] 
            --        [ text "add a new post"
            --        , Icon.view "add_circle_outline"
            --        ]
            --    , a [] [ text "view all topics" ]      
            --    ]
            --, div [] 
            --    [ label [] [ text "create topic" ]
            --    , input [ type_ "text", placeholder "Enter text" ] []
            --    , input [ type_ "file" ] []
            --    , input [ type_ "text", placeholder "Photo Caption"] []
            --    , input [ type_ "search", placeholder "Search category" ] []
            --    , button [] [ text "submit" ]
            --    ]
            , div []
                [ select []
                    [ option [] [ text "Latest" ]
                    , option [] [ text "Most voted" ]
                    , option [] [ text "Popular" ]
                    ]
                ]
            , br2
            , case model.topics of
                Just topics ->
                    div [] (List.map postViewWrapper topics)
                Nothing ->
                    span [] [ text "no topics" ]

            -- , div [] (List.map photoThumbnailView model.photos) 
            ]
        ]


-- SUBVIEW


--photoThumbnailView : (PhotoID, Photo) -> Html Msg
--photoThumbnailView (id, model) =
--    div []
--        [ img [ src model.photoUrl, class "photo-thumbnail" ] []
--        , div [] [ text model.userId ]
--        , div [] [ text model.createdAt ]
--        , div [] [ text model.updatedAt ]
--        , div [] [ text model.displayName ]
--        , div [] [ text model.userId ]
--        , div [] [ text model.alt ]
--        ]


postViewWrapper : (TopicID, Topic) -> Html Msg
postViewWrapper (id, model) =
    let
        topic = model.topic
        -- url = model.url
        route = PostRoute topic id
        topicRoute = TopicRoute topic
        topicAct = GoToTopic topic
        act = GoTo topic id
    in
        div []
            [ PostView.view (route) (topicRoute) (topicAct) (act) (model)
            , br1
            ]




