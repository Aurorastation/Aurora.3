// Defines for atom layers and planes.
//
// Plane values in this file now follow tgstation's plane cube model. Aurora-only
// names that are still required by old callsites are temporary (for sake of compilation)..
// Do not fucking leave these behind, still need migrated later on.

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

// NEVER HAVE ANYTHING BELOW THIS PLANE ADJUST IF YOU NEED MORE SPACE
#define LOWEST_EVER_PLANE -50

// Does not really layer, just throwing this in here because it is the best place.
#define FIELD_OF_VISION_BLOCKER_PLANE -45
#define FIELD_OF_VISION_BLOCKER_RENDER_TARGET "*FIELD_OF_VISION_BLOCKER_RENDER_TARGET"

#define CLICKCATCHER_PLANE -40

#define PLANE_SPACE -21
#define PLANE_SPACE_PARALLAX -20

#define WEATHER_MASK_PLANE -13
#define WEATHER_MASK_RENDER_TARGET "*WEATHER_MASK_RENDER_TARGET"

#define DISPLACEMENT_PLANE -12
#define DISPLACEMENT_RENDER_TARGET "*DISPLACEMENT_RENDER_TARGET"

#define RENDER_PLANE_TRANSPARENT -11 // Transparent plane that shows openspace underneath the floor.

#define TRANSPARENT_FLOOR_PLANE -10

#define FLOOR_PLANE -6

#define WALL_PLANE -5
#define GAME_PLANE -4
#define ABOVE_GAME_PLANE -3
/// Slightly above the game plane but does not catch mouse clicks.
#define SEETHROUGH_PLANE -2

#define RENDER_PLANE_GAME_WORLD -1

#define DEFAULT_PLANE 0

#define WEATHER_PLANE 1
#define PARTICLE_WEATHER_PLANE 2
#define AREA_PLANE 3
#define MASSIVE_OBJ_PLANE 4
#define GHOST_PLANE 5
#define POINT_PLANE 6

//---------- LIGHTING -------------

/// Normal one-per-turf dynamic lighting objects.
#define LIGHTING_PLANE 10

/// Lighting objects that are free floating.
#define O_LIGHTING_VISUAL_PLANE 11

// Render plate used by overlay lighting to mask turf lights.
#define RENDER_PLANE_TURF_LIGHTING 12

#define EMISSIVE_PLANE 13
/// This plane masks out lighting to create an emissive effect.
#define RENDER_PLANE_EMISSIVE 14
#define EMISSIVE_RENDER_TARGET "*RENDER_PLANE_EMISSIVE"
#define EMISSIVE_Z_BELOW_LAYER 1
#define EMISSIVE_FLOOR_LAYER 2
#define EMISSIVE_SPACE_LAYER 3
#define EMISSIVE_WALL_LAYER 4

#define RENDER_PLANE_EMISSIVE_BLOOM_MASK 15
#define EMISSIVE_BLOOM_MASK_RENDER_TARGET "*RENDER_PLANE_EMISSIVE_BLOOM_MASK"
#define RENDER_PLANE_EMISSIVE_BLOOM 16

#define RENDER_PLANE_SPECULAR_MASK 17
#define SPECULAR_MASK_RENDER_TARGET "*RENDER_PLANE_SPECULAR_MASK"

#define RENDER_PLANE_PARTICLE_WEATHER 18
#define RENDER_PLANE_EMISSIVE_PARTICLE_WEATHER 19

/// Main game plane to which everything renders, which is then multiplied by light.
#define RENDER_PLANE_UNLIT_GAME 20

#define RENDER_PLANE_O_LIGHTING 21

#define RENDER_PLANE_LIGHTING 22

/// Masks the lighting plane with turfs, so we never light up the void.
#define RENDER_PLANE_LIGHT_MASK 23
#define LIGHT_MASK_RENDER_TARGET "*RENDER_PLANE_LIGHT_MASK"

/// Speculars render directly to the game plate above lighting.
#define RENDER_PLANE_SPECULAR 24

/// Things that should render ignoring lighting.
#define ABOVE_LIGHTING_PLANE 25

