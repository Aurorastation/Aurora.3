// Planes, layers, and defaults for _renderer.dm
/*
	from stddef.dm, planes & layers built into byond.

	FLOAT_LAYER = -1
	AREA_LAYER = 1
	TURF_LAYER = 2
	OBJ_LAYER = 3
	MOB_LAYER = 4
	FLY_LAYER = 5
	EFFECTS_LAYER = 5000
	TOPDOWN_LAYER = 10000
	BACKGROUND_LAYER = 20000
	------

	FLOAT_PLANE = -32767
*/

#define LOWEST_PLANE -200

#define CLICKCATCHER_PLANE -100

#define SPACE_PLANE -99
	#define SPACE_LAYER 1

#define SKYBOX_PLANE -98
	#define SKYBOX_LAYER 1

#define DUST_PLANE -97
	#define DEBRIS_LAYER 1
	#define DUST_LAYER 2

// Openspace uses planes -80 through -70.
#define OPENTURF_MAX_PLANE -70
#define OPENTURF_MAX_DEPTH 10		// The maxiumum number of planes deep we'll go before we just dump everything on the same plane.

#define OVER_OPENSPACE_PLANE -4

#define WARP_EFFECT_PLANE -3

#define BLACKNESS_PLANE 0 //Blackness plane as per DM documentation.

#define DEFAULT_PLANE 1
	#define PLATING_LAYER 1
	//ABOVE PLATING
	#define HOLOMAP_LAYER 1.01
	#define DECAL_PLATING_LAYER 1.02
	#define DISPOSALS_PIPE_LAYER 1.03
	#define LATTICE_LAYER 1.04
	#define PIPE_LAYER 1.05
	#define WIRE_LAYER 1.06
	#define WIRE_TERMINAL_LAYER 1.07
	#define ABOVE_WIRE_LAYER 1.08
	//TURF_LAYER 2
	#define TURF_DETAIL_LAYER 2.01
	#define TURF_SHADOW_LAYER 2.02
	//ABOVE TURF
	#define DECAL_LAYER 2.03
	#define RUNE_LAYER 2.04
	#define ABOVE_TILE_LAYER 2.05
	#define EXPOSED_PIPE_LAYER 2.06
	#define EXPOSED_WIRE_LAYER 2.07
	#define EXPOSED_WIRE_TERMINAL_LAYER 2.08
	#define CATWALK_LAYER 2.09
	#define ABOVE_CATWALK_LAYER 2.10
	#define BLOOD_LAYER 2.11
	#define MOUSETRAP_LAYER 2.12
	#define PLANT_LAYER 2.13
	#define AO_LAYER 2.14
	//HIDING MOB
	#define HIDING_MOB_LAYER 2.15
	#define SHALLOW_FLUID_LAYER 2.16
	#define MOB_SHADOW_LAYER 2.17
	// OBJ
	#define BELOW_DOOR_LAYER 2.18
	#define OPEN_DOOR_LAYER 2.19
	#define BELOW_TABLE_LAYER 2.20
	#define TABLE_LAYER 2.21
	#define ABOVE_TABLE_LAYER 2.22
	#define BELOW_OBJ_LAYER 2.23
	#define STRUCTURE_LAYER 2.24
	//OBJ_LAYER 3
	#define ABOVE_OBJ_LAYER 3.01
	#define UNDERDOOR 3.015		//Just barely under a closed door. TODO: Obsolete?
	#define CLOSED_DOOR_LAYER 3.02
	#define ABOVE_DOOR_LAYER 3.03
	#define SIDE_WINDOW_LAYER 3.04
	#define FULL_WINDOW_LAYER 3.05
	#define ABOVE_WINDOW_LAYER 3.06
	#define HOLOMAP_OVERLAY_LAYER 3.061
	//LYING MOB AND HUMAN
	#define LYING_MOB_LAYER 3.07
	#define LYING_HUMAN_LAYER 3.08
	#define BASE_ABOVE_OBJ_LAYER 3.09
	//HUMAN
	#define BASE_HUMAN_LAYER 3.10
	//MOB_LAYER 4
	#define MECH_BASE_LAYER 4.01
	#define MECH_INTERMEDIATE_LAYER 4.02
	#define MECH_PILOT_LAYER 4.03
	#define MECH_LEG_LAYER 4.04
	#define MECH_COCKPIT_LAYER 4.05
	#define MECH_ARM_LAYER 4.06
	#define MECH_HEAD_LAYER 4.07
	#define MECH_GEAR_LAYER 4.08
	#define MECH_DECAL_LAYER 4.09
	//ABOVE_HUMAN
	#define ABOVE_HUMAN_LAYER 4.10
	#define ABOVE_ABOVE_HUMAN_LAYER 4.101
	#define VEHICLE_LOAD_LAYER 4.11
	#define CAMERA_LAYER 4.12
	//BLOB
	#define BLOB_SHIELD_LAYER 4.13
	#define BLOB_NODE_LAYER 4.14
	#define BLOB_CORE_LAYER 4.15
	//EFFECTS BELOW LIGHTING
	#define BELOW_PROJECTILE_LAYER 4.16
	#define DEEP_FLUID_LAYER 4.17
	#define FIRE_LAYER 4.18
	#define PROJECTILE_LAYER 4.19
	#define ABOVE_PROJECTILE_LAYER 4.20
	#define SINGULARITY_LAYER 4.21
	#define POINTER_LAYER 4.22
	#define MIMICED_LIGHTING_LAYER 4.23 // Z-Mimic-managed lighting
	//FLY_LAYER 5
	//OBSERVER
	#define OBSERVER_LAYER 5.1
	#define OBFUSCATION_LAYER 5.2

	#define OVERMAP_SECTOR_LAYER 60
	#define OVERMAP_IMPORTANT_SECTOR_LAYER 61
	#define OVERMAP_SHIP_LAYER 62
	#define OVERMAP_SHUTTLE_LAYER 63

	#define AREA_LAYER 999

