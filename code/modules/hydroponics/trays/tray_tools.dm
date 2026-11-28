//Analyzer, pestkillers, weedkillers, nutrients, hatchets, cutters.

/obj/item/wirecutters/clippers
	name = "plant clippers"
	desc = "A tool used to take samples from plants."
	icon_state = "plantclippers"
	item_state = "plantclippers"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_hydro.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_hydro.dmi',
		)
	toolspeed = 0.7
	/// Plant clippers have a 40% chance to successfully defuse a bomb, higher than standard because plant clippers are smaller.
	bomb_defusal_chance = 40
	build_from_parts = FALSE

/obj/item/wirecutters/clippers/update_icon()
	var/matrix/tf = matrix()
	var/obj/item/storage/S = loc
	if(istype(S, /obj/item/storage) && !S.storage_slots)
		tf.Turn(-90) //Vertical for storing compactly
		tf.Translate(-1, 0) //Could do this with pixel_x but let's just update the appearance once.
	transform = tf

/// Like a health analyzer, but for plants! Tells you everything you need to know.
/obj/item/analyzer/plant_analyzer
	name = "plant analyzer"
	icon = 'icons/obj/item/scanner.dmi'
	icon_state = "hydro"
	item_state = "hydro"
	var/form_title
	var/last_data
	matter = list(MATERIAL_STEEL = 80, MATERIAL_GLASS = 20)
	origin_tech = list(TECH_MAGNET = 1, TECH_BIO = 1)

/obj/item/analyzer/plant_analyzer/proc/print_report_verb()
	set name = "Print Plant Report"
	set category = "Object.Held"
	set src = usr

	if(usr.stat || usr.restrained() || usr.lying)
		return
	print_report(usr)

/obj/item/analyzer/plant_analyzer/Topic(href, href_list)
	if(..())
		return
	if(href_list["print"])
		print_report(usr)

/obj/item/analyzer/plant_analyzer/proc/print_report(var/mob/living/user)
	if(!last_data)
		to_chat(user, "There is no scan data to print.")
		return
	var/obj/item/paper/P = new /obj/item/paper(get_turf(src))
	P.set_content_unsafe("paper - [form_title]", "[last_data]")
	if(istype(user,/mob/living/carbon/human) && !(user.l_hand && user.r_hand))
		user.put_in_hands(P)
	user.visible_message("\The [src] spits out a piece of paper.")
	return

/obj/item/analyzer/plant_analyzer/attack_self(mob/user as mob)
	print_report(user)
	return 0

