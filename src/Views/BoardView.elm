module Views.BoardView exposing (view)

import Models.Board exposing (Board, initialBoard, PieceSpace(..), get)
import Update exposing (update, Msg)

import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Css exposing (..)
import Css.Colors exposing (white, black)

pieceView : PieceSpace -> Html msg
pieceView piece =
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

    --div [ css ((backgroundColor (black)) :: circleStyle)] []
    in
    div
    [css [ border3 (px 1) solid black
         , width (px 50)
         , height (px 50)]]
    [ circle ]


boardView : Board -> Html Msg
boardView board =
    div [css [margin auto]]
        [ pieceView (get board 3 4)
        ]
       

view : Board -> Html.Html Msg
view board =
    div []
        [
          h1 [] [ text "Reversi" ],
             boardView board 
        ]
        |> toUnstyled
        
