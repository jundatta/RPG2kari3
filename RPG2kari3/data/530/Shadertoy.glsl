// Ç±ÇøÇÁÇ™ÉIÉäÉWÉiÉãÇ≈Ç∑ÅB
// ÅyçÏé“Åzpanna_pudiÇ≥ÇÒ
// ÅyçÏïiñºÅzDesert Bloom
// https://www.shadertoy.com/view/7ld3DX

uniform vec3 iResolution;
uniform vec4 iMouse;
uniform float iTime;
uniform int iFrame;
uniform sampler2D iChannel0;
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;

// Desert Bloom by Pudi
// Email: k.a.komissar@gmail.com
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
//
// I felt like I wanted to do something cute and I didn't have
// much experience with 2D effects. So I came across some shaders
// from Fabrice that impressed me. For desert there're 2nd order
// Voronoi and applied noise on the edges between individual cell. 
//
// Thanks to Flopine, provod, YX, NuSan, slerpy, wwrighter, Shane,
// BigWings, FabriceNeyret, iq, and Blackle for sharing their knowledge
//
// Vorocracks marble/cracks by Fabrice
// https://www.shadertoy.com/view/Xd3fRN
//
// Hexagonal Voronoi Line Distance by Shane
// https://www.shadertoy.com/view/4dSfzD
// 
// Sakura Bliss by Philippe Desgranges
// https://www.shadertoy.com/view/ts33DX

const float PI = 3.14159265359;
const float TAU = 2. * PI;

// 2d rotation matrix
mat2 rot(float a) {
    float c = cos(a), s = sin(a);
    return mat2(c, -s, s, c);
}

struct HexGrid {
    vec2 uv;
    vec2 id;
    float dist;
};

const float SQRT3 = sqrt(3.);
float hex_dist(vec2 p) {
    p = abs(p);
    // Multiplying by 0.5 is the same as using normalize()
    float d = dot(p, 0.5 * vec2(1., SQRT3));
    return max(d, p.x);
}

HexGrid hex_coords(vec2 p) {
    const vec2 r = vec2(1., SQRT3);
    const vec2 h = r / 2.;
    vec2 a = mod(p, r) - h;
    vec2 b = mod(p - h, r) - h;

    vec2 gv = dot(a, a) < dot(b, b) ? a : b;

    vec2 id = p - gv;
    float dist = 0.5 - hex_dist(gv);
    return HexGrid(gv, id, dist);
}

vec2 pix_to_hex(vec2 p) {
    return floor(vec2(p.x + p.y / SQRT3, 2. * p.y / SQRT3));
}

float hash21(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}


vec2 hash22(vec2 p) {
    float n = sin(dot(p, vec2(41, 289)));
    p = fract(vec2(262144, 32768) * n);
    return sin(p * TAU) * 0.5 + 0.5;
}

// Random point on the hexagonal grid
vec2 hex_pt(vec2 p) {
    return vec2(p.x - p.y * 0.5, SQRT3 / 2. * p.y) +
           (hash22(p) - 0.5) * SQRT3 / 2. / 2.;
}

// IQ's polynomial-based smooth minimum function.
float smin(float a, float b, float k) {
    float h = clamp(0.5 + 0.5 * (b - a) / k, 0., 1.);
    return mix(b, a, h) - k * h * (1. - h);
}

// 2-pass voronoi traversal
float voronoi(vec2 p) {
    vec2 hex_p = pix_to_hex(p);

    // LUT for possible cells for traversal
    const vec2 offsets[7] = vec2[7](vec2(-1), vec2(0, -1), vec2(-1, 0), vec2(0),
                               vec2(1), vec2(1, 0), vec2(0, 1));

    vec2 min_cell_id = vec2(0.);

    vec2 mo;

    float min_dist = 8., smooth_edge_dist = 8., ln_dist, d;
    for (int i = 0; i < 7; ++i) {
        vec2 h = hex_pt(hex_p + offsets[i]) - p;
        d = dot(h,h);
        if (d < min_dist) {
            min_dist = d;
            mo = h;
            min_cell_id = offsets[i];
        }
    }

    for (int i = 0; i < 7; ++i) {
        vec2 h = hex_pt(hex_p + offsets[i] + min_cell_id) - p - mo;

        if (dot(h,h) > 0.00001) {
            ln_dist = dot(mo + h * 0.5, normalize(h));
            smooth_edge_dist = smin(smooth_edge_dist, ln_dist, 0.1);
        }
    }

    return max(smooth_edge_dist, 0.);
}

