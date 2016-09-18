// First Raymarch - Cubes
// Chris Camargo, June 2016

// Distance function for box.
float box(vec3 p, vec3 b)
{
    vec3 d = abs(p) - b;

    return min(max(d.x,max(d.y, d.z)), 0.0) + length(max(d, 0.0));
}

// Repeater distance function for box.
float rep(vec3 p, vec3 c)
{
    vec3 q = mod(p, c) - 0.5 * c;

    return box(q, vec3(0.5, 0.5, 0.5));
}

// Raymarch, computing the distance at each step and incrementing the
// ray parameter t.
float trace(vec3 o, vec3 r)
{
    float t = 0.0;
    for (int i = 0; i < 32; ++i) {
        vec3 p = o + r * t;

        // Distance function.
        float d = rep(p, vec3(2.0, 3.0, 2.0));

        t += d;
    }
    return t;
}

// Image computation.
void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    float x = fragCoord.x;            // Current pixel x-coordinate. Range: [0.5, iResolution.x - 0.5].
    float y = fragCoord.y;            // Current pixel y-coordinate. Range: [0.5, iResolution.y - 0.5].
    float minX = 0.5;                 // Min x-coordinate value.
    float minY = 0.5;                 // Min y-coordinate value.
    float maxX = iResolution.x - 0.5; // Viewport width.
    float maxY = iResolution.y - 0.5; // Viewport height.

    // Feature Scaling. Bring coords to value between [0, 1].
    // https://en.wikipedia.org/wiki/Feature_scaling#Rescaling
    vec2 uv = vec2((x - minX) / (maxX - minX), (y - minY) / (maxY - minY));

    // Coords between [0, 1] so 'eye' is centered at (0.5, 0.5).
    // We want 'eye' centered at (0, 0). Thus subtract 0.5 from
    // each coord.
    uv -= 0.5;

    // Move coords away from 'eye' by a factor of 2.0.
    // You can play with this number.
    uv *= 2.0;
    
    // Scale x based on aspect ratio.
    uv.x *= iResolution.x / iResolution.y;
    
    // Ray origin.
    vec3 o = vec3(0.0, iGlobalTime, iGlobalTime);

    // Ray direction.
    vec3 r = normalize(vec3(uv.x, uv.y, 1.0));

    // Rotate direction r around y-axis by a fraction of time.
    float theta = iGlobalTime * 0.25;
    r.xz *= mat2(cos(theta), -sin(theta), sin(theta), cos(theta));
    
    // Trace ray from origin o in direction r.
    float t = trace(o, r);
    
    // Set the color via 1 / (1. + t): Light attenuation.
    vec3 color = vec3(0.2, 1.0 / (1. + t), 1.0 / (1. + t));
    
    // Set pixel color.
    fragColor =  vec4(color, 1.0);
}