#define WEATHER_GLOW_PLANE 26

// TG_PLANE_CUBE_TEMP: remove after roof visuals are reattached as a tg-style plane master or deleted.
#define ROOF_PLANE 27

/// Pipecrawling images.
#define PIPECRAWL_IMAGES_PLANE 30

/// AI camera static.
#define CAMERA_STATIC_PLANE 31

/// Anything that wants to be part of the game plane, but draw above literally everything else.
#define HIGH_GAME_PLANE 32

#define FULLSCREEN_PLANE 33

/// Popup chat messages.
#define RUNECHAT_PLANE 34
/// Plane for balloon text.
#define BALLOON_CHAT_PLANE 35

// TG_PLANE_CUBE_TEMP: remove after skybox, space parallax, and dust visuals are reattached to tg planes.
#define SPACE_PLANE PLANE_SPACE
#define SKYBOX_PLANE PLANE_SPACE_PARALLAX
#define DUST_PLANE PLANE_SPACE_PARALLAX

//---------- HUD -------------

#define HUD_PLANE 40
#define ABOVE_HUD_PLANE 41

/// Plane of the splash icon used by the lobby screen.
#define SPLASHSCREEN_PLANE 42

// TG_PLANE_CUBE_TEMP: remove after Aurora heat/cold gas visuals are reattached as tg render consumers.
#define HEAT_EFFECT_PLANE 43
// TG_PLANE_CUBE_TEMP: remove after Aurora warp/displacement visuals are reattached as tg render consumers.
#define WARP_EFFECT_PLANE 44

// The largest plane here must still be less than RENDER_PLANE_GAME.

//---------- Rendering -------------

#define RENDER_PLANE_GAME 50
/// If FOV is enabled, draw game to this and handle it there.
#define RENDER_PLANE_GAME_MASKED 51
/// The bit of the game plane that is left alone is sent here.
#define RENDER_PLANE_GAME_UNMASKED 52

// TG_PLANE_CUBE_TEMP: remove after cinematic rendering is reattached as tg HUD/escape-menu behavior.
#define CINEMATIC_PLANE 54

#define RENDER_PLANE_NON_GAME 55

/// Plane related to the menu when pressing Escape.
#define ESCAPE_MENU_PLANE 56

#define RENDER_PLANE_MASTER 57

// Lummox I swear to god.
// NOTE: You can only ever have planes greater than -10000. Too many large
// offsets will break multiz, as will large multiz maps.
#define HIGHEST_EVER_PLANE RENDER_PLANE_MASTER
/// The range unique planes can be in.
#define PLANE_RANGE (HIGHEST_EVER_PLANE - LOWEST_EVER_PLANE)

/// Used to shift topdown emissives back into normal game-plane layer space.
#define TOPDOWN_TO_EMISSIVE_LAYER(layer) (FLOOR_EMISSIVE_START_LAYER + ((FLOOR_EMISSIVE_END_LAYER - FLOOR_EMISSIVE_START_LAYER) * ((layer - (TOPDOWN_LAYER + 1)) / TOPDOWN_LAYER_COUNT)))
/// Must match the offset of the highest topdown layer.
#define TOPDOWN_LAYER_COUNT 18

//---------- TG plane-cube temporary Aurora aliases -------------

// TG_PLANE_CUBE_TEMP: remove after Aurora heat/cold gas visuals are reattached as tg render consumers
#define HEAT_EFFECT_PLATE_RENDER_TARGET "*HEAT_EFFECT_PLATE_RENDER_TARGET"
#define HEAT_EFFECT_COMPOSITE_RENDER_TARGET "*HEAT_EFFECT_COMPOSITE_RENDER_TARGET"
#define COLD_EFFECT_PLATE_RENDER_TARGET "*COLD_EFFECT_PLATE_RENDER_TARGET"
#define COLD_EFFECT_BACK_PLATE_RENDER_TARGET "*COLD_EFFECT_BACK_PLATE_RENDER_TARGET"

