/datum/species/golem
	name = "Stoned Golem"
	name_plural = "golems"
	bodytype = "Golem"
	mob_size = 20

	icobase = 'icons/mob/human_races/golems/r_stone.dmi'
	deform = 'icons/mob/human_races/golems/r_stone.dmi'

	language = "Ceti Basic"
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch)
	flags = NO_BREATHE | NO_PAIN | NO_BLOOD | NO_SCAN | NO_POISON | NO_MINOR_CUT
	appearance_flags = HAS_SKIN_COLOR
	spawn_flags = IS_RESTRICTED
	siemens_coefficient = 0
	rarity_value = 5
	ethanol_resistance = -1

	meat_type = /obj/item/weapon/ore/slag
	gibber_type = /obj/effect/decal/cleanable/ash
	single_gib_type = /obj/effect/decal/cleanable/ash
	gibbed_anim = "empty"
	dusted_anim = "dust-g"
	remains_type = /obj/effect/decal/cleanable/ash
	death_message = "collapses into a heap of dust and raw material..."
	knockout_message = "falls to the ground, motionless!"
	halloss_message = "falls to the ground, motionless."
	halloss_message_self = "You can't go on..."

	brute_mod = 0.75
	slowdown = 1

	warning_low_pressure = 50 //golems can into space now
	hazard_low_pressure = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	breath_type = null
	poison_type = null

	base_color = "#515573"
	flesh_color = "#137E8F"
	blood_color = "#D8BFD8"

	has_organ = list(
		"brain" = /obj/item/organ/brain/golem
		)

	stamina	=	500			  //Tireless automatons
	stamina_recovery = 1
	sprint_speed_factor = 0.3
	exhaust_threshold = 0 //No oxyloss, so zero threshold

	unarmed_types = list(
		/datum/unarmed_attack
		)

/datum/species/golem/handle_death(var/mob/living/carbon/human/H, var/gibbed = 0)
	if(!gibbed)
		if(H.species.meat_type)
			var/obj/item/meat = new meat_type(H.loc)
			var/old_name = meat.name
			meat.name = "enchanted [old_name]"
		var/obj/item/organ/O = H.internal_organs_by_name["brain"]
		if(O && istype(O))
			O.removed(H)
		H.dust()

