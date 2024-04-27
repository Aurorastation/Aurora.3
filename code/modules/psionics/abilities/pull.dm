/singleton/psionic_power/pull
	name = "Pull"
	desc = "Pulls the target straight towards the user, smashing windows along the way. If it can be held in your hands, \
			it goes straight to your hand. Note that you can catch items you pull to yourself if you toggle throw mode before pulling an item."
	icon_state = "tech_passwall"
	point_cost = 2
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/pull

/obj/item/spell/pull
	name = "pull"
	desc = "Not as cool as the Mass Effect one."
	icon_state = "control"
	cast_methods = CAST_RANGED
	aspect = ASPECT_PSIONIC
	cooldown = 50
	psi_cost = 10

/obj/item/spell/pull/on_ranged_cast(atom/hit_atom, mob/user, bypass_psi_check)
	if(!ismovable(hit_atom))
		return
	if(!ishuman(user))
		return
	. = ..()
	if(!.)
		return
	var/atom/movable/AM = hit_atom
	var/mob/living/carbon/human/H = user
	if(isobj(hit_atom) && w_class < ITEMSIZE_IMMENSE)
		if(length(get_line(hit_atom, user)))
			if(H.put_in_any_hand_if_possible(hit_atom))
				return
	user.visible_message(SPAN_WARNING("[user] extends [user.get_pronoun("his")] hand at [hit_atom]and pulls!"), SPAN_WARNING("You mimic pulling at [hit_atom]!"))
	if(ismob(hit_atom))
		to_chat(hit_atom, SPAN_WARNING("A psychic force pulls you!"))
	AM.throw_at(user, 10, 7)
	playsound(user, 'sound/effects/psi/power_evoke.ogg', 40)

