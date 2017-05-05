module Page.Photo.View exposing (view)

import Html exposing (Html, b, button, div, text, i, input, img)
import Html.Attributes exposing (class, type_, placeholder, value, src)
import Html.Events exposing (onClick, onInput)
-- import Types exposing (Msg)
import Page.Photo.Types exposing (Comment, Model, 
        Msg(Like, AddComment, CancelEdit, SubmitEdit, EditComment, EditingComment, TypeComment, DeleteComment))

view : Model -> Html Msg
view model =
    div [] 
        [ img [ class "photo-grid", src model.photoUrl ] []
        , b [] [ text "John Doe"]
        , div [] [ text "Photo" ]
        , i [ class (likeIconClassName model.isLiked), onClick Like ] [ text "favorite" ]
        , div [] [ text (toString(List.length model.comments)) ]
        , div [] 
            [ input 
                [ type_ "text"
                , placeholder "Enter your comment"
                , onInput TypeComment
                , value model.comment ] []
            , button [ onClick (AddComment model.comment) ] [ text "Submit" ]
            ]
        , div [] [ text "Awesome event taking place at Malacca"]
        -- , div [] ( List.map (commentView model) model.comments )
        , div [] ( List.map (newCommentView model) model.newComments)
        ]

likeIconClassName : Bool -> String
likeIconClassName bool =
    if bool then "material-icons icon-favorite" else "material-icons icon-favorite is-selected"


--commentView : Model -> Comment -> Html Msg
--commentView model comment = 
--    if 
--        model.ghostComment.photoId == comment.photoId && model.isEditing == True
--    then
--        div [] 
--            [ div [] 
--                [ b [] [ text model.ghostComment.userId ]
--                ]
--            , input [ type_ "text", value model.ghostComment.text, onInput EditingComment ] []
--            , div [] [ text model.errorEditTextEmpty ]
--            , button [ onClick (CancelEdit model.ghostComment) ] [ text "Cancel Edit" ]
--            , button [ onClick (SubmitEdit model.ghostComment) ] [ text "Submit Edit" ]
--            ]
--    else
--        div [ class "comment-list" ] 
--            [ b [] [ text comment.userId ]
--            , div [] [ text (String.trim comment.text) ]
--            , button [ onClick (DeleteComment comment) ] [ text "Delete" ]
--            , button [ onClick (EditComment comment)] [ text "Edit" ]
--            ]


newCommentView : Model -> (String, Comment) -> Html Msg
newCommentView model (commentId, comment) = 
    if 
        model.ghostID == commentId && model.isEditing == True
    then
        div [] 
            [ div [] 
                [ b [] [ text model.ghostComment.userId ]
                ]
            , input [ type_ "text", value model.ghostComment.text, onInput EditingComment ] []
            , div [] [ text model.errorEditTextEmpty ]
            , button [ onClick (CancelEdit model.ghostComment) ] [ text "Cancel Edit" ]
            , button [ onClick (SubmitEdit model.ghostComment) ] [ text "Submit Edit" ]
            ]
    else
        div [ class "comment-list" ] 
            [ b [] [ text comment.userId ]
            , div [] [ text (String.trim comment.text) ]
            , button [ onClick (DeleteComment comment) ] [ text "Delete" ]
            , button [ onClick (EditComment commentId comment)] [ text "Edit" ]
            ]