/obj/item/analyzer/plant_analyzer/afterattack(obj/target, mob/user, flag)
	if(!flag) return

	var/datum/seed/grown_seed
	var/datum/reagents/grown_reagents
	var/obj/structure/machinery/portable_atmospherics/hydroponics/scanned_tray
	var/obj/item/seeds/scanned_packet
	if(istype(target,/obj/structure/table))
		return ..()
	else if(istype(target,/obj/item/reagent_containers/food/snacks/grown))

		var/obj/item/reagent_containers/food/snacks/grown/G = target
		grown_seed = SSplants.seeds[G.plantname]
		grown_reagents = G.reagents

	else if(istype(target,/obj/item/grown))

		var/obj/item/grown/G = target
		grown_seed = SSplants.seeds[G.plantname]
		grown_reagents = G.reagents

	else if(istype(target,/obj/item/seeds))

		var/obj/item/seeds/S = target
		grown_seed = S.seed
		scanned_packet = S

	else if(istype(target,/obj/structure/machinery/portable_atmospherics/hydroponics))

		var/obj/structure/machinery/portable_atmospherics/hydroponics/H = target
		grown_seed = H.seed
		grown_reagents = H.reagents
		scanned_tray = H

	else if(istype(target, /obj/structure/flora/harvestable))
		var/obj/structure/flora/harvestable/FH = target
		grown_seed = FH.seed

	else if(istype(target, /obj/effect/plant))
		var/obj/effect/plant/EP = target
		grown_seed = EP.seed

	if(!grown_seed)
		to_chat(user, SPAN_DANGER("[src] can tell you nothing about \the [target]."))
		return

	var/botany_skill = GET_SKILL_LEVEL(user, XENOBOTANY_SKILL_COMPONENT) || SKILL_LEVEL_UNFAMILIAR

	form_title = "[grown_seed.seed_name] (#[grown_seed.uid])"
	var/dat = "<h3>Plant data for [form_title]</h3>"
	user.visible_message(SPAN_NOTICE("[user] runs the scanner over \the [target]."))

	dat += "<h2>General Data</h2>"

	dat += "<table>"
	dat += "<tr><td><b>Endurance</b></td><td>[GET_SEED_TRAIT(grown_seed, TRAIT_ENDURANCE)]</td></tr>"
	dat += "<tr><td><b>Yield</b></td><td>[GET_SEED_TRAIT(grown_seed, TRAIT_YIELD)]</td></tr>"
	dat += "<tr><td><b>Maturation time</b></td><td>[GET_SEED_TRAIT(grown_seed, TRAIT_MATURATION)]</td></tr>"
	dat += "<tr><td><b>Production time</b></td><td>[GET_SEED_TRAIT(grown_seed, TRAIT_PRODUCTION)]</td></tr>"
	dat += "<tr><td><b>Potency</b></td><td>[GET_SEED_TRAIT(grown_seed, TRAIT_POTENCY)]</td></tr>"
	if(botany_skill >= SKILL_LEVEL_FAMILIAR && scanned_packet)
		dat += "<tr><td><b>Genetic modification decay</b></td><td>[scanned_packet.modified]%</td></tr>"
	dat += "</table>"

	if(botany_skill >= SKILL_LEVEL_FAMILIAR)
		dat += "<h2>Exact Environmental & Tolerance Profile</h2>"
		dat += "<table>"
		dat += "<tr><td><b>Ideal Temperature</b></td><td>[GET_SEED_TRAIT(grown_seed, TRAIT_IDEAL_HEAT)] K (Pref: &plusmn;[GET_SEED_TRAIT(grown_seed, TRAIT_HEAT_PREFERENCE)] K, Tol: &plusmn;[GET_SEED_TRAIT(grown_seed, TRAIT_HEAT_TOLERANCE)] K)</td></tr>"
		dat += "<tr><td><b>Ideal Light</b></td><td>[GET_SEED_TRAIT(grown_seed, TRAIT_IDEAL_LIGHT)] lm (Pref: &plusmn;[GET_SEED_TRAIT(grown_seed, TRAIT_LIGHT_PREFERENCE)] lm, Tol: &plusmn;[GET_SEED_TRAIT(grown_seed, TRAIT_LIGHT_TOLERANCE)] lm)</td></tr>"
		dat += "<tr><td><b>Pressure Tolerance</b></td><td>[GET_SEED_TRAIT(grown_seed, TRAIT_LOWKPA_TOLERANCE)] kPa &ndash; [GET_SEED_TRAIT(grown_seed, TRAIT_HIGHKPA_TOLERANCE)] kPa</td></tr>"
		dat += "<tr><td><b>Toxin / Pest / Weed Tol.</b></td><td>[GET_SEED_TRAIT(grown_seed, TRAIT_TOXINS_TOLERANCE)] / [GET_SEED_TRAIT(grown_seed, TRAIT_PEST_TOLERANCE)] / [GET_SEED_TRAIT(grown_seed, TRAIT_WEED_TOLERANCE)]</td></tr>"
		dat += "<tr><td><b>Nutrient / Water Use</b></td><td>[GET_SEED_TRAIT(grown_seed, TRAIT_REQUIRES_NUTRIENTS) ? "[GET_SEED_TRAIT(grown_seed, TRAIT_NUTRIENT_CONSUMPTION)]/cycle" : "None"] / [GET_SEED_TRAIT(grown_seed, TRAIT_REQUIRES_WATER) ? "[GET_SEED_TRAIT(grown_seed, TRAIT_WATER_CONSUMPTION)]/cycle" : "None"]</td></tr>"
		dat += "</table>"

		if(scanned_tray)
			dat += "<h2>Live Tray Diagnostics</h2>"
			dat += "<table>"
			dat += "<tr><td><b>Plant Health</b></td><td>[round(scanned_tray.plant_health, 0.1)] / [GET_SEED_TRAIT(grown_seed, TRAIT_ENDURANCE)][scanned_tray.dead ? " (DEAD)" : ""]</td></tr>"
			dat += "<tr><td><b>Plant Age</b></td><td>[scanned_tray.age] (Last produce: [scanned_tray.lastproduce])</td></tr>"
			dat += "<tr><td><b>Water / Nutrients</b></td><td>[round(scanned_tray.waterlevel, 0.1)]/100 / [round(scanned_tray.nutrilevel, 0.1)]/10</td></tr>"
			dat += "<tr><td><b>Toxins / Weeds / Pests</b></td><td>[round(scanned_tray.toxins, 0.1)] / [round(scanned_tray.weedlevel, 0.1)] / [round(scanned_tray.pestlevel, 0.1)]</td></tr>"
			dat += "<tr><td><b>Mutation / Yield Mod</b></td><td>[round(scanned_tray.mutation_level, 0.1)]% / +[scanned_tray.yield_mod]</td></tr>"
			dat += "<tr><td><b>Status Flags</b></td><td>[scanned_tray.stunted ? "Stunted " : ""][scanned_tray.sampled ? "Sampled " : ""][(!scanned_tray.stunted && !scanned_tray.sampled) ? "Nominal" : ""]</td></tr>"
			dat += "</table>"

	if(LAZYLEN(grown_reagents?.reagent_volumes))
		dat += "<h2>Reagent Data</h2>"

		dat += "<br>This sample contains: "
		for(var/_R in grown_reagents.reagent_volumes)
			var/singleton/reagent/R = GET_SINGLETON(_R)
			dat += "<br>- [R.name], [REAGENT_VOLUME(grown_reagents, _R)] unit(s)"

	if(botany_skill >= SKILL_LEVEL_TRAINED && islist(grown_seed.chems) && length(grown_seed.chems))
		dat += "<h2>Genetic Chemical Synthesis Profile</h2>"
		var/potency = GET_SEED_TRAIT(grown_seed, TRAIT_POTENCY)
		for(var/rid in grown_seed.chems)
			var/singleton/reagent/R = GET_SINGLETON(rid)
			if(!R)
				continue
			var/list/reagent_data = grown_seed.chems[rid]
			var/expected_vol = 1
			if(islist(reagent_data) && length(reagent_data))
				expected_vol = reagent_data[1]
				if(length(reagent_data) > 1 && potency > 0 && reagent_data[2])
					expected_vol += round(potency / reagent_data[2])
			dat += "- <b>[R.name]</b>: ~[max(1, expected_vol)] u per product at current potency<br>"

	dat += "<h2>Other Data</h2>"

	if(GET_SEED_TRAIT(grown_seed, TRAIT_HARVEST_REPEAT))
		dat += "This plant can be harvested repeatedly.<br>"

	if(GET_SEED_TRAIT(grown_seed, TRAIT_IMMUTABLE) == -1)
		dat += "This plant is highly mutable.<br>"
	else if(GET_SEED_TRAIT(grown_seed, TRAIT_IMMUTABLE) > 0)
		dat += "This plant does not possess genetics that are alterable.<br>"

	if(GET_SEED_TRAIT(grown_seed, TRAIT_REQUIRES_NUTRIENTS))
		if(GET_SEED_TRAIT(grown_seed, TRAIT_NUTRIENT_CONSUMPTION) < 0.05)
			dat += "It consumes a small amount of nutrient fluid.<br>"
		else if(GET_SEED_TRAIT(grown_seed, TRAIT_NUTRIENT_CONSUMPTION) > 0.2)
			dat += "It requires a heavy supply of nutrient fluid.<br>"
		else
			dat += "It requires a supply of nutrient fluid.<br>"

	if(GET_SEED_TRAIT(grown_seed, TRAIT_REQUIRES_WATER))
		if(GET_SEED_TRAIT(grown_seed, TRAIT_WATER_CONSUMPTION) < 1)
			dat += "It requires very little water.<br>"
		else if(GET_SEED_TRAIT(grown_seed, TRAIT_WATER_CONSUMPTION) > 5)
			dat += "It requires a large amount of water.<br>"
		else
			dat += "It requires a stable supply of water.<br>"

	if(grown_seed.mutants && grown_seed.mutants.len)
		if(botany_skill >= SKILL_LEVEL_TRAINED)
			dat += "It exhibits a high degree of potential subspecies shift into: <b>[english_list(grown_seed.mutants)]</b>.<br>"
		else
			dat += "It exhibits a high degree of potential subspecies shift.<br>"

	dat += "It thrives in a temperature of [GET_SEED_TRAIT(grown_seed, TRAIT_IDEAL_HEAT)] Kelvin."

	if(GET_SEED_TRAIT(grown_seed, TRAIT_LOWKPA_TOLERANCE) < 20)
		dat += "<br>It is well adapted to low pressure levels."
	if(GET_SEED_TRAIT(grown_seed, TRAIT_HIGHKPA_TOLERANCE) > 220)
		dat += "<br>It is well adapted to high pressure levels."

	if(GET_SEED_TRAIT(grown_seed, TRAIT_HEAT_TOLERANCE) > 30)
		dat += "<br>It is well adapted to a range of temperatures."
	else if(GET_SEED_TRAIT(grown_seed, TRAIT_HEAT_TOLERANCE) < 10)
		dat += "<br>It is very sensitive to temperature shifts."

	dat += "<br>It thrives in a light level of [GET_SEED_TRAIT(grown_seed, TRAIT_IDEAL_LIGHT)] lumen\s."

	if(GET_SEED_TRAIT(grown_seed, TRAIT_LIGHT_TOLERANCE) > 10)
		dat += "<br>It is well adapted to a range of light levels."
	else if(GET_SEED_TRAIT(grown_seed, TRAIT_LIGHT_TOLERANCE) < 3)
		dat += "<br>It is very sensitive to light level shifts."

	if(GET_SEED_TRAIT(grown_seed, TRAIT_TOXINS_TOLERANCE) < 3)
		dat += "<br>It is highly sensitive to toxins."
	else if(GET_SEED_TRAIT(grown_seed, TRAIT_TOXINS_TOLERANCE) > 6)
		dat += "<br>It is remarkably resistant to toxins."

	if(GET_SEED_TRAIT(grown_seed, TRAIT_PEST_TOLERANCE) < 3)
		dat += "<br>It is highly sensitive to pests."
	else if(GET_SEED_TRAIT(grown_seed, TRAIT_PEST_TOLERANCE) > 6)
		dat += "<br>It is remarkably resistant to pests."

	if(GET_SEED_TRAIT(grown_seed, TRAIT_WEED_TOLERANCE) < 3)
		dat += "<br>It is highly sensitive to weeds."
	else if(GET_SEED_TRAIT(grown_seed, TRAIT_WEED_TOLERANCE) > 6)
		dat += "<br>It is remarkably resistant to weeds."

	switch(GET_SEED_TRAIT(grown_seed, TRAIT_SPREAD))
		if(1)
			dat += "<br>It is able to be planted outside of a tray."
		if(2)
			dat += "<br>It is a robust and vigorous vine that will spread rapidly."

	switch(GET_SEED_TRAIT(grown_seed, TRAIT_CARNIVOROUS))
		if(1)
			dat += "<br>It is carnivorous and will eat tray pests for sustenance."
		if(2)
			dat	+= "<br>It is carnivorous and poses a significant threat to living things around it."

	if(GET_SEED_TRAIT(grown_seed, TRAIT_PARASITE))
		dat += "<br>It is capable of parisitizing and gaining sustenance from tray weeds."
	if(GET_SEED_TRAIT(grown_seed, TRAIT_ALTER_TEMP))
		dat += "<br>It will periodically alter the local temperature by [GET_SEED_TRAIT(grown_seed, TRAIT_ALTER_TEMP)] degrees Kelvin."

	if(GET_SEED_TRAIT(grown_seed, TRAIT_BIOLUM))
		dat += "<br>It is [GET_SEED_TRAIT(grown_seed, TRAIT_BIOLUM_COLOUR)  ? "<font color='[GET_SEED_TRAIT(grown_seed, TRAIT_BIOLUM_COLOUR)]'>bio-luminescent</font>" : "bio-luminescent"]."

	if(GET_SEED_TRAIT(grown_seed, TRAIT_PRODUCES_POWER))
		dat += "<br>The fruit will function as a battery if prepared appropriately."

	if(GET_SEED_TRAIT(grown_seed, TRAIT_STINGS))
		dat += "<br>The fruit is covered in stinging spines."

	if(GET_SEED_TRAIT(grown_seed, TRAIT_JUICY) == 1)
		dat += "<br>The fruit is soft-skinned and juicy."
	else if(GET_SEED_TRAIT(grown_seed, TRAIT_JUICY) == 2)
		dat += "<br>The fruit is excessively juicy."

	if(GET_SEED_TRAIT(grown_seed, TRAIT_EXPLOSIVE))
		dat += "<br>The fruit is internally unstable."

	if(GET_SEED_TRAIT(grown_seed, TRAIT_TELEPORTING))
		dat += "<br>The fruit is temporal/spatially unstable."

	if(GET_SEED_TRAIT(grown_seed, TRAIT_EXUDE_GASSES) || (islist(grown_seed.exude_gasses) && length(grown_seed.exude_gasses)))
		if(botany_skill >= SKILL_LEVEL_TRAINED && islist(grown_seed.exude_gasses) && length(grown_seed.exude_gasses))
			dat += "<br>It will release gas into the environment (<b>[english_list(grown_seed.exude_gasses)]</b>)."
		else
			dat += "<br>It will release gas into the environment."

	if(GET_SEED_TRAIT(grown_seed, TRAIT_CONSUME_GASSES) || (islist(grown_seed.consume_gasses) && length(grown_seed.consume_gasses)))
		if(botany_skill >= SKILL_LEVEL_TRAINED && islist(grown_seed.consume_gasses) && length(grown_seed.consume_gasses))
			dat += "<br>It will remove gas from the environment (<b>[english_list(grown_seed.consume_gasses)]</b>)."
		else
			dat += "<br>It will remove gas from the environment."

	if(botany_skill >= SKILL_LEVEL_PROFESSIONAL && SSplants?.gene_masked_list)
		dat += "<h2>Decoded Gene Locus Reference</h2>"
		dat += "<table>"
		for(var/list/entry in SSplants.gene_masked_list)
			dat += "<tr><td><b>[entry["mask"]]</b></td><td>[entry["tag"]]</td></tr>"
		dat += "</table>"

	if(dat)
		last_data = dat
		dat += "<br><br>\[<a href='byond://?src=[REF(src)];print=1'>print report</a>\]"
		user << browse(HTML_SKELETON(dat),"window=plant_analyzer")

	return
