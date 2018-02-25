module Model exposing (initModel, Model)

import Models.Board exposing (Board, initialBoard, PieceSpace(..))

type alias Model = { board : Board, pieceCount: Int, current: PieceSpace }

initModel : Model
initModel = {
    board = initialBoard,
    pieceCount = 4,
    current = BlackPiece }
