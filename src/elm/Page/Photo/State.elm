module Page.Photo.State exposing (update)

import Page.Photo.Types exposing (Comment, Model, Msg(Like, CancelEdit, SubmitEdit, DeleteComment, EditComment, EditingComment, TypeComment, AddComment))


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Like ->
            ({ model | isLiked = if model.isLiked then False else True }, Cmd.none)

        TypeComment newComment->
            ({ model | comment = newComment}, Cmd.none)

        AddComment comment ->
            -- No comment
            if model.comment
                |> String.trim
                |> String.isEmpty 
            then
                (model, Cmd.none)
            else
                let 
                    -- Create a new record for comment
                    newComment = Comment "4" (String.trim comment) "UserName"

                    -- Add the comment to the front of the old list
                    newCommentList = newComment :: model.comments
                in 
                    ({ model 
                        | comments = newCommentList
                        , comment = "" }, Cmd.none)

        DeleteComment comment -> 
            let 
                comments = List.filter (filterByID(comment.id)) model.comments
            in
                ({ model | comments = comments }, Cmd.none)

        EditComment comment -> 
            ({ model 
                | isEditing = True 
                , ghostComment = comment
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
                            item.id == comment.id
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
        -- This is a capture all handler
        --_ -> 
        --    (model, Cmd.none)

filterByID : String -> Comment -> Bool
filterByID id model =
    -- Check if the values are equal
    model.id /= id


