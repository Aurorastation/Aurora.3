/**
 * Authentik API
 *
 * This module handles the communication with the Authentik API.
 *
 * @see https://goauthentik.io/docs/api/
 */

/**
 * Authentik Groups
 *
 * Groups are used to determine what rights a user has.
 * The group with the highest priority is the primary group, which is used to determine the users's display rank.
 *
 * In Authentik the groups need to have the following attributes:
 * - gameserver.sync: boolean - Whether the group should be synced to the gameserver.
 * - gameserver.flags: list - The flags the group should have.
 * - priority: number - The priority of the group. The group with the highest priority is the primary group.
 */
/datum/authentik_group
	var/group_id		// pk from API
	var/group_name		// name from API
	var/sync_enabled	// attributes.gameserver.sync
	var/flags			// attributes.gameserver.flags
	var/priority		// attributes.priority (default 0)

/datum/authentik_group/New(data)
	// Parse API response
	group_id = data["pk"]
	group_name = data["name"]

	// Parse attributes
	var/list/attributes = data["attributes"]
	if (attributes)
		parse_attributes(attributes)

/datum/authentik_group/proc/parse_attributes(list/attributes)
	PRIVATE_PROC(TRUE)
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

/**
 * Authentik Users
 *
 * Need to have the following attributes:
 * - accounts.byond.ckey: string - The ckey of the user.
 *
 * The groups of the users are mapped using the group_ids list, which contains the group IDs of the groups the user is in.
 * The primary group is determined by the priority of the group. The group with the highest priority is the primary group.
 * The permissions of all groups the user is in are combined to determine the users's permissions.
 */
/datum/authentik_user
	var/user_id               /// pk from API
	var/username              /// username from API
	var/ckey                  /// attributes.accounts.byond.ckey
	var/list/group_ids        /// groups array from API
	var/primary_group_id      /// Determined by priority
	var/primary_group_name    /// Name of primary group

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
	PRIVATE_PROC(TRUE)
	// Extract BYOND ckey from nested attributes
	if (attributes["accounts"])
		var/list/accounts = attributes["accounts"]
		if (accounts["byond"])
			var/list/byond = accounts["byond"]
			ckey = byond["ckey"]

/**
 * Determines the primary group of the user based on the priority of the groups.
 * The group with the highest priority is the primary group.
 *
 * @returns string The name of the primary group.
 */
/datum/authentik_user/proc/determine_primary_group()
	// Find group with highest priority
	var/highest_priority = -1
	var/datum/authentik_group/primary = null

	for (var/datum/authentik_group/group in SSauth.authentik_groups)
		if (group.group_id in group_ids)
			if (group.priority > highest_priority)
				highest_priority = group.priority
				primary = group

	if (primary)
		primary_group_id = primary.group_id
		primary_group_name = primary.group_name
	else
		primary_group_name = "Administrator"  // Default
	return primary_group_name

/**
 * Aggregates the rights of all groups the user is in.
 *
 * @returns int The aggregated rights of the user.
 */
/datum/authentik_user/proc/aggregate_rights()
	// Aggregate rights from all groups user belongs to
	var/rights = 0

	for (var/datum/authentik_group/group in SSauth.authentik_groups)
		if (group.group_id in group_ids)
			rights |= SSauth.auths_to_rights(group.flags)

	return rights


/datum/http_request/authentik_api

/**
 * Prepares a query to fetch groups from the Authentik API.
 * Does not include users in the response.
 *
 * @param page The page number to fetch.
 */
/datum/http_request/authentik_api/proc/prepare_groups_query(page = 1)
	var/url = "[GLOB.config.authentik_api_url]/core/groups/?page=[page]&include_users=false"
	var/list/headers = list("Authorization" = "Bearer [GLOB.config.authentik_api_key]")
	prepare(RUSTG_HTTP_METHOD_GET, url, headers=headers)

/**
 * Prepares a query to fetch users from the Authentik API.
 * Optionally filters by group IDs.
 *
 * @param list/group_ids List of group IDs to filter by.
 * @param page The page number to fetch.
 */
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
