// Movable flags.
#define MOVABLE_FLAG_EFFECTMOVE       1 //Is this an effect that should move?
#define MOVABLE_FLAG_DEL_SHUTTLE      2 //Shuttle transition will delete this.

#define TURF_IS_MIMICING(T) (isturf(T) && (T:z_flags & ZM_MIMIC_BELOW))
#define CHECK_OO_EXISTENCE(OO) if (OO && !TURF_IS_MIMICING(OO.loc)) { qdel(OO); }
#define UPDATE_OO_IF_PRESENT CHECK_OO_EXISTENCE(bound_overlay); if (bound_overlay) { update_above(); }

// Turf MZ flags.
#define ZM_MIMIC_BELOW     1	// If this turf should mimic the turf on the Z below.
#define ZM_MIMIC_OVERWRITE 2	// If this turf is Z-mimicing, overwrite the turf's appearance instead of using a movable. This is faster, but means the turf cannot have its own appearance (say, edges or a translucent sprite).
#define ZM_ALLOW_ATMOS     4	// If this turf permits passage of air.
#define ZM_MIMIC_NO_AO    8	// If the turf shouldn't apply regular turf AO and only do Z-mimic AO.
#define ZM_NO_OCCLUDE     16	// Don't occlude below atoms if we're a non-mimic z-turf.

// Convenience flag.
#define ZM_MIMIC_DEFAULTS (ZM_MIMIC_BELOW)

// For debug purposes, should contain the above defines in ascending order.
var/list/mimic_defines = list(
	"ZM_MIMIC_BELOW",
	"ZM_MIMIC_OVERWRITE",
	"ZM_ALLOW_LIGHTING",
	"ZM_ALLOW_ATMOS",
	"ZM_MIMIC_NO_AO",
	"ZM_NO_OCCLUDE"
)

#define OVERMAP_SECTOR_BASE              1 // Whether or not this sector is a starting sector. Z levels contained in this sector are added to station_levels
#define OVERMAP_SECTOR_KNOWN             2 // Makes the sector show up on nav computers
#define OVERMAP_SECTOR_IN_SPACE          4 // If the sector can be accessed by drifting off the map edge
#define OVERMAP_SECTOR_UNTARGETABLE      8 // If the sector is untargetable by missiles