#define OBSERVER_PLANE 3

#define LIGHTING_PLANE 4
	#define LIGHTING_LAYER 1

#define EFFECTS_ABOVE_LIGHTING_PLANE 5
	#define EYEGLOW_LAYER 1
	#define BEAM_PROJECTILE_LAYER 2
	#define SUPERMATTER_WALL_LAYER 3
	#define LIGHTNING_LAYER 4

#define FULLSCREEN_PLANE 6
	#define FULLSCREEN_LAYER 1
	#define DAMAGE_LAYER 2
	#define IMPAIRED_LAYER 3
	#define BLIND_LAYER 4
	#define CRIT_LAYER 5

#define HUD_PLANE 7
	#define UNDER_HUD_LAYER 1
	#define HUD_BASE_LAYER 2
	#define HUD_ITEM_LAYER 3
	#define HUD_ABOVE_ITEM_LAYER 4
	#define RADIAL_BACKGROUND_LAYER 5
	#define RADIAL_BASE_LAYER 6
	#define RADIAL_CONTENT_LAYER 7

/// This plane masks out lighting, to create an "emissive" effect for e.g glowing screens in otherwise dark areas.
#define EMISSIVE_PLANE 10
#define EMISSIVE_TARGET "*emissive"
	/// The layer you should use when you -really- don't want an emissive overlay to be blocked.
	#define EMISSIVE_LAYER_UNBLOCKABLE 9999

//-------------------- Rendering ---------------------

/// Semantics - The final compositor or a filter effect renderer
#define RENDER_GROUP_NONE null

/// Things to be drawn within the game context
#define RENDER_GROUP_SCENE 990

/// Things to be drawn within the screen context
#define RENDER_GROUP_SCREEN 995

/// The final render group, for compositing
#define RENDER_GROUP_FINAL 999

/// Integer (One of `*_PLANE`). The atom's rendering plane. See `code\__defines\__renderer.dm` for a list of valid planes. Also see the DM Reference for `plane var (atom)`.
/atom/plane = DEFAULT_PLANE

#define DEFAULT_APPEARANCE_FLAGS (PIXEL_SCALE)

#define DEFAULT_RENDERER_APPEARANCE_FLAGS (PLANE_MASTER | NO_CLIENT_COLOR)

/atom/appearance_flags = DEFAULT_APPEARANCE_FLAGS
/atom/movable/appearance_flags = DEFAULT_APPEARANCE_FLAGS | TILE_BOUND // Most AMs are not visibly bigger than a tile.
/image/appearance_flags = DEFAULT_APPEARANCE_FLAGS
/mutable_appearance/appearance_flags = DEFAULT_APPEARANCE_FLAGS // Inherits /image but re docs, subject to change

/atom/proc/hud_layerise()
	plane = HUD_PLANE
	layer = HUD_ITEM_LAYER

/image/proc/turf_decal_layerise()
	plane = DEFAULT_PLANE
	layer = DECAL_LAYER

/image/proc/plating_decal_layerise()
	plane = DEFAULT_PLANE
	layer = DECAL_PLATING_LAYER

/atom/proc/reset_plane_and_layer()
	plane = initial(plane)
	layer = initial(layer)
