module Model exposing (initModel, Model)

import Models.PieceSpace exposing (PieceSpace(..))
import Models.GameState exposing (..)
import Logics.GamePlay exposing (..)

import Dict exposing (Dict)

type alias Model = {
        state: GameState,
        moves: Dict (Int, Int) (List Sandwich),
        finished: Bool,
        winner: PieceSpace }


initModel : Model
initModel = {
    state = initGameState,
    moves = allValidMoves initGameState,
    finished = False,
    winner = NoPiece}
    
