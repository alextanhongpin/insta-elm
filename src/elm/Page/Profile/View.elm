module Page.Profile.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onInput, onClick)
import Json.Decode as Json


-- ATOM


import Atom.Break.View exposing (br1, br2, br3)


-- MOLECULE


import Molecule.Post.View as PostView exposing (view)
import Molecule.Post.Types exposing (TopicID, Topic)


-- ROUTER


import Router.Main exposing (reverseRoute, onClickPreventDefault)
import Router.Types exposing (Route(..))


-- VIEW


-- ATOM


import Atom.Style exposing (imageCover)


-- PAGE


import Page.Profile.Types exposing (Model, PhotoInfo, Msg(..))


-- VIEW


view : Model -> Html Msg
view model =
    div [ class "page page-profile" ] 
        [ div [ class "container col-8" ]
            [ br2
            , br2
            , userView model
            , br2
            -- , uploadPhotoView model
            -- , photosView model
            , postsView model
            , br2

            , case model.topics of 
                Just topics ->
                    div [] (List.map postViewWrapper topics)
                Nothing ->
                    div [] [ text "No topics yet" ]
            ]
        ]


-- SUBVIEW


-- Takes a model, and return either the displayName or email
usernameText : Model -> String
usernameText model =
    let 
        username = List.head [ model.displayName, model.email ]
    in 
        case username of
            Just name ->
                name
            Nothing ->
                "No username"

editIcon : Html Msg
editIcon 
    = i [ class "material-icons icon-edit"
        , onClick ToggleEditProfile
        , title "Edit"
        ] [ text "mode_edit" ]


isEditingView : Model -> Html Msg
isEditingView model =
    if model.enableEditProfile then
        div [] 
            [ div [] 
                [ input [ type_ "text", value model.ghostDisplayName, placeholder "Your username...", onInput DisplayName ] []
                ]
            , 
            div []
                [ a [ onClick ToggleEditProfile ] [ text "Cancel" ]
                , text " "
                , a [ onClick SubmitEdit ] [ text "Submit" ] 
                ]
            ]
    else
        div [] 
            [ b [] [ text (usernameText model) ]
            , span [] [ text " " ]
            -- , button [ onClick ToggleEditProfile ] [ text "Edit Profile" ]
            , editIcon
            ]


userView : Model -> Html Msg
userView model =
    let 
        -- photoCount = toString(model.count) ++ " photos"
        postCount = "53 posts"
        pointCount = "100 points"
        followerCount = "100 followers"

        countLabel = String.join " | " [ postCount, pointCount, followerCount]
    in
        div [ class "user" ] 
            [ label [ class "user-photo", for "profilePhoto",  style (imageCover model.photoURL) ] [ ]
            , br2
            , isEditingView model
            , br2
            , div [ class "user-stats" ] [ text countLabel ]
            , br2

            -- , div [] [ text (toString(model.progress))]
            -- A hidden html input file
            , input 
                [ id "profilePhoto"
                , type_ "file"
                , accept "image/*"
                , on "change" (Json.succeed (ProfilePhoto "profilePhoto"))
                , style [ ("display", "none")]
                ] []
    ]

uploadPhotoView : Model -> Html Msg
uploadPhotoView model =
    div [ class "form-photo" ] 
        [ div [] [ text "Upload Photo" ]
        , div [] [ text ("Progress:" ++ toString(model.uploadProgress))]
        , textarea
            [ class "form-photo__textarea"
            , value model.alt
            , placeholder ("Whats on your mind " ++ (usernameText model))
            , onInput Caption
            , rows 3
            ] []
        , input 
            [ id "uploader"
            , type_ "file"
            , accept "image/*"
            , on "change" (Json.succeed (UploadFile "uploader" (PhotoInfo "" "" model.displayName model.alt "" "")))
            ] []
        ]


photosView : Model -> Html Msg
photosView model = 
    div [ class "photos" ] (List.map photoView model.photos)


photoView : (String, PhotoInfo) -> Html Msg
photoView (key, data) =
    let 
        url = reverseRoute (PhotoRoute key)
    in
        a [ id key
          , class "photo-wrapper"
          , href url 
          , onClickPreventDefault (NavigateTo key)
          ] [ div [ class "photo", style (imageCover data.photoUrl) ] []
            ]


postsView : Model -> Html Msg
postsView model =
    div []
        [ div []
            [ div [] [ text "Sort by" ]
            , select [] 
                [ option [] [ text "Latest" ]
                , option [] [ text "Most voted" ]
                , option [] [ text "Category" ]
                ]
            ]
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
            , br1
            ]



