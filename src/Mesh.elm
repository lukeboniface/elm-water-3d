module Mesh exposing (..)

import Math.Vector2 exposing (..)
import Math.Vector3 exposing (..)
import Math.Matrix4 exposing (..)
import WebGL exposing (..)
import List exposing (..)


type alias Vertex =
    { position : Vec3, coord : Vec2 }


toUV x y =
    let
        size =
            2
    in
        vec2 ((x / size)) ((y / size))


quad : Float -> Float -> List ( Vertex, Vertex, Vertex )
quad x y =
    let
        br x y =
            let
                x1 =
                    (x + 0.5)

                y1 =
                    (y + -0.5)
            in
                Vertex (vec3 x1 0 y1) (toUV x1 y1)

        --00
        tl x y =
            let
                x1 =
                    (x + -0.5)

                y1 =
                    (y + 0.5)
            in
                Vertex (vec3 x1 0 y1) (toUV x1 y1)

        --11
        tr x y =
            let
                x1 =
                    (x + 0.5)

                y1 =
                    (y + 0.5)
            in
                Vertex (vec3 x1 0 y1) (toUV x1 y1)

        --01
        bl x y =
            let
                x1 =
                    (x + -0.5)

                y1 =
                    (y + -0.5)
            in
                Vertex (vec3 x1 0 y1) (toUV x1 y1)

        --10
    in
        [ ( br x y
          , tl x y
          , tr x y
          )
        , ( br x y
          , bl x y
          , tl x y
          )
        ]


largeQuad x y =
    (concat
        [ quad (x * 2 + 0) (y * 2 + 0)
        , quad (x * 2 + 0) (y * 2 + 1)
        , quad (x * 2 + 1) (y * 2 + 0)
        , quad (x * 2 + 1) (y * 2 + 1)
        ]
    )


doAnim : Float -> Float -> List ( Vertex, Vertex, Vertex ) -> List ( Vertex, Vertex, Vertex )
doAnim t s vertBuffer =
    map (animTriangle t s) vertBuffer


animTriangle : Float -> Float -> ( Vertex, Vertex, Vertex ) -> ( Vertex, Vertex, Vertex )
animTriangle t s triangle =
    let
        ( p1, p2, p3 ) =
            triangle
    in
        ( (animVert t s p1)
        , (animVert t s p2)
        , (animVert t s p3)
        )


animVert : Float -> Float -> Vertex -> Vertex
animVert t s vert =
    let
        x =
            Math.Vector3.getX vert.position

        z =
            Math.Vector3.getZ vert.position

        d =
            (((sin z) * sin (t + 5.33) + (sin (8.44 + t / 4)) + (sin x) * sin (3.66 + t)) / 3) * s
    in
        { vert | position = Math.Vector3.setY d vert.position }


mesh : Float -> Float -> WebGL.Drawable Vertex
mesh t s =
    WebGL.Triangle
        ((concat
            [ largeQuad -0.5 0.5
            , largeQuad -0.5 -0.5
            , largeQuad 0.5 -0.5
            , largeQuad 0.5 0.5
            , largeQuad -0.5 2.5
            , largeQuad -0.5 1.5
            , largeQuad 0.5 1.5
            , largeQuad 0.5 2.5
            , largeQuad -2.5 0.5
            , largeQuad -2.5 -0.5
            , largeQuad -1.5 -0.5
            , largeQuad -1.5 0.5
            , largeQuad -2.5 2.5
            , largeQuad -2.5 1.5
            , largeQuad -1.5 1.5
            , largeQuad -1.5 2.5
            ]
         )
            |> doAnim t s
        )
