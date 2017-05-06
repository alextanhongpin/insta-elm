port module Page.Photo.State exposing (..)

import Page.Photo.Types exposing (Model, Msg(..))


-- PORT


import Port.Photo as PhotoPort


-- MODEL


import Molecule.Comment.Port as CommentPort
import Molecule.Comment.Model exposing (Comment, CommentID)
import Molecule.Comment.Types exposing (CommentMsg(..), CommentEditMsg(..))


-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Like ->
            ({ model | isLiked = not model.isLiked }, Cmd.none)

        ResponsePhoto (photoID, photo) ->
            ({ model | photo = photo, photoID = photoID }, Cmd.none)

        DeletePhoto photoID ->
            (model, PhotoPort.deletePhoto photoID)

        DeletePhotoSuccess photoID ->
            (model, Cmd.none)

        CommentAction childMsg ->
            case childMsg of
                Create text -> 
                    if text
                        |> String.trim
                        |> String.isEmpty 
                    then
                        (model, Cmd.none)
                    else
                        let 
                            newComment = 
                                { photoId = model.photoID
                                , text = (String.trim text)
                                , userId = ""
                                }
                        in
                            -- Clear the input field and request to POST /comments
                            ({ model | comment = "" }, CommentPort.createComment newComment)

                All comments ->
                    let 
                        concatComments = comments ++ model.comments
                    in 
                        ({ model | comments = concatComments }, Cmd.none)

                Update commentID comment ->
                    if comment.text
                        |> String.trim
                        |> String.isEmpty
                    then
                        ({ model | errorEditTextEmpty = "Text cannot be empty" }, Cmd.none)
                    else
                        (model, CommentPort.updateComment (commentID, comment))

                UpdateCallback (commentID, comment) ->
                    let
                        update : (String, Comment) -> (String, Comment)
                        update (cID, c) = 
                            if 
                                cID == commentID
                            then
                                (cID, { c | text = comment.text })
                            else
                                (cID, c)
                        updatedComments = List.map update model.comments
                    in
                        ({ model
                            | comments = updatedComments
                            , ghostComment = Comment "" "" ""
                            , ghostID = ""
                            , isEditing = False
                         }, Cmd.none)

                Delete commentID comment ->
                    (model, CommentPort.deleteComment (commentID, comment))

                DeleteCallback commentID ->
                    let
                        comments = List.filter (\(id, _) -> id /= commentID) model.comments
                    in
                        ({ model | comments = comments}, Cmd.none)

                InputComment newComment ->
                    ({ model | comment = newComment}, Cmd.none)

        CommentEditAction childMsg ->
            case childMsg of 
                Edit commentId comment -> 
                    ({ model 
                        | isEditing = True 
                        , ghostComment = comment
                        , ghostID = commentId
                    }, Cmd.none)

                Cancel comment ->
                    ({ model 
                        | isEditing = False
                        , ghostComment = Comment "" "" ""
                        , ghostID = ""
                    }, Cmd.none)

                InputEdit text ->
                    let 
                        ghostComment = model.ghostComment
                        u = { ghostComment | text = text }
                    in
                        ({ model 
                            | ghostComment = u
                            , errorEditTextEmpty = ""
                        }, Cmd.none)



