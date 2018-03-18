module Update exposing (Msg(..), update)

import Dict

import Model exposing (Model)
import Models.Grid exposing (set)
import Models.Board exposing (Board, initialBoard,
                                  get, PieceSpace(..))
import Logics.Utils exposing (allValidMoves)

type Msg
    = Click (Int, Int)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let {board, pieces, whiteCount, blackCount, current} = model in
    case msg of
        Click (x, y) ->
            let
                moves = allValidMoves model
                (next, newWhite, newBlack) =
                    (nextPiece current whiteCount blackCount)
                newPieces = (x,y)::pieces
            in
                case Dict.get (x, y) moves of
                    Nothing -> (model, Cmd.none)
                    Just toFlip ->
                        let newModel
                                = flip model (List.concat toFlip) in
                        ({board = (set newModel.board x y current),
                         pieces = newPieces,
                         whiteCount = newWhite,
                         blackCount = newBlack,
                         current = next}, Cmd.none)
                        

{- Flip the pieces in the list -}
flip : Model -> List (Int, Int) -> Model
flip model toFlip =
    List.foldl (\(x,y) modelBefore ->
                let {board, pieces, whiteCount, blackCount, current} = modelBefore in
                {board = (set board x y current),
                 pieces = pieces,
                 whiteCount = whiteCount,
                 blackCount = blackCount,
                 current = current}
               ) model toFlip
        
        
nextPiece : PieceSpace -> Int -> Int -> (PieceSpace, Int, Int)
nextPiece piece whiteCount blackCount =
    case piece of
        BlackPiece -> (WhitePiece, whiteCount, blackCount+1)
        WhitePiece -> (BlackPiece, whiteCount+1, blackCount)
        NoPiece -> Debug.crash "You are violating the law of the universe"
