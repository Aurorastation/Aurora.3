/*
	This module is used to generate the debris fields/distribution maps/procedural stations.
*/

#define MIN_SURFACE_COUNT 500
#define MIN_RARE_COUNT 200
#define MIN_DEEP_COUNT 100
#define RESOURCE_HIGH_MAX 4
#define RESOURCE_HIGH_MIN 2
#define RESOURCE_MID_MAX 3
#define RESOURCE_MID_MIN 1
#define RESOURCE_LOW_MAX 1
#define RESOURCE_LOW_MIN 0

#define FLOOR_CHAR 0
#define WALL_CHAR 1
#define DOOR_CHAR 2
#define EMPTY_CHAR 3
#define ROOM_TEMP_CHAR 4
#define MONSTER_CHAR 5
#define ARTIFACT_TURF_CHAR 6
#define ARTIFACT_CHAR 7

#define TRANSLATE_COORD(X,Y) ((((Y) - 1) * limit_x) + (X))
#define TRANSLATE_AND_VERIFY_COORD(X,Y) TRANSLATE_AND_VERIFY_COORD_MLEN(X,Y,map.len)

#define TRANSLATE_AND_VERIFY_COORD_MLEN(X,Y,LEN) \
	tmp_cell = TRANSLATE_COORD(X,Y);\
	if (tmp_cell < 1 || tmp_cell > LEN) {\
		tmp_cell = null;\
	}
