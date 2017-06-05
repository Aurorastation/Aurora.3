//contains:
//~great worm
//~lesser worm
//~great worm king
//~loot tables

////////////////////////////////////////
///////////////Great Worm///////////////
////////////////////////////////////////

/obj/item/weapon/beartrap/sarlacc
	name = "great worm maw"
	desc = "Hop in, the gastrointestinal juices are just fine."
	icon = 'icons/mob/cavern.dmi'
	icon_state = "blank"
	mouse_opacity = 0
	throwforce = 0
	anchored = 1
	deployed = 1
	time_to_escape = 180 SECONDS
	var/mob/living/simple_animal/hostile/greatworm/originator
	var/mob/living/captive

/obj/item/weapon/beartrap/sarlacc/Destroy()
	if(originator)
		originator = null
	..()

/obj/item/weapon/beartrap/sarlacc/Crossed(AM as mob|obj)
	if(originator)
		if(deployed && isliving(AM) && !originator.eating)
			var/mob/living/L = AM
			L.visible_message(
				"<span class='danger'>[L] steps into \the [src].</span>",
				"<span class='danger'>You step into \the [src]!</span>",
				"<b>You hear a loud organic snap!</b>"
				)
			attack_mob(L)
			originator.eating = 1
			captive << "<span class='danger'>\The [src] begins digesting your upper body</span>"
			addtimer(CALLBACK(src, .proc/devour), 185 SECONDS)
	..()

