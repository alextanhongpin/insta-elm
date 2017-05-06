-- Contains Model and Msg, and Route
module Types exposing (..)

--import Http
import Navigation exposing (Location)
--import RemoteData exposing (WebData)
import Page.Login.Types as LoginTypes
import Page.Photo.Types as PhotoTypes
import Page.Register.Types as RegisterTypes
import Page.Profile.Types as ProfileTypes

import Router.Types exposing (Route)
-- Model


type alias Model = 
  { comment : String
  , fromPort : String
  , url : String
  , metadata : Metadata
  , route: Route
  , accessToken : String
  , greet : String

  -- Page Model

  , loginPage : LoginTypes.Model
  , photoPage : PhotoTypes.Model
  , registerPage : RegisterTypes.Model
  , profilePage : ProfileTypes.Model
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
  , loginPage = LoginTypes.model
  , photoPage = PhotoTypes.model
  , registerPage = RegisterTypes.model
  , profilePage = ProfileTypes.model
  , isAuthorized = False
  , greet = ""
  , user = LoginTypes.User "" "" False "" False ""
  }


-- Msg



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
