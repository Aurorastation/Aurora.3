/datum/map_template/ruin
	//name = "A Chest of Doubloons"
	name = null
	var/description = "In the middle of a clearing in the rockface, there's a chest filled with gold coins with Spanish engravings. \
	How is there a wooden container filled with 18th century coinage in the middle of a lavawracked hellscape? \
	It is clearly a mystery."

	var/spawn_weight = 1
	var/spawn_cost = 0
	var/player_cost = 0
	var/ship_cost = 0

	/// This ruin can only spawn in the sectors in this list.
	/// Should contain names of sectors as defined in `space_sectors.dm`.
	/// This list is flattened so it can contain nested lists like, for example, `ALL_POSSIBLE_SECTORS`.
	var/list/sectors = list()
	/// Sectors in this list are removed from the `sectors` list.
	/// Usage is same as of `sectors`.
	/// Intention is to allow to, for example, set `sectors` to `ALL_POSSIBLE_SECTORS`,
	/// but then disallow just one sector from that list.
	var/list/sectors_blacklist = list()

	/// Prefix part of the path to the dmm maps.
	var/prefix = null
	/// A list of suffix parts of paths of the dmm maps.
	/// Combined with prefix to get the actual path.
	var/list/suffixes = null

	/// Template flags for this ruin
	template_flags = TEMPLATE_FLAG_NO_RUINS

	// !! Currently only implemented for away sites
	var/list/force_ruins // Listed ruins are always spawned unless disallowed by flags.
	var/list/allow_ruins // Listed ruins are added to the set of available spawns.
	var/list/ban_ruins   // Listed ruins are removed from the set of available spawns. Beats allowed.

/datum/map_template/ruin/New()
	if (suffixes)
		mappaths = list()
		for (var/suffix in suffixes)
			mappaths += (prefix + suffix)
	sectors = flatten_list(sectors)
	sectors_blacklist = flatten_list(sectors_blacklist)
	sectors -= sectors_blacklist
	..()

/// Returns true if this ruin can spawn in current sector, otherwise false.
/datum/map_template/ruin/proc/spawns_in_current_sector()
	return (SSatlas.current_sector.name in sectors)
