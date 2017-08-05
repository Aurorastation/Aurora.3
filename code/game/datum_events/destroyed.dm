/datum
	var/list/destroy_listeners

/datum/proc/OnDestroy(datum/callback/callback)
	LAZYSET(destroy_listeners, callback.object, callback)
	if (callback.object && callback.object != GLOBAL_PROC)
		callback.object.OnDestroy(CALLBACK(src, .proc/UnregisterOnDestroy, callback.object))

/datum/proc/UnregisterOnDestroy(object)
	if (!destroy_listeners)
		return FALSE

	destroy_listeners[object] = null
	destroy_listeners -= object

	UNSETEMPTY(destroy_listeners)
	. = TRUE

/datum/proc/RaiseOnDestroy()
	if (!destroy_listeners)
		return FALSE

	. = 0
	for (var/thing in destroy_listeners)
		var/datum/callback/cb = destroy_listeners[thing]
		cb.InvokeAsync()
		.++
