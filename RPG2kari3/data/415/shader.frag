// #version 150

uniform float time;
uniform vec2 resolution;
uniform sampler2D tex1;
uniform sampler2D tex2;

void main() {
#if 0
  vec4 t1 = texture(tex1, vec2(gl_FragCoord.x, resolution.y - gl_FragCoord.y));
  vec4 t2 = texture(tex2, vec2(gl_FragCoord.x, resolution.y - gl_FragCoord.y));
#else
	float u = gl_FragCoord.x / resolution.x;
	float v = gl_FragCoord.y / resolution.y;
	vec2 uv = vec2(u, v);
	vec4 t1 = texture(tex1, uv);
	vec4 t2 = texture(tex2, uv);
#endif
  vec4 c = vec4(1.0,0.0,0.0,1.0);
  if(t2 == vec4(0.0)){
    c = t1;
  }else{
    if(t1 == vec4(vec3(1.0), 1.0)){
		c = vec4(vec3(0.0), 1);
	}else{
		if(t1 == vec4(0.0)){
		   c = vec4(vec3(0), 1);
		}else{
			c = vec4(vec3(0.937), 1.0);
		}
	}
  }

//c = t2;
  gl_FragColor = c;
}
