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
	icon = 'icons/obj/item/clothing/eyes/med_hud.dmi'
	icon_state = "healthhud"
	item_state = "healthhud"
	body_parts_covered = 0
	contained_sprite = TRUE


/obj/item/clothing/glasses/hud/health/process_hud(var/mob/M)
	process_med_hud(M, 1)

/obj/item/clothing/glasses/hud/health/is_med_hud()
	return active

/obj/item/clothing/glasses/hud/health/pmc
	name = "PMCG health scanner HUD"
	desc = "A heads-up display in the colours of the Private Military Contracting Group."
	icon_state = "healthhud_pmc"
	item_state = "healthhud_pmc"

/obj/item/clothing/glasses/hud/health/pmc/alt
	name = "EPMC health scanner HUD"
	desc = "A heads-up display in Eridani Private Military Contracting colours."
	icon_state = "healthhud_pmc_alt"
	item_state = "healthhud_pmc_alt"

/obj/item/clothing/glasses/hud/health/nt
	name = "NanoTrasen health scanner HUD"
	desc = "A heads-up display in the colours of the NanoTrasen Corporation."
	icon_state = "healthhud_nt"
	item_state = "healthhud_nt"

/obj/item/clothing/glasses/hud/health/zeng
	name = "Zeng-Hu health scanner HUD"
	desc = "A heads-up display in the colours of Zeng-Hu Pharmaceuticals."
	icon_state = "healthhud_zeng"
	item_state = "healthhud_zeng"

/obj/item/clothing/glasses/hud/health/prescription
	name = "prescription glasses/HUD assembly"
	desc = "A medical HUD clipped onto the side of prescription glasses."
	prescription = 7
	icon_state = "healthhudpresc"
	item_state = "healthhudpresc"
	var/glasses_type = /obj/item/clothing/glasses/regular

/obj/item/clothing/glasses/hud/health/prescription/attack_self(mob/user)
	to_chat(user, SPAN_NOTICE("You detach a set of medical HUDs from your glasses."))
	playsound(src.loc, 'sound/weapons/blade_close.ogg', 50, 1)
	var/obj/item/clothing/glasses/regular/R = new glasses_type(user.loc)
	user.put_in_hands(R)
	var/obj/item/clothing/glasses/hud/health/H = new /obj/item/clothing/glasses/hud/health(user.loc)
	user.put_in_hands(H)
	user.drop_item(src)
	qdel(src)

/obj/item/clothing/glasses/hud/security
	name = "security HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status and security records."
	icon = 'icons/obj/item/clothing/eyes/sec_hud.dmi'
	icon_state = "securityhud"
	item_state = "securityhud"
	body_parts_covered = 0
	var/global/list/jobs[0]
	contained_sprite = TRUE

/obj/item/clothing/glasses/hud/security/is_sec_hud()
	return active

/obj/item/clothing/glasses/hud/security/zavod
	name = "Zavodskoi security HUD"
	desc = "A heads-up display in the colours of Zavodskoi Interstellar."
	icon_state = "securityhud_zavod"
	item_state = "securityhud_zavod"

/obj/item/clothing/glasses/hud/security/pmc
	name = "PMCG security HUD"
	desc = "A heads-up display in the colours of the Private Military Contracting Group."
	icon_state = "securityhud_pmc"
	item_state = "securityhud_pmc"

/obj/item/clothing/glasses/hud/security/pmc/alt
	name = "EPMC security HUD"
	desc = "A heads-up display in Eridani Private Military Contractor colours."
	icon_state = "securityhud_pmc_alt"
	item_state = "securityhud_pmc_alt"

/obj/item/clothing/glasses/hud/security/idris
	name = "Idris security HUD"
	desc = "A heads-up display in the colours of the Idris Incorporated."
	icon_state = "securityhud_idris"
	item_state = "securityhud_idris"

/obj/item/clothing/glasses/hud/security/prescription
	name = "prescription glasses/HUD assembly"
	desc = "A security HUD clipped onto the side of prescription glasses."
	prescription = 7
	icon_state = "sechudpresc"
	item_state = "sechudpresc"
	var/glasses_type = /obj/item/clothing/glasses/regular

/obj/item/clothing/glasses/hud/security/prescription/attack_self(mob/user)
	to_chat(user, SPAN_NOTICE("You detach a set of security HUDs from your glasses."))
	playsound(src.loc, 'sound/weapons/blade_close.ogg', 50, 1)
	var/obj/item/clothing/glasses/regular/R = new glasses_type(user.loc)
	user.put_in_hands(R)
	var/obj/item/clothing/glasses/hud/security/S = new /obj/item/clothing/glasses/hud/security(user.loc)
	user.put_in_hands(S)
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
