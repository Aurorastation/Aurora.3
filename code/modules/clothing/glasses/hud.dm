/obj/item/clothing/glasses/hud
	name = "HUD"
	desc = "A heads-up display that provides important info in (almost) real time."
	flags = 0 //doesn't protect eyes because it's a monocle, duh
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 2)
	var/list/icon/current = list() //the current hud icons

/obj/item/clothing/glasses/proc/process_hud(var/mob/M)
	if(hud)
		hud.process_hud(M)

/obj/item/clothing/glasses/hud/process_hud(var/mob/M)
	return

/obj/item/clothing/glasses/hud/health
	name = "health scanner HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
	icon_state = "healthhud"
	body_parts_covered = 0


/obj/item/clothing/glasses/hud/health/process_hud(var/mob/M)
	process_med_hud(M, 1)

/obj/item/clothing/glasses/hud/health/prescription
	name = "prescription glasses/HUD assembly"
	desc = "A medical HUD clipped onto the side of prescription glasses."
	prescription = 1
	icon_state = "healthhudpresc"
	item_state = "healthhudpresc"

/obj/item/clothing/glasses/hud/health/prescription/attack_self(mob/user)
	to_chat(user, "<span class='notice'>You detach a set of medical HUDs form your glasses.</span>")
	var/turf/T = get_turf(src)
	new /obj/item/clothing/glasses/hud/health(T)
	new /obj/item/clothing/glasses/regular(T)
	user.drop_item(src)
	qdel(src)

/obj/item/clothing/glasses/hud/security
	name = "security HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status and security records."
	icon_state = "securityhud"
	body_parts_covered = 0
	var/global/list/jobs[0]

/obj/item/clothing/glasses/hud/security/prescription
	name = "prescription glasses/HUD assembly"
	desc = "A security HUD clipped onto the side of prescription glasses."
	prescription = 1
	icon_state = "sechudpresc"
	item_state = "sechudpresc"

/obj/item/clothing/glasses/hud/security/prescription/attack_self(mob/user)
	to_chat(user, "<span class='notice'>You detach a set of security HUDs form your glasses.</span>")
	var/turf/T = get_turf(src)
	new /obj/item/clothing/glasses/hud/health(T)
	new /obj/item/clothing/glasses/regular(T)
	user.drop_item(src)
	qdel(src)

/obj/item/clothing/glasses/hud/security/jensenshades
	name = "augmented shades"
	desc = "Polarized bioneural eyewear, designed to augment your vision."
	icon_state = "jensenshades"
	item_state = "jensenshades"
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING

/obj/item/clothing/glasses/hud/security/process_hud(var/mob/M)
	process_sec_hud(M, 1)
