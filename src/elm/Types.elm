-- Contains Model and Msg, and Route
module Types exposing (..)

import Navigation exposing (Location)
import Page.Login.Types as LoginTypes
import Page.Photo.Types as PhotoTypes
import Page.Register.Types as RegisterTypes
import Page.Profile.Types as ProfileTypes
import Page.Topic.Types as TopicTypes
import Page.Topics.Types as TopicsTypes
import Page.Feed.Types as FeedTypes
import Page.Post.Types as PostTypes

import Router.Types exposing (Route)

import Mouse exposing (..)
-- Model


type alias Model = 
  { comment : String
  , fromPort : String
  , url : String
  , metadata : Metadata
  , route: Route
  , accessToken : String
  , greet : String
  , position: Position

  -- Page Model

  , loginPage : LoginTypes.Model
  , photoPage : PhotoTypes.Model
  , registerPage : RegisterTypes.Model
  , profilePage : ProfileTypes.Model
  , topicPage: TopicTypes.Model
  , topicsPage: TopicsTypes.Model
  , feedPage: FeedTypes.Model
  , postPage: PostTypes.Model

  -- Auth Model

  , isAuthorized : Bool
  , user : LoginTypes.User
  }



type alias Metadata =
  { userId : Int
  , id : Int
  , title : String
  , body : String
  }

model : Route -> Model
model route = 
  { comment = "Hello"
  , fromPort = ""
  , url = ""
  , metadata = Metadata 0 0 "" ""
  , route = route
  , accessToken = ""
  , position = Position 0 0 
  
  -- Page Model

  , loginPage = LoginTypes.model
  , photoPage = PhotoTypes.model
  , registerPage = RegisterTypes.model
  , profilePage = ProfileTypes.model
  , topicPage = TopicTypes.model
  , topicsPage = TopicsTypes.model
  , feedPage = FeedTypes.model
  , postPage = PostTypes.model

  -- Auth

  , isAuthorized = False
  , greet = ""
  , user = LoginTypes.User "" "" False "" False ""
  }


{-- 
  MSG
  * Define the global message
  * Define the messages for each page
--}



type Msg 
  -- = NoOp 
  -- | FireAPI (Result Http.Error Metadata) 
  -- | FetchService
  = OnLocationChange Location
  | NavigateTo Route
  | Logout -- Log the user out
  | LogoutSuccess String
  | Authenticate String
  | AuthenticateSuccess LoginTypes.User
  | RegisterCallback String
  -- PAGE MSG
  | LoginPageMsg LoginTypes.Msg
  | PhotoPageMsg PhotoTypes.Msg -- Photo msg
  | RegisterPageMsg RegisterTypes.Msg
  | ProfilePageMsg ProfileTypes.Msg
  | TopicPageMsg TopicTypes.Msg
  | TopicsPageMsg TopicsTypes.Msg
  | FeedPageMsg FeedTypes.Msg
  | PostPageMsg PostTypes.Msg
  | OnMouseClick Position -- Global mouse click








