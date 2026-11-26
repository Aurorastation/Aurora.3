/obj/item/grenade/napalm
	name = "napalm grenade"
	desc = "A grenade that delivers napalm. Not as classy as an airstrike, but still effective."
	desc_extended = "A Necropolis Industries (now known as Zavodskoi Interstellar) engineered device, this grenade is one of the most effective and destructive portable emergency sterilization \
	device available, causing high-intensity sustained fires at over 2000K."
	var/effect = /obj/effect/decal/cleanable/napalm
	var/spread_radius = 3

/obj/item/grenade/napalm/antagonist_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "This causes a [spread_radius]-tiles large fire that burns for quite a while. Don't be a dick with it."

/obj/item/grenade/napalm/prime()
	. = ..()

	for(var/turf/turf as anything in get_spread_turfs(get_turf(src), spread_radius))
		new effect(turf, 100, TRUE, TRUE)

	qdel(src)


/obj/item/grenade/napalm/zorane
	effect = /obj/effect/decal/cleanable/napalm/zorane_fire
