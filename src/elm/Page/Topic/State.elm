module Page.Topic.State exposing (update)


-- MOLECULE


import Molecule.Post.Types exposing (Topic, TopicID, TopicMsg(..))
import Molecule.Post.Port exposing (createTopic)


-- PAGE


import Page.Topic.Types exposing (Model, Msg(..))


-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of 
        Nth ->
            model ! []

        GoTo topic id ->
            model ! []

        GoToTopic topic ->
            model ! []

        ToggleForm ->
            case model.showForm of
                -- NOTE: Clear the form when toggling the form
                Just state ->
                    { model
                        | showForm = Just(not state)
                        , newPost = makeTopic
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

        -- Hide the form 
        HideForm ->
            -- NOTE: Clear the form when hiding the form
            { model
                | showForm = Just(False)
                , newPost = makeTopic
            } ! []

        -- Action when user is typing the content
        OnTypeContent content ->
            let
                newPost = model.newPost
                updatedPost = { newPost | content = content }
            in
                { model | newPost = updatedPost } ! [] 

        -- Action when user is typing the title
        OnTypeTitle title ->
            let
                newPost = model.newPost
                updatedPost = { newPost | title = title }
            in
                { model | newPost = updatedPost } ! [] 

        -- Submit post will call the createTopic port
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
                            , newPost = makeTopic
                        } ! [ createTopic model.newPost ]

                    Nothing ->
                        { model
                            | topics = Just([ ("4", newPost) ])
                            , newPost = makeTopic
                        } ! []

        -- Handle Topic action. Topic action will call the port to trigger the
        -- firebase
        TopicAction childMsg ->
            case childMsg of
                All out ->
                    model ! []


-- UTIL


-- FACTORY PATTERN: Create a new topic
makeTopic : Topic
makeTopic =
    Topic "" "" "" "" "" "" 0 "" ""



