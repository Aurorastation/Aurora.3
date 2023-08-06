/singleton/psionic_power/mirror_shade
	name = "Mirror Shade"
	desc = "Activate this spell to generate two psionic copies of yourself that will attack nearby mobs. These clones are not dense, will deal pain damage, and disappear \
			after thirty seconds."
	icon_state = "wiz_jaunt"
	point_cost = 2
	ability_flags = PSI_FLAG_EVENT
	spell_path = /obj/item/spell/mirror_shade

/obj/item/spell/mirror_shade
	name = "mirror shade"
	desc = "Photocopy yourself."
	icon_state = "darkness"
	cast_methods = CAST_USE
	aspect = ASPECT_PSIONIC
	cooldown = 100
	psi_cost = 20

/obj/item/spell/mirror_shade/on_use_cast(mob/user)
	. = ..()
	if(!.)
		return
	if(do_after(user, 1 SECOND))
		to_chat(user, SPAN_WARNING("You weave your psionic force into two copies of yourself!"))
		for(var/i = 1 to 2)
			var/mob/living/simple_animal/hostile/mirror_shade/MS = new(pick(get_adjacent_open_turfs(user)))
			MS.appearance = user.appearance
			MS.name = user.name
			MS.owner = user

/mob/living/simple_animal/hostile/mirror_shade
	damage_type = DAMAGE_PAIN
	density = FALSE
	destroy_surroundings = FALSE
	melee_damage_lower = 10
	melee_damage_upper = 15
	attack_emote = "tries shambling towards"
	attacktext = "phases its arms through"
	var/mob/living/carbon/human/owner

/mob/living/simple_animal/hostile/mirror_shade/Initialize()
	. = ..()
	friends += owner
	QDEL_IN(src, 30 SECONDS)

/mob/living/simple_animal/hostile/mirror_shade/examine(mob/user)
	/// Technically suspicious, but these have 30 seconds of lifetime so it's probably fine.
	return owner.examine(user)

/mob/living/simple_animal/hostile/mirror_shade/Destroy()
	owner = null
	visible_message(SPAN_WARNING("[src] dissipates into nothingness, as if it were air all along!"))
	return ..()
