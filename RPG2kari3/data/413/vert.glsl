// vec3 aPosition = position.xyz;

attribute vec4 position;
// attribute vec3 aPosition;

attribute vec3 normal;

// Built in p5.js uniforms
//uniform mat4 uModelViewMatrix;
//uniform mat4 uProjectionMatrix;
uniform float uFrameCount;
uniform float cameraZ;

// p5.jsのgl_Position
//  ⇒uProjectionMatrix * uModelViewMatrix * vec4(aPosition, 1.);
// processing javaのgl_Position
//  ⇒transform * position;

//uniform mat4 modelviewMatrix;
//uniform mat4 projectionMatrix;
uniform mat4 transform;

varying vec3 vNormal;
varying vec3 vPosition;

void main() {
	vec3 aPosition = position.xyz;
// 法線の向きをひっくり返してみたが。。。
vec3 aNormal = -normal;
	vec3 delta = 0.1 * aNormal * sin(aPosition * 30. + uFrameCount * 0.1);
	vPosition = aPosition + (aPosition * delta);
	vNormal = normalize(aNormal + delta);
	gl_Position = transform * vec4(vPosition, position.w);
}
