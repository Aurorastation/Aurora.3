/singleton/psionic_power/singularity
	name = "Singularity"
	desc = "Creates a psionic illusion. Anyone within four tiles of it is forced to walk towards it. It will dissipate after ten seconds."
	icon_state = "tech_energysiphon"
	point_cost = 2
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/singularity

/obj/item/spell/singularity
	name = "singularity"
	icon_state = "destablize"
	cast_methods = CAST_RANGED
	aspect = ASPECT_PSIONIC
	cooldown = 200
	psi_cost = 20
	var/obj/effect/singularity/singularity

/obj/item/spell/singularity/Destroy()
	QDEL_NULL(singularity)
	return ..()

/obj/item/spell/singularity/on_ranged_cast(atom/hit_atom, mob/user, bypass_psi_check)
	if(!QDELETED(singularity))
		to_chat(user, SPAN_WARNING("You can't make more than one singularity!"))
		return
	. = ..()
	if(!.)
		return

	var/obj/effect/singularity/S = new(get_turf(hit_atom))
	S.creator = user
	singularity = S
	playsound(get_turf(user), 'sound/effects/fingersnap.ogg', 40)
	user.visible_message(SPAN_DANGER(FONT_HUGE("[user] snaps [user.get_pronoun("his")] fingers and generates a hole of psionic energy!")),
						SPAN_DANGER("You snap your fingers and generate a vortex of psionic energy."))

/obj/effect/singularity
	name = "psionic singularity"
	icon_state = "bluestream_fade"
	var/mob/living/creator

/obj/effect/singularity/process()
	for(var/mob/living/M in get_hearers_in_LOS(4, src))
		if(M == creator)
			continue
		to_chat(M, SPAN_DANGER("Your eyes can't move away from \the [src]... you feel compelled to move towards it!"))
		M.AdjustStunned(1)
		step_towards(M, src)

/obj/effect/singularity/Initialize(mapload, ...)
	. = ..()
	QDEL_IN(src, 10 SECONDS)
	START_PROCESSING(SSprocessing, src)

/obj/effect/singularity/Destroy()
	visible_message(SPAN_WARNING("\The [src] dissipates harmlessly with a light 'fwoosh' sound."))
	creator = null
	STOP_PROCESSING(SSprocessing, src)
	return ..()
