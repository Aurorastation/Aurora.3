/datum/authentik_group
	var/group_id          // pk from API
	var/group_name        // name from API
	var/sync_enabled      // attributes.gameserver.sync
	var/flags        // attributes.gameserver.flags
	var/priority          // attributes.priority (default 0)

/datum/authentik_group/New(data)
	// Parse API response
	group_id = data["pk"]
	group_name = data["name"]

	// Parse attributes
	var/list/attributes = data["attributes"]
	if (attributes)
		parse_attributes(attributes)


/datum/authentik_group/proc/parse_attributes(list/attributes)
	// Extract gameserver settings
	if (attributes["gameserver"])
		var/list/gameserver = attributes["gameserver"]
		sync_enabled = gameserver["sync"] ? TRUE : FALSE

		if (gameserver["flags"])
			flags = gameserver["flags"]
		else
			flags = list()
	else
		sync_enabled = FALSE
		flags = list()

	// Extract priority
	if (attributes["priority"])
		priority = text2num("[attributes["priority"]]")
	else
		priority = 0

/datum/authentik_group/proc/get_rights()
	// Convert flags array to rights bitmask
	// Reuse existing auths_to_rights logic
	var/datum/admin_rank/temp_rank = new()
	return temp_rank.auths_to_rights(flags)

/datum/authentik_user
	var/user_id               // pk from API
	var/username              // username from API
	var/ckey                  // attributes.accounts.byond.ckey
	var/list/group_ids        // groups array from API
	var/primary_group_id      // Determined by priority
	var/primary_group_name    // Name of primary group

/datum/authentik_user/New(data)
	// Parse API response
	user_id = data["pk"]
	username = data["username"]

	// Parse attributes
	var/list/attributes = data["attributes"]
	if (attributes)
		parse_attributes(attributes)

	// Parse groups
	if (data["groups"])
		group_ids = data["groups"]

/datum/authentik_user/proc/parse_attributes(list/attributes)
	// Extract BYOND ckey from nested attributes
	if (attributes["accounts"])
		var/list/accounts = attributes["accounts"]
		if (accounts["byond"])
			var/list/byond = accounts["byond"]
			ckey = byond["ckey"]

/datum/authentik_user/proc/determine_primary_group(list/datum/authentik_group/groups)
	// Find group with highest priority
	var/highest_priority = -1
	var/datum/authentik_group/primary = null

	for (var/datum/authentik_group/group in groups)
		if (group.group_id in group_ids)
			if (group.priority > highest_priority)
				highest_priority = group.priority
				primary = group

	if (primary)
		primary_group_id = primary.group_id
		primary_group_name = primary.group_name
	else
		primary_group_name = "Administrator"  // Default

/datum/authentik_user/proc/aggregate_rights(list/datum/authentik_group/groups)
	// Aggregate rights from all groups user belongs to
	var/rights = 0

	for (var/datum/authentik_group/group in groups)
		if (group.group_id in group_ids)
			rights |= group.get_rights()

	return rights

/datum/http_request/authentik_api

/datum/http_request/authentik_api/proc/prepare_groups_query(page = 1)
	var/url = "[GLOB.config.authentik_api_url]/core/groups/?page=[page]&include_users=false"
	var/list/headers = list("Authorization" = "Bearer [GLOB.config.authentik_api_key]")
	prepare(RUSTG_HTTP_METHOD_GET, url, headers=headers)

/datum/http_request/authentik_api/proc/prepare_users_query(list/group_ids, page = 1)
	// Build query string with group filters
	var/group_filter = ""
	if (length(group_ids))
		for (var/i = 1; i <= length(group_ids); i++)
			if (i > 1)
				group_filter += "&"
			group_filter += "groups_by_pk=[group_ids[i]]"

	var/url = "[GLOB.config.authentik_api_url]/core/users/?[group_filter]&page=[page]"
	var/list/headers = list("Authorization" = "Bearer [GLOB.config.authentik_api_key]")
	prepare(RUSTG_HTTP_METHOD_GET, url, headers=headers)

/datum/http_request/authentik_api/into_response()
	var/datum/http_response/R = ..()

	if (R.errored)
		return R

	try
		R.body = json_decode(R.body)
	catch
		R.errored = TRUE
		R.error = "Malformed JSON returned."
		return R

	// Note: Authentik returns paginated results
	// Body structure: {"pagination": {...}, "results": [...]}
	// We need to handle pagination in the calling code

	return R
