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
        ]
