module Models.Board exposing (Board,
                              initialBoard,
                              get,
                              boardSpec,
                              pieceEqual)

import Models.Grid exposing (Grid, repeat, set)
import Models.PieceSpace exposing (PieceSpace(..))


type alias Board = Grid PieceSpace

boardSpec: (Int, Int)
boardSpec = (8, 8)

initialBoard: Board
initialBoard =
    let (w, h) = boardSpec in
    repeat w h NoPiece |>
    (\board -> set board (w//2-1) (h//2-1) WhitePiece) |>
    (\board -> set board (w//2) (h//2-1) BlackPiece) |>
    (\board -> set board (w//2-1) (h//2) BlackPiece) |>
    (\board -> set board (w//2) (h//2) WhitePiece)

{-
An unsafe version of "get" to access pieces on a board
-}
get: Board -> Int -> Int -> PieceSpace
get board x y =
     case Models.Grid.get board x y of
         Just piece -> piece
         Nothing -> Debug.crash "Out of index"

pieceEqual: PieceSpace -> PieceSpace -> Bool
pieceEqual piece1 piece2 =
    case piece1 of
        NoPiece ->
            Debug.crash "Cannot compare empty place"
        WhitePiece ->
            case piece2 of
                NoPiece ->
                    Debug.crash "Cannot compare empty place"
                WhitePiece -> True
                BlackPiece -> False
        BlackPiece ->
            case piece2 of
                NoPiece ->
                    Debug.crash "Cannot compare empty place"
                WhitePiece -> False
                BlackPiece -> True
