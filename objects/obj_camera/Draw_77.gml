shader_set(shd_deferred_combine);
surface_set_target(self.surf_light);
draw_clear(#404040);

var sampler_depth = shader_get_sampler_index(shd_deferred_combine, "samp_depth");
var sampler_normal = shader_get_sampler_index(shd_deferred_combine, "samp_normal");
texture_set_stage(sampler_depth, surface_get_texture_depth(self.gbuff_diffuse));
texture_set_stage(sampler_normal, surface_get_texture(self.gbuff_normal));

var u_light_point = shader_get_uniform(shd_deferred_combine, "u_light_point");

var u_znear = shader_get_uniform(shd_deferred_combine, "u_znear");
var u_zfar = shader_get_uniform(shd_deferred_combine, "u_zfar");
var u_fov_scale = shader_get_uniform(shd_deferred_combine, "u_fov_scale");
shader_set_uniform_f(u_znear, 1);
shader_set_uniform_f(u_zfar, 8_000);
var fov = 60;
var aspect = 16 / 9;
shader_set_uniform_f(u_fov_scale, dtan(fov / 2) * aspect, dtan(-fov / 2));

var cam = camera_get_active();
camera_set_view_mat(cam, mat_view);
camera_set_proj_mat(cam, mat_proj);
camera_apply(cam);
gpu_set_blendmode(bm_add);
gpu_set_cullmode(cull_clockwise);

for (var i = 0, n = array_length(self.lights); i < n; i += 3) {
    var xx = self.lights[i + 0];
    var yy = self.lights[i + 1];
    var zz = self.lights[i + 2];
    var point = matrix_transform_vertex(self.mat_view, xx, yy, zz);
    
    shader_set_uniform_f(u_light_point, point[0], point[1], point[2]);
    
    matrix_set(matrix_world, matrix_build(xx, yy, zz, 0, 0, 0, 160, 160, 160));
    vertex_submit(vb_sphere, pr_trianglelist, -1);
}

matrix_set(matrix_world, matrix_build_identity());
gpu_set_blendmode(bm_normal);
gpu_set_cullmode(cull_noculling);
shader_reset();

surface_reset_target();

draw_surface_stretched(self.gbuff_diffuse, 0, 0, window_get_width(), window_get_height());

gpu_set_blendmode_ext(bm_dest_color, bm_inv_src_alpha);
draw_surface(self.surf_light, 0, 0);
gpu_set_blendmode(bm_normal);