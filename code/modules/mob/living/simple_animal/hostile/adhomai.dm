/mob/living/simple_animal/hostile/wind_devil
	name = "sham'tyr"
	desc = "A flying adhomian creature, known for their loud wails that can be heard far below the clouds they soar above."
	icon_state = "devil"
	icon_living = "devil"
	icon_dead = "devil_dead"
	icon_rest = "devil_rest"
	turns_per_move = 3

	organ_names = list("head", "chest", "right wing", "left wing", "right leg", "left leg")
	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"
	speed = -2
	maxHealth = 80
	health = 80
	mob_size = 10

	pass_flags = PASSTABLE

	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	environment_smash = 1

	faction = "Adhomai"
	flying = TRUE
	butchering_products = list(/obj/item/stack/material/animalhide = 1)
	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	meat_amount = 5

/mob/living/simple_animal/hostile/harron
	name = "ha'rron"
	desc = "A carnivorous adhomian animal. Some domesticated breeds make excellent hunting companions."

	icon = 'icons/mob/npc/adhomai.dmi'
	icon_state = "harron"
	icon_living = "harron"
	icon_dead = "harron_dead"

	organ_names = list("head", "chest", "right fore leg", "left fore leg", "right rear leg", "left rear leg")

	turns_per_move = 3

	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	speed = -1
	maxHealth = 75
	health = 75

	mob_size = 5

	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	faction = "Adhomai"

	butchering_products = list(/obj/item/stack/material/animalhide = 1)
	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	meat_amount = 5

/mob/living/simple_animal/hostile/wriggler
	name = "wriggler"
	desc = "A large arctic predator.Its body is a white flesh sphere from which several tentacles emerge."
	icon = 'icons/mob/npc/adhomai.dmi'
	icon_state = "wriggler"
	icon_living = "wriggler"
	icon_dead = "wriggler_dead"
	meat_type = /obj/item/reagent_containers/food/snacks/meat/adhomai
	meat_amount = 5
	organ_names = list("body", "tentacles")
	faction = "Adhomai"
	maxHealth = 100
	health = 100

	speak_emote = list("gurgles")
	emote_hear = list("gurgles")
	emote_see = list("wiggles around", "wiggles its tentacles")

	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	melee_damage_lower = 15
	melee_damage_upper = 15

	mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
	mob_push_flags = ALLMOBS

	attacktext = "strangled"
	attack_sound = 'sound/effects/noosed.ogg'

	speed = 1
	mob_size = 10
	environment_smash = 1

	attack_emote = "wiggles toward"
	see_in_dark = 10
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	blood_type = "#281C2D"


/mob/living/simple_animal/hostile/plasmageist
	name = "plasmageist"
	desc = "A luminescent, lightning balls frequently spotted floating over the Adhomian North Pole."
	icon = 'icons/mob/npc/adhomai.dmi'
	icon_state = "plasmageist"
	icon_living = "plasmageist"
	icon_dead = "plasmageist_dead"
	organ_names = list("body")
	faction = "Adhomai"

	speak_emote = list("hums")
	emote_hear = list("hums")
	emote_see = list("hums ominously", "crackles with energy", "floats around")

	maxHealth = 50
	health = 50

	melee_damage_lower = 5
	melee_damage_upper = 5
	attacktext = "shocked"
	attack_sound = 'sound/magic/LightningShock.ogg'

	speed = 1
	mob_size = 5

	attack_emote = "hums at"
	see_in_dark = 10
	see_invisible = SEE_INVISIBLE_NOLIGHTING

	smart_ranged = TRUE

	ranged = TRUE
	projectiletype = /obj/item/projectile/beam/tesla/plasmageist
	projectilesound = 'sound/magic/LightningShock.ogg'

	pass_flags = PASSTABLE|PASSRAILING

	tameable = FALSE
	flying = TRUE

	blood_overlay_icon = null

/mob/living/simple_animal/hostile/plasmageist/attack_hand(mob/living/carbon/human/M as mob)
	M.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	visible_message(SPAN_WARNING("\The [M] tries to touch \the [src]!"))
	tesla_zap(M, 5, 5000)

/mob/living/simple_animal/hostile/plasmageist/attackby(obj/item/O, mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(isliving(user))
		visible_message(SPAN_WARNING("\The [user] tries to touch \the [src]!"))
		tesla_zap(user, 5, 5000)

/mob/living/simple_animal/hostile/plasmageist/death(gibbed)
	..()
	..(null, "disintegrates!")
	var/T = get_turf(src)
	spark(T, 1, alldirs)
	explosion(T, -1, 0, 2)
	qdel(src)

/mob/living/simple_animal/hostile/plasmageist/ex_act(severity)
	return

/obj/item/projectile/beam/tesla/plasmageist/on_impact(atom/target)
	. = ..()
	if(isliving(target))
		explosion(target, -1, 0, 2)
