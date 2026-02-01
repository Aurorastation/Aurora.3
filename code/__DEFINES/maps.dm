// traits
// boolean - marks a level as having that property if present
#define ZTRAIT_CENTCOM "CentCom"
#define ZTRAIT_STATION "Station"
#define ZTRAIT_RESERVED "Transit/Reserved"
#define ZTRAIT_AWAY "Away Mission"
/// boolean - does this z prevent ghosts from observing it
#define ZTRAIT_SECRET "Secret"
/* Aurora Snowflake */
#define ZTRAIT_OVERMAP "Overmap"
#define ZTRAIT_PLANET "Planet"

/// string - type path of the z-level's baseturf (defaults to space)
#define ZTRAIT_BASETURF "Baseturf"

// number - default gravity if there's no gravity generators or area overrides present
#define ZTRAIT_GRAVITY "Gravity"

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

// A map key that corresponds to being one exclusively for Space.
#define SPACE_KEY "space"

// default trait definitions, used by SSmapping
///Z level traits for CentCom
#define ZTRAITS_CENTCOM list(ZTRAIT_CENTCOM = TRUE, ZTRAIT_NOPHASE = TRUE)
///Z level traits for Space Station 13
#define ZTRAITS_STATION list(ZTRAIT_LINKAGE = CROSSLINKED, ZTRAIT_STATION = TRUE)
///Z level traits for Away Missions
#define ZTRAITS_AWAY list(ZTRAIT_AWAY = TRUE)
///Z level traits for Secret Away Missions
#define ZTRAITS_AWAY_SECRET list(ZTRAIT_AWAY = TRUE, ZTRAIT_SECRET = TRUE, ZTRAIT_NOPHASE = TRUE)
///Z level traits for Overmap
#define ZTRAITS_OVERMAP list(ZTRAIT_OVERMAP = TRUE, ZTRAIT_LINKAGE = SELFLOOPING)
///Z level traits for Exoplanets
#define ZTRAITS_PLANET(planet) list(ZTRAIT_PLANET = TRUE, ZTRAIT_LINKAGE = SELFLOOPING, ZTRAIT_BASETURF = (planet.turftype || /turf/simulated/floor/exoplanet))

#define DL_NAME "name"
#define DL_TRAITS "traits"
#define DECLARE_LEVEL(NAME, TRAITS) list(DL_NAME = NAME, DL_TRAITS = TRAITS)

#define RESERVED_TURF_TYPE /turf/space //What the turf is when not being used

// must correspond to _basemap.dm for things to work correctly
#define DEFAULT_MAP_TRAITS list()
