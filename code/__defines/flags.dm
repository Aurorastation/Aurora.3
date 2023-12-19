var/global/list/bitflags = list(1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768)

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

//EMP protection
#define EMP_PROTECT_SELF (1<<0)
#define EMP_PROTECT_CONTENTS (1<<1)
#define EMP_PROTECT_WIRES (1<<2)

// Flags bitmask

/// If a dense atom (potentially) only blocks movements from a given direction, i.e. window panes
#define ATOM_FLAG_CHECKS_BORDER FLAG(1)
/// Used for atoms if they don't want to get a blood overlay.
#define ATOM_FLAG_NO_BLOOD FLAG(2)
/// Reagents do not react in this containers
#define ATOM_FLAG_NO_REACT FLAG(3)
/// Is an open container for chemistry purposes
#define ATOM_FLAG_OPEN_CONTAINER FLAG(4)
/// Reagent container that can pour its contents with a lid on. only used for syrup bottles for now
#define ATOM_FLAG_POUR_CONTAINER FLAG(5)
/// Should we use the initial icon for display? Mostly used by overlay only objects
#define ATOM_FLAG_HTML_USE_INITIAL_ICON FLAG(6)

// Movable flags.

/// Does this object require proximity checking in Enter()?
#define MOVABLE_FLAG_PROXMOVE FLAG(1)
///Is this an effect that should move?
#define MOVABLE_FLAG_EFFECTMOVE FLAG(2)
///Shuttle transition will delete this.
#define MOVABLE_FLAG_DEL_SHUTTLE FLAG(3)

// Obj flags

/// Can this object be rotated?
#define OBJ_FLAG_ROTATABLE FLAG(0)
/// This object can be rotated even while anchored
#define OBJ_FLAG_ROTATABLE_ANCHORED FLAG(1)
/// Can this take a signaler? only in use for machinery
#define OBJ_FLAG_SIGNALER FLAG(2)
/// Will prevent mobs from falling
#define OBJ_FLAG_NOFALL FLAG(3)
/// Object moves with shuttle transition even if turf below is a background turf.
#define OBJ_FLAG_MOVES_UNSUPPORTED FLAG(4)
#define OBJ_FLAG_CONDUCTABLE FLAG(5)

// Item flags
/// When an item has this it produces no "X has been hit by Y with Z" message with the default handler.
#define ITEM_FLAG_NO_BLUDGEON FLAG(0)
/// Does not get contaminated by phoron.
#define ITEM_FLAG_PHORON_GUARD FLAG(1)
/// Prevents syringes, parapens and hyposprays if equiped to slot_suit or slot_head.
#define ITEM_FLAG_THICK_MATERIAL FLAG(2)
/// Functions with internals
#define ITEM_FLAG_AIRTIGHT FLAG(3)
///Prevents from slipping on wet floors, in space, etc.
#define ITEM_FLAG_NO_SLIP FLAG(4)
/// Blocks the effect that chemical clouds would have on a mob -- glasses, mask and helmets ONLY! (NOTE: flag shared with ONESIZEFITSALL)
#define ITEM_FLAG_BLOCK_GAS_SMOKE_EFFECT FLAG(5)
/// At the moment, masks with this flag will not prevent eating even if they are covering your face.
#define ITEM_FLAG_FLEXIBLE_MATERIAL FLAG(6)
/// Allows syringes and hyposprays to inject, even if the material is thick
#define ITEM_FLAG_INJECTION_PORT FLAG(7)
/// When applied to footwear, this makes it so that they don't trigger things like landmines and mouse traps
#define ITEM_FLAG_LIGHT_STEP FLAG(8)
/// whether wearing this item will protect you from loud noises such as flashbangs | this only works for ear slots or the head slot
#define ITEM_FLAG_SOUND_PROTECTION FLAG(9)
/// won't block flavourtext when worn on equipment slot
#define ITEM_FLAG_SHOW_FLAVOR_TEXT FLAG(10)
/// Uses the special held maptext system, which sets a specific maptext if the item is in possession of a mob.
#define ITEM_FLAG_HELD_MAP_TEXT FLAG(11)
/// Cannot be moved from its current inventory slot. Mostly for augments, modules, and other "attached" items.
#define ITEM_FLAG_NO_MOVE FLAG(12)
