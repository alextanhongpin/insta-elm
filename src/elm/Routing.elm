module Routing exposing (..)

import Navigation exposing (Location)
import Html exposing (Attribute)
import Html.Events exposing (onWithOptions)
import UrlParser exposing (..)

import Json.Decode as Json
import Types exposing (..)




matchers : Parser (Route -> a) a
matchers = 
  oneOf
    [ map HomeRoute top
    , map PlayerRoute (s "players" </> string)
    , map PlayersRoute (s "players")
    , map LoginRoute (s "login")
    , map RegisterRoute (s "register")
    , map HomeRoute (s "home")
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

    PlayerRoute id ->
      "/players/" ++ id

    PlayersRoute -> 
      "/players"

    LoginRoute ->
      "/login"

    RegisterRoute ->
      "/register"

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