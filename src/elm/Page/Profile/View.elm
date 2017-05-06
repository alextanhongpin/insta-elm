module Page.Profile.View exposing (view)

import Html exposing (Html, a, b, br, button, div, span, text, input, img, i)
import Html.Attributes exposing (class, href, type_, id, src, width, height, style, accept, value, placeholder)
import Html.Events exposing (on, onInput, onClick)
import Json.Decode as Json


import Router.Main exposing (reverseRoute, onClickPreventDefault)
import Router.Types exposing (Route(PhotoRoute))


-- VIEW


-- ATOM


import Atom.Style exposing (imageCover)


-- PAGE


import Page.Profile.Types exposing (Model, PhotoInfo, Msg(..))


-- VIEW


view : Model -> Html Msg
view model =
    div [ class "page page--profile" ] 
        [ br [] []
        , user model
        , photosView model
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
    = i [ class "material-icons md-18 md-inactive"
        , onClick ToggleEditProfile 
        ] [ text "mode_edit" ]

isEditingView : Model -> Html Msg
isEditingView model =
    if model.enableEditProfile then
        div [] 
            [ input [ type_ "text", value model.ghostDisplayName, placeholder "Enter displayName", onInput DisplayName ] []
            , button [ onClick ToggleEditProfile ] [ text "Cancel" ]
            , button [ onClick SubmitEdit ] [ text "Submit" ] 
            ]
    else
        div [] 
            [ b [] [ text (usernameText model) ]
            , span [] [ text " " ]
            , button [ onClick ToggleEditProfile ] [ text "Edit Profile" ]
            ]

user : Model -> Html Msg
user model =
    div [ class "user" ] 
        [ div [ class "user-photo",  style (imageCover model.photoURL) ] [ ]
        , br [] []
        , isEditingView model
        , br [] []
        , br [] []
        -- , div [] [ text "upload profile photo" ]
        -- , div [] [ text (toString(model.progress))]
        , input 
            [ id "profilePhoto"
            , type_ "file"
            , accept "image/*"
            , on "change" (Json.succeed (ProfilePhoto "profilePhoto"))
            ] []
        , div [] 
            [ div [] [ text "Upload Photo" ]
            -- , div [] [ text ("Progress:" ++ toString(model.uploadProgress))]
            , input [ type_ "text", value model.alt, placeholder "Enter image caption", onInput Caption ] []
            , input 
                [ id "uploader"
                , type_ "file"
                , accept "image/*"
                , on "change" (Json.succeed (UploadFile "uploader" (PhotoInfo "" "" model.displayName model.alt "" "")))
                ] []
            ]
        , div [] 
            [ span [] [ text "101 Followers" ]
            , span [] [ text " " ] 
            , span [] [ text (toString(model.count)) ]
            ]
        , div [] [ text model.uid ]
    ]

photosView : Model -> Html Msg
photosView model = 
    div [] (List.map photoView model.photos)

photoView : (String, PhotoInfo) -> Html Msg
photoView (key, data) =
    let 
        url = reverseRoute (PhotoRoute key)
    in
        a [ id key
          , href url 
          , onClickPreventDefault (NavigateTo key)
          ] [ img [ class "grid", src data.photoUrl ] []
            ]

type alias PhotoInfo =
    { photoUrl : String
    , userId : String
    , displayName : String
    , alt : String
    , createdAt : String
    , updatedAt : String
    }