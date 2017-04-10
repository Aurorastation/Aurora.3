//asteroid cavern creatures

////////////////////////////////////////
///Alberyk's discount Europa creature///
////////////////////////////////////////

/mob/living/simple_animal/hostile/retaliate/cavern_dweller
	name = "cavern dweller"
	desc = "An alien creature that dwells in the tunnels of the asteroid, commonly found in the Romanovich Cloud."
	icon = 'icons/mob/cavern.dmi'
	icon_state = "dweller"
	icon_living = "dweller"
	icon_dead = "dweller_dead"
	ranged = 1
	turns_per_move = 3
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"
	a_intent = I_HURT
	stop_automated_movement_when_pulled = 0
	health = 60
	maxHealth = 60
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "chomped"
	attack_sound = 'sound/weapons/bite.ogg'
	speed = 4
	projectiletype = /obj/item/projectile/beam/cavern
	projectilesound = 'sound/magic/lightningbolt.ogg'
	destroy_surroundings = 1
	emote_see = list("stares","hovers ominously","blinks")

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	faction = "cavern"

/mob/living/simple_animal/hostile/retaliate/cavern_dweller/Allow_Spacemove(var/check_drift = 0)
	return 1

/obj/item/projectile/beam/cavern
	name = "electrical discharge"
	icon_state = "stun"
	damage_type = BURN
	check_armour = "energy"
	damage = 5

	muzzle_type = /obj/effect/projectile/stun/muzzle
	tracer_type = /obj/effect/projectile/stun/tracer
	impact_type = /obj/effect/projectile/stun/impact

/obj/item/projectile/beam/cavern/on_impact(var/atom/A)
	if(ishuman(A))
		var/mob/living/carbon/human/M = A
		var/shock_damage = rand(10,20)
		M.electrocute_act(shock_damage, ran_zone())

///////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////Banelings/////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/baneling
	name = "baneslug"
	desc = "A small, quivering sluglike creature."
	icon = 'icons/mob/cavern.dmi'
	icon_state = "baneling"
	icon_living = "baneling"
	icon_dead = "baneling_dead"
	turns_per_move = 5
	response_help = "rubs"
	response_disarm = "pokes"
	response_harm = "slaps"
	a_intent = I_HURT
	stop_automated_movement_when_pulled = 0
	health = 5
	maxHealth = 5
	melee_damage_lower = 1
	melee_damage_upper = 6
	attacktext = "bursts"
	attack_sound = 'sound/effects/splat.ogg'
	speed = 4
	emote_see = list("quivers","rolls around","drools")
	pass_flags = PASSTABLE
	mob_size = MOB_MINISCULE
	density = 0


	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	faction = "cavern"

/mob/living/simple_animal/hostile/baneling/AttackingTarget()
	setClickCooldown(attack_delay)
	if(!Adjacent(target_mob))
		return
	Baneburst()

