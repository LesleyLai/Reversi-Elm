module Model exposing (initModel, Model)

import Models.Camera exposing (Camera, initCamera)
import Models.PieceSpace exposing (PieceSpace(..))
import Models.GameState exposing (..)
import Logics.GamePlay exposing (..)

import Dict exposing (Dict)
import Time exposing (Time)
import Window

import WebGL.Texture as Texture exposing (Texture)

type alias Model = {
        state: GameState,
        moves: Dict (Int, Int) (List Sandwich),
        finished: Bool,
        winner: PieceSpace,
        -- Below is the stuff for 3d rendering
        currentTime: Time,
        size: Window.Size,
        camera: Camera,
        boardTexture: Maybe Texture }

initModel : Model
initModel = {
    state = initGameState,
    moves = allValidMoves initGameState,
    finished = False,
    winner = NoPiece,
    currentTime = 0,
    size = Window.Size 0 0,
    camera = initCamera,
    boardTexture = Nothing }
    
