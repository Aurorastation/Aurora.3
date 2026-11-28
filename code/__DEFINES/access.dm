#define ACCESS_REGION_NONE -1
#define ACCESS_REGION_ALL 0
#define ACCESS_REGION_SECURITY 1
#define ACCESS_REGION_MEDBAY 2
#define ACCESS_REGION_RESEARCH 3
#define ACCESS_REGION_ENGINEERING 4
#define ACCESS_REGION_COMMAND 5
#define ACCESS_REGION_GENERAL 6
#define ACCESS_REGION_SUPPLY 7

#define ACCESS_TYPE_NONE 0
#define ACCESS_TYPE_CENTCOM 1
#define ACCESS_TYPE_STATION 2
#define ACCESS_TYPE_SYNDICATE 4
#define ACCESS_TYPE_ALL (ACCESS_TYPE_CENTCOM|ACCESS_TYPE_STATION|ACCESS_TYPE_SYNDICATE)

/datum/access
	var/id = 0
	var/desc = ""
	var/region = ACCESS_REGION_NONE
	var/access_type = ACCESS_TYPE_STATION

/datum/access/proc/get_info_list()
	var/list/info = list()
	info["id"] = id
	info["desc"] = desc
	info["region"] = region
	info["access_type"] = access_type
	return info

/// Converts any `/datum/access` typepaths in a list into their numeric `::id` values.
/// Takes a mixed list like `list(42, ACCESS_SECURITY, /datum/access/horizon/security::id, /datum/access/horizon/armory)`.
/// Returns a list with only numeric IDs.
/proc/resolve_access_list(list/access_list)
	// if null or empty, do nothing
	if(!access_list)
		return access_list

	// copy prevents mutating lists shared across instances
	var/list/resolved = access_list.Copy()

	for(var/i in 1 to length(resolved))
		var/entry = resolved[i]

		// valid raw numeric ID
		if(isnum(entry))
			continue

		// valid access datum path
		if(ispath(entry, /datum/access))
			var/datum/access/acc_type = entry

			// abstract types should not be used
			#ifdef UNIT_TEST
			if(is_abstract(acc_type))
				dbg_stack_trace("resolve_access_list(): access path '[entry]' is abstract")
			#endif

			var/resolved_id = acc_type::id
			resolved[i] = resolved_id
			continue

		// neither a number nor a valid access typepath
		dbg_stack_trace("resolve_access_list(): item '[entry]' is neither number nor /datum/access path")

	return resolved
