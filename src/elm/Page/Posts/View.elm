module Page.Posts.View exposing (view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class, href)


-- VIEW


view : Html msg
view = 
    div [] [ text "Posts Page" ]