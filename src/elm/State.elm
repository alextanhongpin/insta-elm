-- Contains init, update, subscriptions
port module State exposing (..)

import Types exposing (..)
import Rest exposing (..)
import Navigation exposing (Location)
import Routing
import Page.Login.Types
import Page.Login.State

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

    SubGetAccessToken token ->
      ({ model | accessToken = token }, Cmd.none)

    LoginPageMsg childMsg ->
      case childMsg of
        Page.Login.Types.Login ->
          let
            ( loginModel, loginCmd ) = 
              Page.Login.State.update childMsg model.loginPage
          in
            ({ model | loginPage = loginModel }
            , Cmd.map LoginPageMsg loginCmd
            )

        Page.Login.Types.OnInputEmail email ->
          let
            ( loginModel, loginCmd ) = 
              Page.Login.State.update childMsg model.loginPage
          in
            ({ model | loginPage = loginModel }
            , Cmd.map LoginPageMsg loginCmd
            )

          


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


-- A subscriber to get access token from the localStorage
port portSubscribeToken : (String -> msg) -> Sub msg
subAccessToken : Model -> Sub Msg
subAccessToken model =
  Sub.batch
    [ portSubscribeToken SubGetAccessToken
    ]
