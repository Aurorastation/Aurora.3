/mob/living/carbon/alien/instantiate_hud(var/datum/hud/HUD)
	HUD.nymph_hud()

/datum/hud/proc/nymph_hud()

	src.adding = list()
	src.other = list()

	var/obj/screen/using

	using = new /obj/screen/movement_intent()
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen/alien.dmi'
	using.icon_state = (mymob.m_intent == M_RUN ? "running" : "walking")
	src.adding += using
	move_intent = using

	mymob.healths = new /obj/screen()
	mymob.healths.icon = 'icons/hud/diona_health.dmi'
	mymob.healths.icon_state = "health0"
	mymob.healths.name = "health"
	mymob.healths.screen_loc = ui_alien_health

	mymob.fire = new /obj/screen()
	mymob.fire.icon = 'icons/mob/screen/alien.dmi'
	mymob.fire.icon_state = "blank"
	mymob.fire.name = "fire"
	mymob.fire.screen_loc = ui_fire

	mymob.client.screen = null
	mymob.client.screen += list(mymob.healths, mymob.fire)
	mymob.client.screen += src.adding + src.other
