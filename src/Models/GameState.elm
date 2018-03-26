module Models.GameState exposing (GameState, initGameState, Point, Sandwich)

import Models.Board exposing (Board, initialBoard)
import Models.PieceSpace exposing (PieceSpace(..))

type alias GameState = { board : Board, pieces: List (Int, Int),
                         whiteCount: Int, blackCount: Int,
                         current: PieceSpace }

type alias Point = (Int, Int)
    
{- Sandwiches are consecutive list of same color pieces that
"sandwiched" by two pieces of different color-}
type alias Sandwich = List Point


initGameState : GameState
initGameState = {
    board = initialBoard,
    pieces = [(3,3), (3,4), (4,3), (4,4)],
    whiteCount = 2,
    blackCount = 2,
    current = BlackPiece }
