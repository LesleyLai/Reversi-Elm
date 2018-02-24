module Models.Grid exposing (Grid, repeat)

import Array exposing (..)

type alias Grid a = Array (Array a)

--  Creates an array with a given dimension, filled with a default element.
repeat : Int -> Int -> a -> Grid a
repeat width height value =
    Array.repeat height (Array.repeat width value)

