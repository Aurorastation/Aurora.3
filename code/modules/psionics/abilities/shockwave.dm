/singleton/psionic_power/shockwave
	name = "Shockwave"
	desc = "Create a wave of telekinetic energy to pummel the ground in a straight line in the direction you're facing. \
			Anyone caught in it falls over unless wearing magboots."
	icon_state = "tech_haste"
	point_cost = 2
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/shockwave

/obj/item/spell/shockwave
	name = "shockwave"
	icon_state = "flame_tongue"
	cast_methods = CAST_USE
	aspect = ASPECT_PSIONIC
	cooldown = 50
	psi_cost = 20

/obj/item/spell/shockwave/on_use_cast(mob/user, bypass_psi_check)
	. = ..()
	if(!.)
		return

	var/user_dir = user.dir
	var/turf/T = get_turf(user)
	if(isspaceturf(T))
		to_chat(user, SPAN_WARNING("You charge your shockwave, slam your foot down... and then remember that you're in space."))
		return
	user.visible_message(SPAN_DANGER(FONT_HUGE("[user] charges [user.get_pronoun("his")] foot with psionic energy and slams it down!")),
						SPAN_DANGER(FONT_HUGE("You charge your foot with psionic energy and slam it down!")))
	playsound(T, 'sound/effects/meteorimpact.ogg', 100)
	for(var/mob/M in get_hearers_in_view(7, src))
		shake_camera(M, 5, 5)
	for(var/i = 1 to 5)
		T = get_step(T, user_dir)
		if(isspaceturf(T))
			break
		for(var/mob/living/M in T)
			if(M.Check_Shoegrip())
				continue
			M.apply_effect(3, WEAKEN)
			M.flash_pain(20)
			to_chat(M, SPAN_DANGER("You get caught in the shockwave and fall down!"))
