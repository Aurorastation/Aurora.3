//contains:
//~cavern dweller
//~baneslug
//~mouse parasite
//~vox bandit
//blind hydra

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
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/carpmeat
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
	see_in_dark = 8

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

/mob/living/simple_animal/hostile/retaliate/cavern_dweller/can_fall()
	return FALSE

/mob/living/simple_animal/hostile/retaliate/cavern_dweller/can_ztravel()
	return TRUE

/mob/living/simple_animal/hostile/retaliate/cavern_dweller/CanAvoidGravity()
	return TRUE

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
	see_in_dark = 5

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

	var/atom/movable/overlay/animation = new(loc)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src

	flick(anim, animation)
	if(do_gibs) gibs(loc, viruses, dna, gibber_type = /obj/effect/gibspawner/acid)
	src.visible_message("<span class='danger'>\The [src] bursts into acid!</span>")

	if(animation)
		QDEL_IN(animation, 15)
	if(src)
		QDEL_IN(src, 15)


/obj/item/weapon/grenade/chem_grenade/banegrenade
	name = "acid grenade"
	desc = "How did this come from that thing?"
	stage = 2
	path = 1

/obj/item/weapon/grenade/chem_grenade/banegrenade/Initialize()
	. = ..()
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

///////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////Mouse Parasite////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/mouse/host
	icon = 'icons/mob/mouse.dmi'
	icon_state = "mouse_white"
	item_state = "mouse_white"
	icon_living = "mouse_white"
	icon_dead = "mouse_white_dead"
	icon_rest = "mouse_white_sleep"
	body_color = "white"
	can_nap = 0

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	faction = "evil"

/mob/living/simple_animal/mouse/host/death()
	..()
	visible_message("<span class='danger'>[src]'s sides burst, revealing spindly arachnid legs.</span>")
	var/mob/living/simple_animal/hostile/mouse/L = new /mob/living/simple_animal/hostile/mouse(src.loc)
	L.name = name
	for(var/mob/living/simple_animal/mouse/host/H in oview(7,src))
		H.death()
	src.gib()

/mob/living/simple_animal/hostile/mouse
	name = "puppeteer"
	desc = "A disgusting arachnid creature slick with blood from the gaping wounds of its legholes."
	icon = 'icons/mob/cavern.dmi'
	icon_state = "mousething"
	icon_living = "mousething"
	icon_dead = "mousething_dead"
	turns_per_move = 5
	response_help = "rubs"
	response_disarm = "pokes"
	response_harm = "crushes"
	a_intent = I_HURT
	stop_automated_movement_when_pulled = 0
	health = 25
	maxHealth = 25
	melee_damage_lower = 5
	melee_damage_upper = 10
	attacktext = "leaps"
	attack_sound = 'sound/weapons/bite.ogg'
	speed = 4
	emote_see = list("quivers","chitters","bleeds")
	pass_flags = PASSTABLE
	mob_size = MOB_MINISCULE
	density = 0
	see_in_dark = 8

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	var/fed_increment = 0

	faction = "evil"

/mob/living/simple_animal/hostile/mouse/AttackingTarget()
	. = ..()
	if(isliving(.))
		var/mob/living/L = .
		if(L.reagents)
			L.reagents.add_reagent("toxin", 5)
			fed_increment += 5
			if(prob(10) && (!issilicon(L) && !isipc(L)))
				to_chat(L, "<span class='warning'>You feel a tiny prick.</span>")
				L.reagents.add_reagent("toxin", 5)
				L.reagents.add_reagent("mindbreaker", 1)
				fed_increment += 5

/mob/living/simple_animal/hostile/mouse/Life()
	..()
	if(fed_increment >= 20)
		if(!locate(/obj/effect/spider/mouse_egg	) in src.loc)
			fed_increment = 0
			visible_message("<span class='danger'>[src] rapidly secretes a small chrysalis layered with purple film from its eggsac.</span>")
		new /obj/effect/spider/mouse_egg(src.loc)
	if((fed_increment >= 15 && health <= maxHealth) && prob(10))
		health += fed_increment
		fed_increment = 0
		visible_message("<span class='danger'>\The [src] cannibalizes its eggsac, replenishing some of its own vigour.</span>")
		if(health >= maxHealth)
			health = maxHealth

/mob/living/simple_animal/hostile/mouse/death()
	..()
	src.gib()

/mob/living/simple_animal/hostile/mouse/fall_impact()
	visible_message("<span class='danger'>\The [src] agilely scurries down the sheer cliff wall.</span>")
	return FALSE

/obj/effect/spider/mouse_egg
	desc = "It looks like a weird egg."
	name = "egg"
	icon = 'icons/mob/cavern.dmi'
	icon_state = "mouseegg"
	health = 60

/obj/effect/spider/mouse_egg/Initialize()
	. = ..()
	addtimer(CALLBACK(src, .proc/hatch), 30 SECONDS)

/obj/effect/spider/mouse_egg/proc/hatch()
	new /mob/living/simple_animal/mouse/host(loc)
	qdel(src)

///////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////Vox bandit////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

/mob/living/simple_animal/hostile/vox
	name = "\improper Vox bandit"
	desc = "Your money and your life."
	icon = 'icons/mob/cavern.dmi'
	icon_state = "metalgearvox"
	icon_living = "metalgearvox"
	icon_dead = "metalgearvox_dead"
	speak_chance = 0
	turns_per_move = 5
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = 4
	stop_automated_movement_when_pulled = 0
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 20
	melee_damage_upper = 20
	attacktext = "punched"
	a_intent = I_HURT
	var/corpse = /obj/effect/landmark/corpse/vox
	var/weapon1  = /obj/item/weapon/melee/energy/vaurca
	var/obj/item/weapon/gun/energy/laser/weapon2 = /obj/item/weapon/gun/energy/laser
	ranged = 1
	projectilesound = 'sound/weapons/laser3.ogg'
	projectiletype = /obj/item/projectile/beam
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	environment_smash = 1
	faction = "syndicate"
	status_flags = CANPUSH
	var/laser_ammo
	see_in_dark = 8

/mob/living/simple_animal/hostile/vox/Initialize()
	. = ..()
	laser_ammo = rand(0,5)

/mob/living/simple_animal/hostile/vox/OpenFire(target_mob)
	if(laser_ammo <= 0)
		src.visible_message("*click click*")
		playsound(src.loc, 'sound/weapons/empty.ogg', 100, 1)
		ranged = 0
		return
	..()
	laser_ammo -= 1

/mob/living/simple_animal/hostile/vox/death()
	..()
	if(prob(75))
		playsound(src.loc, 'sound/machines/signal.ogg', 100, 1)
		sleep(40)
		playsound(loc, 'sound/effects/alert.ogg', 125, 1)
		explosion(src.loc, -1, 1, 4, 6)
		gib()
	else
		if(corpse)
			new corpse (src.loc)
		if(weapon1 && prob(33))
			new weapon1 (src.loc)
		if(weapon2 && prob(33))
			new weapon2 (src.loc)
			weapon2.power_supply.charge = laser_ammo*weapon2.charge_cost
		qdel(src)
		return

/mob/living/simple_animal/hostile/vox/fall_impact()
	return FALSE

///////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////Blind hydra///////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////