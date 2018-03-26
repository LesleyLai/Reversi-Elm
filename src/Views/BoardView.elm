module Views.BoardView exposing (boardView)

import Models.Board exposing (Board, initialBoard,
                                  get, boardSpec)
import Models.PieceSpace exposing (PieceSpace(..))
import Update exposing (update, Msg(..))

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Css exposing (..)
import Css.Colors exposing (white, black)
import List exposing (range)
import Html.Styled.Events exposing (onClick)

blockWidth : Float
blockWidth = 50

pieceView : PieceSpace -> Int -> Int -> Html Msg
pieceView piece x y =
    let circleStyle = [width (px 40),
                      height (px 40),
                      borderRadius (px 25),
                      border3 (px 1) solid black,
                      margin2 (px 5) auto] in
    let
        circle = case piece of
                     NoPiece -> div [] []
                     WhitePiece ->
                         div [ css ((backgroundColor (white)) :: circleStyle)] []
                     BlackPiece ->
                         div [ css ((backgroundColor (black)) :: circleStyle)] []
    in
    div
    [css [ border3 (px 1) solid black
         , width (px blockWidth)
         , height (px blockWidth)],
    onClick (Click (x, y))]
    [ circle ]

rowView : Board -> Int -> Html Msg
rowView board y =
    let (w, h) = boardSpec in
    div [css [displayFlex,
              width (px ((blockWidth + 2) * (toFloat w))),
              margin auto]]
        (List.map (\x -> pieceView (get board x y) x y) (range 0 (w-1)))

boardView : Board -> Html Msg
boardView board =
    let (w, h) = boardSpec in
    div [css [margin auto]]
        (List.map (\y -> (rowView board y)) (range 0 (h-1)))
      
