-- Contains Model and Msg
module Types exposing (..)

import Http


-- Model


type alias Model = 
  { comment : String
  , fromPort : String
  , url : String
  , metadata : Metadata
  }

type alias Metadata =
  { userId : Int
  , id : Int
  , title : String
  , body : String 
  }

model : Model
model = 
  { comment = "Hello"
  , fromPort = ""
  , url = ""
  , metadata = Metadata 0 0 "" ""
  }


-- Msg


type Msg = NoOp | OnChange String | OnStorageSet String | FireAPI (Result Http.Error Metadata) | FetchService
