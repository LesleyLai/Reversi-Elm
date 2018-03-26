module Update exposing (Msg(..), update)

import Dict

import Model exposing (Model)
import Models.GameState exposing (GameState)
import Logics.GamePlay exposing (allValidMoves, nextState)

type Msg
    = Click (Int, Int)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Click (x, y) ->
                case nextState model.state model.moves (x, y) of
                    Just newState -> ({
                        state = newState,
                        moves = allValidMoves newState }
                        , Cmd.none)
                    Nothing -> (model, Cmd.none)
                        

