module View exposing (view)

import Model exposing (Model)
import Views.BoardView exposing (boardView)

import Update exposing (Msg(..))

import Html
import Html.Styled exposing (..)

view : Model -> Html.Html Msg
view model =
    let {board, pieces, whiteCount, blackCount, current} = model in
    div []
        [
          h1 [] [ text "Reversi" ],
             boardView board,
             p [] [ text ("White: " ++ (toString whiteCount))],
             p [] [ text ("Black: " ++ (toString blackCount))]
        ]
        |> toUnstyled

