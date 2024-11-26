function surface_validate(surface_id, w, h, format = surface_rgba8unorm) {
    if (!surface_exists(surface_id)) {
        return surface_create(w, h, format);
    }
    if (surface_get_width(surface_id) != w || surface_get_height(surface_id) != h) {
        surface_free(surface_id);
        return surface_create(w, h, format);
    }
    return surface_id;
}