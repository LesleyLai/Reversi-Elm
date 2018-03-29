module Render.Board exposing (boardEntityGL)

import Math.Matrix4 as Mat4 exposing (Mat4)
import Math.Vector2 as Vec2 exposing (Vec2, vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)

import WebGL exposing (Mesh, Shader, Entity)

import WebGL.Texture as Texture exposing (Error, Texture)

perspective : Float -> Mat4
perspective angle =
    List.foldr Mat4.mul
        Mat4.identity
        [ Mat4.makePerspective 45 1 0.01 100
        , Mat4.makeLookAt (vec3 0 3 8) (vec3 0 0 0) (vec3 0 1 0)
        , Mat4.makeRotate (3 * angle) (vec3 0 1 0)
        ]

boardEntityGL: Texture -> List Entity
boardEntityGL texture = [WebGL.entity
                        boardVertex
                        boardFragment
                        boardMesh
                        {perspective = (perspective 0),
                         texture = texture}]

type alias Uniforms =
    { perspective : Mat4
    , texture : Texture
    }

type alias Vertex =
    { position : Vec3
    , coord : Vec2
    }

boardMesh : Mesh Vertex
boardMesh =
    [ ( 0, 0 ), ( 90, 0 ), ( 180, 0 ), ( 270, 0 ), ( 0, 90 ), ( 0, 270 ) ]
        |> List.concatMap rotatedFace
        |> WebGL.triangles


rotatedFace : ( Float, Float ) -> List ( Vertex, Vertex, Vertex )
rotatedFace ( angleXZ, angleYZ ) =
    let
        transformMat =
            List.foldr Mat4.mul
                Mat4.identity
                [ Mat4.makeTranslate (vec3 0 1 0)
                , Mat4.makeRotate (degrees angleXZ) Vec3.j
                , Mat4.makeRotate (degrees angleYZ) Vec3.i
                , Mat4.makeTranslate (vec3 0 0 1)
                ]

        transform vertex =
            { vertex
                | position =
                    Mat4.transform
                        transformMat
                        vertex.position
            }

        transformTriangle ( a, b, c ) =
            ( transform a, transform b, transform c )
    in
        List.map transformTriangle square

square : List ( Vertex, Vertex, Vertex )
square =
    let
        topLeft =
            { position = vec3 -1 1 0, coord = vec2 0 1 }

        topRight =
            { position = vec3 1 1 0, coord = vec2 1 1 }

        bottomLeft =
            { position = vec3 -1 -1 0, coord = vec2 0 0 }

        bottomRight =
            { position = vec3 1 -1 0, coord = vec2 1 0 }
    in
        [ ( topLeft, topRight, bottomLeft )
        , ( bottomLeft, topRight, bottomRight )
        ]

boardVertex : Shader Vertex Uniforms { vcoord : Vec2 }
boardVertex =
    [glsl|

        attribute vec3 position;
        attribute vec2 coord;
        uniform mat4 perspective;
        varying vec2 vcoord;

        void main () {
          gl_Position = perspective * vec4(position, 1.0);
          vcoord = coord;
        }

    |]


boardFragment : Shader {} { u | texture : Texture } { vcoord : Vec2 }
boardFragment =
    [glsl|

        precision mediump float;
        uniform sampler2D texture;
        varying vec2 vcoord;

        void main () {
          gl_FragColor = texture2D(texture, vcoord);
        }

    |]
