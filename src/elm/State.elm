-- State.elm contains init, update, subscriptions
port module State exposing (..)

import Types exposing (..)
import Rest exposing (..)
import Navigation exposing (Location)
import Routing exposing (reverseRoute)


-- PAGE


import Page.Login.Types as LoginUnion
import Page.Login.State as LoginState
import Page.Photo.Types as PhotoUnion
import Page.Photo.State as PhotoState
-- import Page.Register.Types as RegisterUnion
import Page.Register.State as RegisterState

import Types exposing (Route(LoginRoute, RegisterRoute, HomeRoute), Msg(NavigateTo))

-- Initialize the appliction with a default location, defined by `top` in Routing.elm

init : Location -> (Model, Cmd Msg)
init location =
  let
    -- Get the current route
    currentRoute =
      Routing.parseLocation location
  in
    -- Initialize the model with the current route
    (model currentRoute, Cmd.batch [ dispatchGreet "Initializing app", authenticate (), Cmd.none ])


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

    Logout -> 
      let 
        msg = NavigateTo LoginRoute
      in
        let 
          updatedModel = { model | isAuthorized = False }
        in
          update msg updatedModel

    LoginPageMsg childMsg ->
      case childMsg of
        LoginUnion.OnSubmitLogin ->
          let
            ( loginModel, loginCmd ) = 
              LoginState.update childMsg model.loginPage
          in
            -- Redirect the user if success
            if .isAuthorized loginModel then
              let 
                msg = NavigateTo ProfileRoute
              in
                let 
                  updatedModel = { model | loginPage = loginModel, isAuthorized = True }
                in
                  update msg updatedModel
            else
              ({ model | loginPage = loginModel }
              , Cmd.map LoginPageMsg loginCmd
              )
        _ ->
          let
            ( loginModel, loginCmd ) = 
              LoginState.update childMsg model.loginPage
          in
            ({ model | loginPage = loginModel }
            , Cmd.map LoginPageMsg loginCmd
            )
    PhotoPageMsg childMsg ->
      case childMsg of
        PhotoUnion.Like ->
          let
            ( photoModel, photoCmd ) = 
             PhotoState.update childMsg model.photoPage
          in
            ({ model | photoPage = photoModel }
            , Cmd.map PhotoPageMsg photoCmd
            )
        _ ->
          let
            ( photoModel, photoCmd ) = 
             PhotoState.update childMsg model.photoPage
          in
            ({ model | photoPage = photoModel }
            , Cmd.map PhotoPageMsg photoCmd
            )
    RegisterPageMsg childMsg ->
      case childMsg of
        _ -> 
          let
            ( registerModel, registerCmd ) = 
             RegisterState.update childMsg model.registerPage
          in
            ({ model | registerPage = registerModel }
            , Cmd.map RegisterPageMsg registerCmd
            )

    NavigateTo route -> 
      -- Reset the state when go to a new page
      ({ model | photoPage = PhotoUnion.model }, Navigation.newUrl (reverseRoute route))

    -- Example of using a dispatcher
    Greet str -> 
      ({ model | greet = str }, Cmd.none)

    Authenticate str -> 
      ({ model | greet = str}, Cmd.none)


-- SUBSCRIPTIONS


-- Pub


port setStorage : String -> Cmd msg
port dispatchGreet : String -> Cmd msg
port authenticate : () -> Cmd msg

-- Sub


port onStorageSet : (String -> msg) -> Sub msg
port subscribeGreet : (String -> msg) -> Sub msg
port onAuthenticateStateChange : (String -> msg) -> Sub msg

-- A subscriber to get access token from the localStorage
port portSubscribeToken : (String -> msg) -> Sub msg
subAccessToken : Model -> Sub Msg
subAccessToken model =
  Sub.batch
    [ portSubscribeToken SubGetAccessToken
    ]





subscriptions : Model -> Sub Msg
subscriptions model =
  -- Sub.none
  Sub.batch
    [ onStorageSet OnStorageSet
    , subscribeGreet Greet
    , onAuthenticateStateChange Authenticate
    ]
