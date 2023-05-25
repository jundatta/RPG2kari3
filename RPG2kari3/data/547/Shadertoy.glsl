// Ç±ÇøÇÁÇ™ÉIÉäÉWÉiÉãÇ≈Ç∑ÅB
// ÅyçÏé“Åzmatheusfs2Ç≥ÇÒ
// ÅyçÏïiñºÅzcup of wine 
// https://www.shadertoy.com/view/mltSz8

uniform vec3 iResolution;
uniform vec4 iMouse;
uniform float iTime;
uniform int iFrame;
uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;

struct Ray{
    vec3 origin, direction;
};

struct Sphere {
    vec3 center;
    float radius;
};

Sphere world[] = Sphere[2](
    Sphere(vec3(0.0, 0.0, -1.0), 0.5),
    Sphere(vec3(0.0, -100.5, -1.0), 100.0)
);

struct hit_record {
    float t;
    vec3 p, normal;
};

float hit_sphere(vec3 center, float radius, Ray r){
    vec3 oc = r.origin - center;
    float a = dot(r.direction,r.direction);
    float b = 2.0 * dot(oc, r.direction);
    float c = dot(oc,oc) - radius*radius;
    float discriminat = b*b - 4.0*a*c;
    if (discriminat < 0.0)
    return(-1.0);
    else
    return( (-b - sqrt(discriminat) ) / (2.0*a));
}

vec3 point_at_parameter(Ray r, float t) {
    return(r.origin + t*r.direction);
}

vec3 color(Ray r){
    float t = hit_sphere(vec3(0.,0.,-1.), 0.5, r);
    if(t > 0.0) {
    vec3 N = normalize(point_at_parameter(r,t) - vec3(0.0, 0.0, -1.0));
    return 0.5*(N+vec3(1.0));
    }
    vec3 unit_direction = normalize(r.direction);
    t = 0.5 * (unit_direction.y + 1.0);
    return mix(vec3(1.0), vec3(0.5,0.7,1.0), t);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec2 uv = fragCoord/iResolution.xy;
    float aspect = iResolution.x/iResolution.y;
    vec3 lower_left_corner = vec3(-1.0*aspect,-1.0, -1.0);
    vec3 horizontal = vec3(2.0*aspect, 0.0, 0.0);
    vec3 vertical = vec3(0.0,2.0, 0.0);
    Ray r = Ray(vec3(0,0,0), lower_left_corner+uv.x*horizontal+uv.y*vertical);
    fragColor = vec4(color(r), 1.0);
}

void main() {
	vec4 fragColor;
	vec2 fragCoord = gl_FragCoord.xy;
	mainImage(fragColor, fragCoord);
	fragColor.a = 1.0;
	gl_FragColor = fragColor;
}
