module Rest exposing (..)

import Http
import Json.Decode as Decode
import Types exposing (..)


-- Service


serviceAPI : String -> Cmd Msg
serviceAPI topic =
  let
    url =
      "https://jsonplaceholder.typicode.com/posts/1"
    request =
      Http.get url decodeMetadata
  in 
    Http.send FireAPI request


-- Decoder


decodeMetadata : Decode.Decoder Metadata
decodeMetadata =
  Decode.map4 Metadata
    (Decode.field "userId" Decode.int)
    (Decode.field "id" Decode.int)
    (Decode.field "title" Decode.string)
    (Decode.field "body" Decode.string)

