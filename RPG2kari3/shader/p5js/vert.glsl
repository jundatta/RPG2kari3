// ※processing javaのpositionからp5.jsのaPositionへの
// 　マッピングがいまいちわかってにゃい
// ((transform * potition) + 1.0) / 2.0 ⇒ aPosition？？？

// geometry vertex position provided by p5js.
  attribute vec3 aPosition;
// vertex texture coordinate provided by p5js.
//attribute vec2 aTexCoord;
attribute vec4 texCoord;
attribute vec4 position;	// p5.jsのvec4(aPosition, 1.0)に対応する

// Built in p5.js uniforms
//uniform mat4 uModelViewMatrix;
//uniform mat4 uProjectionMatrix;
// [processing java]
//uniform mat4 modelviewMatrix;
//uniform mat4 projectionMatrix;

uniform mat4 transform;

// Varying values passed to our fragment shader
varying vec2 vTexCoord;

void main() {
	vTexCoord = texCoord.xy;

	vec4 positionVec4 = transform * position;
	// processing javaのpositionからp5.jsのaPositionへの
	// 対応付けがいまいちわかってにゃい
	// ((transform * potition) + 1.0) / 2.0 ⇒ aPosition？？？
//	positionVec4.xy=positionVec4.xy*2.-1.;
	positionVec4.xy=positionVec4.xy;
	gl_Position=positionVec4;
}
