module Model exposing (..)

import WebGL exposing (..)
import Time exposing (..)
import AnimationFrame


{-| Types
-}
type Msg
    = Update String
    | UpdateX1 String
    | UpdateX2 String
    | UpdateY1 String
    | UpdateY2 String
    | UpdateT1 String
    | UpdateT2 String
    | Animate Time
    | TextureLoad WebGL.Texture
    | TextureError WebGL.Error


type alias Model =
    { maybeTexture : Maybe WebGL.Texture
    , elapsed : Time
    , waveHeight : Int
    , t1 : Float
    , x1 : Float
    , y1 : Float
    , t2 : Float
    , x2 : Float
    , y2 : Float
    }
