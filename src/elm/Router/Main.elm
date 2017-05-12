module Router.Main exposing (..)

import Navigation exposing (Location)
import Html exposing (Attribute)
import Html.Events exposing (onWithOptions)
import UrlParser as Url exposing (..)
import Json.Decode as Json

import Router.Types exposing (Route(..))


matchers : Parser (Route -> a) a
matchers = 
  oneOf
    [ map HomeRoute top
    --, map PlayerRoute (s "players" </> string)
    --, map PlayersRoute (s "players")
    , map LoginRoute (s "login")
    , map RegisterRoute (s "register")
    , map HomeRoute (s "home")
    , map ProfileRoute (s "profile")
    , map PhotoRoute (s "photos" </> string)
    , map FeedRoute (s "feeds")
    , map TopicsRoute (s "topics")
    , map TopicRoute (s "topics" </> string)
    , map PostsRoute (s "posts")
    , map PostRoute (s "topics" </> string </> string)
    ]

parseLocation : Location -> Route
parseLocation location = 
  case (parsePath matchers location) of 
    Just route -> 
      route
    Nothing -> 
      NotFoundRoute


-- reverseRoute helps map the route to a url string


reverseRoute : Route -> String
reverseRoute route =
  case route of
    HomeRoute ->
      "/"

    --PlayerRoute id ->
    --  "/players/" ++ id

    --PlayersRoute -> 
    --  "/players"

    LoginRoute ->
      "/login"

    RegisterRoute ->
      "/register"

    ProfileRoute ->
      "/profile"

    PhotoRoute id ->
      "/photos/" ++ id

    FeedRoute ->
      "/feeds"

    TopicsRoute ->
      "/topics"

    TopicRoute id ->
      "/topics/" ++ id

    PostsRoute ->
      "/posts"

    PostRoute topicID postID ->
      "/topics/" ++ topicID ++ "/" ++ postID

    NotFoundRoute ->
      "/404"


-- onClickPreventDefault prevent page from refreshing
-- when the link is clicked


onClickPreventDefault : msg -> Attribute msg
onClickPreventDefault msg =
  onWithOptions
    "click"
    { stopPropagation = True, preventDefault = True }
    (Json.succeed msg)
