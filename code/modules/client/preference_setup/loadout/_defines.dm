#define GEAR_NO_SELECTION BITFLAG(0)
#define GEAR_HAS_COLOR_SELECTION BITFLAG(1)
#define GEAR_HAS_ALPHA_SELECTION BITFLAG(2)
#define GEAR_HAS_ACCENT_COLOR_SELECTION BITFLAG(3)
#define GEAR_HAS_NAME_SELECTION BITFLAG(4)
#define GEAR_HAS_DESC_SELECTION BITFLAG(5)
#define GEAR_HAS_COLOR_ROTATION_SELECTION BITFLAG(6)

// Loadout tag groups. Each group is a header in the loadout UI containing its tags.
#define LOADOUT_TAG_GROUP_CATEGORY "Category"
#define LOADOUT_TAG_GROUP_SLOT "Item Slot"
#define LOADOUT_TAG_GROUP_FACTION "Faction"
#define LOADOUT_TAG_GROUP_ORIGIN "Origin Restriction"
#define LOADOUT_TAG_GROUP_ROLE "Allowed Role"
#define LOADOUT_TAG_GROUP_DEPARTMENT "Department"
#define LOADOUT_TAG_GROUP_SPECIES "Species Restriction"

// Helper tags for gear without a given restriction. They share the group with the actual restriction tags, so they are mutually exclusive.
#define LOADOUT_TAG_NO_FACTION "No Faction Restriction"
#define LOADOUT_TAG_NO_ORIGIN "No Origin Restriction"
#define LOADOUT_TAG_NO_ROLE "No Role Restriction"
#define LOADOUT_TAG_NO_DEPARTMENT "No Department Restriction"
#define LOADOUT_TAG_NO_SPECIES "No Species Restriction"
