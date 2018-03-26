module Update exposing (Msg(..), update)

import Model exposing (Model)

import Logics.GamePlay exposing (allValidMoves, nextState,
                                     gameFinished, winner, flipPlayer)

import Dict

type Msg
    = Click (Int, Int)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Click (x, y) ->
            case nextState model.state model.moves (x, y) of
                Just newState ->
                    let newMoves = allValidMoves newState in
                    if Dict.isEmpty newMoves then
                    -- No valid move for the current player
                        let reversedState = flipPlayer newState in
                        let newMoves2 = allValidMoves reversedState in
                        if Dict.isEmpty newMoves2 then
                            ({
                                state = newState,
                                moves = newMoves,
                                finished = True,
                                winner = winner newState
                            }, Cmd.none)
                        else
                            ({ model |
                            state = reversedState,
                            moves = newMoves2}, Cmd.none)
                    else if gameFinished newState then
                        ({ state = newState,
                           moves = newMoves,
                           finished = True,
                           winner = winner newState }
                        , Cmd.none)
                    else ({ model |
                            state = newState,
                            moves = newMoves}
                         , Cmd.none)
                Nothing -> (model, Cmd.none)
