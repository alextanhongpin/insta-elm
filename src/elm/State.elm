-- State.elm contains init, update, subscriptions
port module State exposing (..)

-- import Types exposing (..)
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


-- PORT


import Port.Profile as ProfilePort exposing (..)
import Port.Photo as PhotoPort exposing (..)
import Molecule.Comment.Port as CommentPort exposing (..)
import Molecule.Comment.Types as CommentTypes exposing (CommentMsg(..))


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
    (model currentRoute, authenticate ())


-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    --FireAPI (Ok newmeta) ->
    --  ({ model | metadata = newmeta }, Cmd.none)

    --FireAPI (Err _) -> 
    --  (model, Cmd.none)

    --FetchService ->
    --  (model, serviceAPI model.url )

    OnLocationChange location -> 
      let
        newRoute = 
          Routing.parseLocation location
      in
      ( { model | route = newRoute }, Cmd.none )


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
        PhotoUnion.DeletePhotoSuccess photoID ->
          let
            profilePageModel = model.profilePage
            photos = profilePageModel.photos
            filteredPhotos = List.filter (\(a, b) -> a /= photoID) photos
            msg = NavigateTo ProfileRoute
            updatedProfileModel = { profilePageModel | photos = filteredPhotos}
            updatedModel = { model | profilePage = updatedProfileModel}
          in
            update msg updatedModel
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
        ProfileUnion.SetDisplayNameSuccess displayName -> 
          let
            ( profileModel, profileCmd ) = ProfileState.update childMsg model.profilePage
            userModel = model.user
            
          in
            let 
              updatedUserModel = { userModel | displayName = displayName }
            in
              ({ model | profilePage = profileModel, user = updatedUserModel }
              , Cmd.map ProfilePageMsg profileCmd
              )

        ProfileUnion.NavigateTo photoId ->
          let
            newMsg = NavigateTo (PhotoRoute photoId)
            -- Get the first photo
            --photos = List.filter (\(id, _) -> id == photoId ) model.profilePage.photos
            --photoPageModel = model.photoPage
          in
            --case List.head photos of
            --  Just p -> 
            --    let
            --      photoUrl
            --        = p
            --        |> Tuple.second
            --        |> .photoUrl
            --      photoID
            --        = p
            --        |> Tuple.first
            --      updatedPhotoPageModel 
            --        = { photoPageModel 
            --          | photoUrl = photoUrl
            --          , photoID = photoID }
            --      newModel = { model | photoPage = updatedPhotoPageModel }
            --    in 
            update newMsg model

              --Nothing ->
              --  -- Not found
              --  update (NavigateTo ProfileRoute) model

            
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
            (model, Cmd.batch [ ProfileState.requestPhotos (), photoCount (), Navigation.newUrl (reverseRoute route)] )

        PhotoRoute photoId ->
          let
            pageModel = model.photoPage
            -- Reset model when entering the page
            newPageModel = { pageModel | comments = [] }
          in
            ({ model | photoPage = newPageModel }, Cmd.batch [ requestPhoto photoId, CommentPort.requestComments photoId, Navigation.newUrl (reverseRoute route)] )
        _ ->
        -- Reset the state when go to a new page
        --  ({ model | photoPage = PhotoUnion.model }, Navigation.newUrl (reverseRoute route))
          (model, Navigation.newUrl (reverseRoute route))

    Authenticate str -> 
      ({ model | greet = str}, Cmd.none)

    {--Is called when the user is logged in firebase--}
    AuthenticateSuccess user ->
      -- Redirect the user after logging in
      let
        -- msg = NavigateTo ProfileRoute
        msg = NavigateTo model.route
        profilePageModel = model.profilePage
        photoPageModel = model.photoPage
        updatedProfilePageModel = 
          { profilePageModel 
            | displayName = user.displayName
            , email = user.email
            , emailVerified = user.emailVerified
            , photoURL = user.photoURL 
            , uid = user.uid
          }
        updatedPhotoPageModel =
          { photoPageModel | userId = user.uid }
        updatedModel = 
          { model
            | user = user
            , isAuthorized = True
            , profilePage = updatedProfilePageModel
            , photoPage = updatedPhotoPageModel
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


port authenticate : () -> Cmd msg
port signOut : () -> Cmd msg


-- Sub


port authenticateSuccess : (LoginUnion.User -> msg) -> Sub msg
port onAuthenticateStateChange : (String -> msg) -> Sub msg

-- A subscriber to get access token from the localStorage
port portSubscribeToken : (String -> msg) -> Sub msg
port logoutSuccess : (String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
  -- Sub.none
  Sub.batch
    [ onAuthenticateStateChange Authenticate
    , RegisterState.onRegistered RegisterCallback 
    , logoutSuccess LogoutSuccess
    , authenticateSuccess AuthenticateSuccess
    {-- This is a bit tricky:
      We map the Child subscription to the childMsg first
      which will be the parameters for loginPageMsg
    --}
    

    -- Login Page


    , Sub.map LoginPageMsg (LoginState.loginSuccess LoginUnion.LoginSuccess)
    , Sub.map LoginPageMsg (LoginState.loginError LoginUnion.LoginError)
    

    -- ProfilePage


    , Sub.map ProfilePageMsg (ProfileState.responsePhotos ProfileUnion.ResponsePhotos)
    , Sub.map ProfilePageMsg (ProfileState.profilePhotoSuccess ProfileUnion.ProfilePhotoSuccess)
    , Sub.map ProfilePageMsg (ProfileState.progress ProfileUnion.Progress)
    , Sub.map ProfilePageMsg (ProfileState.uploadProgress ProfileUnion.UploadProgress)
    , Sub.map ProfilePageMsg (setDisplayNameSuccess ProfileUnion.SetDisplayNameSuccess)
    , Sub.map ProfilePageMsg (PhotoPort.photoCountSuccess ProfileUnion.PhotoCountSuccess)
    

    -- PhotoPage


    , Sub.map PhotoPageMsg (PhotoPort.responsePhoto PhotoUnion.ResponsePhoto)
    , Sub.map PhotoPageMsg (PhotoPort.deletePhotoSuccess PhotoUnion.DeletePhotoSuccess)
    , Sub.map PhotoPageMsg (CommentPort.responseComments (PhotoUnion.CommentAction << CommentTypes.All))
    , Sub.map PhotoPageMsg (CommentPort.deleteCommentSuccess (PhotoUnion.CommentAction << CommentTypes.DeleteCallback))
    , Sub.map PhotoPageMsg (CommentPort.updateCommentSuccess (PhotoUnion.CommentAction << CommentTypes.UpdateCallback))
    ]



