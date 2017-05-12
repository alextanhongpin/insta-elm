module Page.Photo.View exposing (view)

import Html exposing (Html, b, br, button, div, text, i, input, img, span)
import Html.Attributes exposing (class, type_, placeholder, value, src, style)
import Html.Events exposing (onClick, onInput)


-- PAGE


import Page.Photo.Types exposing (Model, Msg(..))


-- MODEL


import Molecule.Comment.Types exposing (Comment, CommentID, CommentMsg(..), CommentEditMsg(..))


-- VIEW


view : Model -> Html Msg
view model =
    let
        photo = model.photo
    in
        div [ class "page page-photo"] 
            [ br [] []
            , img [ class "photo-grid", src photo.photoUrl ] []
            , br [] []
            , br [] []
            , div [ class "user"] 
                [ div [ class "user-photo is-small"] [ ]
                , div [ class "user-info"] 
                    [ div [ class "user-info__date"] [ text "4:50 PM" ]
                    , div [ class "user-info__name"] 
                        [ b [] [ text "username" ] -- The username
                        , span [] [ text " " ] -- Whitespace
                        , span [] [ text photo.alt ] -- The image caption
                        ]
                    ]
                ,   if model.userId == photo.userId then 
                        button [ onClick (DeletePhoto model.photoID) ] [ text "Delete Photo" ]
                    else
                        div [] []
                ]
            -- , div [] [ text (photo.createdAt ++ photo.updatedAt)]
            -- , b [] [ text photo.displayName]
            , i [ class (likeIconClassName model.isLiked), onClick Like ] [ text "favorite" ]
            , div [] [ text (toString(List.length model.comments)) ]
            , div [] 
                [ input 
                    [ type_ "text"
                    , placeholder "Enter your comment"
                    , onInput (CommentAction << InputComment)
                    , value model.comment ] []
                , button [ onClick (CommentAction (Create model.comment)) ] [ text "Submit" ]
                ]
            , div [ class "comments"] ( List.map (commentView model) model.comments)
            ]

likeIconClassName : Bool -> String
likeIconClassName bool =
    if bool then "material-icons icon-favorite" else "material-icons icon-favorite is-selected"

commentView : Model -> (String, Comment) -> Html Msg
commentView model (commentId, comment) = 
    if 
        model.ghostID == commentId && model.isEditing == True
    then
        div [] 
            [ div [] 
                [ b [] [ text model.ghostComment.userId ]
                ]
            , input [ type_ "text", value model.ghostComment.text, onInput (CommentEditAction << InputEdit) ] []
            , div [] [ text model.errorEditTextEmpty ]
            , button [ onClick (CommentEditAction (Cancel model.ghostComment)) ] [ text "Cancel Edit" ]
            , button [ onClick (CommentAction (Update commentId model.ghostComment)) ] [ text "Submit Edit" ]
            ]
    else
        div [ class "comment" ] 
            [ b [] [ text comment.userId ]
            , div [] [ text (String.trim comment.text) ]
            , button [ onClick (CommentAction (Delete commentId comment)) ] [ text "Delete" ]
            , button [ onClick (CommentEditAction (Edit commentId comment)) ] [ text "Edit" ]
            ]

