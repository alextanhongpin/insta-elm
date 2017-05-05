port module Page.Photo.State exposing (update, createComment, requestComments, responseComments)

import Page.Photo.Types exposing (Comment, Model, Msg(Like, CancelEdit, SubmitEdit, DeleteComment, EditComment, EditingComment, TypeComment, AddComment, ResponseComments))


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Like ->
            ({ model | isLiked = not model.isLiked }, Cmd.none)

        TypeComment newComment->
            ({ model | comment = newComment}, Cmd.none)

        AddComment comment ->
            -- No comment
            if comment
                |> String.trim
                |> String.isEmpty 
            then
                (model, Cmd.none)
            else
                let 
                    newComment = 
                        { photoId = model.photoID
                        , text = (String.trim comment)
                        , userId = ""
                        }
                in
                    ({ model | comment = "" }, createComment newComment)
                --let
                --    -- Create a new record for comment
                --    newComment = Comment "4" (String.trim comment) "UserName"

                --    -- Add the comment to the front of the old list
                --    newCommentList = newComment :: model.comments
                --in 
                --    ({ model 
                --        | comments = newCommentList
                --        , comment = "" }, Cmd.none)

        DeleteComment comment -> 
            let 
                comments = List.filter (filterByID(comment.photoId)) model.comments
            in
                ({ model | comments = comments }, Cmd.none)

        EditComment commentId comment -> 
            ({ model 
                | isEditing = True 
                , ghostComment = comment
                , ghostID = commentId
            }, Cmd.none)

        CancelEdit comment -> 
            ({ model 
                | isEditing = False
                , ghostComment = Comment "" "" ""
            }, Cmd.none)

        SubmitEdit comment ->
            if comment.text
                |> String.trim
                |> String.isEmpty
            then
                ({ model | errorEditTextEmpty = "Text cannot be empty" }, Cmd.none)
            else
                let 
                    update : Comment -> Comment
                    update item = 
                        if 
                            item.photoId == comment.photoId
                        then
                            { item | text = comment.text }
                        else
                            item
                    updatedComments = List.map update model.comments
                in
                ({ model
                    | comments = updatedComments
                    , ghostComment = Comment "" "" ""
                    , isEditing = False
                 }, Cmd.none)

        EditingComment text ->
            let 
                ghostComment = model.ghostComment
                u = { ghostComment | text = text }
            in
                ({ model 
                    | ghostComment = u
                    , errorEditTextEmpty = ""
                }, Cmd.none)

        ResponseComments comments ->
            let 
                concatComments = comments ++ model.newComments
            in 
                ({ model | newComments = concatComments }, Cmd.none)
        -- This is a capture all handler
        --_ -> 
        --    (model, Cmd.none)

filterByID : String -> Comment -> Bool
filterByID id model =
    -- Check if the values are equal
    model.photoId /= id


-- PUB


type alias PhotoId = String

port requestComments : PhotoId -> Cmd msg
port createComment :  Comment -> Cmd msg

-- SUB

type alias CommentId = String
port responseComments : (List (CommentId, Comment) -> msg) -> Sub msg

