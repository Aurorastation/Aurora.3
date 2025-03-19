/datum/map_template/ruin
	//name = "A Chest of Doubloons"
	name = null
	var/description = "In the middle of a clearing in the rockface, there's a chest filled with gold coins with Spanish engravings. \
	How is there a wooden container filled with 18th century coinage in the middle of a lavawracked hellscape? \
	It is clearly a mystery."

	/// Spawn weight.
	var/spawn_weight = 1
	/// Sector-dependent `spawn_weight` override, changing the weight based on sector.
	/// Should be assoc list in the form of `= list(X=N)`, where `X` is either a single sector string like `SECTOR_TAU_CETI`
	/// or a list (of lists) like `ALL_POSSIBLE_SECTORS` which will be flattened later, and where `N` is the weight override like `1` or `2`.
	/// Setting weight overrides for blacklisted sectors is valid, and `sectors` and `sectors_blacklist` are respected still.
	/// If current sector is not contained in this assoc list, then `spawn_weight` is not overriden and is used as default value.
	/// The first matching sector override is applied and further ones are not checked.
	var/list/spawn_weight_sector_dependent = list()

	/// Spawn cost, to be used by ruins or sites *WITHOUT* any ghost roles.
	var/spawn_cost = 0
	/// Spawn cost, to be used by ruins or sites *WITH* ghost roles.
	var/ship_cost = 0
	/// Unused?
	var/player_cost = 0

	/**
	 * This ruin can only spawn in the sectors in this list
	 *
	 * Should contain names of sectors as defined in `code\__DEFINES\space_sectors.dm`
	 *
	 * This list is flattened so it can contain nested lists, eg `ALL_POSSIBLE_SECTORS`
	 */
	var/list/sectors = list()

	/**
	 * Sectors in this list are removed from the `sectors` list
	 *
	 * Usage is same as of `sectors`
	 *
	 * It allows to, for example, set `sectors` to `ALL_POSSIBLE_SECTORS` and then disallow it in specific ones
	 */
	var/list/sectors_blacklist = list()

	/**
	 * Static part of the ruin path, ie the folder
	 * have to start without a slash, and end with a slash
	 *
	 * eg. `away_site/`
	 *
	 * Gets combined with the other prefixes in the inheritance tree
	 * (under /New()) to form the relative path from the root of the codebase
	 * to the folder this ruin is in
	 *
	 * If you implement a subtype of another subtype, it is *your* responsibility to
	 * ensure that `/New()` chains the path correctly
	 */
	var/prefix = null

	/**
	 * The dynamic part of the ruin path, ie the file
	 * eg. `my_awesome_ruin.dmm`
	 *
	 * Gets combined with the prefix to form the path to the map file, that are loaded when the ruin loads
	 */
	var/suffix = null

	/// Template flags for this ruin
	template_flags = TEMPLATE_FLAG_NO_RUINS

	///Listed ruins are always spawned unless disallowed by flags
	var/list/force_ruins

	//Listed ruins are added to the set of available spawns
	var/list/allow_ruins

	///Listed ruins are removed from the set of available spawns
	var/list/ban_ruins

/**
 * Ensure to call the parent constructor *last*
 *
 * If you have subtypes and you change the `prefix`, it is *your* responsibility to
 * chain your changed `prefix` here, before calling the parent constructor
 */
/datum/map_template/ruin/New(var/list/paths = null, rename = null)
	// get the map paths
	if (suffix)
		mappath = (prefix + suffix)

	// set up sectors
	sectors = flatten_list(sectors)
	sectors_blacklist = flatten_list(sectors_blacklist)
	sectors.RemoveAll(sectors_blacklist)

	// adjust weight from sector dependent override
	var/datum/space_sector/current_sector = SSatlas.current_sector
	if(current_sector && spawn_weight_sector_dependent)
		for(var/sectors in spawn_weight_sector_dependent)
			var/weight_in_sector = spawn_weight_sector_dependent[sectors]
			var/list/sectors_flattened = flatten_list(list(sectors))
			if(current_sector.name in sectors_flattened)
				spawn_weight = weight_in_sector
				break

	// fin
	..()

/// Returns `TRUE` if this ruin can spawn in current sector, otherwise `FALSE`.
/datum/map_template/ruin/proc/spawns_in_current_sector()
	return (SSatlas.current_sector.name in sectors)
