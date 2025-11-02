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

/// NEVER HAVE ANYTHING BELOW THIS PLANE ADJUST IF YOU NEED MORE SPACE
#define LOWEST_EVER_PLANE -200

#define CLICKCATCHER_PLANE -92

#define SPACE_PLANE -91
	#define SPACE_LAYER 1

#define SKYBOX_PLANE -90
	#define SKYBOX_LAYER 1

#define DUST_PLANE -82
	#define DEBRIS_LAYER 1
	#define DUST_LAYER 2

#define OPENSPACE_BACKDROP_PLANE -81
#define OPEN_SPACE_PLANE_START -80
// Openspace uses planes -80 through -70.
// Do no put anything between these two, adjust more z level support as needed
#define OPEN_SPACE_PLANE_END -70
#define OPENTURF_MAX_DEPTH 10		// The maxiumum number of planes deep we'll go before we just dump everything on the same plane.

#define HEAT_EFFECT_PLANE -4
#define WARP_EFFECT_PLANE -3

#define BLACKNESS_PLANE 0 //Blackness plane as per DM documentation.

/// Game Plane, where most of the game objects reside
#define GAME_PLANE 1
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
	#define EXPOSED_DISPOSALS_PIPE_LAYER 2.06
	#define EXPOSED_PIPE_LAYER 2.07
	#define EXPOSED_WIRE_LAYER 2.08
	#define EXPOSED_WIRE_TERMINAL_LAYER 2.09
	#define CATWALK_LAYER 2.10
	#define ABOVE_CATWALK_LAYER 2.11
	#define BLOOD_LAYER 2.12
	#define MOUSETRAP_LAYER 2.13
	#define PLANT_LAYER 2.14
	#define AO_LAYER 2.15
	//HIDING MOB
	#define HIDING_MOB_LAYER 2.16
	#define SHALLOW_FLUID_LAYER 2.17
	#define PROJECTILE_HIT_THRESHHOLD_LAYER 2.3
	// OBJ
	#define BELOW_DOOR_LAYER 2.69
	#define OPEN_DOOR_LAYER 2.70
	#define BELOW_TABLE_LAYER 2.71
	#define TABLE_LAYER 2.72
	#define ABOVE_TABLE_LAYER 2.73
	#define WINDOW_FRAME_LAYER 2.74
	#define BELOW_WINDOW_LAYER 2.75
	#define SIDE_WINDOW_LAYER 2.76
	#define FULL_WINDOW_LAYER 2.77
	#define ABOVE_WINDOW_LAYER 2.78
	#define BELOW_OBJ_LAYER 2.89
	#define STRUCTURE_LAYER 2.9
	#define ABOVE_STRUCTURE_LAYER 2.91
	//OBJ_LAYER 3
	#define ABOVE_OBJ_LAYER 3.01
	#define MOB_SHADOW_LAYER 3.011
	#define MOB_EMISSIVE_LAYER 3.012
	#define MOB_SHADOW_UPPER_LAYER 3.013
	#define HOLOMAP_OVERLAY_LAYER 3.02
	//LYING MOB AND HUMAN
	#define LYING_MOB_LAYER 3.07
	#define LYING_HUMAN_LAYER 3.08
	#define BASE_ABOVE_OBJ_LAYER 3.09
	//HUMAN
	#define BASE_HUMAN_LAYER 3.10
	//MOB_LAYER 4
	#define UNDERDOOR 4.03
	#define CLOSED_DOOR_LAYER 4.04
	#define ABOVE_DOOR_LAYER 4.05
	#define MECH_BASE_LAYER 4.06
	#define MECH_INTERMEDIATE_LAYER 4.07
	#define MECH_PILOT_LAYER 4.08
	#define MECH_LEG_LAYER 4.09
	#define MECH_COCKPIT_LAYER 4.10
	#define MECH_ARM_LAYER 4.11
	#define MECH_HEAD_LAYER 4.12
	#define MECH_GEAR_LAYER 4.13
	#define MECH_DECAL_LAYER 4.14
	// ABOVE_HUMAN
	#define ABOVE_HUMAN_LAYER 4.15
	#define ABOVE_ABOVE_HUMAN_LAYER 4.151
	#define VEHICLE_LOAD_LAYER 4.16
	#define CAMERA_LAYER 4.17
	// BLOB
	#define BLOB_SHIELD_LAYER 4.18
	#define BLOB_NODE_LAYER 4.19
	#define BLOB_CORE_LAYER 4.20
	// EFFECTS BELOW LIGHTING
	#define BELOW_PROJECTILE_LAYER 4.21
	#define DEEP_FLUID_LAYER 4.22
	#define FIRE_LAYER 4.23
	#define PROJECTILE_LAYER 4.24
	#define ABOVE_PROJECTILE_LAYER 4.25
	#define SINGULARITY_LAYER 4.26
	#define POINTER_LAYER 4.27
	#define MIMICED_LIGHTING_LAYER 4.28 // Z-Mimic-managed lighting

	#define OBFUSCATION_LAYER 5.2
	//FLY_LAYER 5

	#define OVERMAP_SECTOR_LAYER 60
	#define OVERMAP_IMPORTANT_SECTOR_LAYER 61
	#define OVERMAP_SHIP_LAYER 62
	#define OVERMAP_SHUTTLE_LAYER 63

	#define AREA_LAYER 999

