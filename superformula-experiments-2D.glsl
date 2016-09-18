// Superformula Experiments (2D)
// Chris Camargo, September 2016

// Shapes.
// Try out shapes 1 - 8.
#define SHAPE 7

// Superforluma.
float super(float phi, float a, float b, float n1, float n2, float n3, float y, float z)
{
    float abs1 = pow(abs( cos( (y * phi) / 4.0) / a ), n2);
    float abs2 = pow(abs( sin( (z * phi) / 4.0) / b ), n3);
    float pow1 = -(1.0/n1);

    return pow(abs1  +  abs2, pow1);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Map coords to [0, 1].
	vec2 p = fragCoord.xy / iResolution.xy;
    
    // Map coords to [-1, 1].
    vec2 q = -1.0 + 2.0*p;
    
    // Scale x based on aspect ratio.
    q.x *= iResolution.x / iResolution.y;
    
    // Zoom out (i.e. make all coords larger).
    q *= 2.0;
    
    // Final shape color.
    vec3 col = vec3(p, 0.5+0.5*sin(iGlobalTime));
    
    // Superformula params (set SHAPE number to see different shapes).

    float phi = atan(q.y, q.x);
    
#if SHAPE == 1
    float a = 1.0, b = 1.0, n1 = 3.0, n2 = 1.0, n3 = 1.0, y = 4.0, z = 6.0;
#endif
    
#if SHAPE == 2
    float a = 1.0, b = 1.0, n1 = 2.0, n2 = 1.0, n3 = 1.0, y = 6.0, z = 3.0;
#endif

#if SHAPE == 3
    float a = 1.0, b = 1.0, n1 = 1.5, n2 = 1.0, n3 = 1.0, y = 2.0, z = 10.0;
#endif

#if SHAPE == 4
    float a = 1.0, b = 1.0, n1 = -1.5, n2 = 1.0, n3 = 1.0, y = 2.0, z = 10.0;
#endif

#if SHAPE == 5
    q *= 10.0; // Zoom out more.
    float a = 1.0, b = 1.0, n1 = -0.2, n2 = 1.0, n3 = 1.0, y = 2.0, z = 44.0;
#endif

#if SHAPE == 6
    q *= 15.0; // Zoom out more.
    float a = 1.0, b = 1.0, n1 = -0.2, n2 = 1.0, n3 = 1.0, y = 8.0, z = 40.0;
#endif

#if SHAPE == 7
    float a = 1.0, b = 1.0, n1 = 3.0, n2 = 1.0, n3 = 1.0, y = 88.0, z = 64.0;
#endif
    
#if SHAPE == 8
    float a = 1.0, b = 1.0, n1 = -20.0, n2 = 1.0, n3 = 1.0, y = 88.0, z = 64.0;
#endif

    // Calculate the radius using the superformula.
    float r = super(phi, a, b, n1, n2, n3, y, z);
    
    // "Graph" the superformula using smoothstep.
    // 		Any pixels <= r away from q are colored
    //		Any pixels > r + 0.03 away from q are black.
    col *= smoothstep(r + 0.03, r, length(q));
    
    // Output final color.
	fragColor = vec4(col, 1.0);
}
