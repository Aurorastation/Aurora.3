/singleton/psionic_power/mirror_shade
	name = "Mirror Shade"
	desc = "Activate this spell to generate two psionic copies of yourself that will attack nearby mobs. These clones are not dense, will deal pain damage, and disappear \
			after thirty seconds. Clicking mobs before casting protects them from your clones."
	icon_state = "wiz_jaunt"
	point_cost = 2
	ability_flags = PSI_FLAG_EVENT
	spell_path = /obj/item/spell/mirror_shade

/obj/item/spell/mirror_shade
	name = "mirror shade"
	desc = "Photocopy yourself."
	icon_state = "darkness"
	cast_methods = CAST_RANGED|CAST_USE
	aspect = ASPECT_PSIONIC
	cooldown = 100
	psi_cost = 20
	var/list/mob/living/chosen_friends = list()

/obj/item/spell/mirror_shade/on_use_cast(mob/user)
	cooldown = 100
	. = ..()
	if(!.)
		return
	if(do_after(user, 1 SECOND))
		to_chat(user, SPAN_WARNING("You weave your psionic force into two copies of yourself!"))
		for(var/i = 1 to 2)
			var/mob/living/simple_animal/hostile/mirror_shade/MS = new(pick(get_adjacent_open_turfs(user)), user, chosen_friends)
			MS.appearance = user.appearance
			MS.name = user.name

/obj/item/spell/mirror_shade/on_ranged_cast(atom/hit_atom, mob/user, bypass_psi_check = TRUE)
	cooldown = 0
	if(!isliving(hit_atom))
		return
	. = ..()
	if(!.)
		return

	var/mob/living/M = hit_atom
	if(istype(M, /mob/living/simple_animal/hostile/mirror_shade)) return

	if(!(M in chosen_friends))
		chosen_friends.Add(M)
		to_chat(user, SPAN_INFO("Your clones will no longer target [M]!"))
	else
		chosen_friends.Remove(M)
		to_chat(user, SPAN_INFO("Your clones will now target [M]!"))

/obj/item/spell/mirror_shade/Destroy()
	chosen_friends = null
	return ..()

/mob/living/simple_animal/hostile/mirror_shade
	damage_type = DAMAGE_PAIN
	density = FALSE
	destroy_surroundings = FALSE
	melee_damage_lower = 10
	melee_damage_upper = 15
	attack_emote = "tries shambling towards"
	attacktext = "phases its arms through"
	var/mob/living/carbon/human/owner

/mob/living/simple_animal/hostile/mirror_shade/Initialize(mapload, var/mob/set_owner, var/list/mob/living/chosen_friends)
	. = ..()
	if(set_owner)
		owner = set_owner
		friends += owner
		friends |= chosen_friends
		for(var/mob/friend in friends)
			var/brain_worm = friend.has_brain_worms()
			if(brain_worm)
				friends += brain_worm
	QDEL_IN(src, 30 SECONDS)

/mob/living/simple_animal/hostile/mirror_shade/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	if(!QDELETED(owner))
		/// Technically suspicious, but these have 30 seconds of lifetime so it's probably fine.
		return owner.examine(arglist(args))
	return ..()

/mob/living/simple_animal/hostile/mirror_shade/Destroy()
	owner = null
	visible_message(SPAN_WARNING("[src] dissipates into nothingness, as if it were air all along!"))
	return ..()
