{-- 
  View.elm
  * Contains the main view that is handled by routing
--}

module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href)
import Html.Events exposing ( onClick, onWithOptions )
import Types exposing (..)

import Atom.Header.View as Header exposing (view)


-- MOLECULES


import Molecule.Card exposing ( card )
import Page.Login.View as LoginPage
import Page.Home.View as HomePage
import Page.Profile.View as ProfilePage


-- VIEW


-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  case model.route of
      PlayersRoute ->
        div [ ] [
          div [] [ text "This is /players route" ],
          a [ href "#players/1"] [ text "Go to player 1 page" ]
        ]

      PlayerRoute id ->
        div [ ] [
          div [] [ text "This is the player" ],
          button [ onClick FetchService ] [ text "Fetch service" ],
          div [ ] [ text model.metadata.title ],
          div [ ] [ text model.metadata.body ],
          div [ ] [ text (toString(model.metadata.id)) ],
          div [ ] [ text (toString(model.metadata.userId)) ],
          div [ ] [ text ("This is the access token:" ++ model.accessToken) ], 
          card model
        ]

      RegisterRoute -> 
        div [] [ text "Register"]

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
          , ProfilePage.view
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
