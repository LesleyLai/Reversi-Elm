module Model exposing (initModel, Model)

import Models.Board exposing (Board, initialBoard, PieceSpace(..))

type alias Model = { board : Board, pieces: List (Int, Int),
                         whiteCount: Int, blackCount: Int,
                         current: PieceSpace }

initModel : Model
initModel = {
    board = initialBoard,
    pieces = [(3,3), (3,4), (4,3), (4,4)],
    whiteCount = 2,
    blackCount = 2,
    current = BlackPiece }