// type of Perlin noise
int MOD = 0;

float noise2(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = smoothstep(0., 1., f);

    float v =
        mix(mix(hash21(i + vec2(0, 0)), hash21(i + vec2(1, 0)), f.x),
            mix(hash21(i + vec2(0, 1)), hash21(i + vec2(1, 1)), f.x), f.y);
    return MOD == 0 ? v
           // Other two has more sharp edges.
           : MOD == 1 ? 2. * v - 1.
           : MOD == 2 ? abs(2. * v - 1.)
                      : 1. - abs(2. * v - 1.);
}

#define noise22(p) vec2(noise2(p), noise2(p + 17.7))
vec2 fbm22(vec2 p) {
    vec2 v = vec2(0);
    float a = .5;
    mat2 R = rot(.37);

    for (int i = 0; i < 6; i++, p *= 2., a /= 2.)
        p *= R,
        v += a * noise22(p);

    return v;
}

vec3 cracks(vec2 p) {
    const float RATIO = 0.9;
    const float STONE_SLOPE = .2;
    const float FRACTAL_DEPTH = 2.;
    const float FRACTAL_SCALE = 1.9;
    const float NOISE_SCALE = 1.73;
    const float NOISE_AMP = 0.6;
    const float BEVEL = 50.;
    const float GAP = .01;

    vec3 col = vec3(0.);
    for (float i = 0.; i < FRACTAL_DEPTH; ++i) {
        // Scale down
        vec2 crack_cell = p / RATIO;
        // Compute the magnitude of distortions on the path
        vec2 deviation = NOISE_AMP * fbm22(p / NOISE_SCALE) * NOISE_SCALE;
        // Find the distance to the neares crack
        float dist = voronoi(crack_cell + deviation);
        dist = clamp(BEVEL * (dist - GAP), 0., 1.);

        dist *= 1. - STONE_SLOPE * dist;

        // Exposure
        col += vec3(1. - dist) / exp2(i);

        // Shrink and rotate next layer
        p *= FRACTAL_SCALE * rot(0.37);
    }

    return 1. - col;
}

float back_out(float t) {
  float f = 1.0 - t;
  return 1.0 - (pow(f, 2.0) - f * 0.8 *sin(f * PI));
}

// Returns vec4(color, distance)
vec4 draw_lotus(vec2 uv, vec2 id, float blur, float len) {
    vec2 rnd = noise22(id);
    // Computes the angle of the flower with a random rotation speed
    float angle =
        atan(uv.y, uv.x) * sign(rnd.x + 1e-10) + iTime * mix(-0.8, 0.8, rnd.y);

    // Distance to the center of the flower
    float transit = clamp(len, 0., 1.);
    transit = back_out(transit);

    float dist = length(uv) - (transit - 1.);

    // Flower shaped distance function form the center
    float petal = 1.0 - abs(sin(angle * 2.5));
    float sqpetal = petal * petal;
    petal = mix(petal, sqpetal, 0.7);
    float sepal = 1.0 - abs(sin(angle * 2.5 + 1.5));
    petal += sepal * 0.2;

    float lotus_dist = dist + petal * 0.2;

    // Compute a blurry shadow mask.
    float shadow_blur = 0.3;
    float shadow = smoothstep(0.5 + shadow_blur, 0.5 - shadow_blur, lotus_dist) * 0.4;

    //Computes the sharper mask of the flower
    float lotus_mask = smoothstep(0.5 + blur, 0.5 - blur, lotus_dist);

    // The flower has a pink hue and is lighter in the center
    vec3 lotus_col = vec3(1.1, 0.8, 0.7);
    lotus_col += (0.5 - dist) * 0.2;

    // Computes the border mask of the flower
    vec3 outline_col = vec3(1.0, 0.3, 0.3);
    float outline_mask = smoothstep(0.5 - blur, 0.5, lotus_dist + 0.045);

    // Defines a tiling polar_space for the pistil pattern
    float polar_space = angle * 1.9098 + 0.5;
    float polar_pistil = fract(polar_space) - 0.5; // 12 / (2 * pi)

    // Round dot in the center
    outline_mask += smoothstep(0.035 + blur, 0.035 - blur, dist);

    float petal_blur = blur * 2.0;
    float pistil_mask = smoothstep(0.12 + blur, 0.12, dist) *
                        smoothstep(0.05, 0.05 + blur, dist);

    // Compute the pistil 'bars' in polar space
    float barw = 0.2 - dist * 0.7;
    float pistil_bar = smoothstep(-barw, -barw + petal_blur, polar_pistil) *
                      smoothstep(barw + petal_blur, barw, polar_pistil);

    // Compute the little dots in polar space
    float pistil_dot_len = length(vec2(polar_pistil * 0.10, dist) - vec2(0, 0.16)) * 9.0;
    float pistil_dot = smoothstep(0.1 + petal_blur, 0.1 - petal_blur, pistil_dot_len);

    //combines the middle an border color
    outline_mask += pistil_mask * pistil_bar + pistil_dot;
    lotus_col = mix(lotus_col, outline_col, clamp(outline_mask, 0., 1.) * 0.5);

    //sets the background to the shadow color
    lotus_col = mix(vec3(0.2, 0.2, 0.8) * shadow, lotus_col, lotus_mask);

    //incorporates the shadow mask into alpha channel
    lotus_mask = clamp(lotus_mask + shadow, 0., 1.);

    // returns the flower in pre-multiplied rgba
    return vec4(lotus_col, lotus_mask);
}

