/*
 Cloaking
*/
/datum/modifier/cloaking_device/activate()
	..()
	var/mob/living/L = target
	L.cloaked = 1
	L.mouse_opacity = 0
	L.update_icons()


/datum/modifier/cloaking_device/deactivate()
	..()
	for (var/a in cloaking_devices)//Check for any other cloaks
		if (a != source)
			var/obj/item/weapon/cloaking_device/CD = a
			if (CD.get_holding_mob() == target)
				if (CD.active)//If target is holding another active cloak then we wont remove their stealth
					return
	var/mob/living/L = target
	L.cloaked = 0
	L.mouse_opacity = 1
	L.update_icons()


/datum/modifier/cloaking_device/check_validity()
	.=..()
	if (. == 1)
		var/obj/item/weapon/cloaking_device/C = source
		if (!C.active)
			return validity_fail("Cloak is inactive!")