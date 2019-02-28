#define PLANE_SPACE_BACKGROUND -98
#define PLANE_SPACE_PARALLAX (PLANE_SPACE_BACKGROUND + 1) // -97
#define PLANE_SPACE_DUST (PLANE_SPACE_PARALLAX + 1) // -96
#define PLANE_ABOVE_PARALLAX (PLANE_SPACE_BACKGROUND + 3) // -95


#define LOWER_ON_TURF_LAYER (TURF_LAYER + 0.05)	// under the below
#define ON_TURF_LAYER (TURF_LAYER + 0.1)	// sitting on the turf - should be preferred over direct use of TURF_LAYER
#define AO_LAYER (ON_TURF_LAYER + 0.1)
#define PIPE_LAYER 2.4 //under wires with their 2.44
#define CABLE_LAYER 2.44
#define ABOVE_CABLE_LAYER (CABLE_LAYER + 0.1)
#define DOOR_OPEN_LAYER 2.7		//Under all objects if opened. 2.7 due to tables being at 2.6
#define UNDERDOOR 3.09		//Just barely under a closed door.
#define DOOR_CLOSED_LAYER 3.1	//Above most items if closed
#define BELOW_MOB_LAYER 3.7
#define ABOVE_MOB_LAYER 4.1
#define LIGHTING_LAYER 11
#define HUD_LAYER 20			//Above lighting, but below obfuscation. For in-game HUD effects (whereas SCREEN_LAYER is for abstract/OOC things like inventory slots)
#define OBFUSCATION_LAYER 21	//Where images covering the view for eyes are put
#define SCREEN_LAYER 22			//Mob HUD/effects layer
