/obj/machinery/lift_anchor
	icon = 'icons/obj/machines/spacelift_anchor.dmi'
	icon_state = "5"
	var/sprite_number = 5
	var/broken = 0
	var/list/parts

/obj/machinery/lift_anchor/part
	var/master = null

/obj/machinery/lift_anchor/New()
	var/turf/our_turf = get_turf(src)
	var/list/spawn_turfs = block(locate(our_turf.x - 1, our_turf.y + 1, our_turf.z), locate(our_turf.x + 1, our_turf.y - 1, our_turf.z))
	var/count = 0

	for(var/turf/T in spawn_turfs)
		count++
		if(T == our_turf)
			continue

		var/obj/machinery/lift_anchor/part/P = new(T)
		P.sprite_number = count
		P.master = src
		parts += P
		P.update_icon()

/obj/machinery/lift_anchor/ex_act(var/level)
	switch(level)
		if(1)
			return
		if(2)
			return
		if(3)
			broken = 1