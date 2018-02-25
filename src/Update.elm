module Update exposing (Msg(..), update)

import Model exposing (Model)
import Models.Grid exposing (set)
import Models.Board exposing (Board, initialBoard,
                                  get, PieceSpace(..))

type Msg
    = Click (Int, Int)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let {board, pieces, whiteCount, blackCount, current} = model in
    case msg of
        Click (x, y) ->
            let
                nextBoard = (set board x y current)
                (next, newWhite, newBlack) =
                    (nextPiece current whiteCount blackCount)
                newPieces = (x,y)::pieces
            in
            let newModel = {board = nextBoard,
                            pieces = newPieces,
                            whiteCount = newWhite,
                             blackCount = newBlack,
                               current = next} in
            (newModel, Cmd.none)

nextPiece : PieceSpace -> Int -> Int -> (PieceSpace, Int, Int)
nextPiece piece whiteCount blackCount =
    case piece of
        BlackPiece -> (WhitePiece, whiteCount, blackCount+1)
        WhitePiece -> (BlackPiece, whiteCount+1, blackCount)
        NoPiece -> Debug.crash "You are violating the law of the universe"
