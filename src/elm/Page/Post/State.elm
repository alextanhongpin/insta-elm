module Page.Post.State exposing (update)

import Page.Post.Types exposing (Model, Comment, CommentID, Msg(..))

-- UPDATE
import Dom exposing (focus)
import Task exposing (..)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        OnKeyDown key ->
            let
                comment
                    = model.comment 
                    |> String.trim
                hasComment 
                    = comment
                    |> String.isEmpty
                    |> not
            in
                if key == 13 && hasComment then
                    let
                        comments = model.comments
                        lastComment = List.head (List.reverse comments)
                    in
                        case lastComment of
                            Just (id, _) ->
                                case String.toInt(id) of
                                    Ok intID ->
                                        let 
                                            updatedComments = comments ++ [ (toString(intID + 1), Comment "John Doe" comment False) ]
                                        in
                                        ({ model
                                            | comment = ""
                                            , comments = updatedComments 
                                        }, Cmd.none)
                                    Err error ->
                                        (model, Cmd.none)

                            Nothing ->
                                -- There are no comments, create one
                                let 
                                    updatedComments = comments ++ [ ("0", Comment "John Doe" comment False) ]
                                in
                                ({ model
                                    | comment = ""
                                    , comments = updatedComments 
                                }, Cmd.none)
                        
                else
                    (model, Cmd.none)

        OnInputComment comment ->
            ({ model | comment = comment }, Cmd.none)

        ToggleEdit commentID ->
            let
                state = not model.showEdit
            in
                { model 
                    | showEdit = state
                    , editIndex = commentID
                    , isEditing = False } !
                    [Task.attempt FocusResult (Dom.focus commentID)]

        OnEdit commentID ->
            -- Take the first comment
            let
                currentComment
                    = model.comments
                    |> List.filter (\(a, _) -> a == commentID)
                    |> List.head
            in
                case currentComment of
                    Just (_, comment) ->

                        ({model
                            | isEditing = not model.isEditing
                            , showEdit = False
                            , ghostComment = comment
                        }, Cmd.none)
                    Nothing ->
                        (model, Cmd.none)
        
        OnTypeEdit comment ->
            let
                currentComment = model.ghostComment
                updatedComment = { currentComment | text = comment }
            in
                ({ model | ghostComment = updatedComment }, Cmd.none)

        OnSubmitEdit key ->
            let
                comment = String.trim model.comment
                ghostComment = String.trim model.ghostComment.text
                currentID = model.editIndex
                hasComment
                    = ghostComment
                    |> String.isEmpty
                    |> not

                isNotTheSame = not (ghostComment == comment)
            in
                if key == 13 && hasComment && isNotTheSame then
                    let 
                        updateMap : (CommentID, Comment) -> (CommentID, Comment)
                        updateMap (id, model) =
                            if id == currentID then
                                let 
                                    updatedModel = 
                                        { model
                                            | text = ghostComment
                                            , isEdited = True 
                                        }
                                in
                                    (id, updatedModel)
                            else 
                                (id, model)
                    in
                        let updatedComments
                            = model.comments
                            |> List.map updateMap
                        in
                            ({model
                                | isEditing = not model.isEditing
                                , ghostComment = Comment "" "" False
                                , comments = updatedComments
                            }, Cmd.none)

                -- Handle esc key
                else if key == 27 && hasComment && isNotTheSame then
                    ({model
                        | isEditing = False
                        , ghostComment = Comment "" "" False
                        }, Cmd.none)

                else
                    (model, Cmd.none)

        OnCancelEdit ->
            ({model
                | isEditing = False
                , ghostComment = Comment "" "" False
                }, Cmd.none)

        OnDelete commentID ->
            let
                filterFunction : (CommentID, Comment) -> Bool
                filterFunction (id, model) =
                    not (id == commentID)

                updatedComments = model.comments
                    |> List.filter filterFunction
            in

                ({model 
                    | comments = updatedComments
                    , editIndex = "" }, Cmd.none)
        NoOp ->
            (model, Cmd.none)

        OnBlurEditMenu ->
            ({ model | showEdit = False}, Cmd.none)
        
        FocusOn id ->
            --(model, Task.attempt FocusResult (Dom.focus id))
            model ! [ Task.attempt FocusResult (focus id) ]
        FocusResult result ->
            case result of
                Err (Dom.NotFound id) ->
                    { model | error = Just ("Could not find dom id: " ++ id) } ! []

                Ok () ->
                    { model | error = Nothing } ! []