/datum/species/golem/handle_post_spawn(var/mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.assigned_role = "Golem"
		H.mind.special_role = "Golem"
	if(H.species.base_color)
		H.color = base_color //technically hacky but fuck it this is ss13 in BYOND code.
	H.gender = NEUTER


/datum/species/golem/sandstone
	name = "Sandstone Golem"
	base_color = "#D9C179"
	flesh_color = "#D9C179"
	meat_type = /obj/item/stack/material/sandstone
	unarmed_types = list(
		/datum/unarmed_attack/dense
		)

/datum/species/golem/marble
	name = "Marble Golem"
	base_color = "#AAAAAA"
	flesh_color = "#AAAAAA"
	meat_type = /obj/item/stack/material/marble
	unarmed_types = list(
		/datum/unarmed_attack/dense
		)

	brute_mod = 0.5

/datum/species/golem/phoron
	name = "Phoron Golem"
	base_color = "#FC2BC5"
	flesh_color = "#FC2BC5"
	unarmed_types = list(
		/datum/unarmed_attack/dense
		)

	inherent_verbs = list(
	/mob/living/carbon/human/proc/immolate
	)

	meat_type = /obj/item/stack/material/phoron

/datum/species/golem/phoron/handle_death(var/mob/living/carbon/human/H, var/gibbed = 0)
	if(!gibbed)
		H.visible_message("<span class='danger'>\The [H] ignites!</span>")
		H.apply_effect(10,INCINERATE)
		spawn(20)
			explosion(H.loc, -1, 0, 3)
			H.dust()


/datum/species/golem/metal
	name = "Metallic Golem"

	icobase = 'icons/mob/human_races/golems/r_metal.dmi'
	deform = 'icons/mob/human_races/golems/r_metal.dmi'

	brute_mod =     1
	burn_mod =      1
	total_health = 100

/datum/species/golem/metal/bronze
	name = "Bronze Golem"
	base_color = "#CD7F32"
	flesh_color = "#CD7F32"
	meat_type = /obj/item/weapon/material/ashtray/bronze

/datum/species/golem/metal/plastic
	name = "Plastic Golem"
	base_color = "#CCCCCC"
	flesh_color = "#CCCCCC"
	meat_type = /obj/item/stack/material/plastic

/datum/species/golem/metal/gold
	name = "Gold Golem"
	base_color = "#EDD12F"
	flesh_color = "#EDD12F"
	meat_type = /obj/item/stack/material/gold

	brute_mod =     0.9
	burn_mod =      0.9

	bump_flag = HEAVY
	swap_flags = ~HEAVY
	push_flags = HEAVY
	unarmed_types = list(
		/datum/unarmed_attack/superdense
		)

/datum/species/golem/metal/silver
	name = "Silver Golem"
	base_color = "#D1E6E3"
	flesh_color = "#D1E6E3"

	brute_mod =     0.8
	burn_mod =      0.8
	meat_type = /obj/item/stack/material/silver

/datum/species/golem/metal/mhydrogen
	name = "Metallic Hydrogen Golem"
	base_color = "#E6C5DE"
	flesh_color = "#E6C5DE"
	meat_type = /obj/item/stack/material/mhydrogen

	brute_mod =     0.8
	burn_mod =      0.8
	slowdown = 0
	unarmed_types = list(
		/datum/unarmed_attack/shocking
		)


	inherent_verbs = list(
	/mob/living/carbon/human/proc/recharge
	)


/datum/species/golem/metal/tritium
	name = "Tritium Golem"
	base_color = "#777777"
	flesh_color = "#777777"
	meat_type = /obj/item/stack/material/tritium

	brute_mod =     0.7
	burn_mod =      0.7

	inherent_verbs = list(
	/mob/living/carbon/human/proc/radhug
	)

/datum/species/golem/metal/tritium/handle_post_spawn(var/mob/living/carbon/human/H)
	..()
	H.set_light(1, 1, "#777777")

/datum/species/golem/metal/tritium/handle_death(var/mob/living/carbon/human/H, var/gibbed = 0)
	if(!gibbed)
		H.visible_message("<span class='danger'>\The [H] glows vibrantly in death!</span>")
		spawn(40)
			for (var/mob/living/M in range(3,H))
				if(M == src)
					continue
				var/distance = (get_dist(M,src)*15)
				M << "<span class='warning'>You feel an unpleasantly warm sensation wash over you.</span>"
				M.apply_effect((rand(20,60) - distance), IRRADIATE)
			H.dust()

/datum/species/golem/metal/tritium/hug(var/mob/living/carbon/human/H,var/mob/living/target)
	..()
	if(target.total_radiation > 0)
		var/rads_message
		switch(target.total_radiation)
			if(91 to INFINITY)		rads_message = "apocalyptic levels of radiation"
			if(81 to 90)			rads_message = "deadly levels of radiation"
			if(61 to 80)			rads_message = "a nuclear cesspool"
			if(31 to 60)			rads_message = "a radioactive tingling"
			if(11 to 30)			rads_message = "a great deal of warmth"
			if(1 to 10)				rads_message = "some warmth"
			else					rads_message = "a little warmth"

		H << "<span class='notice'>You sense [rads_message] within [target]!</span>"

/datum/species/golem/metal/iron
	name = "Iron Golem"
	base_color = "#5C5454"
	flesh_color = "#5C5454"
	meat_type = /obj/item/stack/material/iron

	brute_mod =     0.7
	burn_mod =      0.7

/datum/species/golem/metal/steel
	name = "Steel Golem"
	base_color = "#666666"
	flesh_color = "#666666"
	meat_type = /obj/item/stack/material/steel

	brute_mod =     0.6
	burn_mod =      0.6

/datum/species/golem/metal/osmium
	name = "Osmium Golem"
	base_color = "#9999FF"
	flesh_color = "#9999FF"
	meat_type = /obj/item/stack/material/osmium

	brute_mod =     0.5
	burn_mod =      0.5
	total_health =  115
	slowdown = 2

	bump_flag = HEAVY
	swap_flags = ~HEAVY
	push_flags = HEAVY
	unarmed_types = list(
		/datum/unarmed_attack/superdense
		)


/datum/species/golem/metal/platinum
	name = "Platinum Golem"
	base_color = "#9999FF"
	flesh_color = "#9999FF"
	meat_type = /obj/item/stack/material/platinum

	brute_mod =     0.5
	burn_mod =      0.5
	total_health =  125
	slowdown = 2
	unarmed_types = list(
		/datum/unarmed_attack/dense
		)

/datum/species/golem/metal/uranium
	name = "Uranium Golem"
	base_color = "#5DCA31"
	flesh_color = "#5DCA31"
	meat_type = /obj/item/stack/material/uranium

	brute_mod =     0.5
	burn_mod =      0.5
	total_health =  125
	slowdown = 2
	unarmed_types = list(
		/datum/unarmed_attack/dense
		)

	inherent_verbs = list(
	/mob/living/carbon/human/proc/radhug,
	/mob/living/carbon/human/proc/gammaburst
	)

/datum/species/golem/metal/uranium/handle_post_spawn(var/mob/living/carbon/human/H)
	..()
	H.set_light(1, 2, "#F3D203")

/datum/species/golem/metal/uranium/handle_death(var/mob/living/carbon/human/H, var/gibbed = 0)
	if(!gibbed)
		H.visible_message("<span class='danger'>\The [H] glows vibrantly in death!</span>")
		spawn(20)
			for (var/mob/living/M in range(3,H))
				if(M == src)
					continue
				var/distance = (get_dist(M,src)*15)
				M << "<span class='warning'>You feel an unpleasantly warm sensation wash over you.</span>"
				M.apply_effect((rand(120,300) - distance), IRRADIATE)
			H.dust()

/datum/species/golem/metal/uranium/hug(var/mob/living/carbon/human/H,var/mob/living/target)
	..()
	if(target.total_radiation > 0)
		var/rads_message
		switch(target.total_radiation)
			if(91 to INFINITY)		rads_message = "apocalyptic levels of radiation"
			if(81 to 90)			rads_message = "deadly levels of radiation"
			if(61 to 80)			rads_message = "a nuclear cesspool"
			if(31 to 60)			rads_message = "a radioactive tingling"
			if(11 to 30)			rads_message = "a great deal of warmth"
			if(1 to 10)				rads_message = "some warmth"
			else					rads_message = "a little warmth"

		H << "<span class='notice'>You sense [rads_message] within [target]!</span>"
	if(prob(25))
		target.apply_radiation(rand(1,15))

/datum/species/golem/metal/plasteel
	name = "Plasteel Golem"
	base_color = "#777777"
	flesh_color = "#777777"
	meat_type = /obj/item/stack/material/plasteel

	brute_mod =     0.5
	burn_mod =      0.5
	total_health =  135
	slowdown = 3
	unarmed_types = list(
		/datum/unarmed_attack/dense
		)

/datum/species/golem/metal/titanium
	name = "Titanium Golem"
	base_color = "#D1E6E3"
	flesh_color = "#D1E6E3"
	meat_type = /obj/item/weapon/material/shard/shrapnel/flechette

	brute_mod =     0.35
	burn_mod =      0.35
	total_health =  150
	slowdown = 4
	unarmed_types = list(
		/datum/unarmed_attack/dense
		)

/datum/species/golem/crystal
	name = "Crystalline Golem"

	icobase = 'icons/mob/human_races/golems/r_crystal.dmi'
	deform = 'icons/mob/human_races/golems/r_crystal.dmi'
	mob_size = 15
	sprint_speed_factor = 0.5


	brute_mod =     1.5
	total_health =  75
	slowdown = 0

/mob/living/carbon/human/crystalgolem/bullet_act(var/obj/item/projectile/P, var/def_zone)
	if(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam))

		var/reflectchance = 120 - round(P.damage/3)
		if(P.starting && prob(reflectchance))
			visible_message("<span class='danger'>\The [src] reflects \the [P] off of their crystalline body!</span>")

			// Find a turf near or on the original location to bounce to
			var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
			var/turf/curloc = get_turf(src)

			// redirect the projectile
			P.redirect(new_x, new_y, curloc, user)

			return PROJECTILE_CONTINUE // complete projectile permutation
	..()

