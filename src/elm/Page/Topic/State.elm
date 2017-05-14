module Page.Topic.State exposing (update)

import Molecule.Post.Types exposing (Topic)
import Page.Topic.Types exposing (Model, Msg(..))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of 
        Nth ->
            (model, Cmd.none)

        GoTo topic id ->
            (model, Cmd.none)

        GoToTopic topic ->
            (model, Cmd.none)

        ToggleForm ->
            case model.showForm of
                -- NOTE: Clear the form when toggling the form
                Just state ->
                    { model
                        | showForm = Just(not state)
                        , newPost = Topic "" "" "" "" "" "" 0 "" ""
                    } ! []

                Nothing ->
                    { model | showForm = Just(True) } ! []

        -- Load more posts
        LoadMore ->
            case model.topics of
                Just topics ->
                    let 
                        updatedTopics = Just(topics ++ [ ("1", Topic "John Doe" "Today" "Today" "Hello World" "This is a hello world content" "apple" 0 "none" "") ] )
                    in
                        { model | topics = updatedTopics } ! []

                Nothing ->
                    { model | topics = Just([ ("1", Topic "John Doe" "Today" "Today" "Hello World" "This is a hello world content" "apple" 0 "none" "") ])} ! []


        HideForm ->
            -- NOTE: Clear the form when hiding the form
            { model
                | showForm = Just(False)
                , newPost = Topic "" "" "" "" "" "" 0 "" ""
            } ! []

        OnTypeContent content ->
            let
                newPost = model.newPost
                updatedPost = { newPost | content = content }
            in
                { model | newPost = updatedPost } ! [] 

        OnTypeTitle title ->
            let
                newPost = model.newPost
                updatedPost = { newPost | title = title }
            in
                { model | newPost = updatedPost } ! [] 

        SubmitPost ->
            let
                post = model.newPost
                newPost 
                    = { post
                    | owner = model.owner
                    , topic = model.topic
                    }
            in
                case model.topics of 
                    Just topics ->
                        { model
                            | topics = Just(topics ++ [ ("4", newPost) ])
                            , newPost = Topic "" "" "" "" "" "" 0 "" ""
                        } ! []  

                    Nothing ->
                        { model
                            | topics = Just([ ("4", newPost) ])
                            , newPost = Topic "" "" "" "" "" "" 0 "" ""
                        } ! []





