//contains:
//~seraph
//~sol combat drone
//~sol viscerator
//~mining drone

//////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////Seraph/////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

/obj/item/projectile/energy/plasmacannon
	name = "plasma arc"
	icon_state = "plasmacannon"
	damage = 25
	damage_type = BURN
	check_armour = "laser"
	pass_flags = PASSTABLE
	muzzle_type = /obj/effect/projectile/plasma/muzzle

/obj/item/projectile/energy/plasmacannon/on_impact(var/atom/A)
	..()
	if(istype(A, /mob/living))
		var/mob/living/L = A
		L.apply_damage(damage, BRUTE, def_zone)
		if(istype(A, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = L
			var/ultimate_def_zone = check_zone(def_zone)
			if(H.has_organ(ultimate_def_zone) && prob(20))
				var/obj/item/organ/external/E = H.get_organ(ultimate_def_zone)
				if(E.internal_organs)
					for(var/obj/item/organ/O in E.internal_organs)
						O.take_damage(rand(damage/5,damage))

/obj/item/projectile/missile
	name = "SRM-8 missile"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "missile"
	damage = 15
	damage_type = BRUTE
	nodamage = 0
	check_armour = "bullet"
	embed = 0
	sharp = 0
	muzzle_type = /obj/effect/projectile/bullet/muzzle

/obj/item/projectile/missile/on_impact(var/atom/A)
	..()
	explosion(A, -1, 0, 4, 6)

/mob/living/simple_animal/hostile/seraph
	name = "prototype Seraph"
	desc = "An ancient looking Seraph-exosuit prototype, caked in dirt and rust. Barely visible on its back are the letters \"SAC\", written in a yellowing paint."
	icon = 'icons/mob/cavern.dmi'
	icon_state = "bigbeepksy_off"
	icon_living = "bigbeepsky_off"
	icon_dead = "bigbeepsky_dead"
	ranged = 1
	turns_per_move = 1
	see_in_dark = 8
	response_help = "taps"
	response_disarm = "knocks"
	response_harm = "raps"
	a_intent = I_HURT
	stop_automated_movement_when_pulled = 0
	health = 550
	maxHealth = 550
	mob_size = 50
	opacity = 1
	melee_damage_lower = 15
	melee_damage_upper = 55
	attacktext = "smashes"
	attack_sound = 'sound/weapons/heavysmash.ogg'
	speed = 6
	move_to_delay = 10
	projectiletype = /obj/item/projectile/energy/plasmacannon
	projectilesound = 'sound/weapons/resonator_fire.ogg'
	destroy_surroundings = 1
	speak_emote = list("buzzes","declares")
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	faction = "sol"

	mob_bump_flag = HEAVY
	mob_swap_flags = ALLMOBS
	mob_push_flags = ALLMOBS

	var/online = 0
	var/shutdown = 1
	var/power_cell = 1
	var/last_target //only so target acquired messages don't get spammed
	var/searchingterm = 0
	var/external_shielding = 1

/mob/living/simple_animal/hostile/seraph/Initialize()
	. = ..()
	name = "[pick("Metatron","Uriel","Lucifer","Tyrael","Kemeul","Seraphiel","Nathanael")] - u[rand(100,999)]"


/mob/living/simple_animal/hostile/seraph/Life()
	if(online)
		. = ..()
		if(.)
			icon_state = "bigbeepsky_on"
			if(!power_cell)
				if(prob(33))
					LoseTarget()
				if(prob(5))
					online = 0
					shutdown = 1
					addtimer(CALLBACK(src, .proc/ThanksLohikar), rand(20,100))

			if(!target_mob)
				searchingterm = world.time + 3000
			else
				searchingterm = 0

			if(searchingterm)
				if(world.time > searchingterm)
					if(health < maxHealth)
						say("Damages detected. No hostils in vicinity. Engaging field repairs - unit shutting down.")
						online = 0
						shutdown = 1
					else
						searchingterm = 0
	else
		icon_state = "bigbeepsky_off"
		if(health < maxHealth)
			health += 25
			if(health >= maxHealth)
				health = maxHealth
		if(health >= 275 && !external_shielding)
			external_shielding = 1
		if(health >= 125 && !power_cell)
			faction = "sol"
			power_cell = 1
		if(!shutdown)
			var/area/powerhouse = get_area(src)
			if(powerhouse.powered(EQUIP))
				playsound(src.loc, 'sound/mecha/nominal.ogg', 100, 0, -6.6, environment=1)
				say("Sol Aerospace Corporation Seraph prototype model [name] online. All systems nominal. Warning: this unit is armed to kill.")
				online = 1
		else
			if(power_cell)
				if(health == maxHealth)
					shutdown = 0

/mob/living/simple_animal/hostile/seraph/Move()
	. = ..()
	if(.)
		playsound(src,'sound/mecha/mechstep.ogg',40,1)

/mob/living/simple_animal/hostile/seraph/FoundTarget()
	if(target_mob != last_target)
		if(ishuman_species(target_mob))
			say("Intruder with unauthorized access detected. Facility status: code red. Opening fire.")
		else
			say("Alien lifeform detected. Facility status: code red. Opening fire.")
	return

/mob/living/simple_animal/hostile/seraph/LostTarget()
	say("Target lost. Resuming patrol.")
	return

/mob/living/simple_animal/hostile/seraph/OpenFire(target_mob)
	var/target = target_mob
	visible_message("<span class='danger'><b>[src]</b> fires at [target]!</span>", 1)
	if(prob(70))
		if(prob(25))
			say("Opening fire.")
		projectiletype = /obj/item/projectile/energy/plasmacannon
		projectilesound = 'sound/weapons/resonator_fire.ogg'
		Shoot(target, src.loc, src)
	else if(prob(30))
		say("Engaging taser hardpoint. Resistance is futile.")
		projectiletype = /obj/item/projectile/beam/stun
		projectilesound = 'sound/weapons/Taser.ogg'
		var/datum/callback/shootcb = CALLBACK(src, /mob/living/simple_animal/hostile/.proc/Shoot, target, loc, src)
		addtimer(shootcb, 1)
		addtimer(shootcb, 4)
		addtimer(shootcb, 6)
	else
		if(prob(60))
			say("Deploying stun grenade.")
			var/obj/item/weapon/grenade/flashbang/F = new /obj/item/weapon/grenade/flashbang(src.loc)
			F.throw_at(target_mob, 30, 2, src)
			addtimer(CALLBACK(F, /obj/item/weapon/grenade/.proc/prime), 20)
		else
			say("Deploying explosive payload.")
			projectiletype = /obj/item/projectile/missile
			projectilesound = 'sound/effects/bang.ogg'
			Shoot(target, src.loc, src)

	stance = HOSTILE_STANCE_IDLE
	last_target = target_mob
	target_mob = null
	return

/mob/living/simple_animal/hostile/seraph/AttackingTarget()
	setClickCooldown(attack_delay)
	if(!Adjacent(target_mob))
		return
	if(isliving(target_mob))
		var/mob/living/L = target_mob
		var/attack_numeral = rand(melee_damage_lower,melee_damage_upper)
		L.attack_generic(src,attack_numeral,attacktext)
		if(attack_numeral >= 35)
			spark(L.loc, 3, alldirs)
			step_away(L,user,15)
			addtimer(CALLBACK(src, .proc/ThanksLohikar2, L, user, attack_numeral), 1)
		return L
	if(istype(target_mob,/obj/mecha))
		var/obj/mecha/M = target_mob
		M.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return M
	if(istype(target_mob,/obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		B.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		return B

/mob/living/simple_animal/hostile/seraph/death()
	stat = DEAD
	var/death_wail = pick("Error. Error. All systems critical. Core meltdown imminent.","Error. Self destruct engaged.", "Braindeath imminent. Systems shutting down.","I have waited long for this day...","Peace...at last...","Thank you...")
	say(death_wail)
	online = 0
	shutdown = 1
	addtimer(CALLBACK(src, .proc/ThanksLohikar4), 30)

/mob/living/simple_animal/hostile/seraph/ex_act(severity)
	if(!blinded)
		flick("flash", flash)
	var/divisor = 1
	if(external_shielding)
		divisor = 3
	switch (severity)
		if (1.0)
			apply_damage(120/divisor, BRUTE)
		if (2.0)
			apply_damage(80/divisor, BRUTE)
		if(3.0)
			apply_damage(40/divisor, BRUTE)

/mob/living/simple_animal/hostile/seraph/proc/DamageCheck()
	if(!online)
		playsound(src.loc, 'sound/mecha/nominal.ogg', 100, 0, -6.6, environment=1)
		say("Sol Aerospace Corporation Seraph prototype model 2 online. All systems nominal. Warning: this unit is armed to kill.")
		online = 1
		shutdown = 0

	if(health <= 300)
		if(prob(20))
			single_spark(src.loc)

	if(health <= 275 && external_shielding)
		playsound(src.loc, 'sound/mecha/critdestr.ogg', 100, 0, -6.6, environment=1)
		say("Critical item destroyed. Hull shielding damaged.")
		spark(src, 3, alldirs)
		external_shielding = 0

	if(health <= 125 && power_cell)
		playsound(src.loc, 'sound/mecha/lowpowernano.ogg', 100, 0, -6.6, environment=1)
		say("Caution: Energy reserves critical. Identification friend-or-foe critically damaged.")
		faction = "no_power"
		spark(src, 3, alldirs)
		power_cell = 0

	if(health <= 75 && ranged)
		playsound(src.loc, 'sound/mecha/weapdestr.ogg', 100, 0, -6.6, environment=1)
		say("Critical hit sustained. Weapon hardpoint destroyed.")
		spark(src, 3, alldirs)
		ranged = 0

/mob/living/simple_animal/hostile/seraph/adjustBruteLoss(var/damage)
	var/ultimate_damage = damage
	if(external_shielding)
		ultimate_damage = (damage*0.5)
	..(ultimate_damage)
	DamageCheck()

/mob/living/simple_animal/hostile/seraph/adjustFireLoss(var/damage)
	var/ultimate_damage = damage
	if(external_shielding)
		ultimate_damage = (damage*0.7)
	..(ultimate_damage)
	DamageCheck()

/mob/living/simple_animal/hostile/seraph/bullet_act(var/obj/item/projectile/P)
	if(external_shielding)
		if(istype(P, /obj/item/projectile/bullet))
			var/reflectchance = 80 - round(P.damage/3)
			if(prob(reflectchance))
				adjustBruteLoss(P.damage * 0.3)
				visible_message("<span class='danger'>The [P.name] gets deflected by [src]'s external shielding!</span>", \
								"<span class='userdanger'>The [P.name] gets deflected by [src]'s external shielding!</span>")

				// Find a turf near or on the original location to bounce to
				if(P.starting)
					var/new_x = P.starting.x + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
					var/new_y = P.starting.y + pick(0, 0, -1, 1, -2, 2, -2, 2, -2, 2, -3, 3, -3, 3)
					var/turf/curloc = get_turf(src)

					// redirect the projectile
					P.redirect(new_x, new_y, curloc, src)

				return -1 // complete projectile permutation

	return (..(P))

/mob/living/simple_animal/hostile/seraph/adjustToxLoss(var/damage)
	return

/mob/living/simple_animal/hostile/seraph/adjustOxyLoss(var/damage)
	return

/mob/living/simple_animal/hostile/seraph/adjustCloneLoss(var/damage)
	return

/mob/living/simple_animal/hostile/seraph/adjustHalLoss(var/damage)
	return

/mob/living/simple_animal/hostile/seraph/proc/ThanksLohikar()
	online = 1
	shutdown = 0

/mob/living/simple_animal/hostile/seraph/proc/ThanksLohikar2(var/mob/living/L, var/mob/user, attack_numeral)
	step_away(L,user,15)
	addtimer(CALLBACK(src, .proc/ThanksLohikar3, L, user, attack_numeral), 1)

/mob/living/simple_animal/hostile/seraph/proc/ThanksLohikar3(var/mob/living/L, var/mob/user, attack_numeral)
	step_away(L,user,15)
	addtimer(CALLBACK(L, /mob/living/.proc/apply_effect,(attack_numeral * 0.3), WEAKEN), 1)

/mob/living/simple_animal/hostile/seraph/proc/ThanksLohikar4()
	fragem(src,10,50,2,2,4,1,2)
	var/obj/effect/decal/mecha_wreckage/WR = new /obj/effect/decal/mecha_wreckage/seraph(loc)
	WR.crowbar_salvage += new /obj/item/weapon/cell/mecha(WR)
	var/obj/item/device/mmi/MMI = new /obj/item/device/mmi(WR)
	if(prob(40))
		MMI.brainobj = new /obj/item/organ/brain(MMI)
		MMI.icon_state = "mmi_full"
	WR.crowbar_salvage += MMI
	if(prob(90))
		WR.crowbar_salvage += new /obj/machinery/portable_atmospherics/canister/air(WR)
	if(prob(50))
		WR.crowbar_salvage += new /obj/item/mecha_parts/mecha_equipment/armor_booster(WR)
	if(prob(35))
		WR.crowbar_salvage += new /obj/item/mecha_parts/mecha_equipment/repair_droid(WR)
	if(prob(60))
		WR.crowbar_salvage += new /obj/item/mecha_parts/mecha_equipment/weapon/energy/plasmacannon(WR)
	if(prob(30))
		WR.crowbar_salvage += new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive(WR)
	else
		WR.crowbar_salvage += new /obj/item/mecha_parts/mecha_equipment/weapon/energy/taser(WR)
	playsound(src.loc, 'sound/mecha/internaldmgalarm.ogg', 100, 0, -6.6, environment=1)
	qdel(src)

/mob/living/simple_animal/hostile/seraph/Allow_Spacemove(var/check_drift = 0)
	return 1

/mob/living/simple_animal/hostile/seraph/can_fall()
	return FALSE

/mob/living/simple_animal/hostile/seraph/can_ztravel()
	return TRUE

/mob/living/simple_animal/hostile/seraph/CanAvoidGravity()
	return TRUE

//////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////Sol Combat Drone///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/retaliate/malf_drone/sol
	name = "combat drone"
	desc = "An ancient looking combat drone. Even a amateur mechanist can easily see it is several models out of date."
	icon = 'icons/mob/cavern.dmi'
	speak = list("Sol Alliance is here to - Sssol All-All-Alliance is here - serve.","Protect and and protect and s-s-s-seeer-rve.","Tres-trespassing is-is-is a violati-tion of Sol l-l-law!","Intruuuuuuuuuuuuuuuuder det-detected. Terminating","Sounding the - sounding the alarm.", "CODE RED!")
	health = 65
	see_in_dark = 8
	maxHealth = 65

	faction = "sol"


//////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////Sol Viscerator/////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/viscerator
	name = "eviscerator"
	desc = "A small, twin-bladed machine capable of inflicting very deadly lacerations. This one seems quite rusty and worse for wear"
	melee_damage_lower = 5
	melee_damage_upper = 5

	faction = "sol"

//////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////Mining drone///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/retaliate/minedrone
	name = "mining rover"
	desc = "A dilapidated mining rover, with the faded colors of the Sol Alliance. It looks more than a little lost."
	icon = 'icons/mob/cavern.dmi'
	icon_state = "sadrone"
	icon_living = "sadrone"
	icon_dead = "sadrone_dead"
	move_to_delay = 5
	health = 60
	maxHealth = 60
	harm_intent_damage = 5
	ranged = 1
	melee_damage_lower = 0
	melee_damage_upper = 0
	attacktext = "barrels into"
	attack_sound = 'sound/weapons/punch1.ogg'
	a_intent = I_HURT
	speak_emote = list("chirps","buzzes","whirrs")
	emote_hear = list("chirps cheerfully","buzzes","whirrs","hums placidly","chirps","hums")
	projectiletype = /obj/item/projectile/beam/plasmacutter
	projectilesound = 'sound/weapons/plasma_cutter.ogg'
	destroy_surroundings = 1
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	light_range = 10
	light_wedge = LIGHT_WIDE
	see_in_dark = 8

	faction = "sol"

	var/list/loot = list()
	var/ore_message = 0
	var/target_ore

/mob/living/simple_animal/hostile/retaliate/minedrone/Initialize()
	. = ..()
	var/i = rand(1,6)
	while(i)
		loot += pick(/obj/item/weapon/ore/silver, /obj/item/weapon/ore/gold, /obj/item/weapon/ore/uranium, /obj/item/weapon/ore/diamond)
		i--

/mob/living/simple_animal/hostile/retaliate/minedrone/Life()
	..()
	FindOre()

/mob/living/simple_animal/hostile/retaliate/minedrone/proc/FindOre()
	if(!enemies.len)
		setClickCooldown(attack_delay)
		if(!target_ore in ListTargets(10))
			target_ore = null
		for(var/obj/item/weapon/ore/O in oview(1,src))
			O.forceMove(src)
			loot += O
			if(target_ore == O)
				target_ore = null
			if(!ore_message)
				ore_message = 1
		if(ore_message)
			visible_message("<span class='notice'>\The [src] collects the ore into a metallic hopper.</span>")
			ore_message = 0
		for(var/obj/item/weapon/ore/O in oview(7,src))
			target_ore = O
			break
		if(target_ore)
			walk_to(src, target_ore, 1, move_to_delay)
		else
			for(var/turf/simulated/mineral/M in orange(7,src))
				if(M.mineral)
					rapid = 1
					OpenFire(M)
					rapid = 0
					break

/mob/living/simple_animal/hostile/retaliate/minedrone/death()
	..(null,"is smashed into pieces!")
	var/T = get_turf(src)
	new /obj/effect/gibspawner/robot(T)
	spark(T, 3, alldirs)
	for(var/obj/item/weapon/ore/O in loot)
		O.forceMove(src.loc)
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/minedrone/adjustToxLoss(var/damage)
	return

/mob/living/simple_animal/hostile/retaliate/minedrone/adjustOxyLoss(var/damage)
	return

/mob/living/simple_animal/hostile/retaliate/minedrone/adjustCloneLoss(var/damage)
	return

/mob/living/simple_animal/hostile/retaliate/minedrone/adjustHalLoss(var/damage)
	return

/mob/living/simple_animal/hostile/retaliate/minedrone/fall_impact()
	visible_message("<span class='danger'>\The [src] bounces harmlessly on its inflated wheels.</span>")
	return FALSE