/// Above Game Plane. For things which are above game objects, but below screen effects.
#define ABOVE_GAME_PLANE 2

#define ROOF_PLANE 3

#define DISPLACEMENT_PLATE_RENDER_LAYER 4
#define DISPLACEMENT_PLATE_RENDER_TARGET "*DISPLACEMENT_PLATE_RENDER_TARGET"

#define GHOST_PLANE 80

#define LIGHTING_PLANE 100
	#define LIGHTING_LAYER 1

#define BALLOON_CHAT_PLANE 110

#define ABOVE_LIGHTING_PLANE 150
	#define EYE_GLOW_LAYER 1
	#define BEAM_PROJECTILE_LAYER 2
	#define SUPERMATTER_WALL_LAYER 3
	#define LIGHTNING_LAYER 4

#define RUNECHAT_PLANE 501

#define FULLSCREEN_PLANE 9
	#define FULLSCREEN_LAYER 1
	#define DAMAGE_LAYER 2
	#define IMPAIRED_LAYER 3
	#define BLIND_LAYER 4
	#define CRIT_LAYER 5

#define HUD_PLANE 1000
	#define UNDER_HUD_LAYER 1
	#define HUD_BASE_LAYER 2
	#define HUD_BELOW_ITEM_LAYER 2.9
	#define HUD_ITEM_LAYER 3
	#define HUD_ABOVE_ITEM_LAYER 4
	#define RADIAL_BACKGROUND_LAYER 5
	#define RADIAL_BASE_LAYER 6
	#define RADIAL_CONTENT_LAYER 7

#define CINEMATIC_PLANE 1200

/*=============================*\
| |
|   PLANE DEFINES |
| |
\*=============================*/

#define RENDER_PLANE_GAME 990
#define RENDER_PLANE_NON_GAME 995

#define RENDER_PLANE_MASTER 999

/// Plane master controller keys
#define PLANE_MASTERS_GAME "plane_masters_game"
#define PLANE_MASTERS_NON_MASTER "plane_masters_non_master"

//---------- EMISSIVES -------------
//Layering order of these is not particularly meaningful.
//Important part is the seperation of the planes for control via plane_master

/// This plane masks out lighting, to create an "emissive" effect for e.g glowing screens in otherwise dark areas.
#define EMISSIVE_PLANE 90
#define EMISSIVE_TARGET "*emissive"
	/// The layer you should use when you -really- don't want an emissive overlay to be blocked.
	#define EMISSIVE_LAYER_UNBLOCKABLE 9999

/// The render target used by the emissive layer.
#define EMISSIVE_RENDER_TARGET "*EMISSIVE_PLANE"

#define DEFAULT_APPEARANCE_FLAGS (PIXEL_SCALE)

#define DEFAULT_RENDERER_APPEARANCE_FLAGS (PLANE_MASTER | NO_CLIENT_COLOR)

/image/appearance_flags = DEFAULT_APPEARANCE_FLAGS

/atom/proc/hud_layerise()
	plane = HUD_PLANE
	layer = HUD_ITEM_LAYER

/image/proc/turf_decal_layerise()
	plane = GAME_PLANE
	layer = DECAL_LAYER

/image/proc/plating_decal_layerise()
	plane = GAME_PLANE
	layer = DECAL_PLATING_LAYER

/atom/proc/reset_plane_and_layer()
	plane = initial(plane)
	layer = initial(layer)
