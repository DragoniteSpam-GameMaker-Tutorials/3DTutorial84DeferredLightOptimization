// Feather disable all
// @ignore
function Drago3D_Internals() {
    static Vertex = function(vbuff, x, y, z, nx, ny, nz, u, v, c, a) {
        vertex_position_3d(vbuff, x, y, z);
        vertex_normal(vbuff, nx, ny, nz);
        vertex_colour(vbuff, c, a);
        vertex_texcoord(vbuff, u, v);
    };
    
    static format = undefined;
    
    if (format == undefined) {
        vertex_format_begin();
        vertex_format_add_position_3d();
        vertex_format_add_normal();
        vertex_format_add_color();
        vertex_format_add_texcoord();
        format = vertex_format_end();
    }
    
    static Unarchive = function(archive, cache, archive_limit = 1000) {
        static age_limit = 60_000;
        
        if (ds_priority_size(archive) > archive_limit) {
            var oldest = ds_priority_find_min(archive);
            var oldest_time = ds_priority_find_priority(archive, oldest);
            
            if (current_time - oldest_time >= age_limit) {
                ds_priority_delete_value(archive, oldest);
                vertex_delete_buffer(oldest.vb);
                variable_struct_remove(cache, oldest.key);
            }
        }
    };
    
    static Mat4Inverse = function(mat) {
        var results = array_create(16);
        results[0]  =  mat[ 5] * mat[10] * mat[15] - mat[ 5] * mat[11] * mat[14] - mat[ 9] * mat[ 6] * mat[15] + mat[ 9] * mat[ 7] * mat[14] + mat[13] * mat[ 6] * mat[11] - mat[13] * mat[ 7] * mat[10];
        results[1]  = -mat[ 1] * mat[10] * mat[15] + mat[ 1] * mat[11] * mat[14] + mat[ 9] * mat[ 2] * mat[15] - mat[ 9] * mat[ 3] * mat[14] - mat[13] * mat[ 2] * mat[11] + mat[13] * mat[ 3] * mat[10];
        results[2]  =  mat[ 1] * mat[ 6] * mat[15] - mat[ 1] * mat[ 7] * mat[14] - mat[ 5] * mat[ 2] * mat[15] + mat[ 5] * mat[ 3] * mat[14] + mat[13] * mat[ 2] * mat[ 7] - mat[13] * mat[ 3] * mat[ 6];
        results[3]  = -mat[ 1] * mat[ 6] * mat[11] + mat[ 1] * mat[ 7] * mat[10] + mat[ 5] * mat[ 2] * mat[11] - mat[ 5] * mat[ 3] * mat[10] - mat[ 9] * mat[ 2] * mat[ 7] + mat[ 9] * mat[ 3] * mat[ 6];
        results[4]  = -mat[ 4] * mat[10] * mat[15] + mat[ 4] * mat[11] * mat[14] + mat[ 8] * mat[ 6] * mat[15] - mat[ 8] * mat[ 7] * mat[14] - mat[12] * mat[ 6] * mat[11] + mat[12] * mat[ 7] * mat[10];
        results[5]  =  mat[ 0] * mat[10] * mat[15] - mat[ 0] * mat[11] * mat[14] - mat[ 8] * mat[ 2] * mat[15] + mat[ 8] * mat[ 3] * mat[14] + mat[12] * mat[ 2] * mat[11] - mat[12] * mat[ 3] * mat[10];
        results[6]  = -mat[ 0] * mat[ 6] * mat[15] + mat[ 0] * mat[ 7] * mat[14] + mat[ 4] * mat[ 2] * mat[15] - mat[ 4] * mat[ 3] * mat[14] - mat[12] * mat[ 2] * mat[ 7] + mat[12] * mat[ 3] * mat[ 6];
        results[7]  =  mat[ 0] * mat[ 6] * mat[11] - mat[ 0] * mat[ 7] * mat[10] - mat[ 4] * mat[ 2] * mat[11] + mat[ 4] * mat[ 3] * mat[10] + mat[ 8] * mat[ 2] * mat[ 7] - mat[ 8] * mat[ 3] * mat[ 6];
        results[8]  =  mat[ 4] * mat[ 9] * mat[15] - mat[ 4] * mat[11] * mat[13] - mat[ 8] * mat[ 5] * mat[15] + mat[ 8] * mat[ 7] * mat[13] + mat[12] * mat[ 5] * mat[11] - mat[12] * mat[ 7] * mat[ 9];
        results[9]  = -mat[ 0] * mat[ 9] * mat[15] + mat[ 0] * mat[11] * mat[13] + mat[ 8] * mat[ 1] * mat[15] - mat[ 8] * mat[ 3] * mat[13] - mat[12] * mat[ 1] * mat[11] + mat[12] * mat[ 3] * mat[ 9];
        results[10] =  mat[ 0] * mat[ 5] * mat[15] - mat[ 0] * mat[ 7] * mat[13] - mat[ 4] * mat[ 1] * mat[15] + mat[ 4] * mat[ 3] * mat[13] + mat[12] * mat[ 1] * mat[ 7] - mat[12] * mat[ 3] * mat[ 5];
        results[11] = -mat[ 0] * mat[ 5] * mat[11] + mat[ 0] * mat[ 7] * mat[ 9] + mat[ 4] * mat[ 1] * mat[11] - mat[ 4] * mat[ 3] * mat[ 9] - mat[ 8] * mat[ 1] * mat[ 7] + mat[ 8] * mat[ 3] * mat[ 5];
        results[12] = -mat[ 4] * mat[ 9] * mat[14] + mat[ 4] * mat[10] * mat[13] + mat[ 8] * mat[ 5] * mat[14] - mat[ 8] * mat[ 6] * mat[13] - mat[12] * mat[ 5] * mat[10] + mat[12] * mat[ 6] * mat[ 9];
        results[13] =  mat[ 0] * mat[ 9] * mat[14] - mat[ 0] * mat[10] * mat[13] - mat[ 8] * mat[ 1] * mat[14] + mat[ 8] * mat[ 2] * mat[13] + mat[12] * mat[ 1] * mat[10] - mat[12] * mat[ 2] * mat[ 9];
        results[14] = -mat[ 0] * mat[ 5] * mat[14] + mat[ 0] * mat[ 6] * mat[13] + mat[ 4] * mat[ 1] * mat[14] - mat[ 4] * mat[ 2] * mat[13] - mat[12] * mat[ 1] * mat[ 6] + mat[12] * mat[ 2] * mat[ 5];
        results[15] =  mat[ 0] * mat[ 5] * mat[10] - mat[ 0] * mat[ 6] * mat[ 9] - mat[ 4] * mat[ 1] * mat[10] + mat[ 4] * mat[ 2] * mat[ 9] + mat[ 8] * mat[ 1] * mat[ 6] - mat[ 8] * mat[ 2] * mat[ 5];
    
        var determinant = mat[0] * results[0] + mat[1] * results[4] + mat[2] * results[8] + mat[3] * results[12];
    
        if (determinant == 0) {
        	return undefined;
        }
	
    	array_map_ext(results, method({ determinant: determinant }, function(val) {
    		return val / self.determinant;
    	}));
	    
        return results;
    };
}

Drago3D_Internals();