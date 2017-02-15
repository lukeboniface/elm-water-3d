module View3D exposing (..)

import Math.Vector2 exposing (..)
import Math.Vector3 exposing (..)
import Math.Matrix4 exposing (..)
import WebGL exposing (..)
import Time exposing (..)
import AnimationFrame
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Html exposing (..)
import Model exposing (..)
import Debug exposing (..)
import Mesh exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ div
            []
            [ text "x1"
            , input
                [ type_ "range"
                , Html.Attributes.min "0"
                , Html.Attributes.max "100"
                , value <| toString model.x1
                , onInput UpdateX1
                ]
                []
            , text "x2"
            , input
                [ type_ "range"
                , Html.Attributes.min "0"
                , Html.Attributes.max "100"
                , value <| toString model.x2
                , onInput UpdateX2
                ]
                []
            , text "y1"
            , input
                [ type_ "range"
                , Html.Attributes.min "0"
                , Html.Attributes.max "100"
                , value <| toString model.y1
                , onInput UpdateY1
                ]
                []
            , text "y2"
            , input
                [ type_ "range"
                , Html.Attributes.min "0"
                , Html.Attributes.max "100"
                , value <| toString model.y2
                , onInput UpdateY2
                ]
                []
            , text "t1"
            , input
                [ type_ "range"
                , Html.Attributes.min "0"
                , Html.Attributes.max "100"
                , value <| toString model.t1
                , onInput UpdateT1
                ]
                []
            , text "t1"
            , input
                [ type_ "range"
                , Html.Attributes.min "0"
                , Html.Attributes.max "100"
                , value <| toString model.t2
                , onInput UpdateT2
                ]
                []
            ]
        , WebGL.toHtml
            [ width 1024
            , height 768
            , Html.Attributes.style [ ( "background-color", "grey" ) ]
            ]
            (case model.maybeTexture of
                Nothing ->
                    []

                Just texture ->
                    [ render vertexShader
                        fragmentShader
                        (mesh model.elapsed (toFloat (model.waveHeight) / 20.0))
                        { perspective = perspective 1
                        , texture = texture
                        , time = model.elapsed
                        , t1 = model.t1 / 10.0
                        , x1 = model.x1 / 10.0
                        , y1 = model.y1 / 10.0
                        , t2 = model.t2 / 10.0
                        , x2 = model.x2 / 10.0
                        , y2 = model.y2 / 10.0
                        }
                    ]
            )
        ]


perspective : Float -> Mat4
perspective t =
    let
        eye =
            (vec3 -1.5 10 -8)

        centre =
            (vec3 -1.5 -1 1)

        up =
            (vec3 0 1 0)
    in
        mul (makePerspective 45 1 0.01 100)
            (makeLookAt eye centre up)



-- Shaders


vertexShader : Shader { a | position : Vec3, coord : Vec2 } { u | perspective : Mat4 } { vcoord : Vec2 }
vertexShader =
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


fragmentShader :
    Shader {}
        { u
            | texture : WebGL.Texture
            , time : Float
            , t1 : Float
            , x1 : Float
            , y1 : Float
            , t2 : Float
            , x2 : Float
            , y2 : Float
        }
        { vcoord : Vec2 }
fragmentShader =
    [glsl|
precision mediump float;
varying vec2 vcoord;
uniform sampler2D texture;
uniform float time;

uniform float t1;
uniform float x1;
uniform float y1;
uniform float t2;
uniform float x2;
uniform float y2;

float compoundSinX(float x, float y, float t)
{
  return (sin(t + t1 * x + x1 * y + y1) + sin(-t + t2 * x + x2 * y + y2))/2.0;
}

float compoundSinY(float x, float y, float t)
{
  return (sin(t + t1*1.2 * x + x1*0.8 * y + y1) + sin(-t + t2*0.4 * x + x2 * 1.3 * y + y2 *1.5))/2.0;
}

void main () {

    vec4 temp = texture2D(texture, vec2(
      compoundSinX(vcoord.x, vcoord.y, time),
      compoundSinY(vcoord.y, vcoord.y, time)));

    vec4 colour = vec4(temp.r, temp.g, 1.0, 1.0);
    gl_FragColor = colour;
}
|]
