{-- 
  View.elm
  * Contains the main view that is handled by routing
--}

module View exposing (..)

import Html exposing (..)
import Types exposing (..)

import Atom.Header.View as Header exposing (view)

import Router.Types exposing (..)


-- MOLECULES



-- PAGE


import Page.Login.View as LoginPage
import Page.Home.View as HomePage
import Page.Profile.View as ProfilePage
import Page.Photo.View as PhotoPage
import Page.Register.View as RegisterPage


-- VIEW


-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  case model.route of
      --PlayersRoute ->
      --  div [ ] [
      --    div [] [ text "This is /players route" ],
      --    a [ href "#players/1"] [ text "Go to player 1 page" ]
      --  ]

      --PlayerRoute id ->
      --  div [ ] [
      --    div [] [ text "This is the player" ],
      --    button [ onClick FetchService ] [ text "Fetch service" ],
      --    div [ ] [ text model.metadata.title ],
      --    div [ ] [ text model.metadata.body ],
      --    div [ ] [ text (toString(model.metadata.id)) ],
      --    div [ ] [ text (toString(model.metadata.userId)) ],
      --    div [ ] [ text ("This is the access token:" ++ model.accessToken) ], 
      --    card model
      --  ]

      RegisterRoute -> 
        let 
          pageModel = model.registerPage
          pageView = RegisterPage.view
          pageMsg = RegisterPageMsg
        in
          div [] 
          [ Header.view model
          , Html.map pageMsg (pageView pageModel)
          ]

      LoginRoute -> 
        div [] 
        [ Header.view model
        , Html.map LoginPageMsg (LoginPage.view model.loginPage)
        ]

      HomeRoute -> 
        div []
          [ Header.view model
          , HomePage.view
          ]

      ProfileRoute ->
        div [] 
          [ Header.view model
          , Html.map ProfilePageMsg (ProfilePage.view model.profilePage)
          ]

      PhotoRoute id ->
        --let 
        --  initModel 
        --    = { model | photoPage = PhotoPageTypes.model }
        --in
        -- Problem: How do I reset the state when I enter a new page
        div [] 
          [ Header.view model
          , Html.map PhotoPageMsg (PhotoPage.view model.photoPage)
          ]

      NotFoundRoute ->
        notFoundView


-- CSS STYLES


styles : { img : List ( String, String ) }
styles =
  {
    img =
      [ ( "width", "33%" )
      , ( "border", "4px solid #337AB7")
      ]
  }

notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]
