/mob/living/carbon/alien/instantiate_hud(var/datum/hud/HUD)
	HUD.larva_hud()

/datum/hud/proc/larva_hud()

	src.adding = list()
	src.other = list()

	var/obj/screen/using

	using = new /obj/screen/movement_intent()
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen/alien.dmi'
	using.icon_state = (mymob.m_intent == "run" ? "running" : "walking")
	src.adding += using
	move_intent = using

	mymob.healths = new /obj/screen()
	mymob.healths.icon = 'icons/mob/screen/alien.dmi'
	mymob.healths.icon_state = "health0"
	mymob.healths.name = "health"
	mymob.healths.screen_loc = ui_alien_health

	mymob.blind = new /obj/screen()
	mymob.blind.icon = 'icons/mob/screen/full.dmi'
	mymob.blind.icon_state = "blackimageoverlay"
	mymob.blind.name = " "
	mymob.blind.screen_loc = "1,1"
	mymob.blind.invisibility = 101

	mymob.flash = new /obj/screen()
	mymob.flash.icon = 'icons/mob/screen/alien.dmi'
	mymob.flash.icon_state = "blank"
	mymob.flash.name = "flash"
	mymob.flash.screen_loc = ui_entire_screen
	mymob.flash.layer = 17
	mymob.flash.mouse_opacity = 0

	mymob.fire = new /obj/screen()
	mymob.fire.icon = 'icons/mob/screen/alien.dmi'
	mymob.fire.icon_state = "fire0"
	mymob.fire.name = "fire"
	mymob.fire.screen_loc = ui_fire

	mymob.client.screen = null
	mymob.client.screen += list( mymob.healths, mymob.blind, mymob.flash, mymob.fire) //, mymob.rest, mymob.sleep, mymob.mach )
	mymob.client.screen += src.adding + src.other
