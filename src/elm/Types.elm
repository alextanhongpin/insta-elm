-- Contains Model and Msg
module Types exposing (..)

import Http
import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Page.Login.Types
-- Model


type alias Model = 
  { comment : String
  , fromPort : String
  , url : String
  , metadata : Metadata
  , route: Route
  , accessToken : String
  , loginPage : Page.Login.Types.Model
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
  , loginPage = Page.Login.Types.model
  }


-- Msg


type alias PlayerId =
  String

type Msg 
  = NoOp 
  | OnChange String 
  | OnStorageSet String 
  | FireAPI (Result Http.Error Metadata) 
  | FetchService
  | OnLocationChange Location
  | SubGetAccessToken String
  | LoginPageMsg Page.Login.Types.Msg
  | NavigateTo Route


type Route
  = PlayersRoute -- the route for players
  | PlayerRoute PlayerId
  | LoginRoute
  | RegisterRoute
  | HomeRoute
  | NotFoundRoute
