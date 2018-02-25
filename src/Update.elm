module Update exposing (Msg(..), update)

import Model exposing (Model)
import Models.Grid exposing (set)
import Models.Board exposing (Board, initialBoard,
                                  get, PieceSpace(..))

type Msg
    = Click (Int, Int)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Click (x, y) ->
            let {board, pieceCount, current} = model in
            let nexeBoard = (set board x y current) in
            let newModel = {board = nexeBoard,
                             pieceCount = (pieceCount+1),
                               current = (nextPiece current)} in
            (newModel, Cmd.none)

nextPiece : PieceSpace -> PieceSpace
nextPiece piece =
    case piece of
        BlackPiece -> WhitePiece
        WhitePiece -> BlackPiece
        NoPiece -> Debug.crash "You are violating the law of the universe"
