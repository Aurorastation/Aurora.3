/datum/unarmed_attack/bite/sharp //eye teeth
	attack_verb = list("bit", "chomped on")
	attack_sound = 'sound/weapons/bite.ogg'
	desc = "Biting down on the opponent with your sharp teeth. Only possible if you aren't wearing a muzzle. Don't try biting their head, it won't work!"
	shredding = 0
	sharp = TRUE
	edge = TRUE
	damage = 5
	attack_name = "sharp bite"

/datum/unarmed_attack/diona
	attack_verb = list("lashed", "bludgeoned")
	attack_noun = list("tendril")
	desc = "Whip your enemy with a tendril! I hope we can show this on television."
	eye_attack_text = "a tendril"
	eye_attack_text_victim = "a tendril"
	attack_name = "tendrils"

/datum/unarmed_attack/claws
	attack_verb = list("scratched", "clawed", "slashed")
	attack_noun = list("claws")
	desc = "Use your in-built knives to turn your foes into mincemeat. Some call it unfair, some call it species superiority. Can't complain if they're dead*, though.<br/>*Citation Needed"
	eye_attack_text = "claws"
	eye_attack_text_victim = "sharp claws"
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	sharp = TRUE
	edge = TRUE
	damage = 5
	attack_name = "claws"

/datum/unarmed_attack/claws/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/skill = user.skills["combat"]
	var/obj/item/organ/external/affecting = target.get_organ(zone)

	if(!skill)	skill = 1
	attack_damage = Clamp(attack_damage, 1, 5)

	if(target == user)
		user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [user.get_pronoun("himself")] in the [affecting.name]!</span>")
		return 0

	switch(zone)
		if(BP_HEAD, BP_MOUTH, BP_EYES)
			// ----- HEAD ----- //
			switch(attack_damage)
				if(1 to 2)
					user.visible_message("<span class='danger'>[user] scratched [target] across [target.get_pronoun("his")] cheek!</span>")
				if(3 to 4)
					user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [target]'s [pick(BP_HEAD, "neck")]!</span>") //'with spread claws' sounds a little bit odd, just enough that conciseness is better here I think
				if(5)
					user.visible_message(pick(
						"<span class='danger'>[user] rakes [user.get_pronoun("his")] [pick(attack_noun)] across [target]'s face!</span>",
						"<span class='danger'>[user] tears [user.get_pronoun("his")] [pick(attack_noun)] into [target]'s face!</span>",
						))
		else
			// ----- BODY ----- //
			switch(attack_damage)
				if(1 to 2)	user.visible_message("<span class='danger'>[user] scratched [target]'s [affecting.name]!</span>")
				if(3 to 4)	user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [pick("", "", "the side of")] [target]'s [affecting.name]!</span>")
				if(5)		user.visible_message("<span class='danger'>[user] tears [user.get_pronoun("his")] [pick(attack_noun)] [pick("deep into", "into", "across")] [target]'s [affecting.name]!</span>")

/datum/unarmed_attack/claws/unathi
	sparring_variant_type = /datum/unarmed_attack/pain_strike/heavy // unathi have heavier pain hits in this mode

/datum/unarmed_attack/claws/shredding
	desc = "Use your in-built knives to turn your foes into mincemeat. These claws are durable enough for you to shred some objects open, such as airlocks. Some call it unfair, some call it species superiority. Can't complain if they're dead*, though.<br/>*Citation Needed"
	shredding = TRUE
	attack_name = "durable claws"

/datum/unarmed_attack/claws/strong
	attack_verb = list("slashed")
	damage = 10
	shredding = TRUE
	attack_name = "strong claws"

/datum/unarmed_attack/claws/strong/zombie
	attack_verb = list("mauled", "slashed", "gored", "stabbed")
	desc = "These claws are armor-piercing and do a good amount of damage, but do not infect! Use these if you need to take someone with heavy armor down."
	damage = 25
	armor_penetration = 35

/datum/unarmed_attack/bite/strong
	attack_verb = list("mauled")
	damage = 10
	shredding = TRUE
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
	desc = "Beat your opponent to death like you're a trash compactor and they're a piece of discarded Go-Go Gwok packaging! Murder has never been so efficient!"
	damage = 7
	attack_sound = 'sound/weapons/smash.ogg'
	attack_name = "heavy fist"
	shredding = TRUE
	sparring_variant_type = /datum/unarmed_attack/pain_strike/heavy

/datum/unarmed_attack/industrial/heavy
	damage = 9

/datum/unarmed_attack/industrial/xion
	damage = 5
	shredding = 0

/datum/unarmed_attack/terminator
	attack_verb = list("pulverized", "crushed", "pounded")
	attack_noun = list("power fist")
	desc = "Hunt down your foes and shove your arm straight through their torso with your highly advanced power fist! You are built to kill, show the world!"
	damage = 12
	attack_sound = 'sound/weapons/beartrap_shut.ogg'
	attack_name = "power fist"
	shredding = TRUE

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
	sharp = TRUE
	edge = TRUE
	attack_name = "massive claws"
	shredding = TRUE

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
	armor_penetration = 25
	shredding = TRUE
	sharp = TRUE
	edge = TRUE
	attack_name = "mandibles"

/datum/unarmed_attack/bite/infectious
	desc = "This attack infects those you bite, but it is chance-based and depends on their armour. It is not very strong against armoured foes, compared to your claws."
	damage = 20
	armor_penetration = 15
	shredding = TRUE

/datum/unarmed_attack/bite/infectious/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/armor,var/attack_damage,var/zone)
	..()
	if(!target || target.stat == DEAD)
		return
	if(target.internal_organs_by_name[BP_ZOMBIE_PARASITE])
		to_chat(user, SPAN_WARNING("You feel that \the [target] has been already infected!"))

	var/infection_chance = 80
	infection_chance -= target.get_blocked_ratio(zone, BRUTE, damage_flags = DAM_SHARP|DAM_EDGE, damage = damage)*100
	if(prob(infection_chance))
		if(target.reagents)
			var/trioxin_amount = REAGENT_VOLUME(target.reagents, /singleton/reagent/toxin/trioxin)
			target.reagents.add_reagent(/singleton/reagent/toxin/trioxin, min(10, ZOMBIE_MAX_TRIOXIN - trioxin_amount))

/datum/unarmed_attack/golem
	attack_verb = list("smashed", "crushed", "rammed")
	attack_noun = list("fist")
	damage = 15
	attack_sound = 'sound/weapons/heavysmash.ogg'
	attack_name = "crushing fist"
	shredding = TRUE

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

/datum/unarmed_attack/claws/vaurca_bulwark
	attack_verb = list("punched", "clobbered", "lacerated")
	attack_noun = list("clawed fists")
	eye_attack_text = "claws"
	eye_attack_text_victim = "claws"
	attack_name = "clawed fists"
	shredding = TRUE

	damage = 7.5
	attack_door = 20
	crowbar_door = TRUE

/datum/unarmed_attack/bite/warrior
	attack_name = "warrior bite"
	attack_verb = list("mauled", "lacerated")
	damage = 10
	desc = "Rip into an opponent with your warrior mandibles. Only possible if you aren't wearing a muzzle. Next to useless against someone in armour but the vicious attacks will shred someone without it into ribbons."