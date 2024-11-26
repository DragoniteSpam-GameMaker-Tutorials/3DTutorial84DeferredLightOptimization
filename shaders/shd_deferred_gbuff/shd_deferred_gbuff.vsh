attribute vec3 in_Position;
attribute vec3 in_Normal;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec3 v_vNormal;

void main()
{
    vec4 objectSpace = vec4(in_Position, 1);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * objectSpace;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
    v_vNormal = normalize(gm_Matrices[MATRIX_WORLD_VIEW] * vec4(in_Normal, 0)).xyz;
}
