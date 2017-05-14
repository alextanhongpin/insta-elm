module Page.Post.View exposing (view)

import Html exposing (Html, a, b, button, div, span, text, input, Attribute)
import Html.Attributes exposing (class, id, type_, placeholder, value, tabindex)
import Html.Events exposing (on, onClick, onBlur, onInput, keyCode, onFocus)

import Json.Decode as Json

-- ATOM


import Atom.Icon.View as Icon exposing (view)


-- PAGE


import Page.Post.Types exposing (Comment, CommentID, Model, Msg(..))

-- VIEW


view : Model -> Html Msg
view model = 
    div [ class "page page-post"]
        [ div [ class "container col-8" ]
            [ div [ class "br br-200" ] []
            , div [ class "post" ]
                [ div [ class "post-footer" ]
                    [ text "submitted by "
                    , a [] [ text model.owner ]
                    , text " in "
                    , case model.topic of 
                        Just topic -> 
                            a [] [ text ("my/" ++ topic) ]
                        Nothing ->
                            text "Nothing"
                    ]
                , div [ class "br br-100" ] []
                , div [ class "headline"]
                    [ div [ class "headline-left" ]
                        [ div [ class "post-header"] [ text "Growing ransomeware cases in Malaysia" ]
                        , div [ class "br br-100" ] []
                        , div [ class "post-body"] [ text "Anyone knows experts in Malaysia that can deal with ransomewares? \n Apparently my account got hacked and they are requesting b*tcoints.\n\n Dammmmm..." ]
                        ]
                    , div [ class "headline-right" ]
                        [  div [ class "headline-icon-edit"] [ Icon.view "more_vert" ] ]
                    ]
                ]


            -- BR
            , div [ class "br br-200" ] []

            , div [ class "comment-prev", onClick LoadMore ] [ text "show previous comments" ]
            , div [] (List.map (commentView model) model.comments)
            , commentFormView model

            -- BR
            , div [ class "br  br-200" ] []
            ] -- End of container
        ]


-- CUSTOM EVENT


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)

-- SUBVIEW


commentFormView : Model -> Html Msg
commentFormView model = 
    div [ class "comment-form" ]
        [ div [ class "comment-form__left"]
            [ div [ class "comment-form__userphoto" ] []
            ]
        , div [ class "comment-form__right"]
            [ div []
                [ input
                    [ class "comment-form__input"
                    , type_ "text"
                    , placeholder "Write a comment..."
                    , onInput OnInputComment
                    , value model.comment
                    , onKeyDown OnKeyDown
                    , onFocus OnFocusInputWhileEditing
                    ] [] 
                ]
            , div [ class "br br-50" ] []
            , div [ class "small" ] [ text "press enter to submit" ]
            ]

        ]


-- EDIT VIEW


editMenuView : String -> Html Msg
editMenuView commentID = 
    div [ id commentID, class "comment-menu", onBlur OnBlurEditMenu, tabindex 0 ]
        [ div [ class "content-menu__item", onClick (OnEdit commentID)] [ text "Edit"]
        , div [ class "content-menu__item", onClick (OnDelete commentID) ] [ text "Delete" ] 
        ]


-- COMMENT VIEW


commentView : Model -> (CommentID, Comment) -> Html Msg
commentView parent (id, model) = 
    let
        isEditMode =  parent.isEditing && parent.editIndex == id
        showEditMenu = parent.showEdit && parent.editIndex == id
        isOwner = parent.owner == model.name
    in
        div [ class "comment" ]
            [ div [ class "comment-left" ]
                [ div [ class "comment-photo" ] []
                ]
            , div [ class "comment-right" ]
                [ div [ class "comment-nested-left"][
                    if isEditMode then
                        div [] 
                            [ input 
                                [ class "comment-input-edit"
                                , type_ "text"
                                , value parent.ghostComment.text 
                                , onInput OnTypeEdit
                                , onKeyDown OnSubmitEdit
                                ] []
                            , div [ class "small" ] [ text "Press Esc to ", 
                             a [ onClick OnCancelEdit ] [ text "cancel"] ]
                            ]
                    else
                        div []
                            [ div [ class "comment-body" ] [ span [ class "comment-username"] [ text model.name ], text " ", text model.text ]
                            , div [ class "br br-50" ] []
                            , div [ class "comment-footer" ]
                                [ div [] [ text "100 Like | upvote | downvote", text " ", text "4:50 AM", text ("(ID:" ++ id ++ ")")
                                    , if model.isEdited then 
                                    span [] [ text "Edited"] 
                                    else span [] [] ]
                                ]
                        ]
                    ]
                ,
                -- Only the owner can edit it
                if isOwner then
                    if isEditMode then 
                        span [] []
                    else
                        div [ class "comment-nested-right" ]
                            [ div 
                                [ class "comment-icon--edit"
                                , onClick (ToggleEdit id)
                                ] [ Icon.view "more_vert" ]
                            , if showEditMenu then
                                editMenuView id
                              else
                                span [] []
                            ]
                        
                else
                    span [] []
                ]
    ]













