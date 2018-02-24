module GridTests exposing (..)
import Test exposing (..)
import Expect

import Array
import Models.Grid as Grid


all : Test
all =
    describe "A Test Suite"
        [ test "Create grid through repeat" <|
            \_ ->
              let aa = Array.fromList ['a', 'a'] in
                Expect.equal (Grid.repeat 2 2 'a')
              (Array.fromList [aa, aa])
        , test "Get element of grid through index" <|
            \_ ->
                let aaaa = (Grid.repeat 2 2 'a') in
                let a = Grid.get aaaa 1 0 in
                Expect.equal a (Just  'a')
        , test "Get element out of index returns nothing" <|
            \_ ->
                let aaaa = (Grid.repeat 2 2 'a') in
                let a = Grid.get aaaa 1 2 in
                Expect.equal a Nothing
        , test "Set element of a array" <|
            \_ ->
                let aaaa = (Grid.repeat 2 2 'a') in
                let aaba = (Grid.set aaaa 1 0 'b') in
                Expect.equal (Grid.get aaba 1 0) (Just 'b')
        ]
