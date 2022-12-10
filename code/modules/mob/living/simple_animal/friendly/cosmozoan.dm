/mob/living/simple_animal/cosmozoan
	name = "cosmozoan"
	desc = "These jellyfish-like entities drift through asteroid fields, emitting a soft glow."
	desc_info = "Schools of Cosmozoans often congregate in asteroid fields, though they have rarely been witnessed in greater number and size in the Frontier. Their origin remains a mystery but it is believed they predate early man. This belief landed them the name Cosmozoa."
	icon_state = "cosmozoan"
	icon_living = "cosmozoan"
	icon_dead = "cosmozoan_dead"
	maxHealth = 15
	health = 15
	meat_type = /obj/item/reagent_containers/food/snacks/fish/cosmozoan
	meat_amount = 2
	organ_names = list("hood", "tentacles")
	response_help   = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "whacks"
	harm_intent_damage = 5
	blood_type = COLOR_CRYSTAL
	blood_overlay_icon = null
	canbrush = TRUE
	brush = /obj/item/reagent_containers/glass/rag
	wanders_diagonally = TRUE

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	flying = TRUE
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING

/mob/living/simple_animal/cosmozoan/Initialize()
	. = ..()
	set_light(1.4, 3, COLOR_CRYSTAL)

// run away when attacked
/mob/living/simple_animal/cosmozoan/handle_attack_by(var/mob/M)
	var/list/valid_dirs = alldirs.Copy()
	valid_dirs -= get_dir(src, M)
	var/turf/target_turf = get_ranged_target_turf(src, pick(valid_dirs), 5)
	if(target_turf)
		for(var/i = 1 to 5)
			if(loc == target_turf)
				break
			step_to(src, target_turf)
			sleep(6)