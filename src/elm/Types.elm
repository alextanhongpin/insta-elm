-- Contains Model and Msg, and Route
module Types exposing (..)

import Http
import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Page.Login.Types as LoginTypes
import Page.Photo.Types as PhotoTypes
import Page.Register.Types as RegisterTypes
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
  -- Auth Model
  , isAuthorized : Bool
  , user : User
  }

type alias User = 
  { displayName : String
  , email : String
  , emailVerified : Bool
  , photoURL : String
  , isAnonymous : Bool
  , uid : String
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
  , isAuthorized = False
  , greet = ""
  , user = User "" "" False "" False ""
  }


-- Msg


type alias PlayerId =
  String

type alias PhotoId =
  String

type Msg 
  = NoOp 
  | OnChange String 
  | OnStorageSet String 
  | FireAPI (Result Http.Error Metadata) 
  | FetchService
  | OnLocationChange Location
  | SubGetAccessToken String
  | NavigateTo Route
  | Logout -- Log the user out
  | Greet String
  | Authenticate String
  

  -- PAGE MSG


  | LoginPageMsg LoginTypes.Msg
  | PhotoPageMsg PhotoTypes.Msg -- Photo msg
  | RegisterPageMsg RegisterTypes.Msg


type Route
  = PlayersRoute -- the route for players
  | PlayerRoute PlayerId
  | LoginRoute
  | RegisterRoute
  | HomeRoute
  | NotFoundRoute
  | ProfileRoute
  | PhotoRoute PhotoId