// TG_PLANE_CUBE_TEMP: remove after Aurora warp/displacement visuals are reattached as tg render consumers
#define DISPLACEMENT_PLATE_RENDER_LAYER DISPLACEMENT_PLANE
#define DISPLACEMENT_PLATE_RENDER_TARGET DISPLACEMENT_RENDER_TARGET
#define WARP_EFFECT_PLATE_RENDER_TARGET "*WARP_EFFECT_PLATE_RENDER_TARGET"

// TG_PLANE_CUBE_TEMP: remove after old Aurora lighting mask/static systems are replaced by tg lighting
#define BLACKNESS_PLANE DEFAULT_PLANE
#define O_LIGHTING_VISUAL_RENDER_TARGET "O_LIGHT_VISUAL_PLANE"
#define LIGHTING_RENDER_TARGET "LIGHT_PLANE"
#define SHADOW_RENDER_TARGET "SHADOW_RENDER_TARGET"
#define EMISSIVE_TARGET EMISSIVE_RENDER_TARGET

//---------- Plane layers retained for current Aurora callsites -------------

#define SPACE_LAYER 1.8
#define SKYBOX_LAYER 1
#define DEBRIS_LAYER 1
#define DUST_LAYER 2

	#define PLATING_LAYER 1
	// ABOVE PLATING
	#define HOLOMAP_LAYER 1.01
	#define DECAL_PLATING_LAYER 1.02
	#define DISPOSALS_PIPE_LAYER 1.03
	#define LATTICE_LAYER 1.04
	#define PIPE_LAYER 1.05
	#define WIRE_LAYER 1.06
	#define WIRE_TERMINAL_LAYER 1.07
	#define ABOVE_WIRE_LAYER 1.08
	// TURF_LAYER 2
	#define TURF_DETAIL_LAYER 2.01
	#define TURF_SHADOW_LAYER 2.02
	// ABOVE TURF
	#define DECAL_LAYER 2.03
	#define RUNE_LAYER 2.04
	#define ABOVE_TILE_LAYER 2.05
	#define FLOOR_EMISSIVE_START_LAYER 2.09
	#define FLOOR_EMISSIVE_END_LAYER 2.26
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
	// HIDING MOB
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
	// OBJ_LAYER 3
	#define ABOVE_OBJ_LAYER 3.01
	#define MOB_SHADOW_LAYER 3.011
	#define MOB_EMISSIVE_LAYER 3.012
	#define MOB_SHADOW_UPPER_LAYER 3.013
	#define HOLOMAP_OVERLAY_LAYER 3.02
	#define MOB_LOWER_FIRE_OVERLAY 3.03
	// LYING MOB AND HUMAN
	#define LYING_MOB_LAYER 3.07
	#define LYING_HUMAN_LAYER 3.08
	#define BASE_ABOVE_OBJ_LAYER 3.09
	// HUMAN
	#define BASE_HUMAN_LAYER 3.10
	// MOB_LAYER 4
	#define MOB_UPPER_FIRE_OVERLAY 4.01
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

	#define OBFUSCATION_LAYER 5.2
	// FLY_LAYER 5

	#define OVERMAP_SECTOR_LAYER 60
	#define OVERMAP_IMPORTANT_SECTOR_LAYER 61
	#define OVERMAP_SHIP_LAYER 62
	#define OVERMAP_SHUTTLE_LAYER 63

	#define AREA_LAYER 999

// LIGHTING_PLANE layers
#define LIGHTING_LAYER 1
#define O_LIGHTING_VISUAL_LAYER 16
#define LIGHTING_MASK_LAYER 10
#define LIGHTING_PRIMARY_LAYER 15
#define LIGHTING_PRIMARY_DIMMER_LAYER 15.1
#define LIGHTING_SECONDARY_LAYER 16
#define LIGHTING_SHADOW_LAYER 17
#define LIGHTING_ABOVE_ALL 20

// ABOVE_LIGHTING_PLANE layers
#define EYE_GLOW_LAYER 1
#define BEAM_PROJECTILE_LAYER 2
#define SUPERMATTER_WALL_LAYER 3
#define LIGHTNING_LAYER 4