/datum/species/golem/crystal/glass
	name = "Glass Golem"
	base_color = "#00E1FF"
	flesh_color = "#00E1FF"
	meat_type = /obj/item/stack/material/glass

/datum/species/golem/crystal/rglass
	name = "Reinforced Glass Golem"
	base_color = "#00E1FF"
	flesh_color = "#00E1FF"
	meat_type = /obj/item/stack/material/glass/reinforced

	brute_mod =     1.25

/datum/species/golem/crystal/pglass
	name = "Borosilicate Glass Golem"
	base_color = "#FC2BC5"
	flesh_color = "#FC2BC5"
	meat_type = /obj/item/stack/material/glass/phoronglass

	brute_mod =     1.25
	burn_mod =      0.5
	total_health =  75

/datum/species/golem/crystal/rpglass
	name = "Reinforced Borosilicate Glass Golem"
	base_color = "#FC2BC5"
	flesh_color = "#FC2BC5"
	meat_type = /obj/item/stack/material/glass/phoronrglass

	brute_mod =     1
	burn_mod =      0.25
	total_health =  100

/datum/species/golem/crystal/diamond
	name = "Diamond Golem"
	base_color = "#00FFE1"
	flesh_color = "#00FFE1"
	meat_type = /obj/item/stack/material/diamond

	brute_mod =     0.5
	burn_mod =      0.25
	total_health =  125

