#define PI 3.1415926538

const float uTime = 0.;

#include "flywheel:util/matrix.glsl"
#include "flywheel:util/quaternion.glsl"

float toRad(float degrees) {
    return fract(degrees / 360.) * PI * 2.;
}

float getFlapAngle(float flapness, float intensity, float scale) {
    float absFlap = abs(flapness);

    float angle = sin((1. - absFlap) * PI * intensity) * 30. * flapness * scale;

    float halfAngle = angle * 0.5;

    float which = step(0., flapness); // 0 if negative, 1 if positive
    float degrees = which * halfAngle + (1. - which) * angle; // branchless conditional multiply

    return degrees;
}

void flw_instanceVertex(in FlwInstance flap) {
    float flapAngle = getFlapAngle(flap.flapness, flap.intensity, flap.flapScale);

    vec4 orientation = quat(vec3(0., 1., 0.), -flap.horizontalAngle);
    vec4 flapRotation = quat(vec3(1., 0., 0.), flapAngle);

    vec3 rotated = rotateVertexByQuat(flw_vertexPos.xyz - flap.pivot, flapRotation) + flap.pivot + flap.segmentOffset;
    rotated = rotateVertexByQuat(rotated - .5, orientation) + flap.instancePos + .5;

    flw_vertexPos = vec4(rotated, 1.);
    flw_vertexNormal = rotateVertexByQuat(rotateVertexByQuat(flw_vertexNormal, flapRotation), orientation);
    flw_vertexLight = flap.light;
}