/obj/item/weapon/beartrap/sarlacc/proc/devour()
	if(!captive)
		if(!deployed)
			deployed = 1
		return
	if(!originator)
		return
	if(!originator.eating)
		return
	var/mob/living/L = captive
	if(istype(L,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = L
		H.visible_message(
			"<span class='danger'>\The [src] snaps tight across [H]'s upper body, swallowing it in three grisly gulps.</span>",
			"<span class='danger'>You feel a searing pain as \the [src] severs your lower body and sends you careening into its grotesque gullet!</span>",
			"<b>You hear a sick crunch!</b>"
			)
		var/obj/item/organ/external/G = H.get_organ("groin")
		G.droplimb(0,DROPLIMB_EDGE)
		if(SSmob.greatasses.len)
			var/obj/structure/sarlacc/S = pick(SSmob.greatasses)
			H.forceMove(S.loc)
		else
			H.gib()
		originator.sated += 200+H.mob_size //instantly sates the originator
	else if(istype(L,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = L
		L.visible_message(
			"<span class='danger'>\The [src] spits [R] out with a frustrated screech after failing to swallow.</span>",
			"<span class='danger'>\The [src] scrapes and gnashes against your exoskeleton before spitting you out!</span>",
			"<b>You hear several metallic scrapes!</b>"
			)
		R.apply_damage(60,BRUTE)
	else
		L.visible_message(
			"<span class='danger'>\The [src] eviscerates [L] with its teeth, swallowing what little remains whole!</span>",
			"<span class='danger'>\The [src] turns you into a slightly viscuous and very bloody paste.</span>",
			"<b>You hear a grisly splat!</b>"
			)
		L.gib()
		originator.sated += L.mob_size*2
	unbuckle_mob()
	captive = null
	deployed = 1
	originator.eating = 0

/mob/living/simple_animal/hostile/greatworm
	name = "great worm"
	desc = "The gaping maw opens and closes eternally, insatiably... Rumours however tell that those who can sate it are rewarded."
	icon = 'icons/mob/cavern.dmi'
	icon_state = "sarlacc"
	health = 100
	maxHealth = 100
	gender = NEUTER
	status_flags = 0
	anchored = 1
	density = 0
	a_intent = I_HURT
	stop_automated_movement = 1
	wander = 0
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	layer = 2.1
	var/eating = 0
	var/sated = 0
	var/asleep = 0
	var/tentacles = 6
	var/list/active_tentacles = list()
	var/obj/item/weapon/beartrap/sarlacc/sarlacc
	var/loot_count
	var/spawn_delay = 0
	var/spawn_time = 5

	faction = "worms"

/mob/living/simple_animal/hostile/greatworm/Initialize()
	. = ..()
	SSmob.greatworms += src
	loot_count = 4+(rand(0,4))
	var/obj/item/weapon/beartrap/sarlacc/L = new /obj/item/weapon/beartrap/sarlacc(src.loc)
	L.originator = src
	sarlacc = L

/mob/living/simple_animal/hostile/greatworm/Destroy()
	SSmob.greatworms -= src
	if(sarlacc)
		qdel(sarlacc)
		sarlacc = null
	..()

/mob/living/simple_animal/hostile/greatworm/Life()
	..()
	if(!sarlacc)
		var/obj/item/weapon/beartrap/sarlacc/L = new /obj/item/weapon/beartrap/sarlacc(src.loc)
		L.originator = src
		sarlacc = L
	if(sated < 0)
		sated = 0
	if(sated == 0 && asleep)
		asleep = 0
		icon_state = "sarlacc"
		visible_message(
			"<span class='danger'>\The [src] awakens!</span>",
			"<span class='danger'>You awaken! You're so HUNGRY!</span>",
			"<b>You hear a deep, rumbling roar in the earth!</b>"
			)
		sarlacc.deployed = 1
	if(sated >= 200)
		Sandman()
	if(asleep)
		if(icon_state != "sarlacc_asleep")
			icon_state = "sarlacc_asleep"
		if(prob(50))
			sated -= 1
		if(prob(5) && tentacles < 6)
			tentacles += 1
		if(health < maxHealth)
			health += 1
			sated -= 1
			if(health >= maxHealth)
				health = maxHealth
		if(sarlacc.deployed)
			sarlacc.deployed = 0
	else
		while(eating)
			if(!sarlacc.deployed && sarlacc.captive) //if the sarlacc is not deployed but IS captivating, that means its captive escaped
				sarlacc.captive = null
				sarlacc.deployed = 1
				eating = 0
			else
				if(prob(50))
					var/mob/living/L = sarlacc.captive
					if(L)
						L.apply_damage(rand(3,10),BRUTE)

/mob/living/simple_animal/hostile/greatworm/death()
	..()
	visible_message("<span class='danger'>With a frenzy of tooth and tendril, \the [src] slides deep into the earth, leaving a gaping hole in its place!</span>")
	var/turf/T = src.loc
	T.ChangeTurf(/turf/space)
	qdel()

/mob/living/simple_animal/hostile/greatworm/proc/Sandman()
	if(!asleep)
		asleep = 1
	icon_state = "sarlacc_asleep"
	sarlacc.deployed = 0
	var/make_loot = loot_count
	visible_message("<span class='danger'>With a contented heave, \the [src] slides into the earth and begins regurgitating several treasures before shutting tight.</span>")
	while(make_loot)
		for(var/turf/simulated/floor/F in orange(1,src))
			new /obj/random/sarlacc(F)
			make_loot--
			sleep(5)
	new /obj/random/sarlacc/precious(src.loc)

/mob/living/simple_animal/hostile/greatworm/FindTarget()
	if(eating)
		return
	if(asleep)
		return
	..()

/mob/living/simple_animal/hostile/greatworm/FoundTarget()
	if(target_mob.faction != "syndicate")
		spawn_tentacle(target_mob)
	LoseTarget()
	return

/mob/living/simple_animal/hostile/greatworm/proc/spawn_tentacle(var/mob/living/target)
	if(active_tentacles.len >= tentacles)
		return 0
	if(spawn_delay > world.time)
		return 0
	if(target.loc == src.loc)
		return 0
	var/turf/T = get_turf(target.loc)
	if(!istype(T,/turf/simulated/floor/asteroid))
		return 0
	if(locate(/mob/living/simple_animal/hostile/lesserworm) in T)
		return 0
	spawn_delay = world.time + spawn_time
	var/turf/simulated/floor/asteroid/A = T
	var/mob/living/simple_animal/hostile/lesserworm/L = new /mob/living/simple_animal/hostile/lesserworm(A)
	if(A.dug < 1)
		A.gets_dug()
	active_tentacles += L
	L.originator = src
	L.faction = src.faction
	visible_message("<span class='danger'>\The [L] bursts from the earth under [target].</span>")


////////////////////////////////////////
////////Not So Great Worm///////////////
////////////////////////////////////////

/mob/living/simple_animal/hostile/lesserworm
	name = "lesser worm"
	desc = "The maw on this creature is substantially smaller than the one on it's master, but it still hurts like hell."
	icon = 'icons/mob/cavern.dmi'
	icon_state = "sarlacctentacle"
	health = 25
	maxHealth = 25
	gender = NEUTER
	status_flags = 0
	anchored = 1
	density = 0
	a_intent = I_HURT
	stop_automated_movement = 1
	wander = 0
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	var/mob/living/simple_animal/hostile/greatworm/originator

	faction = "worms"

/mob/living/simple_animal/hostile/lesserworm/Initialize()
	. = ..()
	addtimer(CALLBACK(src, .proc/Penetrate), 6)
	QDEL_IN(src, 15)

/mob/living/simple_animal/hostile/lesserworm/Destroy()
	if(originator)
		originator.active_tentacles -= src
	..()

/mob/living/simple_animal/hostile/lesserworm/proc/Penetrate()
	playsound(src.loc, 'sound/effects/blobattack.ogg', 100, 1)
	var/list/possible_targets = list()
	for(var/mob/living/L in src.loc)
		if(L != src)
			L.apply_damage(15,BRUTE)
			possible_targets += L
	if(Adjacent(originator) && possible_targets.len)
		var/mob/living/L = pick(possible_targets)
		L << "<span class='danger'>\The [src] wraps around you tightly and flings you into \the [originator]'s maw!</span>"
		L.Move(originator.loc)

////////////////////////////////////////
////////Really Quite Great Worm/////////
////////////////////////////////////////

/obj/item/projectile/energy/thoughtbubble
	name = "psionic blast"
	icon_state = "ion"
	nodamage = 1
	taser_effect = 1
	agony = 20
	check_armour = "energy"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	var/list/thoughts = list(
		"You hear a cacophany of alien sounds.",
		"You see a field of black stars.",
		"You feel the sound of light.",
		"You feel the zap of an electric probe.",
		"You taste the iron blood of death.",
		"You feel time stop, and then suddenly begin again.",
		"Your brain is crying. Make it stop.",
		"You want more!",
		"You hear a whisper: \"Come closer...\"",
		"You feel a burning sensation; you miss home.",
		"You feel a burning sensation; you feel so alone.",
		"You feel a burning sensation; you're nothing to your peers.",
		"You feel a burning sensation; why do bad things happen to good people?",
		"You feel a burning sensation; time is moving so fast, and you feel so old.",
		"You feel like a stranger in a strange land.",
		"Colors swim before you, and you feel like you can touch each one.",
		"You feel like you're going to die here. It makes you happy.",
		"You feel like you could take a nap right here...",
		"You feel so tired.",
		"You scream and scream, but there is no sound.",
		"You feel like a prisoner of time, trying fruitlessly to break free.",
		"Today must be a Thursday. You could never quite get the hang of Thursdays.",
		"You've got a bad feeling about this."
	)

/obj/item/projectile/energy/thoughtbubble/on_impact(var/atom/A)
	..()
	if(istype(A, /mob/living))
		var/mob/living/L = A
		if(L.reagents)
			var/madhouse = pick("psilocybin","mindbreaker","impedrezene","cryptobiolin","stoxin","mutagen")
			var/madhouse_verbal_component = pick(thoughts)
			L.reagents.add_reagent("[madhouse]", 3)
			L << "<span class='alium'><b><i>[madhouse_verbal_component]</i></b></span>"

/mob/living/simple_animal/hostile/greatwormking
	name = "great worm king"
	desc = "This pulsating brain seems somehow connected to all the other orifices in this room..."
	icon = 'icons/mob/cavern.dmi'
	icon_state = "sarlaccbrain"
	health = 300
	maxHealth = 300
	gender = MALE
	status_flags = 0
	anchored = 1
	density = 1
	a_intent = I_HURT
	stop_automated_movement = 1
	wander = 0
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	ranged = 1
	projectilesound = 'sound/magic/WandODeath.ogg'
	projectiletype = /obj/item/projectile/energy/thoughtbubble
	emote_see = list("ooozes","pulses","drips","pumps")

	faction = "worms"

/mob/living/simple_animal/hostile/greatwormking/Destroy()
	playsound(src.loc, 'sound/hallucinations/wail.ogg', 200, 1, usepressure = 0)
	for(var/mob/living/L in SSmob.greatworms)
		L.death()
	for(var/obj/structure/S in SSmob.greatasses)
		qdel(S)
	..()

/obj/structure/sarlacc
	name = "great worm rectum"
	desc = "The intestinal length of the great worm this end belongs to travels for what looks like miles."
	icon = 'icons/mob/cavern.dmi'
	icon_state = "sarlaccend"
	anchored = 1
	density = 0
	layer = 2.1

/obj/structure/sarlacc/Initialize()
	. = ..()
	SSmob.greatasses += src

/obj/structure/sarlacc/Destroy()
	SSmob.greatasses -= src
	..()

////////////////////////////////////////
///////////////loot///////////////
////////////////////////////////////////

/obj/random/sarlacc //TODO: Finish. Currently a copy of random/loot
	name = "random sarlacc treasure"
	desc = "Stuff for the hole-fillers."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift3"
	problist = list(
		/obj/item/clothing/glasses/meson = 1,
		/obj/item/clothing/glasses/meson/prescription = 0.7,
		/obj/item/clothing/glasses/material = 0.8,
		/obj/item/clothing/glasses/sunglasses = 1.5,
		/obj/item/clothing/glasses/welding = 1.2,
		/obj/item/clothing/under/captain_fly = 0.5,
		/obj/item/clothing/under/rank/mailman = 0.6,
		/obj/item/clothing/under/rank/vice = 0.8,
		/obj/item/clothing/under/assistantformal = 1,
		/obj/item/clothing/under/rainbow = 0.9,
		/obj/item/clothing/under/overalls = 1,
		/obj/item/clothing/under/redcoat = 0.5,
		/obj/item/clothing/under/serviceoveralls = 1,
		/obj/item/clothing/under/psyche = 0.5,
		/obj/item/clothing/under/rank/dispatch = 0.8,
		/obj/item/clothing/under/syndicate/tacticool = 1,
		/obj/item/clothing/under/syndicate/tracksuit = 0.2,
		/obj/item/clothing/under/rank/clown = 0.1,
		/obj/item/clothing/under/mime = 0.1,
		/obj/item/clothing/accessory/badge = 0.2,
		/obj/item/clothing/accessory/badge/old = 0.2,
		/obj/item/clothing/accessory/storage/webbing = 0.6,
		/obj/item/clothing/accessory/storage/knifeharness = 0.3,
		/obj/item/clothing/head/collectable/petehat = 0.3,
		/obj/item/clothing/head/hardhat = 1.2,
		/obj/item/clothing/head/redcoat = 0.4,
		/obj/item/clothing/head/syndicatefake = 0.5,
		/obj/item/clothing/head/richard = 0.3,
		/obj/item/clothing/head/soft/rainbow = 0.7,
		/obj/item/clothing/head/plaguedoctorhat = 0.5,
		/obj/item/clothing/head/cueball = 0.5,
		/obj/item/clothing/head/pirate = 0.4,
		/obj/item/clothing/head/bearpelt = 0.4,
		/obj/item/clothing/head/witchwig = 0.5,
		/obj/item/clothing/head/pumpkinhead = 0.6,
		/obj/item/clothing/head/kitty = 0.2,
		/obj/item/clothing/head/ushanka = 0.6,
		/obj/item/clothing/head/helmet/augment = 0.1,
		/obj/item/clothing/mask/balaclava = 1,
		/obj/item/clothing/mask/gas = 1.5,
		/obj/item/clothing/mask/gas/cyborg = 0.7,
		/obj/item/clothing/mask/gas/owl_mask = 0.8,
		/obj/item/clothing/mask/gas/syndicate = 0.4,
		/obj/item/clothing/mask/fakemoustache = 0.4,
		/obj/item/clothing/mask/horsehead = 0.9,
		/obj/item/clothing/mask/gas/clown_hat = 0.1,
		/obj/item/clothing/mask/gas/mime = 0.1,
		/obj/item/clothing/shoes/rainbow = 1,
		/obj/item/clothing/shoes/jackboots = 1,
		/obj/item/clothing/shoes/workboots = 1,
		/obj/item/clothing/shoes/cyborg = 0.4,
		/obj/item/clothing/shoes/galoshes = 0.6,
		/obj/item/clothing/shoes/slippers_worn = 0.5,
		/obj/item/clothing/shoes/combat = 0.2,
		/obj/item/clothing/shoes/clown_shoes = 0.1,
		/obj/item/clothing/suit/storage/hazardvest = 1,
		/obj/item/clothing/suit/storage/leather_jacket/nanotrasen = 0.7,
		/obj/item/clothing/suit/ianshirt = 0.5,
		/obj/item/clothing/suit/syndicatefake = 0.6,
		/obj/item/clothing/suit/imperium_monk = 0.4,
		/obj/item/clothing/suit/storage/vest = 0.2,
		/obj/item/clothing/gloves/black = 1,
		/obj/item/clothing/gloves/fyellow = 1.2,
		/obj/item/clothing/gloves/yellow = 0.9,
		/obj/item/clothing/gloves/watch = 0.3,
		/obj/item/clothing/gloves/boxing = 0.3,
		/obj/item/clothing/gloves/boxing/green = 0.3,
		/obj/item/clothing/gloves/botanic_leather = 0.7,
		/obj/item/clothing/gloves/combat = 0.2,
		/obj/item/toy/bosunwhistle = 0.5,
		/obj/item/toy/balloon = 0.4,
		/obj/item/weapon/haircomb = 0.5,
		/obj/item/weapon/lipstick = 0.6,
		/obj/item/weapon/material/knife/hook = 0.3,
		/obj/item/weapon/material/hatchet/tacknife = 0.4,
		/obj/item/weapon/storage/fancy/cigarettes/dromedaryco = 1.2,
		/obj/item/weapon/storage/bag/plasticbag = 1,
		/obj/item/weapon/extinguisher = 1.3,
		/obj/item/weapon/extinguisher/mini = 0.9,
		/obj/item/device/flashlight = 1,
		/obj/item/device/flashlight/heavy = 0.5,
		/obj/item/device/flashlight/maglight = 0.4,
		/obj/item/device/flashlight/flare = 0.5,
		/obj/item/device/flashlight/lantern = 0.4,
		/obj/item/device/taperecorder = 0.6,
		/obj/item/weapon/reagent_containers/food/drinks/teapot = 0.4,
		/obj/item/weapon/reagent_containers/food/drinks/flask/shiny = 0.3,
		/obj/item/weapon/reagent_containers/food/drinks/flask/lithium = 0.3,
		/obj/item/bodybag = 0.7,
		/obj/item/weapon/reagent_containers/spray/cleaner = 0.6,
		/obj/item/weapon/tank/emergency_oxygen = 0.7,
		/obj/item/weapon/tank/emergency_oxygen/double = 0.4,
		/obj/item/clothing/mask/smokable/pipe/cobpipe = 0.5,
		/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba = 0.7,
		/obj/item/weapon/flame/lighter = 0.9,
		/obj/item/weapon/flame/lighter/zippo = 0.7,
		/obj/item/device/gps/engineering = 0.6,
		/obj/item/device/megaphone = 0.5,
		/obj/item/device/floor_painter = 0.6,
		/obj/random/toolbox = 1,
		/obj/random/coin = 1.2,
		/obj/random/tech_supply = 1.2,
		/obj/random/powercell = 0.8,
		/obj/random/colored_jumpsuit = 0.7,
		/obj/random/booze = 1.1,
		/obj/random/belt = 0.9,
		/obj/random/backpack = 0.7,
		/obj/random/contraband = 0.9,
		/obj/random/firstaid = 0.4,
		/obj/random/medical = 0.4,
		/obj/random/glowstick = 0.7,
		/obj/item/weapon/caution/cone = 0.7,
		/obj/item/weapon/staff/broom = 0.5,
		/obj/item/weapon/soap = 0.4,
		/obj/item/weapon/storage/box/donkpockets = 0.6,
		/obj/item/weapon/contraband/poster = 1.3,
		/obj/item/device/magnetic_lock/security = 0.3,
		/obj/item/device/magnetic_lock/engineering = 0.3,
		/obj/item/weapon/shovel = 0.5,
		/obj/item/weapon/pickaxe = 0.4,
		/obj/item/weapon/inflatable_duck = 0.2,
		/obj/random/hoodie = 0.5
	)

/obj/random/sarlacc/precious //TODO: Finish. Currently a copy of random/highvalue
	name = "random high valuable item"
	desc = "This is a random high valuable item."
	icon = 'icons/obj/items.dmi'
	icon_state = "coin_diamond"
	problist = list(
		/obj/item/bluespace_crystal = 7,
		/obj/item/weapon/storage/secure/briefcase/money = 5,
		/obj/item/stack/telecrystal{amount = 10} = 7,
		/obj/item/clothing/suit/armor/reactive = 0.5,
		/obj/item/clothing/glasses/thermal = 0.5,
		/obj/item/weapon/gun/projectile/automatic/rifle/shotgun = 0.5,
		/obj/random/sword = 0.5,
		/obj/item/weapon/gun/energy/lawgiver = 0.5,
		/obj/item/weapon/melee/energy/axe = 0.5,
		/obj/item/weapon/gun/projectile/automatic/terminator = 0.5,
		/obj/item/weapon/rig/military = 0.5,
		/obj/item/weapon/rig/unathi/fancy = 0.5,
		/obj/item/clothing/mask/ai = 0.5
	)
