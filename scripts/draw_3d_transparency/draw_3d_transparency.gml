function draw_3d_transparency() {
    surface_set_target(self.surf_combine, self.gbuff_diffuse);
    gpu_set_ztestenable(true);
    gpu_set_zwriteenable(true);
    gpu_set_cullmode(cull_counterclockwise);

    var cam = camera_get_active();
    camera_set_view_mat(cam, self.mat_view);
    camera_set_proj_mat(cam, matrix_build_projection_perspective_fov(-60, -16 / 9, 1, 8_000));
    camera_apply(cam);

    var t = current_time / 100;
    matrix_set(matrix_world, matrix_build(0, 0, sin(current_time / 1000) * 64, t, t, t, 1, 1, 1));
    vertex_submit(self.vb_cube_rainbow, pr_trianglelist, -1);
    matrix_set(matrix_world, matrix_build_identity());

    gpu_set_ztestenable(false);
    gpu_set_zwriteenable(false);
    surface_reset_target();
    gpu_set_cullmode(cull_noculling);
}