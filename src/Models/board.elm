module Models.Board exposing (PieceSpace(..), Board, initialBoard, get)

import Models.Grid exposing (Grid, repeat, set)

type PieceSpace = NoPiece | WhitePiece | BlackPiece

type alias Board = Grid PieceSpace


initialBoard: Board
initialBoard =
    repeat 8 8 NoPiece |>
    (\board -> set board 3 3 WhitePiece) |>
    (\board -> set board 3 4 BlackPiece) |>
    (\board -> set board 4 3 BlackPiece) |>
    (\board -> set board 4 4 WhitePiece)

{-
An unsafe version of "get" to access pieces on a board
-}
get: Board -> Int -> Int -> PieceSpace
get board x y =
     case Models.Grid.get board x y of
         Just piece -> piece
         Nothing -> Debug.crash "Out of index"
