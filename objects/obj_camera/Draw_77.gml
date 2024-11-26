shader_set(shd_deferred_combine);
surface_set_target(self.surf_combine);

var sampler_depth = shader_get_sampler_index(shd_deferred_combine, "samp_depth");
var sampler_normal = shader_get_sampler_index(shd_deferred_combine, "samp_normal");
texture_set_stage(sampler_depth, surface_get_texture_depth(self.gbuff_diffuse));
texture_set_stage(sampler_normal, surface_get_texture(self.gbuff_normal));

var u_light_point = shader_get_uniform(shd_deferred_combine, "u_light_point");
var u_light_count = shader_get_uniform(shd_deferred_combine, "u_light_count");

var u_znear = shader_get_uniform(shd_deferred_combine, "u_znear");
var u_zfar = shader_get_uniform(shd_deferred_combine, "u_zfar");
var u_fov_scale = shader_get_uniform(shd_deferred_combine, "u_fov_scale");
shader_set_uniform_f(u_znear, 1);
shader_set_uniform_f(u_zfar, 8_000);
var fov = 60;
var aspect = 16 / 9;
shader_set_uniform_f(u_fov_scale, dtan(fov / 2) * aspect, dtan(-fov / 2));

var transformed = array_create(array_length(self.lights));
var count = 0;
for (var i = 0, n = array_length(self.lights); i < n; i += 3) {
    var xx = self.lights[i + 0];
    var yy = self.lights[i + 1];
    var zz = self.lights[i + 2];
    var point = matrix_transform_vertex(self.mat_view, xx, yy, zz);
    transformed[i + 0] = point[0];
    transformed[i + 1] = point[1];
    transformed[i + 2] = point[2];
    count++;
}

shader_set_uniform_f_array(u_light_point, transformed);
shader_set_uniform_i(u_light_count, count);

draw_surface_stretched(self.gbuff_diffuse, 0, 0, window_get_width(), window_get_height());
shader_reset();

surface_reset_target();

draw_surface(self.surf_combine, 0, 0);