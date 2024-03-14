/obj/item/grenade/napalm
	name = "napalm grenade"
	desc = "A grenade that delivers napalm, not as classy as an airstrike bomb, but still effective."
	desc_extended = "A Necropolis Industries (now known as Zavodskoi Interstellar) engineered device, this grenade is one of the most effective and destructive portable emergency sterilization \
	device available, causing high-intensity sustained fires at over 2000K."
	desc_antag = "This causes a 5-tiles large fire that burns for quite a while, don't be a dick with it."

/obj/item/grenade/napalm/prime()
	. = ..()

	for(var/turf/turf in view(5, get_turf(src)))
		new /obj/effect/decal/cleanable/liquid_fuel/napalm(turf, 100, TRUE)

	qdel(src)
