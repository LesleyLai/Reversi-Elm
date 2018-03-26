module Main exposing (..)

import Html exposing (Html)
import Model exposing (Model)
import Update exposing (init, update, subscriptions, Msg(..))
import View exposing (view)


---- MODEL ----


---- PROGRAM ----

main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
