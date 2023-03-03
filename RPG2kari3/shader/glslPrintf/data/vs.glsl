// https://stackoverflow.com/questions/44793883/convert-floating-point-numbers-to-decimal-digits-in-glsl
// GLSL内部で値を表示する
// （PC-8001さんに教えていただきました）
//
attribute vec4 position;	// p5.jsのvec4(aPosition, 1.0)に対応する
uniform mat4 transform;
//---------------------------------------------------------------------------
// Vertex
//---------------------------------------------------------------------------
varying vec2 pos;   // screen position <-1,+1>
void main()
    {
    gl_Position= transform * position;
    pos=gl_Position.xy;
    }
//---------------------------------------------------------------------------
