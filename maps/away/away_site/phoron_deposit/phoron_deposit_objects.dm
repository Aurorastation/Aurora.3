// Mob stuff
/mob/living/simple_animal/hostile/carp/shark/phoron_deposit
	maxHealth = 60
	health = 60

/mob/living/simple_animal/hostile/carp/shark/reaver/phoron_deposit
	maxHealth = 60
	health = 60
	speed = 6

/mob/living/simple_animal/hostile/gnat/phoron_deposit
	maxHealth = 15
	health = 15
	destroy_surroundings = TRUE

/mob/living/simple_animal/hostile/carp/shark/reaver/eel/phoron_deposit
	maxHealth = 90
	health = 90
	speed = 3
	var/tmp/wall_breaking_allowed = FALSE // The eel gets to break walls just to make sure the event can't be cheesed by building them
	var/tmp/breaking_wall = FALSE

/mob/living/simple_animal/hostile/carp/shark/reaver/eel/phoron_deposit/Move(NewLoc)
	if(!wall_breaking_allowed)
		return ..()

	if(!breaking_wall)
		if(istype(NewLoc, /turf/simulated/wall))
			breaking_wall = TRUE
			var/turf/wall = NewLoc
			spawn(0)
				sleep(5 SECONDS)
				if(wall && istype(wall, /turf/simulated/wall) && wall == get_turf(wall) && get_dist(src, wall) == 1)
					visible_message(SPAN_DANGER("With a loud thud, \the [src] breaks down the [wall]!"))
					playsound(src.loc, 'sound/effects/meteorimpact.ogg', 50, 1)
					wall.ChangeTurf(/turf/simulated/floor/exoplanet/asteroid/ash/rocky)
					new /obj/effect/decal/cleanable/floor_damage/broken6(get_turf(wall))
				breaking_wall = FALSE
			return FALSE

	return ..()

// Phoron deposit turf

/turf/simulated/floor/exoplanet/asteroid/ash/rocky/phoron_deposit
	name = "phoron deposit"
	desc = "A rare deposit, full of crystal phoron. You can drill it to extract it, but you've a feeling you should prepare accordingly first..."
	var/mineral_amount = 300

/turf/simulated/floor/exoplanet/asteroid/ash/rocky/phoron_deposit/Initialize()
	..()
	var/turf/T = get_turf(src)
	if (T)
		T.has_resources = TRUE
		if (!T.resources)
			T.resources = list()
		T.resources[ORE_PHORON] = mineral_amount

	return INITIALIZE_HINT_NORMAL

/turf/simulated/floor/exoplanet/asteroid/ash/rocky/phoron_deposit/Destroy()
	var/turf/T = get_turf(src)
	if (T && T.resources)
		T.resources[ORE_PHORON] = max(0, T.resources[ORE_PHORON] - mineral_amount)
		if (T.resources[ORE_PHORON] <= 0)
			T.resources -= ORE_PHORON
		if (!length(T.resources))
			T.has_resources = FALSE
	..()
	return QDEL_HINT_LETMELIVE

/turf/simulated/floor/exoplanet/asteroid/ash/rocky/phoron_deposit/gets_dug(var/mob/user)
	..()
	for (var/mob/M in view(null, src))
		M.show_message(SPAN_DANGER("You struggle to retain your balance as the ground beneath you violently tremors. This can't be just the work of the drill, something is coming!<br>"), 1)
	for (var/mob/L in world)
		if (L.client && L.z == src.z)
			if (!L.client.prefs || (L.client.prefs.sfx_toggles & ASFX_MUSIC))
				sound_to(L, 'sound/music/phoron_deposit.ogg')
	sleep(16 SECONDS)
	activate_fauna_spawners(src.z)

//Corpse
/obj/effect/landmark/corpse/einstein
	name = "Einstein Prospector"
	corpseuniform = /obj/item/clothing/under/rank/einstein
	corpseshoes = /obj/item/clothing/shoes/jackboots
	corpsehelmet = /obj/item/clothing/head/helmet/space/void/einstein
	corpsesuit = /obj/item/clothing/suit/space/void/einstein
	corpseid = TRUE
	corpseidjob = "Prospector (Einstein)"
	corpseidicon = "einstein_card"
	corpsepocket1 = /obj/item/storage/wallet/random

//Paper
/obj/item/paper/phoron_deposit/briefing_note
	name = "printed message"
	desc = "A message printed from a computer."
	info = "<h4>Einstein Engines Internal Communication</h4><br>\
From: Central Command<br>\
To: EEV Origination<br>\
<br>\
We have received credible intelligence that a large Conglomerate vessel is inbound to the sector, the sensor equipment on this vessel is very likely to detect the deposit. Therefore, awaiting further reinforcements is no longer an option. The deposit must be extracted before our competitors reach it.<br>\
<br>\
We understand your concerns regarding the caverns and the presence of fauna. We've prepared a plan of action to ensure the extraction is conducted safely, despite shortage of personnel.<br>\
<br>\
1. Gather all available resources.<br>\
An abundance of ammunition may prove necessary, bring as much as possible. Steel and plasteel will also be required in order to fortify the area around your drilling equipment. Additionally, you are advised to bring medicinal injectors in the event of an emergency, especially painkillers.<br>\
<br>\
2. Construct a defensive perimeter around the deposit. <br>\
Steel and plasteel barricades with barbed wire are advised. Construct several layers, if there is sufficient material to do so.<br>\
<br>\
3. Begin drilling operations.<br>\
Be prepared to defend yourselves upon activation of drilling equipment. We estimate that extracting the deposit entirely will take approximately 15 minutes.<br>\
<br>\
4. Evacuate the site.<br>\
Once the deposit is empty, abandon the defenses and quickly exfiltrate with the phoron. Should the presence of fauna be as intense as we anticipate, it is vital that the area is evacuated with haste. Do not attempt to hold the position.<br>\
<br>\
Follow these steps precisely, and the likelihood of a swift and safe extraction is high. Report back immediately upon mission success.<br>\
<br>\
Good luck.<br>\
<font size=1>Einstein Engines. Lead by our history, leading our future.</font>"
