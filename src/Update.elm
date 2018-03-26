module Update exposing (Msg(..), update)

import Model exposing (Model)

import Logics.GamePlay exposing (allValidMoves, nextState, gameFinished, winner)

type Msg
    = Click (Int, Int)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Click (x, y) ->
            case nextState model.state model.moves (x, y) of
                Just newState ->
                    if gameFinished newState then
                        ({ state = newState,
                           moves = allValidMoves newState,
                           finished = True,
                           winner = winner newState }
                        , Cmd.none)
                    else ({ model |
                            state = newState,
                            moves = allValidMoves newState }
                         , Cmd.none)
                Nothing -> (model, Cmd.none)
                        

