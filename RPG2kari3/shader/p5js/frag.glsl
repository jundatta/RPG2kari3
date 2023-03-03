  // set the default precision for float variables
  precision mediump float;

// uniform float uTime;
uniform vec2 uResolution;

varying vec2 vTexCoord;

uniform sampler2D tex;
uniform sampler2D coolingMap;

float deltay=1.;

float rem(float x, float y) {
	x=abs(x);
	y=abs(y);
	for (int i=0; i>-1; i+=0) {
	  if (x<y) {
	    break;
	  }
	  x-=y;
	}
	return x;
}
float sq(float x) {
	return pow(x, 2.);
}
void main() {
	float width = uResolution.x;
	float height = uResolution.y;
	
	float x=vTexCoord.x*width;
	float y=height-vTexCoord.y*height;
	float val=(
	  texture2D(tex, vec2(x/width, (y-1.)/height)).r+
	  texture2D(tex, vec2((x+1.)/width, y/height)).r+
	  texture2D(tex, vec2(x/width, (y+1.)/height)).r+
	  texture2D(tex, vec2((x-1.)/width, y/height)).r
	  )/4.;
	val-=texture2D(coolingMap, vec2(x/width, rem(y/height, 1.))).r/5.;
	float arg=sqrt(sq(x-width/2.)+sq(y-height/2.));
	if (arg>height/4.&&arg<height/4.+5.) {
	  val=1.;
	}
	gl_FragColor=vec4(vec3(val, (val-0.3), (val-0.6)), 1.);
}
