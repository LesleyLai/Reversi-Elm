module Update exposing (Msg, update)

import Models.Board exposing (Board, initialBoard)

type Msg
    = NoOp

update : Msg -> Board -> ( Board, Cmd Msg )
update msg model =
    ( model, Cmd.none )
