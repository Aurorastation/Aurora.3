/obj/item/device/uv_light
	name = "\improper UV light"
	desc = "A small handheld black light."
	icon_state = "uv_off"
	slot_flags = SLOT_BELT
	w_class = 2
	item_state = "electronic"
	matter = list(DEFAULT_WALL_MATERIAL = 150)
	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)
	offset_light = 1
	var/list/scanned = list()
	var/list/stored_alpha = list()
	var/list/reset_objects = list()

	var/range = 3
	var/on = 0
	var/step_alpha = 50

/obj/item/device/uv_light/attack_self(var/mob/user)
	on = !on
	if(on)
		set_light(range, 2, "#7700dd")
		processing_objects |= src
		icon_state = "uv_on"
	else
		set_light(0)
		clear_last_scan()
		processing_objects -= src
		icon_state = "uv_off"

/obj/item/device/uv_light/proc/clear_last_scan()
	if(scanned.len)
		for(var/atom/O in scanned)
			O.invisibility = scanned[O]
			if(O.fluorescent == 2) O.fluorescent = 1
		scanned.Cut()
	if(stored_alpha.len)
		for(var/atom/O in stored_alpha)
			O.alpha = stored_alpha[O]
			if(O.fluorescent == 2) O.fluorescent = 1
		stored_alpha.Cut()
	if(reset_objects.len)
		for(var/obj/item/I in reset_objects)
			I.overlays -= I.blood_overlay
			if(I.fluorescent == 2) I.fluorescent = 1
		reset_objects.Cut()

/obj/item/device/uv_light/process()
	clear_last_scan()
	if(on)
		step_alpha = round(255/range)
		var/turf/origin = get_turf(src)
		if(!origin)
			return
		for(var/turf/T in range(range, origin))
			var/use_alpha = 255 - (step_alpha * get_dist(origin, T))
			for(var/atom/A in T.contents)
				if(A.fluorescent == 1)
					A.fluorescent = 2 //To prevent light crosstalk.
					if(A.invisibility)
						scanned[A] = A.invisibility
						A.invisibility = 0
						stored_alpha[A] = A.alpha
						A.alpha = use_alpha
					if(istype(A, /obj/item))
						var/obj/item/O = A
						if(O.was_bloodied && !(O.is_bloodied))//If blood isnt currently visible
							//O.overlays |= O.blood_overlay
							//reset_objects |= O
							O.is_bloodied = 1//We quickly set it bloodied
							O.update_icon() //Update the icon
							O.is_bloodied = 0//And then unset it again.
					if(istype(A, /mob))
						var/mob/M = A
						if(M.was_bloodied && !(M.is_bloodied))//If blood isnt currently visible
							//O.overlays |= O.blood_overlay
							//reset_objects |= O
							M.is_bloodied = 1//We quickly set it bloodied
							M.update_inv_gloves() //Update the icon
							M.is_bloodied = 0//And then unset it again.
						if(M.feet_was_bloodied && !(M.feet_is_bloodied))//If blood isnt currently visible
							//O.overlays |= O.blood_overlay
							//reset_objects |= O
							M.feet_is_bloodied = 1//We quickly set it bloodied
							M.update_inv_shoes() //Update the icon
							M.feet_is_bloodied = 0//And then unset it again.
						for(var/atom/B in M.contents)
							if(B.fluorescent == 1)
								B.fluorescent = 2 //To prevent light crosstalk.
								if(B.invisibility)
									scanned[B] = B.invisibility
									B.invisibility = 0
									stored_alpha[B] = A.alpha
									B.alpha = use_alpha
								if(istype(B, /obj/item))
									var/obj/item/O = B
									if(O.was_bloodied && !(O.is_bloodied))//If blood isnt currently visible
										//O.overlays |= O.blood_overlay
										//reset_objects |= O
										O.is_bloodied = 1//We quickly set it bloodied
										O.update_icon() //Update the icon
										O.update_worn_icon()
										O.is_bloodied = 0//And then unset it again.