/mob/living/simple_animal/hostile/baneling/proc/Baneburst()
	if(isliving(target_mob))
		var/mob/living/L = target_mob
		L.attack_generic(src,rand(melee_damage_lower,melee_damage_upper),attacktext)
		L.apply_damage(rand(1,10),TOX)
	if(istype(target_mob,/obj/mecha))
		var/obj/mecha/M = target_mob
		M.attack_generic(src,(rand(melee_damage_lower,melee_damage_upper)+rand(1,10)),attacktext)
	if(istype(target_mob,/obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		B.attack_generic(src,(rand(melee_damage_lower,melee_damage_upper)+rand(1,10)),attacktext)
	new /obj/effect/decal/cleanable/greenglow(src.loc)
	src.gib()

/mob/living/simple_animal/hostile/baneling/death(gibbed)
	if(!gibbed)
		if(prob(15))
			new /obj/item/weapon/grenade/chem_grenade/banegrenade(src.loc)
		src.gib()

/mob/living/simple_animal/hostile/baneling/gib(anim="gibbed-m",do_gibs)
	death(1)
	transforming = 1
	canmove = 0
	icon = null
	invisibility = 101
	update_canmove()
	dead_mob_list -= src

	var/atom/movable/overlay/animation = null
	animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src

	flick(anim, animation)
	if(do_gibs) gibs(loc, viruses, dna, gibber_type = /obj/effect/gibspawner/acid)
	src.visible_message("<span class='danger'>\The [src] bursts into acid!</span>")

	spawn(15)
		if(animation)	qdel(animation)
		if(src)			qdel(src)


/obj/item/weapon/grenade/chem_grenade/banegrenade
	name = "acid grenade"
	desc = "How did this come from that thing?"
	stage = 2
	path = 1

/obj/item/weapon/grenade/chem_grenade/banegrenade/New()
	..()
	var/obj/item/weapon/reagent_containers/glass/beaker/large/B1 = new(src)
	var/obj/item/weapon/reagent_containers/glass/beaker/large/B2 = new(src)

	B1.reagents.add_reagent("phosphorus", 40)
	B1.reagents.add_reagent("potassium", 40)
	B1.reagents.add_reagent("amatoxin", rand(2,20))
	B1.reagents.add_reagent("cryptobiolin", rand(1,5))
	B2.reagents.add_reagent("sugar", 40)
	B2.reagents.add_reagent("amatoxin", rand(20,40))
	B2.reagents.add_reagent("cryptobiolin", rand(1,5))

	detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

	beakers += B1
	beakers += B2
	icon_state = initial(icon_state) +"_locked"


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
	response_help = "taps"
	response_disarm = "knocks"
	response_harm = "raps"
	a_intent = I_HURT
	stop_automated_movement_when_pulled = 0
	health = 650
	maxHealth = 650
	resistance = 15
	mob_size = 50
	opacity = 1
	melee_damage_lower = 15
	melee_damage_upper = 55
	attacktext = "smashes"
	attack_sound = 'sound/weapons/heavysmash.ogg'
	speed = 6
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
	destroy_surroundings = 1

	var/online = 0
	var/shutdown = 1
	var/power_cell = 1
	var/last_target //only so target acquired messages don't get spammed
	var/searchingterm = 0
	var/external_shielding = 1

/mob/living/simple_animal/hostile/seraph/New()
	..()
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
					spawn(rand(20,100))
						online = 1
						shutdown = 0

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
	visible_message("<span class='danger'>[src]</b> fires at [target]!</span>", 1)
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
		spawn(1)
			Shoot(target, src.loc, src)
		spawn(4)
			Shoot(target, src.loc, src)
		spawn(6)
			Shoot(target, src.loc, src)
	else
		if(prob(60))
			say("Deploying stun grenade.")
			var/obj/item/weapon/grenade/flashbang/F = new /obj/item/weapon/grenade/flashbang(src.loc)
			F.throw_at(target_mob, 30, 2, src)
			spawn(20)
				F.prime()
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
		if(attack_numeral >= 40)
			spark(L.loc, 3, alldirs)
			step_away(L,user,15)
			spawn(1)
				step_away(L,user,15)
				spawn(1)
					step_away(L,user,15)
					spawn(1)
						L.apply_effect(attack_numeral * 0.3, WEAKEN)
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
	spawn(30)
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

/mob/living/simple_animal/hostile/seraph/ex_act(severity)
	if(!blinded)
		flick("flash", flash)
	switch (severity)
		if (1.0)
			apply_damage(100, BRUTE)
		if (2.0)
			apply_damage(60, BRUTE)
		if(3.0)
			apply_damage(30, BRUTE)

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

/mob/living/simple_animal/hostile/seraph/adjustToxLoss(var/damage)
	return

/mob/living/simple_animal/hostile/seraph/adjustOxyLoss(var/damage)
	return

/mob/living/simple_animal/hostile/seraph/adjustCloneLoss(var/damage)
	return

/mob/living/simple_animal/hostile/seraph/adjustHalLoss(var/damage)
	return

