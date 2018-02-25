module Main exposing (..)

import Html exposing (Html)
import Model exposing (Model, initModel)
import Update exposing (update, Msg)
import View exposing (view)

---- MODEL ----

init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )

---- PROGRAM ----

main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
