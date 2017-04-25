-- Contains Model and Msg
module Types exposing (..)

import Http
import Navigation exposing (Location)
import RemoteData exposing (WebData)

-- Model


type alias Model = 
  { comment : String
  , fromPort : String
  , url : String
  , metadata : Metadata
  , route: Route
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
  }

type alias PlayerId =
  String

-- Msg




type Msg 
  = NoOp 
  | OnChange String 
  | OnStorageSet String 
  | FireAPI (Result Http.Error Metadata) 
  | FetchService
  | OnLocationChange Location

type Route
  = PlayersRoute
  | PlayerRoute PlayerId
  | NotFoundRoute
