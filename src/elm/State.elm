-- State.elm contains init, update, subscriptions
port module State exposing (..)

-- import Types exposing (..)
import Rest exposing (..)
import Navigation exposing (Location)
import Router.Main as Routing exposing (reverseRoute)
import Router.Types exposing (Route(ProfileRoute, PhotoRoute, LoginRoute, RegisterRoute, HomeRoute))


-- PAGE


import Page.Login.Types as LoginUnion
import Page.Login.State as LoginState
import Page.Photo.Types as PhotoUnion
import Page.Photo.State as PhotoState
import Page.Profile.Types as ProfileUnion
import Page.Profile.State as ProfileState
-- import Page.Register.Types as RegisterUnion
import Page.Register.State as RegisterState

-- import Types exposing (Model, Msg(NavigateTo, LoginPageMsg))
import Types exposing (..)

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
      --let 
      --  msg = NavigateTo LoginRoute
      --in
      --  let 
      --    updatedModel = { model | isAuthorized = False }
      --  in
      --    update msg updatedModel
      -- Empty the state
        (model, Cmd.batch [ signOut (), Cmd.none ])

    LogoutSuccess str -> 
      let 
        msg = NavigateTo LoginRoute
        updatedModel = { model | isAuthorized = False }
      in
        update msg updatedModel

    LoginPageMsg childMsg ->
      case childMsg of
        --LoginUnion.LoginError error ->
        --  let
        --    ( loginModel, loginCmd ) = 
        --      LoginState.update childMsg model.loginPage
        --    updatedModel = { loginModel | error = error }
        --  in
        --    ({ model | loginPage = updatedModel }
        --    , Cmd.map LoginPageMsg loginCmd
        --    )

        LoginUnion.LoginSuccess user ->
          let 
            msg = NavigateTo ProfileRoute
            updatedModel = 
              { model 
                | loginPage = LoginUnion.model
                , user = user
                , isAuthorized = True 
              }
          in
            update msg updatedModel

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

    ProfilePageMsg childMsg ->
      case childMsg of
        ProfileUnion.NavigateTo photoId ->
          let
            newMsg = NavigateTo (PhotoRoute photoId)
            -- Get the first photo
            photos = List.filter (\(id, _) -> id == photoId ) model.profilePage.photos
            photoPageModel = model.photoPage
          in
            case List.head photos of
              Just p -> 
                let
                  photoUrl
                    = p
                    |> Tuple.second
                    |> .photoUrl
                  photoID
                    = p
                    |> Tuple.first
                  updatedPhotoPageModel 
                    = { photoPageModel 
                      | photoUrl = photoUrl
                      , photoID = photoID }
                  newModel = { model | photoPage = updatedPhotoPageModel }
                in 
                  update newMsg newModel

              Nothing ->
                -- Not found
                update (NavigateTo ProfileRoute) model

            
        _ -> 
          let
            ( profileModel, profileCmd ) = 
             ProfileState.update childMsg model.profilePage
          in
            ({ model | profilePage = profileModel }
            , Cmd.map ProfilePageMsg profileCmd
            )

    NavigateTo route ->
      case route of
        ProfileRoute ->
          if
            model.route == route && not (List.isEmpty model.profilePage.photos)
          then
            (model, Cmd.none)
          else
            -- Request new photos when the user enter the page
            (model, Cmd.batch [ ProfileState.requestPhotos (), Navigation.newUrl (reverseRoute route)] )
        PhotoRoute photoId ->
          let
            pageModel = model.photoPage
            -- Reset model when entering the page
            newPageModel = { pageModel | newComments = [] }
          in
            ({ model | photoPage = newPageModel }, Cmd.batch [ PhotoState.requestComments photoId, Navigation.newUrl (reverseRoute route)] )
        _ ->
        -- Reset the state when go to a new page
        --  ({ model | photoPage = PhotoUnion.model }, Navigation.newUrl (reverseRoute route))
          (model, Navigation.newUrl (reverseRoute route))

    -- Example of using a dispatcher
    Greet str -> 
      ({ model | greet = str }, Cmd.none)

    Authenticate str -> 
      ({ model | greet = str}, Cmd.none)

    {--Is called when the user is logged in firebase--}
    AuthenticateSuccess user ->
      -- Redirect the user after logging in
      let
        msg = NavigateTo ProfileRoute
        profilePageModel = model.profilePage
        updatedProfilePageModel = 
          { profilePageModel 
            | displayName = user.displayName
            , email = user.email
            , emailVerified = user.emailVerified
            , photoURL = user.photoURL 
          }
        updatedModel = 
          { model
            | user = user
            , isAuthorized = True
            , profilePage = updatedProfilePageModel
          }
      in
        update msg updatedModel

    RegisterCallback str ->
      let 
        registerPage = model.registerPage
        output = { registerPage | error = "YESS" }
      in
        ({model | registerPage = output }, Cmd.none)


-- SUBSCRIPTIONS


-- Pub


port setStorage : String -> Cmd msg
port dispatchGreet : String -> Cmd msg
port authenticate : () -> Cmd msg
port signOut : () -> Cmd msg
-- Sub


port onStorageSet : (String -> msg) -> Sub msg
port subscribeGreet : (String -> msg) -> Sub msg
port authenticateSuccess : (LoginUnion.User -> msg) -> Sub msg
port onAuthenticateStateChange : (String -> msg) -> Sub msg

-- A subscriber to get access token from the localStorage
port portSubscribeToken : (String -> msg) -> Sub msg
port logoutSuccess : (String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
  -- Sub.none
  Sub.batch
    [ onStorageSet OnStorageSet
    , subscribeGreet Greet
    , onAuthenticateStateChange Authenticate
    , RegisterState.onRegistered RegisterCallback 
    , logoutSuccess LogoutSuccess
    , authenticateSuccess AuthenticateSuccess
    {-- This is a bit tricky:
      We map the Child subscription to the childMsg first
      which will be the parameters for loginPageMsg
    --}
    , Sub.map LoginPageMsg (LoginState.loginSuccess LoginUnion.LoginSuccess)
    , Sub.map LoginPageMsg (LoginState.loginError LoginUnion.LoginError)
    , Sub.map ProfilePageMsg (ProfileState.responsePhotos ProfileUnion.ResponsePhotos)
    , Sub.map PhotoPageMsg (PhotoState.responseComments PhotoUnion.ResponseComments)
    ]
