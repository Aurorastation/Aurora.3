/datum/species/kocasslani

	name = "Neo-Kocasslani"
	name_plural = "Kocasslani"
	short_name = "koc"
	blurb = "In the grim darkness of the far future there is only war. In orbit above the pitiful empires of man a million drums beat in perfect unison. \
	War! War! War! The enslaving Kocasslani, a threat once thought diminished to irrelevancy, have returned. They have not spent these past years since their defeat \
	in idleness - they have modified their spirits and their bodies to perfection using dark magic and NanoTrasen slime research stolen from slimified Xenobiologists, \
	becoming the dreadful aberration: The Neo-Kocasslani. Their gelatinous \
	bodies have transcended their previous mortal weaknesses, at only the cost of their immortal soul. With the demonic power of Satan on their side, all else shall crumble. \
	Even now the Sol Alliance and the Jargon Federation lie in smoking ruins - Tau Ceti is next. \
	Employed on NanoTrasen stations for their admirable work ethics and can-do attitudes, Neo-Kocasslani are a common sight throughout space, frequently praised for \
	their good manners, reliability, intelligence, cannibalism, and innovation."
	age_min = 4
	age_max = 8
	economic_modifier = 20

	icobase = 'code/modules/mob/living/carbon/human/species/station/meme/r_kocasslani.dmi'

	has_floating_eyes = TRUE
	blood_color = "#1BE215"
	flesh_color = "#1BE215"
	virus_immune = TRUE

	language = "Neo-Kocasslani"
	name_language = "Neo-Kocasslani"

	unarmed_types = list(/datum/unarmed_attack/slime_glomp)
	brute_mod = 0.8
	burn_mod = 0.8
	oxy_mod = 0.8
	toxins_mod = 0.8
	radiation_mod = 0.8
	flash_mod = 0.8
	fall_mod = 0.8
	breakcuffs = list(MALE,FEMALE,NEUTER)

	reagent_tag = IS_SLIME
	cold_level_1 = 280
	cold_level_2 = 260
	cold_level_3 = 230
	hazard_low_pressure = -1
	heat_discomfort_level = -1
	cold_discomfort_level = 285
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You shiver suddenly.",
		"Your gelatinous innards begin to harden"
		)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/commune,
		/mob/living/proc/devour,
		/mob/living/carbon/human/proc/slime_toxin)
	siemens_coefficient = 3

	flags = NO_SCAN | NO_SLIP | NO_BREATHE | NO_EMBED | NO_BLOOD | NO_PAIN
	appearance_flags = HAS_EYE_COLOR | HAS_SOCKS
	spawn_flags = CAN_JOIN
	slowdown = -1

	ethanol_resistance = 0.25
	taste_sensitivity = TASTE_DULL

	sprint_speed_factor = 2.0

	gluttonous = TRUE
	allowed_eat_types = TYPE_ORGANIC

	                              // Determines the organs that the species spawns with and
	has_organ = list(
		"brain" = /obj/item/organ/brain/slime
		)

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/unbreakable),
		"groin" =  list("path" = /obj/item/organ/external/groin/unbreakable),
		"head" =   list("path" = /obj/item/organ/external/head/unbreakable),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/unbreakable),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/unbreakable),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/unbreakable),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/unbreakable),
		"l_hand" = list("path" = /obj/item/organ/external/hand/unbreakable),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/unbreakable),
		"l_foot" = list("path" = /obj/item/organ/external/foot/unbreakable),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/unbreakable)
		)

/datum/species/kocasslani/equip_survival_gear(var/mob/living/carbon/human/H)
	var/obj/item/weapon/material/S
	switch(rand(1,3))
		if(1)
			S = new /obj/item/weapon/material/twohanded/pike/halberd(H.)
		if(2)
			S = new /obj/item/weapon/material/sword/axe(H)
		if(3)
			if(prob(25))
				S = new /obj/item/weapon/material/twohanded/zweihander(H)
			else
				S = new /obj/item/weapon/material/twohanded/pike/pitchfork(H)

	if(!H.equip_to_slot_or_del(S, slot_r_hand))
		H.equip_to_slot_or_del(S, slot_l_hand)

	if(!QDELETED(S))
		S.autodrobe_no_remove = 1

	var/new_name = "[pick(list("Az","Ash","Agh","Bag","Bub","Dug","Durb","Ghash","Gimb","Glob","Gul","Hai","Ishi","Krimp","Lug","Nazg","Og","Ol","Ronk","Skai","Shar","Sha","Sna","Ga","Thrak","Ur","Uk"))]"
	var/max = rand(1,2)
	for(var/i=0;i<= max;i++)
		if(i != max && prob(50/max))
			new_name += "[pick(list("-","-","-","'","'","'"))]"
		new_name += "[pick(list("az","ash","agh","bag","bub","dug","durb","ghash","gimb","glob","gul","hai","ishi","krimp","lug","nazg","og","ol","ronk","skai","shar","sha","sna","ga","thrak","ur","uk"))]"
	new_name += "[pick(list(" the Tormentor", " the Defiler", " the Exterminator", " the Bringer of the End-Times", " the Bane of Man", " the Scream of Hell", " the Talon of Satan", " the Spine of Damnation", " the Skrell-slayer", " the Revengeance", " the Terminator", " the Thrice-Damned", " the Furious", " the Slayer", " the Black Claw", " the Damned", " the Burning Wrath", " the Godforsaken"))]"
	S.name = new_name
	S.desc += "This one has been forged in the hellfires of some infernal Neo-Kocasslani Warpvessel. On the bottom is stamped \"APPROVED FOR CARRY BY NANOTRASEN COMMISSAR-GENERAL M. TRASEN\"."
	H.gender = NEUTER

/datum/species/kocasslani/handle_death(var/mob/living/carbon/human/H)
	spawn(1)
		if(H)
			var/mob/living/carbon/slime/S = new /mob/living/carbon/slime(H.loc)
			H << "<b>Whatever complexity or civilization your Kocasslani mind had is now reduced to a feralness as your true form emerges from the dessicated carcass of your former self, free of the pathetic trappings of mortality and morality. Hail Satan!</b>"
			H.mind.transfer_to(S)
			H.gib()


/mob/living/carbon/human/proc/slime_toxin()
	set name = "Launch Neurogel"
	set desc = "Spits a toxic neurogel at someone, paralyzing them for a short time if they are not wearing protective gear."
	set category = "Abilities"

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		src << "You cannot spit neurotoxin in your current state."
		return

	visible_message("<span class='warning'>[src] launches neurotoxin!</span>", "<span class='notice'>You launch neurotoxin.</span>")

	src.apply_damage(5,BURN)
	var/obj/item/projectile/energy/neurotoxin/A = new /obj/item/projectile/energy/neurotoxin(src.loc)
	A.launch_projectile(get_edge_target_turf(src, src.dir))