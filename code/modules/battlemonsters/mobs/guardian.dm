/mob/living/simple_animal/hostile/commanded/battlemonster/guardian
	name = "Guardian"
	short_name = "Guardians"

	icon = 'icons/mob/guardian.dmi'
	icon_state = ""
	icon_living = ""
	icon_dead = ""
	icon_gib = ""

	mob_bump_flag = 0
	mob_swap_flags = 0
	mob_push_flags = 0
	attack_delay = 0.1 SECONDS

	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE | PASSDOORHATCH | PASSMOB

/mob/living/simple_animal/hostile/commanded/battlemonster/guardian/AttackingTarget()
	. = ..()
	say("ATATATATATATATATATATATATATATATATAT")

/mob/living/simple_animal/hostile/commanded/battlemonster/guardian/Move()
	. = ..()
	if(target_mob)
		var/obj/effect/temp_visual/decoy/D = new /obj/effect/temp_visual/decoy(loc,src)
		animate(D, alpha = 0, color = "#FFFFFF", transform = matrix()*2, time = 3)

/mob/living/simple_animal/hostile/commanded/battlemonster/guardian/pink
	name = "Pink Guardian"
	icon_state = "magicPink"
	icon_living = "magicPink"

/mob/living/simple_animal/hostile/commanded/battlemonster/guardian/red
	name = "Red Guardian"
	icon_state = "magicRed"
	icon_living = "magicRed"

/mob/living/simple_animal/hostile/commanded/battlemonster/guardian/orange
	name = "Orange Guardian"
	icon_state = "magicOrange"
	icon_living = "magicOrange"

/mob/living/simple_animal/hostile/commanded/battlemonster/guardian/green
	name = "Green Guardian"
	icon_state = "magicGreen"
	icon_living = "magicGreen"

/mob/living/simple_animal/hostile/commanded/battlemonster/guardian/blue
	name = "Blue Guardian"
	icon_state = "magicBlue"
	icon_living = "magicBlue"

/mob/living/simple_animal/hostile/commanded/battlemonster/guardian/gay
	name = "Rainbow Guardian"
	icon_state = "magicGay"
	icon_living = "magicGay"