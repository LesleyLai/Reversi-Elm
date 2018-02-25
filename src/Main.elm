module Main exposing (..)

import Html exposing (Html)
import Models.Board exposing (Board, initialBoard)
import Update exposing (update, Msg)
import Views.BoardView exposing (view)

---- MODEL ----

type alias Model =
    Board

init : ( Model, Cmd Msg )
init =
    ( initialBoard, Cmd.none )

---- PROGRAM ----

main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
