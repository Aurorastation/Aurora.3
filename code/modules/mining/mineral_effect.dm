/obj/effect/mineral
	name = "mineral vein"
	icon = 'icons/obj/mining.dmi'
	desc = "Shiny."
	mouse_opacity = 0
	density = 0
	anchored = 1
	var/ore_key
	var/image/scanner_image

/obj/effect/mineral/Initialize(mapload, var/ore/M)
	. = ..()
	name = "[M.display_name] deposit"
	ore_key = M.name
	icon_state = "rock_[ore_key]"
	var/turf/simulated/mineral/T = get_turf(src)
	layer = T.layer + 0.1
	if(!istype(T))
		crash_with("Invalid loc for mineral overlay: [T ? T.type : "NULL"].")
		qdel(src)
		return

	if(T.my_mineral)
		crash_with("Mineral overlay created on turf that already had one.")
		qdel(T.my_mineral)

	T.my_mineral = src

/obj/effect/mineral/Destroy()
	var/turf/simulated/mineral/T = loc
	if(istype(T))
		T.my_mineral = null
	return ..()

/obj/effect/mineral/proc/get_scan_overlay()
	if(!scanner_image)
		var/ore/O = ore_data[ore_key]
		if(O)
			scanner_image = image(icon, loc = get_turf(src), icon_state = (O.scan_icon ? O.scan_icon : icon_state))
		else
			crash_with("No ore data for [src]!")
	return scanner_image

/obj/effect/mineral/singularity_pull()
	return

/obj/effect/mineral/singuloCanEat()
	return FALSE