// Emissive layers
#define EMISSIVE_LAYER_UNBLOCKABLE 9999

#define LIGHTING_BACKPLANE_LAYER 14.5

// Fullscreen image layers
#define FLASH_LAYER 1
#define FULLSCREEN_LAYER 2
#define DAMAGE_LAYER 2
#define UI_DAMAGE_LAYER 3
#define IMPAIRED_LAYER 3
#define BLIND_LAYER 4
#define CRIT_LAYER 5
#define CURSE_LAYER 6
#define ECHO_LAYER 7
#define PARRY_LAYER 8
#define MINIMAP_IMAGE_LAYER 9
#define MINIMAP_BLIPS_LAYER 10
#define MINIMAP_LOCATOR_LAYER 11
#define MINIMAP_LABELS_LAYER 12

#define FOV_EFFECT_LAYER 100

/// Bubble for typing indicators.
#define TYPING_LAYER 500

#define UNDER_HUD_LAYER 1
#define HUD_BASE_LAYER 2
#define HUD_BELOW_ITEM_LAYER 2.9
#define HUD_ITEM_LAYER 3
#define HUD_ABOVE_ITEM_LAYER 4
#define RADIAL_BACKGROUND_LAYER 5
#define RADIAL_BASE_LAYER 6
/// 1000 is an unimportant number, it is just to normalize copied layers.
#define RADIAL_CONTENT_LAYER 1000

#define ADMIN_POPUP_LAYER 1
#define SCREENTIP_LAYER 4
#define TUTORIAL_INSTRUCTIONS_LAYER 5
#define LIGHT_DEBUG_LAYER 6
#define PATH_ARROW_DEBUG_LAYER 7
#define PATH_DEBUG_LAYER 8

#define LOBBY_BELOW_MENU_LAYER 2
#define LOBBY_BACKGROUND_LAYER 3
#define LOBBY_MENU_LAYER 4
#define LOBBY_SHUTTER_LAYER 5
#define LOBBY_BOTTOM_BUTTON_LAYER 6

/// Cinematics are below the splash screen.
#define CINEMATIC_LAYER -1

/// Plane master controller keys.
#define PLANE_MASTERS_GAME "plane_masters_game"
#define PLANE_MASTERS_NON_MASTER "plane_masters_non_master"
#define PLANE_MASTERS_COLORBLIND "plane_masters_colorblind"

// Plane master critical flags.
#define PLANE_CRITICAL_DISPLAY (1<<0)
#define PLANE_CRITICAL_NO_RELAY (1<<1)
#define PLANE_CRITICAL_CUT_RENDER (1<<2)

#define PLANE_CRITICAL_FUCKO_PARALLAX (PLANE_CRITICAL_DISPLAY|PLANE_CRITICAL_NO_RELAY|PLANE_CRITICAL_CUT_RENDER)

// Plane master offsetting_flags.
#define BLOCKS_PLANE_OFFSETTING (1<<0)
#define OFFSET_RELAYS_MATCH_HIGHEST (1<<1)

/// A value of /datum/preference/numeric/multiz_performance that disables the option.
#define MULTIZ_PERFORMANCE_DISABLE -1
/// We expect at most 3 layers of multiz.
#define MAX_EXPECTED_Z_DEPTH 3

#define DEFAULT_APPEARANCE_FLAGS (PIXEL_SCALE)

#define DEFAULT_RENDERER_APPEARANCE_FLAGS (PLANE_MASTER | NO_CLIENT_COLOR)

/image/appearance_flags = DEFAULT_APPEARANCE_FLAGS

/atom/proc/hud_layerise()
	plane = HUD_PLANE
	layer = HUD_ITEM_LAYER

/image/proc/turf_decal_layerise()
	plane = FLOOR_PLANE
	layer = DECAL_LAYER

/image/proc/plating_decal_layerise()
	plane = FLOOR_PLANE
	layer = DECAL_PLATING_LAYER

/atom/proc/reset_plane_and_layer()
	plane = initial(plane)
	layer = initial(layer)
	return layer