/datum/species/golem/cloth
	name = "Sewn Golem"

	icobase = 'icons/mob/human_races/golems/r_cloth.dmi'
	deform = 'icons/mob/human_races/golems/r_cloth.dmi'
	mob_size = 10
	sprint_speed_factor = 1
	brute_mod =     1.25
	burn_mod =      2
	total_health = 50
	slowdown = -2

/datum/species/golem/cloth/cloth
	name = "Cloth Golem"
	base_color = "#FFFFFF"
	flesh_color = "#FFFFFF"
	meat_type = /obj/item/stack/material/cloth

/datum/species/golem/cloth/cardboard
	name = "Cardboard Golem"
	base_color = "#473D35"
	flesh_color = "#473D35"
	meat_type = /obj/item/stack/material/cardboard

/datum/species/golem/cloth/cardboard/handle_post_spawn(var/mob/living/carbon/human/H)
	..()
	H.equip_to_slot(new /obj/item/clothing/head/cardborg(src),slot_head)
	H.equip_to_slot(new /obj/item/clothing/suit/cardborg(src),slot_wear_suit)

/datum/species/golem/cloth/cloth/carpet
	name = "Shaggy Golem"
	base_color = "#DA020A"
	flesh_color = "#DA020A"

	brute_mod =     1
	total_health = 75
	meat_type = /obj/item/stack/tile/carpet

/datum/species/golem/flesh
	name = "Homonculus"
	name_plural = "homonculi"
	mob_size = 15
	gluttonous = GLUT_SMALLER
	meat_type = /obj/item/device/soulstone

	inherent_verbs = list(
	/mob/living/proc/devour,
	/mob/living/carbon/human/proc/regurgitate,
	/mob/living/carbon/human/proc/homonculify
	)

	icobase = 'icons/mob/human_races/golems/r_flesh.dmi'
	deform = 'icons/mob/human_races/golems/r_flesh.dmi'
	base_color = "#A10808"
	flags = NO_BREATHE | NO_PAIN | NO_SCAN | NO_POISON | NO_MINOR_CUT
	appearance_flags = 0

	brute_mod =     0.75
	burn_mod =      0.75
	total_health = 125
	base_color = 0

	blood_color = "#A10808"
	unarmed_types = list(
		/datum/unarmed_attack/claws/strong,
		/datum/unarmed_attack/bite/strong
		)

/datum/species/golem/wood
	name = "Wood Golem"
	mob_size = 15
	meat_type = /obj/item/stack/material/wood

	icobase = 'icons/mob/human_races/golems/r_wood.dmi'
	deform = 'icons/mob/human_races/golems/r_wood.dmi'
	appearance_flags = 0

	brute_mod =     0.75
	burn_mod =      1.5
	total_health = 100
	base_color = 0

////////////
///POWERS///
////////////

