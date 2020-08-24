/datum/unarmed_attack/bite/sharp //eye teeth
	attack_verb = list("bit", "chomped on")
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = 0
	sharp = 1
	edge = 1
	damage = 5
	attack_name = "sharp bite"

/datum/unarmed_attack/diona
	attack_verb = list("lashed", "bludgeoned")
	attack_noun = list("tendril")
	eye_attack_text = "a tendril"
	eye_attack_text_victim = "a tendril"
	attack_name = "tendrils"

/datum/unarmed_attack/claws
	attack_verb = list("scratched", "clawed", "slashed")
	attack_noun = list("claws")
	eye_attack_text = "claws"
	eye_attack_text_victim = "sharp claws"
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	sharp = 1
	edge = 1
	damage = 5
	attack_name = "claws"

/datum/unarmed_attack/claws/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/skill = user.skills["combat"]
	var/obj/item/organ/external/affecting = target.get_organ(zone)

	if(!skill)	skill = 1
	attack_damage = Clamp(attack_damage, 1, 5)

	if(target == user)
		user.visible_message("<span class='danger'>[user] [pick(attack_verb)] \himself in the [affecting.name]!</span>")
		return 0

	switch(zone)
		if(BP_HEAD, BP_MOUTH, BP_EYES)
			// ----- HEAD ----- //
			switch(attack_damage)
				if(1 to 2)
					user.visible_message("<span class='danger'>[user] scratched [target] across \his cheek!</span>")
				if(3 to 4)
					user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [target]'s [pick(BP_HEAD, "neck")]!</span>") //'with spread claws' sounds a little bit odd, just enough that conciseness is better here I think
				if(5)
					user.visible_message(pick(
						"<span class='danger'>[user] rakes \his [pick(attack_noun)] across [target]'s face!</span>",
						"<span class='danger'>[user] tears \his [pick(attack_noun)] into [target]'s face!</span>",
						))
		else
			// ----- BODY ----- //
			switch(attack_damage)
				if(1 to 2)	user.visible_message("<span class='danger'>[user] scratched [target]'s [affecting.name]!</span>")
				if(3 to 4)	user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [pick("", "", "the side of")] [target]'s [affecting.name]!</span>")
				if(5)		user.visible_message("<span class='danger'>[user] tears \his [pick(attack_noun)] [pick("deep into", "into", "across")] [target]'s [affecting.name]!</span>")

/datum/unarmed_attack/claws/strong
	attack_verb = list("slashed")
	damage = 10
	shredding = 1
	attack_name = "strong claws"

/datum/unarmed_attack/bite/strong
	attack_verb = list("mauled")
	damage = 10
	shredding = 1
	attack_name = "strong bite"

/datum/unarmed_attack/slime_glomp
	attack_verb = list("glomped")
	attack_noun = list("body")
	damage = 2
	attack_name = "glomp"

/datum/unarmed_attack/slime_glomp/apply_effects()
	//Todo, maybe have a chance of causing an electrical shock?
	return

/datum/unarmed_attack/stomp/weak
	attack_verb = list("jumped on")
	attack_name = "weak stomp"

/datum/unarmed_attack/stomp/weak/get_unarmed_damage()
	return damage

/datum/unarmed_attack/stomp/weak/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	user.visible_message("<span class='warning'>[user] jumped up and down on \the [target]'s [affecting.name]!</span>")
	playsound(user.loc, attack_sound, 25, 1, -1)

/datum/unarmed_attack/punch/ipc
	damage = 3

/datum/unarmed_attack/kick/ipc
	damage = 3

/datum/unarmed_attack/stomp/ipc
	damage = 3

/datum/unarmed_attack/industrial
	attack_verb = list("pulverized", "crushed", "pounded")
	attack_noun = list("heavy fist")
	damage = 7
	attack_sound = 'sound/weapons/smash.ogg'
	attack_name = "heavy fist"
	shredding = 1

/datum/unarmed_attack/industrial/heavy
	damage = 9

