attribute vec4 position;	// p5.jsのvec4(aPosition, 1.0)に対応する？

// Built in p5.js uniforms
//attribute vec3 aNormal;
// [processing java]
attribute vec3 normal;


// Built in p5.js uniforms
//uniform mat4 uModelViewMatrix;
//uniform mat4 uProjectionMatrix;
//uniform mat3 uNormalMatrix;
// [processing java]
uniform mat4 modelviewMatrix;
//uniform mat4 projectionMatrix;
uniform mat3 normalMatrix;

uniform mat4 transform;

varying vec3 pos;
varying vec3 normalInterp;

void main() {
	vec4 positionVec4 = transform * position;
	gl_Position=positionVec4;

    vec4 pos4 = modelviewMatrix * position;
    normalInterp = normalMatrix * normal;
    pos = vec3(pos4) / pos4.w;
}
