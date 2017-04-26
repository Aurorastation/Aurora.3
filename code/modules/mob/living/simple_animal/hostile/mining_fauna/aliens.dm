//contains:
//cavern dweller @ line #4
//baneslug @ line #67
//vox bandit @ line #
//blind hydra @ line #

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