/datum
	var/list/destroy_listeners

/**
 * @param second_link should only ever be passed as TRUE from this proc. It's a
 * recursion guard. The reverse registration is necessary to clean up hard refs.
 */
/datum/proc/OnDestroy(datum/callback/callback, second_link = FALSE)
	LAZYSET(destroy_listeners, callback.object, callback)
	if (!second_link && callback.object && callback.object != GLOBAL_PROC)
		callback.object.OnDestroy(CALLBACK(src, .proc/UnregisterOnDestroy, callback.object), TRUE)

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