/mob/living/carbon/human/proc/radhug()
	set category = "Abilities"
	set name = "Absorb Radiation"
	set desc = "While grabbing someone, absorb any radiation they may have and heal yourself with it."

	if(last_special > world.time)
		src << "<span class='warning'>You are still absorbing your previous hug!</span>"
		return

	if(stat || paralysis || stunned || weakened || lying)
		src << "<span class='warning'> You cannot do that in your current state.</span>"
		return

	var/obj/item/weapon/grab/G = locate() in src
	if(!G || !istype(G))
		src << "<span class='warning'>You are not grabbing anyone.</span>"
		return

	if(!istype(G.affecting,/mob/living))
		src << "span class = 'warning'>[G.affecting] is not compatible with your embrace!</span>"
		return

	var/mob/living/M = G.affecting
	if(M.total_radiation <= 0)
		src << "span class = 'warning'>[G.affecting] is devoid of radioactive warmth! Anathema!</span>"
		return

	last_special = world.time + 10

	visible_message("<span class='warning'><b>\The [src]</b> embraces \the [G.affecting]'s and begins to glow!</span>")

	var/rads = M.total_radiation
	M.total_radiation = 0
	src.heal_overall_damage(rads, rads)

/mob/living/carbon/human/proc/gammaburst()
	set category = "Abilities"
	set name = "Gamma Burst"
	set desc = "Emit a moderate burst of ambient radiation."

	if(last_special > world.time)
		src << "<span class='warning'>You are not ready for a gamma burst.</span>"
		return

	if(stat || paralysis || stunned || weakened || lying)
		src << "<span class='warning'> You cannot do that in your current state.</span>"
		return

	last_special = world.time + 60

	visible_message("<span class='warning'><b>\The [src]</b> glows brightly!</span>")
	sleep(10)
	playsound(src, 'sound/effects/EMPulse.ogg', 75, 1)
	for (var/mob/living/M in range(3,src))
		if(M == src)
			continue
		var/distance = (get_dist(M,src)*15)
		M << "<span class='warning'>You feel an unpleasantly warm sensation wash over you.</span>"
		M.apply_effect((rand(80,120) - distance), IRRADIATE)

/mob/living/carbon/human/proc/immolate()
	set category = "Abilities"
	set name = "Immolate"
	set desc = "Emit a short burst of heat that immolates mobs adjacent to you."

	if(last_special > world.time)
		src << "<span class='warning'>You are not ready to immolate.</span>"
		return

	if(stat || paralysis || stunned || weakened || lying)
		src << "<span class='warning'>You cannot do that in your current state.</span>"
		return

	last_special = world.time + 120

	visible_message("<span class='warning'><b>\The [src]</b> emits a wave of fire!</span>")
	playsound(src, 'sound/effects/bamf.ogg', 75, 1)
	for (var/mob/living/M in orange(1,src))
		if(prob(90))
			M << "<span class='warning'>You ignite!</span>"
			M.apply_effect(rand(2,12), INCINERATE)

/mob/living/carbon/human/proc/recharge()
	set category = "Abilities"
	set name = "Recharge"
	set desc = "Charge allenergy cells within sight."

	if(stat || paralysis || stunned || weakened || lying)
		src << "<span class='warning'>You cannot do that in your current state.</span>"
		return

	if(last_special > world.time)
		src << "<span class='warning'>You are still recharging your energy!</span>"
		return


	visible_message("<span class='warning'><b>\The [src]</b> focuses for a moment, before emitting a weak pulse of electricity!</span>")

	last_special = world.time + 100

	for(var/atom/movable/M in view(7, src))
		for(var/obj/item/weapon/cell/C in M.contents)
			if(C.charge != C.maxcharge)
				var/datum/effect/effect/system/spark_spread/spark_system = PoolOrNew(/datum/effect/effect/system/spark_spread)
				spark_system.set_up(5, 0, M.loc)
				spark_system.start()
				C.charge += C.maxcharge/3
				if(C.charge >= C.maxcharge)
					C.charge = C.maxcharge

	for(var/obj/item/weapon/cell/C in view(7, src))
		if(C.charge != C.maxcharge)
			var/datum/effect/effect/system/spark_spread/spark_system = PoolOrNew(/datum/effect/effect/system/spark_spread)
			spark_system.set_up(5, 0, C.loc)
			spark_system.start()
			C.charge += C.maxcharge/2
			if(C.charge >= C.maxcharge)
				C.charge = C.maxcharge

