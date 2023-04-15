/mob/living/carbon/alien
	name = "La Creatura"
	desc = "La creatura. Huh wuh?"
	icon = 'icons/mob/npc/alien.dmi'
	icon_state = "la_creatura"
	pass_flags = PASSTABLE
	health = 50
	maxHealth = 50
	mob_size = 4

	var/adult_form
	var/icon_dead
	var/amount_grown = 0
	var/max_grown = 200
	var/time_of_birth
	var/language
	var/death_msg = "lets out a waning guttural screech!"
	var/meat_amount = 0
	var/meat_type = /obj/item/reagent_containers/food/snacks/xenomeat

	icon_dead = "la_creatura_dead"

/mob/living/carbon/alien/Initialize()
	. = ..()

	time_of_birth = world.time

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	name = "[initial(name)] ([rand(1, 1000)])"
	real_name = name
	regenerate_icons()

	if(language)
		add_language(language)

	gender = NEUTER

/mob/living/carbon/alien/u_equip(obj/item/W as obj)
	return

/mob/living/carbon/alien/Stat()
	..()
	stat(null, "Progress: [amount_grown]/[max_grown]")

/mob/living/carbon/alien/restrained()
	return 0

/mob/living/carbon/alien/show_inv(mob/user as mob)
	return // Consider adding cuffs and hats to this, for the sake of fun.

/mob/living/carbon/alien/cannot_use_vents()
	return