module Model exposing (initModel, Model)

import Models.PieceSpace exposing (PieceSpace(..))
import Models.GameState exposing (..)
import Logics.GamePlay exposing (..)

import Dict exposing (Dict)
import Time exposing (Time)
import Window

type alias Model = {
        state: GameState,
        moves: Dict (Int, Int) (List Sandwich),
        finished: Bool,
        winner: PieceSpace,
        -- Below is the stuff for 3d rendering
        currentTime: Time,
        size: Window.Size
    }

initModel : Model
initModel = {
    state = initGameState,
    moves = allValidMoves initGameState,
    finished = False,
    winner = NoPiece,
    currentTime = 0,
    size = Window.Size 0 0 }
    
