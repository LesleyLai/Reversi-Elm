module Models.Grid exposing (Grid, repeat, get, set)

import Array exposing (Array, repeat, get, set)
import Maybe exposing (andThen, map)

type alias Grid a = Array (Array a)

--  Creates an array with a given dimension, filled with a default element.
repeat : Int -> Int -> a -> Grid a
repeat width height value =
    Array.repeat height (Array.repeat width value)

get : Grid a -> Int -> Int -> Maybe a
get grid x y =
    Array.get y grid |> andThen (Array.get x)

{-|  Set the element at a particular coordinate.
      Returns an updated grid.
      If the grid is out of range, the grid is unaltered.
-}
set: Grid a -> Int -> Int -> a -> Grid a
set grid x y value =
    Array.get y grid
        |> Maybe.map (Array.set x value)
        |> Maybe.map (\row -> Array.set y row grid)
        |> Maybe.withDefault grid
    
