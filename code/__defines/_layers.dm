#define PLANE_SPACE_BACKGROUND -98
#define PLANE_SPACE_PARALLAX (PLANE_SPACE_BACKGROUND + 1) // -97
#define PLANE_SPACE_DUST (PLANE_SPACE_PARALLAX + 1) // -96
#define PLANE_ABOVE_PARALLAX (PLANE_SPACE_BACKGROUND + 3) // -95
#define PLANE_DEFAULT 0

#define LOWER_ON_TURF_LAYER (TURF_LAYER + 0.05)	// under the below
#define ON_TURF_LAYER (TURF_LAYER + 0.1)	// sitting on the turf - should be preferred over direct use of TURF_LAYER
#define AO_LAYER (ON_TURF_LAYER + 0.1)
#define PIPE_LAYER 2.4 //under wires with their 2.44
#define UNDER_PIPE_LAYER (PIPE_LAYER - 0.1)
#define CABLE_LAYER 2.44
#define ABOVE_CABLE_LAYER (CABLE_LAYER + 0.1)
#define DOOR_OPEN_LAYER 2.7		//Under all objects if opened. 2.7 due to tables being at 2.6
#define ABOVE_OBJ_LAYER 3.01
#define UNDERDOOR 3.09		//Just barely under a closed door.
#define DOOR_CLOSED_LAYER 3.1	//Above most items if closed
#define BELOW_MOB_LAYER 3.7
#define ABOVE_MOB_LAYER 4.1
#define ABOVE_ALL_MOB_LAYER 4.5
#define LIGHTING_LAYER 11
#define EFFECTS_ABOVE_LIGHTING_LAYER 12 // For overlays you want to be above light.
#define UNDER_HUD_LAYER 19
#define HUD_LAYER 20			//Above lighting, but below obfuscation. For in-game HUD effects (whereas SCREEN_LAYER is for abstract/OOC things like inventory slots)
#define OBFUSCATION_LAYER 21	//Where images covering the view for eyes are put
#define SCREEN_LAYER 22			//Mob HUD/effects layer
#define CINEMA_LAYER 23

#define LAYER_TABLE 2.8
#define LAYER_UNDER_TABLE 2.79
#define LAYER_ABOVE_TABLE 2.81

#define MECH_UNDER_LAYER            4
#define MECH_BASE_LAYER             4.01
#define MECH_HATCH_LAYER            4.02
#define MECH_HEAD_LAYER             4.03
#define MECH_EYES_LAYER             4.04
#define MECH_LEG_LAYER              4.05
#define MECH_ARM_LAYER              4.06
#define MECH_DECAL_LAYER            4.07
#define MECH_GEAR_LAYER             4.08
#define MECH_ABOVE_LAYER            4.09

// Blob Layers
#define BLOB_SHIELD_LAYER           4.11
#define BLOB_NODE_LAYER             4.12
#define BLOB_CORE_LAYER	            4.13

#define CLICKCATCHER_PLANE -100