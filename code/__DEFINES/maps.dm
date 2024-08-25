// traits
// boolean - marks a level as having that property if present
#define ZTRAIT_CENTCOM "CentCom"
#define ZTRAIT_STATION "Station"
#define ZTRAIT_RESERVED "Transit/Reserved"
#define ZTRAIT_AWAY "Away Mission"
/* Aurora Snowflake */
#define ZTRAIT_OVERMAP "Overmap"
#define ZTRAIT_EXPLANET "Exoplanet"


// Whether this z level is linked up/down. Bool.
#define ZTRAIT_UP "Up"
#define ZTRAIT_DOWN "Down"

// enum - how space transitions should affect this level
#define ZTRAIT_LINKAGE "Linkage"
	// UNAFFECTED if absent - no space transitions
	#define UNAFFECTED null
	// SELFLOOPING - space transitions always self-loop
	#define SELFLOOPING "Self"
	// CROSSLINKED - mixed in with the cross-linked space pool
	#define CROSSLINKED "Cross"

// default trait definitions, used by SSmapping
///Z level traits for CentCom
#define ZTRAITS_CENTCOM list(ZTRAIT_CENTCOM = TRUE, ZTRAIT_NOPHASE = TRUE)
///Z level traits for Space Station 13
#define ZTRAITS_STATION list(ZTRAIT_LINKAGE = CROSSLINKED, ZTRAIT_STATION = TRUE)
///Z level traits for Away Missions
#define ZTRAITS_AWAY list(ZTRAIT_AWAY = TRUE)
///Z level traits for Overmap
#define ZTRAITS_OVERMAP list(ZTRAIT_OVERMAP = TRUE, ZTRAIT_LINKAGE = SELFLOOPING)
///Z level traits for Exoplanets
#define ZTRAITS_EXPLANET list(ZTRAIT_EXPLANET = TRUE, ZTRAIT_LINKAGE = SELFLOOPING)

#define DL_NAME "name"
#define DL_TRAITS "traits"
#define DECLARE_LEVEL(NAME, TRAITS) list(DL_NAME = NAME, DL_TRAITS = TRAITS)

// must correspond to _basemap.dm for things to work correctly
#define DEFAULT_MAP_TRAITS list(\
	DECLARE_LEVEL("CentCom", ZTRAITS_CENTCOM),\
)
