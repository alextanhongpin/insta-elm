-- Contains init, update, subscriptions
port module State exposing (..)

import Types exposing (..)
import Rest exposing (..)
import Navigation exposing (Location)
import Routing

init : Location -> (Model, Cmd Msg)
init location =
  let
    currentRoute =
      Routing.parseLocation location
  in
    (model currentRoute, Cmd.none)


-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp -> 
      (model, Cmd.none)

    -- the setStorage is port that is responsible for sending a model to the index.html
    OnChange a -> 
      ({ model | comment = a }, Cmd.batch [ setStorage "Hello world", Cmd.none ] )

    -- listen to the external port
    OnStorageSet a ->
      ({ model | fromPort = a }, Cmd.none)

    FireAPI (Ok newmeta) ->
      ({ model | metadata = newmeta }, Cmd.none)

    FireAPI (Err _) -> 
      (model, Cmd.none)

    FetchService ->
      (model, serviceAPI model.url )

    OnLocationChange location -> 
      let
        newRoute = 
          Routing.parseLocation location
      in
      ( { model | route = newRoute }, Cmd.none )



-- SUBSCRIPTIONS


-- Pub


port setStorage : String -> Cmd msg


-- Sub


port onStorageSet : (String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
  -- Sub.none
  Sub.batch
    [ onStorageSet OnStorageSet
    ]
