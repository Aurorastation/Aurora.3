/mob/living/simple_animal/hostile/morph/instantiate_hud(datum/hud/HUD)
	HUD.morph_hud()

/datum/hud/proc/morph_hud()
	var/atom/movable/screen/mov_intent = new /atom/movable/screen/movement_intent()
	mov_intent.set_dir(SOUTHWEST)
	mov_intent.icon = 'icons/mob/screen/morph.dmi'
	mov_intent.icon_state = (mymob.m_intent == M_RUN ? "running" : "walking")
	move_intent = mov_intent

	mymob.healths = new /atom/movable/screen()
	mymob.healths.name = "health"
	mymob.healths.icon = 'icons/mob/screen/morph.dmi'
	mymob.healths.icon_state = "health0"
	mymob.healths.screen_loc = ui_alien_health

	mymob.zone_sel = new /atom/movable/screen/zone_sel()
	mymob.zone_sel.icon = 'icons/mob/screen/morph.dmi'
	mymob.zone_sel.ClearOverlays()
	mymob.zone_sel.AddOverlays(image('icons/mob/zone_sel.dmi', "[mymob.zone_sel.selecting]"))

	var/atom/movable/screen/resist = new /atom/movable/screen()
	resist.name = "resist"
	resist.icon = 'icons/mob/screen/morph.dmi'
	resist.icon_state = "act_resist"
	resist.screen_loc = ui_morph_resist
	hotkeybuttons += resist

	mymob.client.screen = null
	mymob.client.screen += list(mov_intent, mymob.healths, mymob.zone_sel, resist)
