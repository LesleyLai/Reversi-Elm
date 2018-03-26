module View exposing (view)

import Model exposing (Model)
import Models.PieceSpace exposing (PieceSpace(..))

import Views.BoardView exposing (boardView)

import Update exposing (Msg(..))

import Html
import Html.Styled exposing (..)

view : Model -> Html.Html Msg
view model =
    let headerText =
            if model.finished then
                case model.winner of
                    WhitePiece -> "White win!"
                    BlackPiece -> "Black win!"
                    NoPiece -> "Draw!"
            else
                "Reversi"
    in
    let {board, pieces, whiteCount, blackCount, current} = model.state in
    div []
        [
          h1 [] [ text headerText ],
             boardView board,
             p [] [ text ("White: " ++ (toString whiteCount))],
             p [] [ text ("Black: " ++ (toString blackCount))]
        ]
        |> toUnstyled

