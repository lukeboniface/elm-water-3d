module Main exposing (..)

import WebGL exposing (..)
import Time exposing (..)
import Task exposing (Task)
import AnimationFrame
import Html.Attributes exposing (width, height, style)
import Html exposing (Html)
import View3D exposing (..)
import Model exposing (..)


init : ( Model, Cmd Msg )
init =
    { maybeTexture = Nothing
    , elapsed = 0
    , waveHeight = 15
    , t1 = 21
    , x1 = 0
    , y1 = 5
    , t2 = 30
    , x2 = 25
    , y2 = 18
    }
        ! [ getTexture ]


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


getTexture : Cmd Msg
getTexture =
    WebGL.loadTexture "/texture/tile.png"
        |> Task.attempt
            (\result ->
                case result of
                    Err err ->
                        TextureError err

                    Ok val ->
                        TextureLoad val
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ AnimationFrame.diffs Animate ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Animate elapsed ->
            ( { model | elapsed = model.elapsed + elapsed / 1000 }, Cmd.none )

        TextureLoad texture ->
            { model | maybeTexture = Just texture } ! []

        TextureError _ ->
            Debug.crash "Error loading texture"

        Update v ->
            { model | waveHeight = String.toInt (Debug.log "" v) |> Result.withDefault 0 } ! []

        UpdateX1 v ->
            { model | x1 = String.toFloat (Debug.log "" v) |> Result.withDefault 0 } ! []

        UpdateX2 v ->
            { model | x2 = String.toFloat (Debug.log "" v) |> Result.withDefault 0 } ! []

        UpdateY1 v ->
            { model | y1 = String.toFloat (Debug.log "" v) |> Result.withDefault 0 } ! []

        UpdateY2 v ->
            { model | y2 = String.toFloat (Debug.log "" v) |> Result.withDefault 0 } ! []

        UpdateT1 v ->
            { model | t1 = String.toFloat (Debug.log "" v) |> Result.withDefault 0 } ! []

        UpdateT2 v ->
            { model | t2 = String.toFloat (Debug.log "" v) |> Result.withDefault 0 } ! []


animate : Time -> Model -> Model
animate elapsed model =
    model
