module Logics.GamePlay exposing (neighbors, inBoard,
                                  allPotentialMoves, listOfSandwiches,
                                  allValidMoves, nextState,
                                  gameFinished, winner)

import Models.Grid exposing (set)
import Models.Board exposing (boardSpec, get, pieceEqual)
import Models.PieceSpace exposing (PieceSpace(..))
import Models.GameState exposing (..)

import Dict exposing (Dict)

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

{- Get all potential moves without consider it is valid or not -}
allPotentialMoves : GameState -> List (Int, Int)
allPotentialMoves state =
    let
        board = state.board
        pieces = state.pieces
        piecesSet = Set.fromList pieces
    in
        List.concatMap neighbors pieces
            |> List.filter (\piece-> not <| Set.member piece piecesSet)
            |> Set.fromList
            |> Set.toList


type alias Direction = (Int, Int)
               
nextPiece : Point -> Direction -> Maybe Point
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

            
sandwichHelper : GameState -> Point -> Direction -> PieceSpace -> Maybe Sandwich
sandwichHelper state point direction firstColor =
    let piece = nextPiece point direction in
    case piece of
        Nothing -> Nothing
        Just (x, y) ->
            case get state.board x y of
                NoPiece -> Nothing
                color ->
                    if (not (pieceEqual color firstColor)) then
                        Just [point]
                    else
                        case (sandwichHelper state (x,y) direction firstColor) of
                            Just pieces -> Just (point::pieces)
                            Nothing -> Nothing
            
sandwich : GameState -> Point -> Direction -> Maybe Sandwich
sandwich state initPoint direction =
    let board = state.board in
    let firstPiece = nextPiece initPoint direction in
    case firstPiece of
        Nothing ->
            Nothing
        Just (x, y) ->
            let firstColor = get board x y in
            case firstColor of
                NoPiece -> Nothing
                _ ->
                 if (pieceEqual firstColor state.current) then
                     Nothing
                 else
                     sandwichHelper state (x, y) direction firstColor
                                    

listOfSandwiches : GameState -> Point -> List Sandwich
listOfSandwiches state point =
    let directions = [(-1, -1), (-1, 0), (-1, 1), (0, -1),
                      (0, 1), (1, -1), (1, 0), (1, 1)] in
    List.filterMap (sandwich state point) directions
        
allValidMoves : GameState -> Dict Point (List Sandwich)
allValidMoves state =
    let allMoves = allPotentialMoves state in
    let verifyMove point =
        case listOfSandwiches state point of
            [] -> Nothing
            ss -> Just (point, ss)
    in 
    List.filterMap verifyMove allMoves |> Dict.fromList

nextState: GameState -> Dict Point (List Sandwich) -> Point -> (Maybe GameState)
nextState state possibleMoves move =
    let (x, y) = move in
    case Dict.get move possibleMoves of
                    Nothing -> Nothing
                    Just toFlip ->
                        let {board, pieces, whiteCount, blackCount, current} = state in
                        let nextPiece piece whiteCount blackCount =
                                case piece of
                                    BlackPiece -> (WhitePiece, whiteCount, blackCount+1)
                                    WhitePiece -> (BlackPiece, whiteCount+1, blackCount)
                                    NoPiece -> Debug.crash "You are violating the law of the universe"
                        in
                        let flipedState
                                = flip state (List.concat toFlip)
                            (next, newWhite, newBlack)
                                = (nextPiece current
                                       flipedState.whiteCount
                                       flipedState.blackCount )
                            newPieces = (x,y)::pieces
                        in
                        Just (GameState (set flipedState.board x y current)
                             newPieces newWhite newBlack next)

{- Flip the pieces in the list -}
flip : GameState -> List (Int, Int) -> GameState
flip state toFlip =
    Debug.log (toString toFlip)
    List.foldl (\(x,y) stateBefore ->
                let {board, pieces, whiteCount, blackCount, current} = stateBefore in
                let (whiteChange, blackChange) =
                    case current of
                        BlackPiece -> (-1, 1)
                        WhitePiece -> (1, -1)
                        NoPiece -> Debug.crash "Current piece must be black or white"
                in
                let
                    newWhiteCount = whiteCount + whiteChange
                    newBlackCount = blackCount + blackChange
                in
                (GameState (set board x y current)
                     pieces
                     newWhiteCount
                     newBlackCount
                     current)
               ) state toFlip

gameFinished : GameState -> Bool
gameFinished state =
    state.whiteCount + state.blackCount == 64

winner : GameState -> PieceSpace
winner state =
    if (state.whiteCount > state.blackCount) then
        WhitePiece
    else if (state.whiteCount < state.blackCount) then
        BlackPiece
    else
        NoPiece
