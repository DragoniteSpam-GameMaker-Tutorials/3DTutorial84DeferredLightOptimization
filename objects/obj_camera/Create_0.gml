vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_colour();
self.format = vertex_format_end();

//show_debug_overlay(true);

#region floor
var x1 = -10000;
var y1 = -10000;
var x2 = 10000;
var y2 = 10000;

self.vb_floor = vertex_create_buffer();
vertex_begin(self.vb_floor, self.format);

vertex_position_3d(self.vb_floor, x1, y1, 0);
vertex_normal(self.vb_floor, 0, 0, 1);
vertex_texcoord(self.vb_floor, 0, 0);
vertex_colour(self.vb_floor, c_green, 1);

vertex_position_3d(self.vb_floor, x2, y1, 0);
vertex_normal(self.vb_floor, 0, 0, 1);
vertex_texcoord(self.vb_floor, 0, 0);
vertex_colour(self.vb_floor, c_green, 1);

vertex_position_3d(self.vb_floor, x2, y2, 0);
vertex_normal(self.vb_floor, 0, 0, 1);
vertex_texcoord(self.vb_floor, 0, 0);
vertex_colour(self.vb_floor, c_green, 1);

vertex_position_3d(self.vb_floor, x2, y2, 0);
vertex_normal(self.vb_floor, 0, 0, 1);
vertex_texcoord(self.vb_floor, 0, 0);
vertex_colour(self.vb_floor, c_green, 1);

vertex_position_3d(self.vb_floor, x1, y2, 0);
vertex_normal(self.vb_floor, 0, 0, 1);
vertex_texcoord(self.vb_floor, 0, 0);
vertex_colour(self.vb_floor, c_green, 1);

vertex_position_3d(self.vb_floor, x1, y1, 0);
vertex_normal(self.vb_floor, 0, 0, 1);
vertex_texcoord(self.vb_floor, 0, 0);
vertex_colour(self.vb_floor, c_green, 1);

vertex_end(self.vb_floor);
#endregion

#region trees
var data = buffer_load("tree_simple.vbuff");
var vb_tree_simple = vertex_create_buffer_from_buffer(data, self.format);
vertex_freeze(vb_tree_simple);
buffer_delete(data);

var data = buffer_load("tree_cone.vbuff");
var vb_tree_cone = vertex_create_buffer_from_buffer(data, self.format);
vertex_freeze(vb_tree_cone);
buffer_delete(data);

var data = buffer_load("tree_cone_dark.vbuff");
var vb_tree_cone_dark = vertex_create_buffer_from_buffer(data, self.format);
vertex_freeze(vb_tree_cone_dark);
buffer_delete(data);

var data = buffer_load("tree_detailed.vbuff");
var vb_tree_detailed = vertex_create_buffer_from_buffer(data, self.format);
vertex_freeze(vb_tree_detailed);
buffer_delete(data);

var data = buffer_load("tree_fat.vbuff");
var vb_tree_fat = vertex_create_buffer_from_buffer(data, self.format);
vertex_freeze(vb_tree_fat);
buffer_delete(data);

var data = buffer_load("tree_fat_dark.vbuff");
var vb_tree_fat_dark = vertex_create_buffer_from_buffer(data, self.format);
vertex_freeze(vb_tree_fat_dark);
buffer_delete(data);

var data = buffer_load("tree_plateau.vbuff");
var vb_tree_plateau = vertex_create_buffer_from_buffer(data, self.format);
vertex_freeze(vb_tree_plateau);
buffer_delete(data);

var data = buffer_load("tree_plateau_dark.vbuff");
var vb_tree_plateau_dark = vertex_create_buffer_from_buffer(data, self.format);
vertex_freeze(vb_tree_plateau_dark);
buffer_delete(data);

var data = buffer_load("cube_rainbow.vbuff");
self.vb_cube_rainbow = vertex_create_buffer_from_buffer(data, self.format);
vertex_freeze(self.vb_cube_rainbow);
buffer_delete(data);

self.tree_models = [
    vb_tree_simple, vb_tree_cone, vb_tree_cone_dark, vb_tree_detailed,
    vb_tree_fat, vb_tree_fat_dark, vb_tree_plateau, vb_tree_plateau_dark
];

var data = buffer_load("terrain0.vbuff");
var vb_terrain_0 = vertex_create_buffer_from_buffer(data, self.format);
vertex_freeze(vb_terrain_0);
buffer_delete(data);

var data = buffer_load("terrain1.vbuff");
var vb_terrain_1 = vertex_create_buffer_from_buffer(data, format);
vertex_freeze(vb_terrain_1);
buffer_delete(data);

var data = buffer_load("terrain2.vbuff");
var vb_terrain_2 = vertex_create_buffer_from_buffer(data, format);
vertex_freeze(vb_terrain_2);
buffer_delete(data);

self.terrain_models = [
    vb_terrain_0, vb_terrain_1, vb_terrain_2
];

#macro TREE_COUNT 1500
#macro TERRAIN_COUNT 100

self.world_objects = array_create(TREE_COUNT + 2);

for (var i = 0; i < TREE_COUNT; i++) {
    self.world_objects[i] = new TreeObject(self.tree_models[irandom(array_length(self.tree_models) - 1)]);
}

self.tree_mesh = new TreeObject(vb_tree_plateau);
self.tree_mesh.x = 0;
self.tree_mesh.y = 0;
self.tree_mesh.transform = matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1);
self.world_objects[TREE_COUNT] = self.tree_mesh;

self.world_objects[TREE_COUNT + 1] = new FloorObject(self.vb_floor);

self.terrain_objects = array_create(TERRAIN_COUNT * 2);
for (var i = 0; i < TERRAIN_COUNT; i++) {
    self.terrain_objects[i] = new TerrainObject(self.terrain_models[irandom(array_length(self.terrain_models) - 1)]);
}
for (var i = TERRAIN_COUNT; i < TERRAIN_COUNT * 2; i++) {
    self.terrain_objects[i] = new LargeTerrainObject(self.terrain_models[irandom(array_length(self.terrain_models) - 1)]);
}
#endregion

#region player
self.player = new PlayerObject();

var data = buffer_load("player.vbuff");
self.vb_player = vertex_create_buffer_from_buffer(data, self.format);
buffer_delete(data);
#endregion

window_mouse_set(window_get_width() / 2, window_get_height() / 2);

window_set_size(1600, 900);
surface_resize(application_surface, 1600, 900);
window_mouse_set_locked(true);
//window_set_fullscreen(true);

call_later(1, time_source_units_frames, window_center, false);

application_surface_draw_enable(false);

self.gbuff_diffuse = -1;
self.gbuff_normal = -1;

self.surf_combine = -1;

surf_light = -1;

var n = 1024;
var s = sqrt(n);
self.lights = array_create(n * 3);
for (var i = 0; i < n * 3; i += 3) {
    self.lights[i + 0] = ((i mod s) - (s / 2)) * 120;
    self.lights[i + 1] = ((i div s) - (s / 2)) * 120;
    self.lights[i + 2] = 64;
}

var b = buffer_load("sphere.vbuff");
vb_sphere = vertex_create_buffer_from_buffer(b, format);
vertex_freeze(vb_sphere);
buffer_delete(b);