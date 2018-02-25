module Update exposing (Msg(..), update)

import Models.Board exposing (Board, initialBoard)

type Msg
    = Click (Int, Int)

update : Msg -> Board -> ( Board, Cmd Msg )
update msg model =
    case msg of
        Click (x, y) ->
            Debug.log (toString (x, y))
            ( model, Cmd.none )

