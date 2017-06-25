/mob/living/simple_animal/hostile/true_changeling
	name = "abomination"
	desc = "A monstrous creature, made of twisted flesh and bone."
	speak_emote = list("says with one of its faces")
	emote_hear = list("says with one of its faces")
	icon = 'icons/mob/animal.dmi'
	icon_state = "horror"
	icon_living = "horror"
	icon_dead = "horror_dead"
	stop_automated_movement = 1
	universal_speak =1

	mob_swap_flags = HUMAN|SIMPLE_ANIMAL|SLIME|MONKEY
	mob_push_flags = ALLMOBS

	response_help  = "pets"
	response_disarm = "shoves"
	response_harm   = "harmlessly punches"
	maxHealth = 750
	health = 750
	harm_intent_damage = 0
	melee_damage_lower = 30
	melee_damage_upper = 30
	mob_size = 25
	environment_smash = 2
	attacktext = "mangled"
	attack_sound = 'sound/weapons/bloodyslice.ogg'

	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING

	minbodytemp = 0
	maxbodytemp = 350
	min_oxy = 0
	max_co2 = 0
	max_tox = 0
	
	var/is_devouring = FALSE
	
/mob/living/simple_animal/hostile/true_changeling/Initialize()
	. = ..()
	if(prob(25))
		icon_state = "horror_alt"
		icon_living = "horror_alt"
	
/mob/living/simple_animal/hostile/true_changeling/Life()
	..()
	adjustBruteLoss(-10) //it will slowly heal brute damage, making fire/laser a stronger option
	
/mob/living/simple_animal/hostile/true_changeling/death()
	..()
	visible_message("<b>[src]</b> lets out a waning scream as it falls, twitching, to the floor!")
	playsound(loc, 'sound/effects/creepyshriek.ogg', 30, 1)
	gibs(src.loc)
	qdel(src)
	return

/mob/living/simple_animal/hostile/true_changeling/verb/ling_devour(mob/living/target as mob in oview())
	set category = "Changeling"
	set name = "Devour"
	set desc = "Devours a creature, destroying its body and regenerating health."

	if(!Adjacent(target))
		return
		
	if(target.isSynthetic())
		return
		
	var/mob/living/simple_animal/hostile/true_changeling/M = usr
	
	if(M.is_devouring)
		usr << "<span class='warning'>We are already feasting on something!</span>"
		return 0

	if(!health)
		usr << "<span class='notice'>We are dead, we cannot use any abilities!</span>"
		return

	if(last_special > world.time)
		usr << "<span class='warning'>We must wait a little while before we can use this ability again!</span>"
		return

	M.visible_message("<span class='warning'>[M] begins ripping apart and feasting on [target]!</span>")
	M.is_devouring = TRUE
					
	target.adjustBruteLoss(35)

	if(!do_after(M,150))
		M<< "<span class='warning'>You need to wait longer to devour \the [target]!</span>"
		M.is_devouring = FALSE
		return 0
		
	M.visible_message("<span class='warning'>[M] tears a chunk from \the [target]'s flesh!</span>")
	
	target.adjustBruteLoss(35)
		
	if(!do_after(M,150))
		M<< "<span class='warning'>You need to wait longer to devour \the [target]!</span>"
		M.is_devouring = FALSE
		return 0

	M.visible_message("<span class='warning'>[target] is completely devoured by [M]!</span>", \
						"<span class='danger'>You completely devour \the [target]!</span>")
	target.gib()
	rejuvenate()
	updatehealth()
	last_special = world.time + 100
	M.is_devouring = FALSE
	return
	
	
/mob/living/simple_animal/hostile/true_changeling/verb/dart(mob/living/target as mob in oview())
	set name = "Launch Bone Dart"
	set desc = "Launches a Bone Dart at a target."
	set category = "Changeling"

	if(!health)
		usr << "<span class='notice'>We are dead, we cannot use any abilities!</span>"
		return

	if(last_special > world.time)
		return

	last_special = world.time + 30

	visible_message("<span class='warning'>\The [src]'s skin bulges and tears, launching a bone-dart at [target]!</span>")

	playsound(src.loc, 'sound/weapons/bladeslice.ogg', 50, 1)
	var/obj/item/weapon/bone_dart/A = new /obj/item/weapon/bone_dart(usr.loc)
	A.throw_at(target, 10, 20, user)
	target.Weaken(5)
	msg_admin_attack("[key_name_admin(src)] launched a bone dart at [key_name_admin(target)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)",ckey=key_name(src),ckey_target=key_name(target))

