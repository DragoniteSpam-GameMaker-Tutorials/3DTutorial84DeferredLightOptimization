varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vNormal;

void main()
{   
    gl_FragData[0] = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    gl_FragData[1] = vec4((v_vNormal.xyz * 0.5) + 0.5, 1);
    
    if (gl_FragData[0].a < 0.25) {
        discard;
    }
}