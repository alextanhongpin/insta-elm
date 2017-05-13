module Page.Topic.Types exposing (..)


-- MODEL

mockTopics : List (TopicID, Topic)
mockTopics = 
    [ ("1", Topic "John Doe" "Today" "Today" "Hello World" "This is a hello world content" "apple" 0 "none" "") ]

type alias Model =
    { topic : String -- Store the query parameter for the topic
    , topics : Maybe (List (TopicID, Topic))
    , newPost : Topic -- The new post that the user is creating
    , showForm : Maybe Bool
    , owner : String
    }

type alias TopicID = String
type alias Topic =
    { owner : String
    , createdAt : String
    , updatedAt : String
    , title : String
    , content : String
    , topic : String
    , commentCount : Int
    , url : String
    , photoURL : String }


model : Model
model =
    { topic = ""
    , topics = Nothing
    , newPost = Topic "" "" "" "" "" "" 0 "" ""
    , showForm = Nothing
    , owner = "John Doe"
    }


-- MSG 


type Msg
    = Nth
    | GoTo String String
    | GoToTopic String
    | ToggleForm -- Use to toggle the create form
    | HideForm
    | LoadMore -- Load more posts
    | OnTypeContent String
    | OnTypeTitle String
    | SubmitPost









