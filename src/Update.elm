module Update exposing (Msg(..), init, update, subscriptions)

import Model exposing (Model, initModel)

import Logics.GamePlay exposing (allValidMoves, nextState,
                                     gameFinished, winner, flipPlayer)

import Window
import AnimationFrame
import Task exposing (Task)
import Time exposing (Time)

import Dict

type Msg
    = Animate Time | Click (Int, Int) | Resize Window.Size

init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.batch [Task.perform Resize Window.size] )
      
subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ AnimationFrame.diffs Animate
        --, Keyboard.downs (KeyChange True)
        --, Keyboard.ups (KeyChange False)
        , Window.resizes Resize
        ]
      
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Animate dt ->
            ({ model | currentTime = model.currentTime + dt}, Cmd.none)
        Resize size ->
            ({ model | size = size}, Cmd.none)
        Click (x, y) ->
            (model, Cmd.none)
            
            ----------------------------------------------------------------
            -- case nextState model.state model.moves (x, y) of           --
            --     Just newState ->                                       --
            --         let newMoves = allValidMoves newState in           --
            --         if Dict.isEmpty newMoves then                      --
            --         -- No valid move for the current player            --
            --             let reversedState = flipPlayer newState in     --
            --             let newMoves2 = allValidMoves reversedState in --
            --             if Dict.isEmpty newMoves2 then                 --
            --                 ({                                         --
            --                     state = newState,                      --
            --                     moves = newMoves,                      --
            --                     finished = True,                       --
            --                     winner = winner newState               --
            --                 }, Cmd.none)                               --
            --             else                                           --
            --                 ({ model |                                 --
            --                 state = reversedState,                     --
            --                 moves = newMoves2}, Cmd.none)              --
            --         else if gameFinished newState then                 --
            --             ({ state = newState,                           --
            --                moves = newMoves,                           --
            --                finished = True,                            --
            --                winner = winner newState }                  --
            --             , Cmd.none)                                    --
            --         else ({ model |                                    --
            --                 state = newState,                          --
            --                 moves = newMoves}                          --
            --              , Cmd.none)                                   --
            --     Nothing -> (model, Cmd.none)                           --
            ----------------------------------------------------------------
