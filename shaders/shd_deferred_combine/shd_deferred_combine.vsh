attribute vec3 in_Position;

uniform vec4 u_position;

void main()
{
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] *
        vec4(in_Position * u_position.w + u_position.xyz, 1);
}