// vec4(color, distance)
vec4 draw_leaf(vec2 q, float factor, vec2 dir) {
    float scale = 12.;

    // Rotate uv in particular direction.
    {
        // Originally each leaf facing up.
        vec2 a = vec2(0., 1.);
        // Find orthogonal direction by computing vector product in 3D
        // cross(vec3(dir, 0), vec3(0, 0, 1))
        dir = vec2(-dir.y, dir.x);

        float angle =
            atan(dir.y * a.x - dir.x * a.y, dir.x * a.x - dir.y * a.y);
        q *= rot(angle);
    }

    // Distance from the center.
    float r = length(q * scale) / factor;
    // Mirrored polar angle.
    float t = abs(atan(q.x, q.y) / PI);

    // Scary polynomial to define the edge of leaf.
    float leaf_edge = (11.0 * t - 6.0 * t * t * t + 6.0 * t * t * t * t * t) /
                      (4.0 - 3.0 * t);
    float leaf_blur = 0.9;

    // Make darkened borders, but without of soft blur outside because
    // of the limitations? of texture bombing.
    float leaf =
        1. - smoothstep(leaf_edge - leaf_blur, leaf_edge + leaf_blur, r);

    // False shading for folded in half leaf.
    leaf *= smoothstep(-0.3, 0.5, abs(q.x)) * 0.5;

    vec3 leaf_color = 2.8 * vec3(0.11 * leaf, 0.69 * leaf, 0.14 * leaf);
    return vec4(leaf_color, leaf);
}


// Defines the border between the different parts.
float transit(vec2 uv) {
    return uv.x - 0.5 + 0.35 * sin(uv.y * 3.);
}

