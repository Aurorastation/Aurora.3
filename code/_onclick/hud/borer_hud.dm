/mob/living/simple_animal/borer/instantiate_hud(var/datum/hud/HUD)
	HUD.borer_hud()

/datum/hud/proc/borer_hud()
	src.adding = list()

	var/obj/screen/borer/chemicals/C = new /obj/screen/borer/chemicals()
	adding += C

	var/mob/living/simple_animal/borer/B = mymob
	B.chem_hud = C

	mymob.client.screen += src.adding