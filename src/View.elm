module View exposing (view)

import Dict

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
        moves = Dict.keys model.moves
        currentPlayer =
            case model.state.current of
                WhitePiece -> "White"
                BlackPiece -> "Black"
                NoPiece -> Debug.crash "Impossible"
    in
    let {board, pieces, whiteCount, blackCount, current} = model.state in
    div []
        [
          h1 [] [ text headerText ],
             p [] [ text (currentPlayer ++ " Move")],
             boardView board moves,
             p [] [ text ("White: " ++ (toString whiteCount))],
             p [] [ text ("Black: " ++ (toString blackCount))]
        ]
        |> toUnstyled