/datum/unarmed_attack/industrial/xion
	damage = 5
	shredding = 0

/datum/unarmed_attack/terminator
	attack_verb = list("pulverized", "crushed", "pounded")
	attack_noun = list("power fist")
	damage = 12
	attack_sound = 'sound/weapons/beartrap_shut.ogg'
	attack_name = "power fist"
	shredding = 1

/datum/unarmed_attack/terminator/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/armor,var/attack_damage,var/zone)
	..()
	if(prob(25) && target.mob_size <= 30)
		playsound(user, 'sound/weapons/push_connect.ogg', 50, 1, -1)
		user.visible_message("<span class='danger'>[user] shoves hard, sending [target] flying!</span>")
		var/T = get_turf(user)
		spark(T, 3, alldirs)
		step_away(target,user,15)
		sleep(1)
		step_away(target,user,15)
		sleep(1)
		step_away(target,user,15)
		sleep(1)
		step_away(target,user,15)
		sleep(1)
		target.apply_effect(attack_damage * 0.4, WEAKEN, armor)

/datum/unarmed_attack/claws/cleave
	attack_verb = list("cleaved", "plowed", "swiped")
	attack_noun = list("massive claws")
	damage = 25
	sharp = 1
	edge = 1
	attack_name = "massive claws"
	shredding = 1

/datum/unarmed_attack/claws/cleave/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/armor,var/attack_damage,var/zone)
	..()
	var/hit_mobs = 0
	for(var/mob/living/L in orange(1,user))
		if(L == user)
			continue
		if(L == target)
			continue
		L.apply_damage(rand(5,20), BRUTE, zone, armor)
		to_chat(L, "<span class='danger'>\The [user] [pick(attack_verb)] you with its [attack_noun]!</span>")
		hit_mobs++
	if(hit_mobs)
		to_chat(user, "<span class='danger'>You used \the [attack_noun] to attack [hit_mobs] other target\s!</span>")


/datum/unarmed_attack/bite/mandibles
	attack_verb = list("mauled","gored","perforated")
	attack_noun = list("mandibles")
	damage = 35
	shredding = 1
	sharp = 1
	edge = 1
	attack_name = "mandibles"

/datum/unarmed_attack/bite/infectious
	shredding = 1

/datum/unarmed_attack/bite/infectious/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/armor,var/attack_damage,var/zone)
	..()
	if(target && target.stat == DEAD)
		return
	if(target.internal_organs_by_name["zombie"])
		to_chat(user, "<span class='danger'>You feel that \the [target] has been already infected!</span>")

	var/infection_chance = 80
	infection_chance -= target.run_armor_check(zone,"melee")
	if(prob(infection_chance))
		if(target.reagents)
			target.reagents.add_reagent(/datum/reagent/toxin/trioxin, 10)


/datum/unarmed_attack/golem
	attack_verb = list("smashed", "crushed", "rammed")
	attack_noun = list("fist")
	damage = 15
	attack_sound = 'sound/weapons/heavysmash.ogg'
	attack_name = "crushing fist"
	shredding = 1

/datum/unarmed_attack/shocking
	attack_verb = list("prodded", "touched")
	attack_noun = list("electrifying fist")
	damage = 5
	attack_sound = 'sound/effects/sparks4.ogg'
	attack_name = "electrifying touch"

/datum/unarmed_attack/shocking/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/armor,var/attack_damage,var/zone)
	..()
	if(prob(25))
		target.electrocute_act(20, user, def_zone = zone)

/datum/unarmed_attack/flame
	attack_verb = list("scorched", "burned")
	attack_noun = list("flaming fist")
	damage = 10
	attack_sound = 'sound/items/welder.ogg'
	attack_name = "flaming touch"
	damage_type = BURN

/datum/unarmed_attack/flame/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/armor,var/attack_damage,var/zone)
	..()
	if(prob(25))
		target.apply_effect(1, INCINERATE, 0)
