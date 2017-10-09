/mob/living
	var/list/death_listeners

/mob/living/proc/OnDeath(thingtocall, proctocall, ...)
	.(CALLBACK(thingtocall, proctocall, ...))

/mob/living/OnDeath(datum/callback/callback)
	LAZYSET(death_listeners, callback.object, callback)
	if (callback.object && callback.object != GLOBAL_PROC)
		callback.object.OnDestroy(CALLBACK(src, .proc/UnregisterOnDeath, callback.object))

/mob/living/proc/UnregisterOnDeath(object)
	if (!death_listeners)
		return FALSE

	death_listeners[object] = null
	death_listeners -= object

	UNSETEMPTY(death_listeners)
	. = TRUE

/mob/living/proc/RaiseOnDeath(gibbed)
	if (!death_listeners)
		return FALSE

	for (var/thing in death_listeners)
		var/datum/callback/cb = death_listeners[thing]
		cb.InvokeAsync(gibbed)

/mob/living/Destroy()
	death_listeners = null
	return ..()

/mob/living/death(gibbed, deathmessage = "seizes up and falls limp...")
	. = ..()
	if (.)
		RaiseOnDeath(gibbed)
