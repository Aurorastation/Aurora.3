// Tool types, as used by the obj/item variable 'tool_behaviour'. These are strings and not bitfields, because even
// though some objects logically could function as multiple tools simultaneously, the 'tool_behaviour' variable describes
// current intention, not functionality. For an item that can function as multiple tools, it must have a mechanism to switch
// between intended tool types.
#define TOOL_CROWBAR "crowbar"
#define TOOL_MULTITOOL "multitool"
#define TOOL_SCREWDRIVER "screwdriver"
#define TOOL_WIRECUTTER "cutters"
#define TOOL_WRENCH "wrench"
#define TOOL_PIPEWRENCH "pipe wrench"
#define TOOL_WELDER "welder"
#define TOOL_ANALYZER "analyzer"
#define TOOL_MINING "mining"
#define TOOL_SHOVEL "shovel"
#define TOOL_RETRACTOR "retractor"
#define TOOL_HEMOSTAT "hemostat"
#define TOOL_CAUTERY "cautery"
#define TOOL_DRILL "drill"
#define TOOL_SCALPEL "scalpel"
#define TOOL_SAW "saw"
#define TOOL_BONESET "bonesetter"
#define TOOL_KNIFE "knife"
#define TOOL_BLOODFILTER "bloodfilter"
#define TOOL_ROLLINGPIN "rolling pin"
#define TOOL_CABLECOIL "cable coil"
#define TOOL_HAMMER "hammer"
#define TOOL_PEN "pen"

/**
 * The "default value" a tool quality should be. Lower than this means a worse tool, higher than this means a better tool.
 * This is a floating point. I'm not making any more defines than this, tool quality can be any real number between +/- INFINITY.
 */
#define STANDARD_TOOL_LEVEL 3.0

// If delay between the start and the end of tool operation is less than MIN_TOOL_SOUND_DELAY,
// tool sound is only played when op is started. If not, it's played twice.
#define MIN_TOOL_SOUND_DELAY 20
#define MIN_TOOL_OPERATING_DELAY 40 //minimum delay for operating sound. Prevent overlaps and overhand sound.
/// Return when an item interaction is successful.
/// This cancels the rest of the chain entirely and indicates success.
#define ITEM_INTERACT_SUCCESS (1<<0) // Same as TRUE, as most tool (legacy) tool acts return TRUE on success
/// Return to prevent the rest of the attack chain from being executed / preventing the item user from thwacking the target.
/// Similar to [ITEM_INTERACT_SUCCESS], but does not necessarily indicate success.
#define ITEM_INTERACT_BLOCKING (1<<1)
	/// Only for people who get confused by the naming scheme
	#define ITEM_INTERACT_FAILURE ITEM_INTERACT_BLOCKING
/// Return to skip the rest of the interaction chain, going straight to attack.
#define ITEM_INTERACT_SKIP_TO_ATTACK (1<<2)

/// Combination flag for any item interaction that blocks the rest of the attack chain
#define ITEM_INTERACT_ANY_BLOCKER (ITEM_INTERACT_SUCCESS | ITEM_INTERACT_BLOCKING)

/// How many seconds between each fuel depletion tick ("use" proc)
#define TOOL_FUEL_BURN_INTERVAL 5

///This is a number I got by quickly searching up the temperature to melt iron/glass, though not really realistic.
///This is used for places where lighters should not be hot enough to be used as a welding tool on.
#define HIGH_TEMPERATURE_REQUIRED 1500

/**
 * A helper for checking if an item interaction should be skipped.
 * This is only used explicitly because some interactions may not want to ever be skipped.
 */
#define SHOULD_SKIP_INTERACTION(target, item, user) (HAS_TRAIT(target, TRAIT_COMBAT_MODE_SKIP_INTERACTION) && user.combat_mode)

// Used by the decal painter to get information about the decal being painted
/// Icon state to paint
#define DECAL_INFO_ICON_STATE "icon_state"
/// Color to paint the decal with
#define DECAL_INFO_COLOR "color"
/// Dir of the decal sprite
#define DECAL_INFO_DIR "dir"
/// Alpha of the decal
#define DECAL_INFO_ALPHA "alpha"

/obj/proc/issurgerycompatible() // set to false for things that are too unwieldy for surgery
	return TRUE

/proc/check_tool_quality(var/obj/item/tool, var/quality, var/return_value, var/requires_surgery_compatibility = FALSE)
	if(quality == tool.tool_behaviour && (!requires_surgery_compatibility || tool.issurgerycompatible()))
		return return_value

	return null

/**
 * Retrieves the given tool level from a target, which can either be null (logically 0 if you're doing math) or an actual number.
 * This can safely be used in math equations, but is slow if you need more than one tool check. Do not ever divide by this or use it in a ternary operator.
 * Use GET_TOOL_QUALITIES(target) instead if you are checking bulk tool qualities.
 */
#define GET_TOOL_LEVEL(target, tool) astype(target.GetComponent(/datum/component/tool_quality_container), /datum/component/tool_quality_container)?.tool_qualities[tool]

/**
 * Retrieves an associative list of all of a target's tool qualities, if any.
 * You should still null check this before using it.
 * This is not safe to drop-in to math equations.
 * Use GET_TOOL_LEVEL(target, tool) instead if you only need one numerical tool level.
 */
#define GET_TOOL_QUALITIES(target) astype(target.GetComponent(/datum/component/tool_quality_container), /datum/component/tool_quality_container)?.tool_qualities

/**
 * The primary intended method of INITIALIZING tool qualities.
 * This will declare a variable as per outvar which is typed as a /datum/component/tool_quality_container,
 * and since this variable works via LoadComponent, it will NEVER require null checking.
 *
 * Beware that this macro will erase any pre-existing tool qualities if present, so don't use it outside of Initialize().
 * If you want to change tool qualities AFTER initializing, do so via SET_TOOL_QUALITIES.
 */
#define LOAD_TOOL_QUALITIES(target, qualities, outvar) \
	var/datum/component/tool_quality_container/outvar = target.LoadComponent(/datum/component/tool_quality_container); \
	outvar.tool_qualities = qualities

/**
 * A variant of LOAD_TOOL_QUALITIES that will set the matching key/value pairs for an item's tool qualities to a defined set.
 * EG: Item A has qualities "TOOL_CROWBAR = 3, TOOL_MULTITOOL = 1", and I call SET_TOOL_QUALITIES(src, alist(TOOL_MULTITOOL = 5, TOOL_SCALPEL = 1), toolComp)
 * Then the it will have the qualities Crowbar 3, Multitool 5, Scalpel 1.
 */
#define SET_TOOL_QUALITIES(target, qualities, outvar) \
	var/datum/component/tool_quality_container/outvar = target.LoadComponent(/datum/component/tool_quality_container); \
	for(var/key, value in qualities) \
		outvar.tool_qualities[key] = value
