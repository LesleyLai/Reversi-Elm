module View exposing (view)

import Model exposing (Model)
import Views.BoardView exposing (boardView)

import Update exposing (Msg(..))

import Html
import Html.Styled exposing (..)

view : Model -> Html.Html Msg
view model =
    let {board, pieceCount, current} = model in
    div []
        [
          h1 [] [ text "Reversi" ],
             boardView board
        ]
        |> toUnstyled

