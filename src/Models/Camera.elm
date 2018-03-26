module Models.Camera exposing (Camera, initCamera)

import Math.Vector3 as Vec3 exposing (Vec3, vec3)

-- This "Crystall Ball" camera always focus on the center of the scene
type alias Camera = {
        position : Vec3,
        up: Vec3
    }

initCamera : Camera
initCamera = {
    position = (vec3 0 0 4),
    up = Vec3.j
 }
