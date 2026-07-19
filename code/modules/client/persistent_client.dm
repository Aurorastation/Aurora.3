/// Tracks same-round information that should survive client disconnects and mob swaps.
/datum/persistent_client
	/// Canonical ckey for this same-round state.
	var/ckey
	/// The currently connected client, if any.
	var/client/client
	/// The mob currently associated with this ckey.
	var/mob/mob
	/// Major version of BYOND this client last used.
	var/byond_version
	/// Build number of BYOND this client last used.
	var/byond_build
	/// Individual log storage keyed by stringified LOG_* bitflag.
	var/list/logging = list()
	/// Action datums assigned to this player and re-granted on login.
	var/list/datum/action/player_actions = list()
	/// Callbacks invoked when this client logs in again.
	var/list/post_login_callbacks = list()
	/// Callbacks invoked when this client logs out.
	var/list/post_logout_callbacks = list()
	/// Assoc list of names this key has used this round, name -> mob tag/ref.
	var/list/played_names = list()
	/// Lazylist of preference slots this client has joined the round under.
	var/list/joined_as_slots
	/// World.time this player last died. Aurora keeps respawn timers on prefs; this is for tg-compatible consumers.
	var/time_of_death = 0

/datum/persistent_client/New(client_ckey)
	// Callers must pass a canonical real ckey; use the bind helpers for raw keys.
	src.ckey = client_ckey
	GLOB.persistent_clients_by_ckey[client_ckey] = src
	GLOB.persistent_clients += src

/datum/persistent_client/Destroy(force)
	SHOULD_CALL_PARENT(FALSE)
	return QDEL_HINT_LETMELIVE

/// Setter for the client var, updating both sides of the reference.
/datum/persistent_client/proc/set_client(client/new_client)
	if(client == new_client)
		return

	if(client)
		client.persistent_client = null

	if(new_client?.persistent_client && new_client.persistent_client != src)
		new_client.persistent_client.set_client(null)

	client = new_client

	if(client)
		client.persistent_client = src
		byond_build = client.byond_build
		byond_version = client.byond_version

/// Setter for the mob var, updating both sides of the reference.
/datum/persistent_client/proc/set_mob(mob/new_mob)
	if(mob == new_mob)
		return

	if(mob)
		mob.persistent_client = null

	if(new_mob?.persistent_client && new_mob.persistent_client != src)
		new_mob.persistent_client.set_mob(null)

	mob = new_mob

	if(mob)
		mob.persistent_client = src

/// Writes all played names into an HTML-escaped string.
/datum/persistent_client/proc/get_played_names()
	var/list/previous_names = list()
	for(var/previous_name in played_names)
		previous_names += html_encode("[previous_name] ([played_names[previous_name]])")
	return previous_names.Join("; ")

/// Writes played name data back into a persistent client datum.
/proc/log_played_names(client_ckey, list/data)
	if(istext(client_ckey) && copytext(client_ckey, 1, 2) == "@")
		return

	client_ckey = ckey(client_ckey)
	if(!client_ckey || !islist(data))
		return

	var/datum/persistent_client/writable = GLOB.persistent_clients_by_ckey[client_ckey]
	if(!writable)
		return

	if(!islist(writable.played_names))
		writable.played_names = list()

	for(var/name in data)
		if(!name || (name in writable.played_names))
			continue
		writable.played_names[name] = data[name]

/// Returns the full BYOND version string, e.g. 515.1642.
/datum/persistent_client/proc/full_byond_version()
	if(!byond_version)
		return "Unknown"
	return "[byond_version].[byond_build || "xxx"]"

/// Ensures a client has a same-round persistent client datum.
/client/proc/bind_persistent_client()
	var/client_ckey = ckey || key
	if(istext(client_ckey) && copytext(client_ckey, 1, 2) == "@")
		return null

	client_ckey = ckey(client_ckey)
	if(!client_ckey)
		return null

	var/datum/persistent_client/persistent = GLOB.persistent_clients_by_ckey[client_ckey]
	if(!persistent)
		persistent = new /datum/persistent_client(client_ckey)

	persistent.set_client(src)
	return persistent

/// Binds a mob to the persistent client for a ckey, creating the datum if needed.
/mob/proc/bind_persistent_client_by_ckey(client_ckey = ckey)
	if(istext(client_ckey) && copytext(client_ckey, 1, 2) == "@")
		return null

	client_ckey = ckey(client_ckey)
	if(!client_ckey)
		return null

	var/datum/persistent_client/persistent = client?.persistent_client
	if(persistent?.ckey != client_ckey)
		persistent = null
	if(!persistent)
		persistent = GLOB.persistent_clients_by_ckey[client_ckey]
	if(!persistent)
		persistent = new /datum/persistent_client(client_ckey)

	persistent.set_mob(src)
	return persistent
