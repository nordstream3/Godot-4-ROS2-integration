shader_type spatial;
render_mode unshaded;
//render_mode cull_front; // Cull front-faces. Cull back-faces.
//uniform sampler2D noise_tex;

/*void vertex() {
	// Called for every vertex the material is visible on.
}*/

//varying mat4 CAMERA;

void vertex() {
  //CAMERA = INV_VIEW_MATRIX;
}

uniform sampler2D depth_texture : source_color, hint_depth_texture;

/*void fragment() {
	// Called for every pixel the material is visible on.
	//float depth = max(0.0, 1.0 - FRAGCOORD.z / FRAGCOORD.w);
	float depth = texture(depth_texture, SCREEN_UV).x;
	//ALPHA = 0.5;
	if (depth > 0.007)
		ALBEDO = vec3(1.0);
	else
		ALBEDO = vec3(0.0);
}*/

void fragment() {
	float depth = texture(depth_texture, SCREEN_UV).r;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	//vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	//view.xyz /= view.w;
	//float linear_depth = -view.z;

	//vec4 world = CAMERA * INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	vec4 world = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	vec3 world_position = world.xyz / world.w;

	ALBEDO = vec3(min(1.0, world_position.z/-10.0));
	//ALBEDO = vec3(0);
	ALPHA = 1.0; //vec3(0);
	//ALPHA = min(1.0, world_position.z / -10.0);
	/*if (world_position.z > -10.0)
		ALBEDO = vec3(1.0, 1.0, 0.0);
	else
		ALBEDO = vec3(0.0);*/

    SPECULAR = 0.0;              // No specular reflection
    ROUGHNESS = 1.0;             // Fully rough (no reflections)
    METALLIC = 0.0;              // Not metallic

    // Set the emission color, making the material self-illuminating
    //EMISSION = vec3(0.1, 0.1, 0.1); // Example: Orange self-illumination
}

// Disable any lighting effect
void light() {
    DIFFUSE_LIGHT = vec3(0);  // No light contribution
}
//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
