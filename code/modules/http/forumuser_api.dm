var/global/forumuser_api_key = null

/datum/forum_user
	var/forum_member_id
	var/forum_name
	var/forum_primary_group
	var/list/forum_secondary_groups = list()
	var/discord_id
	var/ckey
	var/psync_game_disabled = FALSE

/datum/forum_user/New(data)
	forum_member_id = data["forum_member_id"]
	forum_name = data["forum_name"]
	forum_primary_group = data["forum_primary_group"]

	for (var/id in splittext(data["forum_secondary_groups"], ","))
		forum_secondary_groups += text2num(id)

	discord_id = data["discord_id"]
	ckey = data["ckey"]
	if(data["psync_game_disabled"] == 1) //This here is needed because the data can be null, 1 or 0
		psync_game_disabled = TRUE

/datum/http_request/forumuser_api

/datum/http_request/forumuser_api/proc/prepare_roles_query(role_id)
	var/url = "[config.forumuser_api_url]/staff/[role_id]"

	var/list/headers = list("Authorization" = "Bearer [forumuser_api_key]")

	prepare(RUSTG_HTTP_METHOD_GET, url, headers=headers)

/datum/http_request/forumuser_api/proc/prepare_user_discord(discord_id)
	var/url = "[config.forumuser_api_url]/user/discord/[discord_id]"

	var/list/headers = list("Authorization" = "Bearer [forumuser_api_key]")

	prepare(RUSTG_HTTP_METHOD_GET, url, headers=headers)

/datum/http_request/forumuser_api/proc/prepare_user_ckey(ckey)
	var/url = "[config.forumuser_api_url]/user/ckey/[ckey]"

	var/list/headers = list("Authorization" = "Bearer [forumuser_api_key]")

	prepare(RUSTG_HTTP_METHOD_GET, url, headers=headers)

/datum/http_request/forumuser_api/into_response()
	var/datum/http_response/R = ..()

	if (R.errored)
		return R

	try
		R.body = json_decode(R.body)
	catch
		R.errored = TRUE
		R.error = "Malformed JSON returned."
		return R

	var/list/users = list()
	for (var/d in R.body)
		users += new /datum/forum_user(d)

	R.body = users

	return R
