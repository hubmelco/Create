#define PI 3.1415926538

#include "flywheel:util/matrix.glsl"

const float uTime = 0.;

mat4 kineticRotation(float offset, float speed, vec3 axis) {
    float degrees = offset + uTime * speed * 3./10.;
    float angle = fract(degrees / 360.) * PI * 2.;

    return rotate(axis, angle);
}

void flw_instanceVertex(in FlwInstance instance) {
    mat4 spin = kineticRotation(instance.offset, instance.speed, instance.axis);

    vec4 worldPos = spin * vec4(flw_vertexPos.xyz - .5, 1.);
    flw_vertexPos = vec4(worldPos.xyz + instance.pos + .5, 1.);

    flw_vertexNormal = modelToNormal(spin) * flw_vertexNormal;
    flw_vertexLight = instance.light;

    #if defined(DEBUG_RAINBOW)
    flw_vertexColor = instance.color;
    #endif
}