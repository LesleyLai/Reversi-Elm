module Logics.Utils exposing (..)

import Model exposing (Model)
import Models.Board exposing (boardSpec, get, PieceSpace(..), pieceEqual)

import Set

{- 
Gets the neighbors of a coordinate on a board,
ignore places out of index
-}
neighbors : (Int, Int) -> List (Int, Int)
neighbors (x, y) = 
    if not (inBoard (x, y)) then []
    else
    let potentialNeighbors = [(x-1, y-1), (x-1, y), (x-1, y+1),
                              (x, y-1), (x, y+1),
                              (x+1, y-1), (x+1, y), (x+1, y+1)] in
    List.filter inBoard potentialNeighbors

inBoard : (Int, Int) -> Bool
inBoard (x, y) = 
    let (w, h) = boardSpec in
    if x < 0 || y < 0 || x >= w || y >= h then
        False
    else
        True

allPotentialMoves : Model -> List (Int, Int)
allPotentialMoves model =
    let
        board = model.board
        pieces = model.pieces
        piecesSet = Set.fromList pieces
    in
        List.concatMap neighbors pieces
            |> List.filter (\piece-> not <| Set.member piece piecesSet)
            |> Set.fromList
            |> Set.toList

{- Sandwiches are consecutive list of same color pieces that
"sandwiched" by two pieces of different color-}
type alias Sandwich = List (Int, Int)
    
type alias Direction = (Int, Int)
    
nextPiece : (Int, Int) -> Direction -> Maybe (Int, Int)
nextPiece point direction =
    let
        (x, y) = point
        (dx, dy) = direction
    in
    let nextPoint = (x + dx, y + dy) in
    if inBoard nextPoint then
        Just nextPoint
    else
        Nothing

sandwichHelper : Model -> (Int, Int) -> Direction -> PieceSpace -> Maybe Sandwich
sandwichHelper model point direction firstColor =
    let piece = nextPiece point direction in
    case piece of
        Nothing -> Nothing
        Just (x, y) ->
            case get model.board x y of
                NoPiece -> Nothing
                color ->
                    if (not (pieceEqual color firstColor)) then
                        Just []
                    else
                        case (sandwichHelper model (x,y) direction firstColor) of
                            Just pieces -> Just ((x,y)::pieces)
                            Nothing -> Nothing
            
sandwich : Model -> (Int, Int) -> Direction -> Maybe Sandwich
sandwich model initPoint direction =
    let board = model.board in
    let firstPiece = nextPiece initPoint direction in
    case firstPiece of
        Nothing ->
            Debug.log ("Empty" ++ (toString initPoint))
            Nothing
        Just (x, y) ->
            let firstColor = get board x y in
            case firstColor of
                NoPiece -> Nothing
                _ ->
                 if (pieceEqual firstColor model.current) then
                     Nothing
                 else
                     sandwichHelper model (x, y) direction firstColor
                                    

listOfSandwiches : Model -> (Int, Int) -> List Sandwich
listOfSandwiches model point =
    let directions = [(-1, -1), (-1, 0), (-1, 1), (0, -1),
                      (0, 1), (1, -1), (1, 0), (1, 1)] in
    List.filterMap (sandwich model point) directions
