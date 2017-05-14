module Page.Topic.View exposing (view)


-- HTML


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


-- ROUTER


import Router.Types exposing (Route(..))


-- ATOM


import Atom.Icon.View as Icon exposing (view)


-- MOLECULE


import Molecule.Post.View as PostView exposing (view)
import Molecule.Post.Types exposing (Topic, TopicID)

-- PAGE


import Page.Topic.Types exposing (Model, Msg(..))


-- VIEW


view : Model -> Html Msg
view model =
    div [ class "page page-topic" ]
        [ div [ class "container col-8" ]
            [ div [ class "br br-200" ] []
            , div [ class "button-create-wrapper" ]
                [ button [ onClick ToggleForm ] [ text "Add Post" ] 
                ]
            , h3 [ class "h3" ] [ text model.topic ]
            , h4 [ class "h4"] [ text ("Everything about " ++ model.topic) ] 

            -- BR
            , div [ class "br br-200" ] []

            -- The form for creating new posts
            , formView model

            -- BR
            , div [ class "br br-200" ] []

            -- The list of posts
            -- , postsView model

            , case model.topics of
                Just topics ->
                    div [ class "posts" ] (List.map postViewWrapper topics)

                Nothing ->
                    div [] [ text "Loading..." ]

            , button [ class "load-more", disabled False, onClick LoadMore ] [ text "show more" ]
            , div [ class "br br-200" ] []
            , div [ class "br br-200" ] []
            , div [ class "br br-200" ] []
            , div [ class "br br-200" ] []
            , div [ class "br br-200" ] []
            , div [ class "br br-200" ] []
        ]
        ]


-- SUBVIEW


formView : Model -> Html Msg
formView model =
    case model.showForm of
        Just showForm ->
            if showForm == True then
                let
                    newPost = model.newPost

                    isTitleEmpty
                        = newPost.title
                        |> String.trim
                        |> String.isEmpty

                    isContentEmpty
                        = newPost.content
                        |> String.trim
                        |> String.isEmpty

                    isButtonDisabled = isTitleEmpty || isContentEmpty
                in
                    div [ class "form-topic-backdrop" ] [
                        div [ class "form-topic" ]
                            [ div [ class "br br-100" ] []
                            , div [ class "form-topic-header" ]
                                [ a [ class "form-topic__button-close", onClick HideForm ] [ text "Close" ]
                                ]

                            , input [ class "form-topic-input"
                                    , type_ "text"
                                    , placeholder "Give your post a title..."
                                    , onInput OnTypeTitle
                                    , value model.newPost.title
                                    ] []
                            , textarea [ rows 5
                                        , class "form-topic__textarea"
                                        , placeholder "Write a post..."
                                        , onInput OnTypeContent
                                        , value model.newPost.content
                                        ] []
                            , div [] [ text (toString(String.length model.newPost.content) ++ " word(s)") ]

                            -- Hidden file inputs
                            , input [ type_ "file", style [ ("display", "none") ] ] []
                            , div [] [ text "attach a photo", Icon.view "add_a_photo" ]
                            , button [ class "", disabled isButtonDisabled, onClick SubmitPost ] [ text "Submit" ]
                            ]
                            , div [ class "br br-100" ] []
                        ]
            else
                span [] []

        Nothing ->
            div [ class "form-topic__placeholder-create" ] 
                [ text "There are no posts yet. "
                , a [ onClick ToggleForm  ] [ text "Create" ]
                , text " a new post and share it with others here :)"
                ]


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
            , div [ class "br br-100" ] []
            ]