void mainImage( out vec4 fragColour, in vec2 fragCoord ) {
    // Screen coordinates in [-1, 1] range with aspect.
    vec2 uv = (fragCoord / iResolution.xy) * 2.0 - 1.0;
    uv *= vec2(iResolution.x / iResolution.y, 1.);
    uv *= 3.;
    
    // Distance between pixels for antialiasing.
    float pix = fwidth(uv.x);
    
    // Separate coordinates and shifted from 0 by y to remove artifacts.
    vec2 p = uv;
    p -= vec2(iTime * 0.5, -4.5);
    
    // Initialize base color.
    vec3 col = vec3(0.);
    
    // Hexagonal grid.
    HexGrid gv = hex_coords(p);
    vec2 id = gv.id;
    
    // Antialiazed mask to the border of hexagonal grid.
    float hex_grid_border = smoothstep(0.02 - pix, 0.02 + pix, gv.dist);
    vec2 gr = id + iTime * 0.5;
    float edge = transit(gr);
    
    // Broken clay
    {
        // Compute broken clay pattern on local hex coordinates
        // with offset based on index.
        vec3 crack = cracks(gv.uv * 2.5 + id * 4.);
        const vec3 desert = vec3(0.9726, 0.851, 0.300);
        col = vec3(hex_grid_border * crack * desert);

        // Add basic shading.
        float shade = 1. - dot(gv.uv, normalize(vec2(1., -1.)));
        col *= shade * crack * 1.5;
    }

    
    // Flooding water
    {
        // Combine two masks.
        edge = smoothstep(-0.1, 0.7, edge);

        vec3 water = vec3(0.61, 0.705, 0.752);
        col = mix(col, water, edge);
        // To keep hex edge from disappearing
        // float border = edge * hex_grid_border;
        // col = mix(col, water, border);
    }
    
    
    vec2 q = p * 3.; // scaled screen coordinates.
    vec2 cell = floor(q); // divide space on cells.
    vec2 offset = fract(q); // local cell coordinates.

    // Keep track of layering separate leaf based on priority.
    float priority = 999.;

    // The amount of neighbours to visit
    int nbors = 1;
    // Texture Bombing 101
    // https://developer.download.nvidia.com/books/HTML/gpugems/gpugems_ch20.html
    // The basic idea behind texture bombing is to divide UV space into a regular
    // grid of cells. We then place an image within each cell at a random location,
    // using a noise or pseudo-random number function. The final result is the composite
    // of these images over the background.
    for (int u = -nbors; u <= nbors; ++u) {
        for (int v = -nbors; v <= nbors; ++v) {
            // Compute a new cell coordinates by shifting origin on integral offset.
            vec2 cell_n = cell - vec2(u, v);
            vec2 cell_offset = offset + vec2(u, v);

            // Add more leaves in each cell for crowded overlapping.
            for (float  n = 0.5; n < 3.; ++n) {
                // Choose random place inside of cell
                vec2 random_uv = hash22(cell_n + n);
                vec2 off = cell_offset - random_uv;

                float leaf_size; vec2 dir;
                {
                    // Recalculate hex coordinates for each cell
                    // in very cumbersome way and will visit this
                    // place later to:
                    // 1. Choose leaf direction orthogonal to hex coords.
                    // 2. Vary length depending on the distance to the edge.
                    vec2 lu = cell_n + vec2(iTime * 1.5, 0.);
                    lu /= 7.;
                    HexGrid hb = hex_coords(lu - vec2(iTime * 0.5, 0.));

                    float curvy_wall = lu.x + 0.5 + 0.2 * sin(lu.y * 3. + iTime * 0.3);
                    float edge_mask = smoothstep(0.1 - 0.3, 0.1 , hb.id.y);

                    leaf_size = clamp(curvy_wall * edge_mask, 0., 1.);

                    vec2 k = hex_coords(cell_n).id - cell_n;
                    dir = k + (hash22(random_uv + n) * 2. - 1.) * 0.25;
                }

                // We need to check adjacent cells for overlapping leaves.
                // This process is computationally heavy and might be logical to
                // split this function on two. The first for checking the hit `leaf.w`
                // and coloring.
                vec4 leaf = draw_leaf(off, leaf_size, dir);
                if (leaf.w > 0. && random_uv.x < priority) {
                    col = leaf.rgb;
                    priority = random_uv.x;
                }
            }
        }
    }

    
    // Lotus flowers
    {
        float len = transit(gr + vec2(0.6, 0.));

        float blur = 0.1;
        vec4 lotus = draw_lotus(gv.uv * 1.3, gv.id, blur, len);
        col = mix(col, lotus.rgb, lotus.w);
    }

    // Vignette
    vec2 d = abs(fragCoord / iResolution.xy - vec2(0.5)) * 1.15;
    d = pow(d, vec2(2.0));
    col *= pow(clamp(1.0 - dot(d, d), 0., 1.0), 3.5);
    
    // Gamma Correction
    col = pow(col, vec3(0.4545));
    
    // Output to screen
    fragColour = vec4(col,1.0);
}

void main() {
	vec4 fragColor;
	vec2 fragCoord = gl_FragCoord.xy;
	mainImage(fragColor, fragCoord);
	fragColor.a = 1.0;
	gl_FragColor = fragColor;
}
