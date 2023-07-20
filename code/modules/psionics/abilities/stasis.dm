/singleton/psionic_power/stasis
	name = "Stasis"
	desc = "Condenses the Nlom field around one person at a time. This immobilises them like an energy net and also applies stasis to them."
	icon_state = "wiz_shield"
	point_cost = 2
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/stasis

/obj/item/spell/stasis
	name = "stasis"
	desc = "Almost as cool as the Mass Effect one."
	icon_state = "shield"
	cast_methods = CAST_RANGED
	aspect = ASPECT_PSIONIC
	cooldown = 100
	psi_cost = 20
	var/obj/effect/energy_net/our_net

/obj/item/spell/stasis/Destroy()
	qdel(our_net)
	our_net = null
	return ..()

/obj/item/spell/stasis/on_ranged_cast(atom/hit_atom, mob/user, bypass_psi_check)
	if(!isliving(hit_atom))
		return
	if(!QDELETED(our_net))
		to_chat(user, SPAN_WARNING("You can't target more than one person with this!"))
		return
	. = ..()
	if(!.)
		return
	var/mob/living/L = M
	var/obj/effect/energy_net/EN = locate() in get_turf(M)
	if(EN)
		qdel(EN)

	var/turf/T = get_turf(M)
	if(T)
		var/obj/effect/energy_net/stasis/net = new(T)
		net.layer = M.layer + 1
		M.captured = TRUE
		M.update_canmove()
		net.affecting = M
		our_net = net
		M.visible_message(SPAN_DANGER("A field of condensed Nlom appears around [M]!"), SPAN_DANGER("You are immobilised by a field of condensed Nlom! You feel your body and mind slow down..."))

/obj/effect/energy_net/stasis
	name = "condensed nlom field"
	desc = "A crystallized field of pure Nlom energy."
	color = COLOR_LIGHT_CYAN
	health = 100

/obj/effect/energy_net/stasis/process()
	. = ..()
	if(iscarbon(affecting))
		var/mob/living/carbon/C = affecting
		C.SetStasis(10)
