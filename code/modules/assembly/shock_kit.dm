/obj/item/assembly/shock_kit
	name = "electrohelmet assembly"
	desc = "This appears to be made from both an electropack and a helmet."
	icon_state = "shock_kit"
	var/obj/item/clothing/head/helmet/part1 = null
	var/obj/item/device/radio/electropack/part2 = null
	var/status = FALSE
	w_class = ITEMSIZE_HUGE
	flags = CONDUCT

/obj/item/assembly/shock_kit/Destroy()
	qdel(part1)
	qdel(part2)
	return ..()

/obj/item/assembly/shock_kit/attackby(obj/item/W, mob/user)
	if(W.iswrench() && !status)
		var/turf/T = loc
		if(ismob(T))
			T = T.loc
		part1.forceMove(T)
		part2.forceMove(T)
		part1.master = null
		part2.master = null
		part1 = null
		part2 = null
		qdel(src)
		return
	if(W.isscrewdriver())
		status = !status
		var/msg = "[src] is now [status ? "secured" : "unsecured"]!"
		to_chat(user, SPAN_NOTICE(msg))
	add_fingerprint(user)
	return

/obj/item/assembly/shock_kit/attack_self(mob/user)
	part1.attack_self(user, status)
	part2.attack_self(user, status)
	add_fingerprint(user)

/obj/item/assembly/shock_kit/receive_signal()
	if(istype(loc, /obj/structure/bed/chair/e_chair))
		var/obj/structure/bed/chair/e_chair/C = loc
		C.shock()