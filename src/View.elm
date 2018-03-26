module View exposing (view)

import Dict

import Model exposing (Model)
import Models.PieceSpace exposing (PieceSpace(..))

import Views.BoardView exposing (boardView)

import Update exposing (Msg(..))

import Html
import Html.Attributes exposing (width, height, style)

import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import Math.Matrix4 as Mat4 exposing (Mat4)
import WebGL exposing (Mesh, Shader)

type alias Vertex =
    { position : Vec3
    , color : Vec3
    }

mesh : Mesh Vertex
mesh =
    WebGL.triangles
        [ ( Vertex (vec3 0 0 0) (vec3 1 0 0)
          , Vertex (vec3 1 1 0) (vec3 0 1 0)
          , Vertex (vec3 1 -1 0) (vec3 0 0 1)
          )
        ]

view : Model -> Html.Html Msg
view model =
    let t = model.currentTime
        size = model.size
    in
    let
        perspective =
                Mat4.makePerspective 45 (toFloat size.width / toFloat size.height) 0.01 100
        camera =
            Mat4.makeLookAt
                model.camera.position
                (vec3 0 0 0)
                model.camera.up
    in
    WebGL.toHtml
        [ width model.size.width
        , height model.size.height
        , style [ ( "display", "block" ) ]
        ]
    [ WebGL.entity
          vertexShader
          fragmentShader
          mesh
          { perspective = perspective, camera = camera }
        ]
    
    ---------------------------------------------------------------------------
    -- let headerText =                                                      --
    --         if model.finished then                                        --
    --             case model.winner of                                      --
    --                 WhitePiece -> "White win!"                            --
    --                 BlackPiece -> "Black win!"                            --
    --                 NoPiece -> "Draw!"                                    --
    --         else                                                          --
    --             "Reversi"                                                 --
    --     moves = Dict.keys model.moves                                     --
    --     currentPlayer =                                                   --
    --         case model.state.current of                                   --
    --             WhitePiece -> "White"                                     --
    --             BlackPiece -> "Black"                                     --
    --             NoPiece -> Debug.crash "Impossible"                       --
    -- in                                                                    --
    -- let {board, pieces, whiteCount, blackCount, current} = model.state in --
    -- div []                                                                --
    --     [                                                                 --
    --       h1 [] [ text headerText ],                                      --
    --          p [] [ text (currentPlayer ++ " Move")],                     --
    --          boardView board moves,                                       --
    --          p [] [ text ("White: " ++ (toString whiteCount))],           --
    --          p [] [ text ("Black: " ++ (toString blackCount))]            --
    --     ]                                                                 --
    --     |> toUnstyled                                                     --
    ---------------------------------------------------------------------------

perspective : Mat4
perspective =
    Mat4.mul
    (Mat4.makePerspective 45 1 0.01 100)
    (Mat4.makeLookAt (vec3 4 4 0) (vec3 0 0 0) (vec3 0 1 0))


-- Shaders --
type alias Uniforms =
    { perspective : Mat4, camera: Mat4 }


vertexShader : Shader Vertex Uniforms { vcolor : Vec3 }
vertexShader =
    [glsl|
        attribute vec3 position;
        attribute vec3 color;
        uniform mat4 perspective;
        uniform mat4 camera;
        varying vec3 vcolor;

        void main () {
            gl_Position = perspective * camera * vec4(position, 1.0);
            vcolor = color;
        }

    |]


fragmentShader : Shader {} Uniforms { vcolor : Vec3 }
fragmentShader =
    [glsl|

        precision mediump float;
        varying vec3 vcolor;

        void main () {
            gl_FragColor = vec4(vcolor, 1.0);
        }

    |]
