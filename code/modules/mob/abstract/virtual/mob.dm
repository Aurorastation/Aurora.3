/mob/abstract/observer/virtual/mob
	host_type = /mob

/mob/abstract/observer/virtual/mob/New(var/location, var/mob/host)
	..()

	sight_set_event.register(host, src, /mob/abstract/observer/virtual/mob/proc/sync_sight)
	see_invisible_set_event.register(host, src, /mob/abstract/observer/virtual/mob/proc/sync_sight)
	see_in_dark_set_event.register(host, src, /mob/abstract/observer/virtual/mob/proc/sync_sight)

	sync_sight(host)

/mob/abstract/observer/virtual/mob/Destroy()
	sight_set_event.unregister(host, src, /mob/abstract/observer/virtual/mob/proc/sync_sight)
	see_invisible_set_event.unregister(host, src, /mob/abstract/observer/virtual/mob/proc/sync_sight)
	see_in_dark_set_event.unregister(host, src, /mob/abstract/observer/virtual/mob/proc/sync_sight)
	. = ..()

/mob/abstract/observer/virtual/mob/proc/sync_sight(var/mob/mob_host)
	sight = mob_host.sight
	see_invisible = mob_host.see_invisible
	see_in_dark = mob_host.see_in_dark