-- State.elm contains init, update, subscriptions
port module State exposing (..)

-- import Types exposing (..)
import Navigation exposing (Location)
import Router.Main as Routing exposing (reverseRoute)
import Router.Types exposing (Route(..))
import Port exposing (..)

-- PAGE


-- STATE


import Page.Login.State as LoginState
import Page.Photo.State as PhotoState
import Page.Photos.State as PhotosState
import Page.Profile.State as ProfileState
import Page.Register.State as RegisterState
import Page.Topic.State as TopicState
import Page.Topics.State as TopicsState
import Page.Feed.State as FeedState
import Page.Post.State as PostState


-- Types


import Page.Login.Types as LoginTypes
import Page.Photo.Types as PhotoTypes
import Page.Photos.Types as PhotosTypes
import Page.Profile.Types as ProfileTypes
import Page.Feed.Types as FeedTypes
import Page.Topic.Types as TopicTypes
import Page.Topics.Types as TopicsTypes
-- import Page.Post.Types as PostTypes


-- PORT


import Molecule.Photo.Port as PhotoPort exposing (..)
import Molecule.Comment.Port as CommentPort exposing (..)


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
    OnLocationChange location -> 
      let
        newRoute = 
          Routing.parseLocation location
      in
      ( { model | route = newRoute }, Cmd.none )

    Logout ->
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
        LoginTypes.LoginSuccess user ->
          let 
            msg = NavigateTo ProfileRoute
            updatedModel = 
              { model 
                | loginPage = LoginTypes.model
                , user = user
                , isAuthorized = True 
              }
          in
            update msg updatedModel

        LoginTypes.OnSubmitLogin ->
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


    {-- PHOTO PAGE
        
      * Intercept messages from the photo page
      * Add custom logic/modify model/trigger commands 

    --}


    PhotoPageMsg childMsg ->
      case childMsg of
        PhotoTypes.DeletePhotoSuccess photoID ->
          let
            childModel = model.profilePage
            newPhotos = List.filter (\(a, b) -> a /= photoID) childModel.photos
            newMsg = NavigateTo ProfileRoute
            newChildModel = { childModel | photos = newPhotos }
            newModel = { model | profilePage = newChildModel}
          in
            update newMsg newModel
        _ ->
          let
            ( childModel, childCmd ) = 
             PhotoState.update childMsg model.photoPage
          in
            { model | photoPage = childModel } ! [ Cmd.map PhotoPageMsg childCmd ]


    {-- REGISTER PAGE
        
      * Intercept messages from the register page

    --}


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


    {-- FEED PAGE
        
      * Intercept messages from the feed page

    --}


    FeedPageMsg childMsg ->
      case childMsg of
        FeedTypes.GoToTopic topicID ->
          let 
            msg = NavigateTo (TopicRoute topicID)
          in
            update msg model

        _ -> 
          let
            ( feedModel, feedCmd ) = 
             FeedState.update childMsg model.feedPage
          in
            ({ model | feedPage = feedModel }
            , Cmd.map FeedPageMsg feedCmd
            )


    {-- TOPIC PAGE
        
      * Intercept messages from the feed page

    --}


    -- GET /topics/:id
    TopicPageMsg childMsg ->
      case childMsg of
        TopicTypes.GoTo topic id ->
          let 
            msg = NavigateTo (PostRoute topic id)
          in
            update msg model

        TopicTypes.GoToTopic topic ->
          let 
            msg = NavigateTo (TopicRoute topic)
          in
            update msg model
        --TopicTypes.TopicAction childMsg ->
        --  model ! []
        _ -> 
          let
            ( topicModel, topicCmd ) = 
             TopicState.update childMsg model.topicPage
          in
            ({ model | topicPage = topicModel }
            , Cmd.map TopicPageMsg topicCmd
            )


    {-- TOPICS PAGE
        
      * Intercept messages from the feed page

    --}


    TopicsPageMsg childMsg ->
      case childMsg of
        TopicsTypes.GoToTopic topic ->
          let
            msg = NavigateTo (TopicRoute topic)
          in
            update msg model
        _ -> 
          let
            ( topicsModel, topicsCmd ) = 
             TopicsState.update childMsg model.topicsPage
          in
            ({ model | topicsPage = topicsModel }
            , Cmd.map TopicsPageMsg topicsCmd
            )


    {-- POST PAGE
        
      * Intercept messages from the feed page

    --}


    PostPageMsg childMsg ->
      case childMsg of
        _ -> 
          let
            ( childModel, childCmd ) = 
             PostState.update childMsg model.postPage
          in
            ({ model | postPage = childModel }
            , Cmd.map PostPageMsg childCmd
            )


    {-- PROFILE PAGE
        
      * Intercept messages from the feed page

    --}


    ProfilePageMsg childMsg ->
      case childMsg of
        ProfileTypes.SetDisplayNameSuccess displayName -> 
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

        ProfileTypes.NavigateTo photoId ->
          let
            newMsg = NavigateTo (PhotoRoute photoId)
          in
            update newMsg model
            
        _ -> 
          let
            ( profileModel, profileCmd ) = 
             ProfileState.update childMsg model.profilePage
          in
            ({ model | profilePage = profileModel }
            , Cmd.map ProfilePageMsg profileCmd
            )



    {-- NAVIGATION
        
      * Handle the core navigation of the app 
      * Uses HTML5 History API
      * Logic here will execute before going to the route (before hook)

    --}


    NavigateTo route ->
      let
        navigate = Navigation.newUrl (reverseRoute route)
      in
        case route of
          FeedRoute ->
            -- requestPublicPhotos ()
            --let
            --  sub = Navigation.newUrl (reverseRoute route)
            --in 
            model ! [ Cmd.batch [ navigate ] ]

          ProfileRoute ->
            if
              model.route == route && not (List.isEmpty model.profilePage.photos)
            then
              model ! []
            else
              -- Request new photos when the user enter the page
              -- ProfileState.requestPhotos (), photoCount ()
              model ! [ Cmd.batch [ navigate ] ]

          PhotoRoute photoId ->
            let
              pageModel = model.photoPage
              -- Reset model when entering the page
              newPageModel = { pageModel | comments = [] }
            in
              ({ model | photoPage = newPageModel }, Cmd.batch [ requestPhoto photoId, CommentPort.requestComments photoId, navigate ] )

          TopicRoute topic ->
            let
              pageModel = model.topicPage
              newPageModel = { pageModel | topic = topic, topics = Just [] }
            in
              { model | topicPage = newPageModel } ! [ navigate ]

          PostRoute topic id ->
            let
              pageModel = model.postPage
              newPageModel = { pageModel | topic = Just(topic), postID = Just(id) }
            in
              { model | postPage = newPageModel } ! [ navigate ]

          _ ->
          -- Reset the state when go to a new page
            model ! [ navigate ]

    Authenticate str -> 
      --if str == "login" then
      --  if model.route == LoginRoute then
      --    let
      --      newMsg = NavigateTo ProfileRoute
      --    in
      --      update newMsg model
      --  else
      --    let
      --      newMsg = NavigateTo model.route
      --    in
      --      update newMsg model
      --else if str == "logout" then
      --  let
      --    newMsg = NavigateTo LoginRoute
      --  in
      --    update newMsg model
      --else
        model ! []

    {--Is called when the user is logged in firebase--}
    AuthenticateSuccess user ->
      -- Redirect the user after logging in
      let
        -- msg = NavigateTo ProfileRoute
        msg = if model.route == LoginRoute then 
          NavigateTo ProfileRoute
        else 
          NavigateTo model.route
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


    -- OnMouseClick position ->
    --   ({ model | position = position }, Cmd.none)