/mob/living/carbon/human/proc/homonculify()
	set category = "Abilities"
	set name = "Resurrect"
	set desc = "While holding a brain of any kind, rejuvenate the brain's owner in the form of a homonculus."

	if(last_special > world.time)
		src << "<span class='warning'>You are not strong enough for that yet.</span>"
		return

	if(stat || paralysis || stunned || weakened || lying)
		src << "<span class='warning'>You cannot do that in your current state.</span>"
		return

	var/obj/item/organ/brain/B = get_active_hand()
	if(!istype(B))
		src << "<span class='warning'>You must be holding the brain in your active hand.</span>"
		return

	if(!B.brainmob)
		src << "<span class='warning'>The brain appears to be limb and unresponsive for now. A waste of time.</span>"
		return

	var/mob/selected = find_dead_player("[B.brainmob.ckey]")
	selected << 'sound/machines/chime.ogg'	//probably not the best sound but I think it's reasonable
	var/answer = alert(selected,"Do you want to return to life as a Homonculus?","Homonculification","Yes","No")
	if(answer != "No")
		if(!istype(B))
			src << "<span class='warning'>The brain emits a brief spark of life, but as it is no longer in your active hand you did not catch it.</span>"
			selected << "<span class='warning'>\The [src] no longer has your brain in their active hand. Revival aborted.</span>"
			return
		last_special = world.time + 100
		visible_message("<span class='warning'><b>\The [src]</b> rips a spark from the [B], and weaves a curtain of flesh around it from their own blood!</span>")
		sleep(30)
		var/mob/living/carbon/human/G = new(src.loc)
		G.set_species("Homonculus")
		G.key = selected
		G << "You are a Homonculus, a golem woven of flesh. You can impart the gift of your being upon any brain you find, and can devour creatures smaller than you with great gluttony. Serve [src], and assist them in completing their goals at any cost."
		qdel(B)
	else
		src << "<span class='warning'>The brain appears to be limb and unresponsive for now. A waste of time.</span>"
		return

/////////////
///ATTACKS///
/////////////

/datum/unarmed_attack/dense //attack used for high-level metal golems and stone golems.
	damage = 8
	attack_verb = list("pummelled", "bashed", "bwonked")
	attack_noun = list("heavy fist")
	attack_sound = 'sound/effects/bang.ogg'

/datum/unarmed_attack/superdense //attack used for gold and osmium golems
	attack_verb = list("pulverized", "crushed", "pounded", "atomized")
	attack_noun = list("dense fist")
	damage = 10
	attack_sound = 'sound/weapons/beartrap_shut.ogg'

/datum/unarmed_attack/superdense/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/armour,var/attack_damage,var/zone)
	..()
	if(prob(25) && target.mob_size <= 30)
		playsound(user, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		user.visible_message("<span class='danger'>[user] shoves hard, sending [target] flying!</span>")
		var/T = get_turf(user)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(3, 1, T)
		s.start()
		step_away(target,user,15)
		sleep(1)
		step_away(target,user,15)
		sleep(1)
		step_away(target,user,15)
		sleep(1)
		step_away(target,user,15)
		sleep(1)
		target.apply_effect(attack_damage * 0.4, WEAKEN, armour)

/datum/unarmed_attack/shocking //attack used for metallic hydrogen golems
	attack_verb = list("pulsed", "shocked", "zapped")
	attack_noun = list("electrified fist")
	attack_sound = 'sound/weapons/Egloves.ogg'

/datum/unarmed_attack/shocking/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/armour,var/attack_damage,var/zone)
	..()
	target.apply_damage(5, BURN, armour)
	if(prob(50))
		playsound(user, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		user.visible_message("<span class='danger'>[user] shocks [target]!</span>")
		var/T = get_turf(target)
		var/datum/effect/effect/system/spark_spread/spark_system = PoolOrNew(/datum/effect/effect/system/spark_spread)
		spark_system.set_up(5, 0, T)
		spark_system.start()
		target.apply_effect(attack_damage, STUN, armour)
		if(prob(15))
			empulse(target, 0, 1)