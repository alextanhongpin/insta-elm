module Atom.Header.View exposing (view)


import Html exposing (Html, a, div, span, i, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (on, onClick)

import Types exposing (Model, Msg(..))


-- ROUTER


import Router.Main exposing (reverseRoute, onClickPreventDefault)
import Router.Types exposing (Route(..))


-- CONSTANTS


appName : String
appName = "NewsMap"


--VIEW


view : Model -> Html Msg
view model =
  if model.isAuthorized then
    div [ class "header" ] 
        [ brandView model
        , div []
            [ div [ class "header-link-group" ] 
              [ linkView (FeedRoute) ("Feed") (model.route)
              , linkView (TopicsRoute) ("Groups") (model.route)
              , linkView (ProfileRoute) ("Profile") (model.route)
              , div [ class "logout", onClick Logout ] [ text "Logout" ] 
              ]
            ]
        ]
  else
    div [ class "header" ]
        [ brandView model
        , authorizedView model
        ]


-- SUBVIEW


linkView : Route -> String -> Route -> Html Msg
linkView route label currentRoute =
    let
      className 
        = if currentRoute == route then "header-link is-selected" 
        else "header-link"
    in
      a 
      [ class className
      , href (reverseRoute route)
      , onClickPreventDefault (NavigateTo route) ] 
      [ text label ]


brandView : Model -> Html Msg
brandView model = 
    a [ class "header-brand" 
      , href (reverseRoute HomeRoute)
      , if model.isAuthorized then 
          onClickPreventDefault (NavigateTo ProfileRoute) 
        else
          onClickPreventDefault (NavigateTo HomeRoute) 
      ] [ text appName ]


authorizedView : Model -> Html Msg
authorizedView model =
    div [ class "header-links" ] 
      [ loginLink model
      , registerLink model]


loginLink : Model -> Html Msg
loginLink model = 
    a [ class "header-link"
      , href (reverseRoute LoginRoute)
      , onClickPreventDefault (NavigateTo LoginRoute) 
    ] [ text "Login" ]


registerLink : Model -> Html Msg
registerLink model =
    a [ class "header-link"
    , href (reverseRoute RegisterRoute)
    , onClickPreventDefault (NavigateTo RegisterRoute) 
    ] [ text "Register" ]






