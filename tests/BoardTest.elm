module BoardTest exposing (..)

import Models.Board exposing (..)
import Test exposing (..)
import Expect


-- Check out http://package.elm-lang.org/packages/elm-community/elm-test/latest to learn more about testing in Elm!


all : Test
all =
    describe "A Test Suite"
        [ test "initial board 33" <|
              \_ ->
              Expect.equal (get initialBoard 3 3) WhitePiece
        , test "initial board 44" <|
            \_ ->
                Expect.equal (get initialBoard 4 4) WhitePiece
        , test "initial board 34" <|
            \_ ->
                Expect.equal (get initialBoard 3 4) BlackPiece
        , test "initial board 43" <|
            \_ ->
                Expect.equal (get initialBoard 4 3) BlackPiece
        , test "initial board empty places" <|
            \_ ->
                Expect.equal (get initialBoard 1 1) NoPiece
        ]
        
