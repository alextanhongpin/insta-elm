module Atom.Header.View exposing (view)


import Html exposing (Html, a, div, span, i, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)

import Types exposing (Model, Msg(NavigateTo, Logout))
import Router.Main exposing (reverseRoute, onClickPreventDefault)
import Router.Types exposing (Route(..))

import Atom.Icon.View as Icon exposing (view)

view : Model -> Html Msg
view model = 
    if model.isAuthorized then
      div [ class "header" ] 
          [ brand model
          , div [] 
              [ a 
                [ href (reverseRoute FeedRoute)
                , onClickPreventDefault (NavigateTo FeedRoute) ] 
                [ text "Feed" ]
              , a 
                [ href (reverseRoute ProfileRoute)
                , onClickPreventDefault (NavigateTo ProfileRoute) ] 
                [ text "Profile"
                , Icon.view "person"
                ]
              , a 
                [ href (reverseRoute TopicsRoute)
                , onClickPreventDefault (NavigateTo TopicsRoute) ]
                [ text "Topics" ] 
              ]
          , div [ class "logout", onClick Logout ] [ text "Logout" ] 
          ]
    else
      div [ class "header" ]
          [ brand model
          , authorizedView model
          ]


brand : Model -> Html Msg
brand model = 
    a [ class "header-brand" 
      , href (reverseRoute HomeRoute)
      , if model.isAuthorized then 
          onClickPreventDefault (NavigateTo ProfileRoute) 
        else
          onClickPreventDefault (NavigateTo HomeRoute) 
      ] [ text "InstaElm" ]


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






