// Planes & Layers definition file.
// Please #define planes/layers here instead of using numbers in code.

#define PLANE_SPACE -20

#define PLANE_BELOW_PLATING -16
#define PLANE_PLATING -15	// Plating.
	#define LAYER_ATOM 0	
	#define LAYER_MOVABLE 1
#define PLANE_ABOVE_PLATING -12
	#define LAYER_PIPE_DISPOSAL 1
	#define LAYER_PIPE_SCRUBBER 2
	#define LAYER_PIPE_SUPPLY 3
	#define LAYER_PIPE_GENERIC 4
	#define LAYER_PIPE_SPECIALIZED 5
	#define LAYER_PIPE_HE 5
	#define LAYER_WIRE 6
	#define LAYER_WIRE_KNOT 7
	#define LAYER_WIRE_TERMINAL 8
	#define LAYER_UNDERFLOOR_DEVICE 9
	#define LAYER_FLOOR 10
	#define LAYER_FLOOR_LIGHT 11

#define PLANE_WALL	-14

// Stuff above floor tiles/turfs.
#define PLANE_ABOVE_FLOOR -13		
	#define LAYER_FLOOR_PAINT 1		// Stuff painted on floors, like decals.
	#define LAYER_FLOOR_BLOOD 2		// Blood & Oil.
	#define LAYER_ATMOS_UNARY 3
	#define LAYER_FLOOR_DEVICE 3

// Mobs hiding under objects.
#define PLANE_HIDING_MOB -12

// Objects that are not mobs.
#define PLANE_OBJECT -11
	#define LAYER_DOOR_OPEN 1
	#define LAYER_UNDER_DOOR 2
	#define LAYER_DOOR 3
	#define LAYER_OVER_DOOR 4
	#define LAYER_FOAM 5

#define PLANE_LYING_MOB -10

#define PLANE_COVER_LYING -9

#define PLANE_MOB_GENERIC -8
	#define LAYER_GENERIC 1
	#define LAYER_MECHA 2

#define PLANE_MOB_HUMAN -7

// Objects that should cover human mobs and objects.
#define PLANE_OBJECT_COVER -6
#define PLANE_OBJECT_OVERHEAD -6

#define PLANE_EFFECTS -5

#define PLANE_HUD_ANTAG -4

#define PLANE_HUD_HEALTH -3
	#define LAYER_HUD_HEALTH_BAR 1
	#define LAYER_HUD_HEALTH_STATUS 2 

// generally only want one of these two
#define PLANE_HUD_SECURITY_BASIC -2
#define PLANE_HUD_SECURITY_FULL -2
	#define LAYER_HUD_SECURITY_JOB 1
	#define LAYER_HUD_SECURITY_LOYALTY 2
	#define LAYER_HUD_SECURITY_TRACKING 3
	#define LAYER_HUD_SECURITY_STATUS 4

#define PLANE_LIGHTING -1
	#define LAYER_LIGHTING 1
	#define LAYER_OBFUSCATE 2
	#define LAYER_OVER_LIGHTING 3
	

// Default BYOND plane.
// Use planes below zero for world objects & turfs, 
// and planes above zero for UI elements & effects.
// Avoid usage of plane zero itself if possible.
// Anything that does not have its plane explicitly set goes here.
// Fog of War also (should) render on this plane.
#define PLANE_BASE 0

// User HUD should be above zero.

#define PLANE_AI_STATIC 1
// For full-screen effects like flash, blind, crit.
#define PLANE_OVERLAY 2
	#define LAYER_OVERLAY_DRUGGY 1
	#define LAYER_OVERLAY_BLURRY 1
	#define LAYER_OVERLAY_GENERIC 2 
	#define LAYER_OVERLAY_FLASH 3
	#define LAYER_OVERLAY_DMG 4

#define PLANE_AI_HUD 3
	#define LAYER_AI_BUTTON 1

// UI crap like inventory.
#define PLANE_HUD 3
	#define LAYER_HUD_GENERIC 1		// 19
	#define LAYER_HUD_INV_BG 1
	#define LAYER_HUD_BUTTON 2		// 20
	#define LAYER_HUD_INV_ITEM 2	// also 20
	#define LAYER_HUD_INTENT_BTN 3	// 21?

// It gets its own snowflake plane.
#define PLANE_CINEMATIC 4
	#define LAYER_CINEMATIC 1

// ???
#define PLANE_SPECIAL 10
	#define LAYER_AREA 1
	#define LAYER_MARK 2
