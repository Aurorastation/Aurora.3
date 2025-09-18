/datum/plantgene
	/// Label used when applying trait.
	var/genetype
	/// Values to copy into the target seed datum.
	var/list/values

/datum/seed
	//Tracking.
	/// Unique identifier
	var/uid
	/// Index for global list
	var/name
	/// Plant name for seed packet
	var/seed_name
	/// Descriptor for packet
	var/seed_noun = SEED_NOUN_SEEDS
	/// Prettier name
	var/display_name

	/// If set, seed will not display variety number
	var/roundstart
	/// Only used for the random seed packets.
	var/mysterious
	/// Mostly used for living mobs
	var/can_self_harvest = 0
	/// Number of stages the plant passes through before it is mature
	var/growth_stages = 0

	/// Initialized in New()
	var/list/traits = list()
	/// Possible predefined mutant varieties, if any
	var/list/mutants
	/// Chemicals that plant produces in products/injects into victim
	var/list/chems
	/// The plant will absorb these gasses during its life
	var/list/consume_gasses
	/// The plant will exude these gasses during its life
	var/list/exude_gasses

	/// Used by the reagent grinder
	var/kitchen_tag
	/// Garbage item produced when eaten
	var/trash_type
	/// Graffiti decal
	var/splat_type = /obj/effect/decal/cleanable/fruit_smudge
	var/product_type = /obj/item/reagent_containers/food/snacks/grown
	/// If set, overrides the description of the product (What the produce looks like for example)
	var/product_desc
	/// If set, overrides the extended scription of the product (Useful to describe the 'lore')
	var/product_desc_extended

	/// The base percentage chance the plant will grow per each process().
	var/base_growth_speed = 10
	/// The boost to the base growth speed applied to the plant if within temperature preferences.
	var/temperature_growth_boost = 20
	/// The boost to the base growth speed applied to the plant if within light preferences.
	var/light_growth_boost = 5

	var/force_layer
	var/hydrotray_only

/datum/seed/proc/setup_traits()

/datum/seed/New()
	set_trait(TRAIT_SPOROUS,              0)
	set_trait(TRAIT_IMMUTABLE,            0)
	set_trait(TRAIT_HARVEST_REPEAT,       0)
	set_trait(TRAIT_PRODUCES_POWER,       0)
	set_trait(TRAIT_JUICY,                0)
	set_trait(TRAIT_EXPLOSIVE,            0)
	set_trait(TRAIT_CARNIVOROUS,          0)
	set_trait(TRAIT_PARASITE,             0)
	set_trait(TRAIT_STINGS,               0)
	set_trait(TRAIT_YIELD,                0)
	set_trait(TRAIT_SPREAD,               0)
	set_trait(TRAIT_MATURATION,           0)
	set_trait(TRAIT_PRODUCTION,           0)
	set_trait(TRAIT_TELEPORTING,          0)
	set_trait(TRAIT_BIOLUM,               0)
	set_trait(TRAIT_ALTER_TEMP,           0)
	set_trait(TRAIT_PRODUCT_ICON,         0)
	set_trait(TRAIT_PLANT_ICON,           0)
	set_trait(TRAIT_PRODUCT_COLOUR,       0)
	set_trait(TRAIT_BIOLUM_COLOUR,        0)
	set_trait(TRAIT_BIOLUM_PWR,           1)
	set_trait(TRAIT_POTENCY,              1)
	set_trait(TRAIT_REQUIRES_NUTRIENTS,   1)
	set_trait(TRAIT_REQUIRES_WATER,       1)
	set_trait(TRAIT_WATER_CONSUMPTION,    3)
	set_trait(TRAIT_LIGHT_TOLERANCE,      2.5) // Plants will begin to die if the light levels are 2.5 or more lumens from their ideal.
	set_trait(TRAIT_TOXINS_TOLERANCE,     5)
	set_trait(TRAIT_PEST_TOLERANCE,       5)
	set_trait(TRAIT_WEED_TOLERANCE,       5)
	set_trait(TRAIT_IDEAL_LIGHT,          IDEAL_LIGHT_TEMPERATE)
	set_trait(TRAIT_HEAT_TOLERANCE,       12) // Plants will begin to die if they're twelve or more degrees from their ideal temperature.
	set_trait(TRAIT_LOWKPA_TOLERANCE,     25) // Plants survive all the way down to a quarter of an atmosphere!
	set_trait(TRAIT_ENDURANCE,            100)
	set_trait(TRAIT_HIGHKPA_TOLERANCE,    200)
	set_trait(TRAIT_IDEAL_HEAT,           IDEAL_HEAT_TEMPERATE)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.25)
	set_trait(TRAIT_PLANT_COLOUR,         "#46B543")
	set_trait(TRAIT_LARGE,                0)
	set_trait(TRAIT_HEAT_PREFERENCE,      5) // By default, plants grow faster in a temperature within five degrees of their ideal.
	set_trait(TRAIT_LIGHT_PREFERENCE,     1.5) // Similarly, they grow faster under lumens within 1.5 of their ideal.

	setup_traits()

	update_growth_stages()

/datum/seed/proc/get_trait(var/trait)
	return traits["[trait]"]

/datum/seed/proc/get_trash_type()
	return trash_type

/datum/seed/proc/set_trait(var/trait,var/nval,var/ubound,var/lbound, var/degrade)
	if(!isnull(degrade)) nval *= degrade
	if(!isnull(ubound))  nval = min(nval,ubound)
	if(!isnull(lbound))  nval = max(nval,lbound)
	traits["[trait]"] =  nval

/datum/seed/proc/create_spores(var/turf/T)
	if(!T)
		return
	if(!istype(T))
		T = get_turf(T)
	if(!T)
		return

	var/datum/reagents/R = new/datum/reagents(100)
	if(chems.len)
		for(var/rid in chems)
			var/injecting = max(1,get_trait(TRAIT_POTENCY)/5)
			R.add_reagent(rid,injecting)

	var/datum/effect/effect/system/smoke_spread/chem/spores/S = new(name)
	S.attach(T)
	S.set_up(R, round(get_trait(TRAIT_POTENCY)/4), 0, T, 40)
	S.start()

/// Does brute damage to a target.
/datum/seed/proc/do_thorns(var/mob/living/carbon/human/target, var/obj/item/fruit, var/target_limb)

	if(!get_trait(TRAIT_CARNIVOROUS))
		return

	if(!istype(target))
		if(israt(target))
			new /obj/effect/decal/remains/rat(get_turf(target))
			qdel(target)
		else if(istype(target, /mob/living/simple_animal/lizard))
			new /obj/effect/decal/remains/lizard(get_turf(target))
			qdel(target)
		return


	if(!target_limb) target_limb = pick(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_HAND,BP_R_HAND,BP_L_ARM, BP_R_ARM,BP_HEAD,BP_CHEST,BP_GROIN)
	var/obj/item/organ/external/affecting = target.get_organ(target_limb)
	var/damage = 0

	if(get_trait(TRAIT_CARNIVOROUS))
		if(get_trait(TRAIT_CARNIVOROUS) == 2)
			if(affecting)
				to_chat(target, SPAN_DANGER("\The [fruit]'s thorns pierce your [affecting.name] greedily!"))
			else
				to_chat(target, SPAN_DANGER("\The [fruit]'s thorns pierce your flesh greedily!"))
			damage = get_trait(TRAIT_POTENCY)/2
		else
			if(affecting)
				to_chat(target, SPAN_DANGER("\The [fruit]'s thorns dig deeply into your [affecting.name]!"))
			else
				to_chat(target, SPAN_DANGER("\The [fruit]'s thorns dig deeply into your flesh!"))
			damage = get_trait(TRAIT_POTENCY)/5
	else
		return

	if(affecting)
		affecting.take_damage(damage, 0)
		affecting.add_autopsy_data("Thorns",damage)
	else
		target.adjustBruteLoss(damage)
	target.UpdateDamageIcon()
	target.updatehealth()

/// Adds reagents to a target.
/datum/seed/proc/do_sting(var/mob/living/carbon/human/target, var/obj/item/fruit)
	if(!get_trait(TRAIT_STINGS))
		return
	if(chems && chems.len)

		var/body_coverage = HEAD|FACE|EYES|UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

		for(var/obj/item/clothing/clothes in target)
			if(target.l_hand == clothes|| target.r_hand == clothes)
				continue
			body_coverage &= ~(clothes.body_parts_covered)

		if(!body_coverage)
			return

		to_chat(target, SPAN_DANGER("You are stung by \the [fruit]!"))
		for(var/rid in chems)
			var/injecting = min(5,max(1,get_trait(TRAIT_POTENCY)/5))
			target.reagents.add_reagent(rid,injecting)

/// Splatter a turf.
/datum/seed/proc/splatter(var/turf/T,var/obj/item/thrown)
	if(splat_type && !(locate(/obj/effect/plant) in T))
		var/obj/effect/plant/splat = new splat_type(T, src)
		if(!istype(splat)) // Plants handle their own stuff.
			splat.name = "[thrown.name] [pick("smear","smudge","splatter")]"
			if(get_trait(TRAIT_BIOLUM))
				var/pwr
				if(get_trait(TRAIT_BIOLUM_PWR) == 0)
					pwr = get_trait(TRAIT_BIOLUM)
				else
					pwr = get_trait(TRAIT_BIOLUM_PWR)
				var/clr
				if(get_trait(TRAIT_BIOLUM_COLOUR))
					clr = get_trait(TRAIT_BIOLUM_COLOUR)
				splat.set_light(get_trait(TRAIT_POTENCY)/10, pwr, clr)
				addtimer(CALLBACK(splat, TYPE_PROC_REF(/atom, set_light), 0), rand(3 MINUTES, 5 MINUTES))
			var/flesh_colour = get_trait(TRAIT_FLESH_COLOUR)
			if(!flesh_colour) flesh_colour = get_trait(TRAIT_PRODUCT_COLOUR)
			if(flesh_colour) splat.color = get_trait(TRAIT_PRODUCT_COLOUR)

	if(chems)
		for(var/mob/living/M in T.contents)
			if(!M.reagents)
				continue
			for(var/chem in chems)
				var/injecting = min(5,max(1,get_trait(TRAIT_POTENCY)/3))
				M.reagents.add_reagent(chem,injecting)

/// Applies an effect to a target atom.
/datum/seed/proc/thrown_at(var/obj/item/thrown,var/atom/target, var/force_explode)

	var/splatted
	var/turf/origin_turf = get_turf(target)

	if(force_explode || get_trait(TRAIT_EXPLOSIVE))

		create_spores(origin_turf)

		var/flood_dist = min(10,max(1,get_trait(TRAIT_POTENCY)/15))
		var/list/open_turfs = list()
		var/list/closed_turfs = list()
		var/list/valid_turfs = list()
		open_turfs |= origin_turf

		// Flood fill to get affected turfs.
		while(open_turfs.len)
			var/turf/T = pick(open_turfs)
			open_turfs -= T
			closed_turfs |= T
			valid_turfs |= T

			for(var/dir in GLOB.alldirs)
				var/turf/neighbor = get_step(T,dir)
				if(!neighbor || (neighbor in closed_turfs) || (neighbor in open_turfs))
					continue
				if(neighbor.density || get_dist(neighbor,origin_turf) > flood_dist || istype(neighbor,/turf/space))
					closed_turfs |= neighbor
					continue
				// Check for windows.
				var/no_los
				var/turf/last_turf = origin_turf
				for(var/turf/target_turf in getline(origin_turf,neighbor))
					if(!last_turf.Enter(target_turf) || target_turf.density)
						no_los = 1
						break
					last_turf = target_turf
				if(!no_los && !origin_turf.Enter(neighbor))
					no_los = 1
				if(no_los)
					closed_turfs |= neighbor
					continue
				open_turfs |= neighbor

		for(var/turf/T in valid_turfs)
			for(var/mob/living/M in T.contents)
				apply_special_effect(M)
			splatter(T,thrown)
		if(origin_turf)
			origin_turf.visible_message(SPAN_DANGER("The [thrown.name] explodes!"))
		qdel(thrown)
		return

	if(istype(target,/mob/living))
		splatted = apply_special_effect(target,thrown)
	else if(istype(target,/turf))
		splatted = 1
		for(var/mob/living/M in target.contents)
			apply_special_effect(M)

	if(get_trait(TRAIT_JUICY) && splatted)
		splatter(origin_turf,thrown)
		if(origin_turf)
			origin_turf.visible_message(SPAN_DANGER("The [thrown.name] splatters against [target]!"))
		qdel(thrown)

	if(get_trait(TRAIT_TELEPORTING))

		var/outer_teleport_radius = get_trait(TRAIT_POTENCY)/5
		var/inner_teleport_radius = get_trait(TRAIT_POTENCY)/15

		var/list/turfs = list()
		if(inner_teleport_radius > 0)
			for(var/turf/T in orange(target,outer_teleport_radius))
				if(get_dist(target,T) >= inner_teleport_radius)
					turfs |= T

		if(turfs.len)
			var/turf/picked = get_turf(pick(turfs))
			var/obj/effect/portal/P = new /obj/effect/portal(get_turf(target))
			P.set_target(picked)
			P.creator = null

/// Checks the plant's environment. If anything is improper, adds to a value that will ultimately be used to damage the plant.
/datum/seed/proc/handle_environment(var/turf/current_turf, var/datum/gas_mixture/environment, var/light_supplied, var/check_only)
	var/health_change = 0
	// Handle gas consumption.
	if(consume_gasses && consume_gasses.len)
		var/missing_gas = 0
		for(var/gas in consume_gasses)
			if(environment && environment.gas && environment.gas[gas] && \
				environment.gas[gas] >= consume_gasses[gas])
				if(!check_only)
					environment.adjust_gas(gas,-consume_gasses[gas],1)
			else
				missing_gas++

		if(missing_gas > 0)
			health_change += missing_gas * HYDRO_SPEED_MULTIPLIER

	// Process it.
	var/pressure = environment.return_pressure()
	if(pressure < get_trait(TRAIT_LOWKPA_TOLERANCE)|| pressure > get_trait(TRAIT_HIGHKPA_TOLERANCE))
		health_change += rand(1,3) * HYDRO_SPEED_MULTIPLIER

	// We take the absolute value of the environment's temperature minus the ideal heat - closer to 0 is better, in this case.
	// If that value is greater than the heat tolerance, we apply some damage to the plant.
	if(check_heat_tolerances(environment))
		health_change += rand(1,3) * HYDRO_SPEED_MULTIPLIER

	// Handle gas production.
	if(exude_gasses && exude_gasses.len && !check_only)
		for(var/gas in exude_gasses)
			environment.adjust_gas(gas, max(1,round((exude_gasses[gas]*(get_trait(TRAIT_POTENCY)/5))/exude_gasses.len)))

	// Handle light requirements.
	if(!light_supplied)
		if (TURF_IS_DYNAMICALLY_LIT(current_turf))
			light_supplied = current_turf.get_lumcount(0, 3) * 10
		else
			light_supplied = 5

	if(light_supplied)
		if(check_light_tolerances(light_supplied))
			health_change += rand(1,3) * HYDRO_SPEED_MULTIPLIER

	return health_change

/// Returns true if a plant is outside their light tolerances, otherwise false.
/datum/seed/proc/check_light_tolerances(var/light_supplied)
	if(abs(light_supplied - get_trait(TRAIT_IDEAL_LIGHT)) > get_trait(TRAIT_LIGHT_TOLERANCE))
		return TRUE
	return FALSE

/// Returns true if a plant is outside their heat tolerances, otherwise false.
/datum/seed/proc/check_heat_tolerances(var/datum/gas_mixture/environment)
	if(abs(environment.temperature - get_trait(TRAIT_IDEAL_HEAT)) > get_trait(TRAIT_HEAT_TOLERANCE))
		return TRUE
	return FALSE

/// Returns true if a plant is in their light preferences, otherwise false.
/datum/seed/proc/check_light_preferences(var/light_supplied)
	if(abs(light_supplied - get_trait(TRAIT_IDEAL_LIGHT)) < get_trait(TRAIT_LIGHT_PREFERENCE))
		return TRUE
	return FALSE

/// Returns true if a plant is in their heat preferences, otherwise false.
/datum/seed/proc/check_heat_preferences(var/datum/gas_mixture/environment)
	if(abs(environment.temperature - get_trait(TRAIT_IDEAL_HEAT)) < get_trait(TRAIT_HEAT_PREFERENCE))
		return TRUE
	return FALSE

/// Checks the preferences of the seed, and returns the percentage chance for growth to occur. Called in tray_process.
/datum/seed/proc/get_probability_of_growth(var/turf/current_turf, var/datum/gas_mixture/environment, var/light_supplied, var/check_only)
	// By standard, the probability of growth is only the base. This rises if growing conditions are within their preferences.
	// This is intended to motivate the use of atmospheric equipment to more viably grow plants with irregular preferences.
	// You *can* grow plants outside of their preferences without them dying so long as it's within their tolerance, but it'll be pretty slow.
	var/return_probability = base_growth_speed

	// Handle light requirements.
	if(!light_supplied)
		if (TURF_IS_DYNAMICALLY_LIT(current_turf))
			light_supplied = current_turf.get_lumcount(0, 3) * 10
		else
			light_supplied = 5

	// Are we within the preference zone for temperature? If so, add to the chance of growth.
	if(check_heat_preferences(environment))
		return_probability += temperature_growth_boost

	// Same for light!
	if(check_light_preferences(light_supplied))
		return_probability += light_growth_boost

	return return_probability

/datum/seed/proc/apply_special_effect(var/mob/living/target,var/obj/item/thrown)

	var/impact = 1
	do_sting(target,thrown)
	do_thorns(target,thrown)

	return impact

/datum/seed/proc/generate_name()
	var/prefix = ""
	var/name = ""
	if(prob(50)) //start with a prefix.
		//These are various plant/mushroom genuses.
		//I realize these might not be entirely accurate, but it could facilitate RP.
		var/list/possible_prefixes
		if(seed_noun == SEED_NOUN_CUTTINGS || seed_noun == SEED_NOUN_SEEDS || (seed_noun == SEED_NOUN_NODES && prob(50)))
			possible_prefixes = list("amelanchier", "saskatoon",
										"magnolia", "angiosperma", "osmunda", "scabiosa", "spigelia", "psydrax", "chastetree",
										"strychnos", "treebine", "caper", "justica", "ragwortus", "everlasting", "combretum",
										"loganiaceae", "gelsemium", "logania", "sabadilla", "neuburgia", "canthium", "rytigynia",
										"chaste", "vitex", "cissus", "capparis", "senecio", "curry", "cycad", "liverwort", "charophyta",
										"glaucophyte", "pinidae", "vascular", "embryophyte", "lillopsida")
		else
			possible_prefixes = list("bisporus", "bitorquis", "campestris", "crocodilinus", "agaricus",
									"armillaria", "matsutake", "mellea", "ponderosa", "auricularia", "auricala",
									"polytricha", "boletus", "badius", "edulis", "mirabilis", "zelleri",
									"calvatia", "gigantea", "clitopilis", "prumulus", "entoloma", "abortivum",
									"suillus", "tuber", "aestivum", "volvacea", "delica", "russula", "rozites")
		possible_prefixes |= list("butter", "shad", "sugar", "june", "wild", "rigus", "curry", "hard", "soft", "dark", "brick", "stone", "red", "brown",
								"black", "white", "paper", "slippery", "honey", "bitter")
		prefix = pick(possible_prefixes)
	var/num = rand(2,5)
	var/list/possible_name = list("rhon", "cus", "quam", "met", "eget", "was", "reg", "zor", "fra", "rat", "sho", "ghen", "pa",
								"eir", "lip", "sum", "lor", "em", "tem", "por", "invi", "dunt", "ut", "la", "bore", "mag", "na",
								"al", "i", "qu", "yam", "er", "at", "sed", "di", "am", "vol", "up", "tua", "at", "ve", "ro", "eos",
								"et", "ac", "cus")
	for(var/i in 1 to num)
		var/syl = pick(possible_name)
		possible_name -= syl
		name += syl
	if(prefix)
		name = "[prefix] [name]"
	seed_name = name
	display_name = name
	display_name = "[name] plant"

/// Creates a random seed. MAKE SURE THE LINE HAS DIVERGED BEFORE THIS IS CALLED.
/datum/seed/proc/randomize(var/list/native_gases = list(GAS_OXYGEN, GAS_NITROGEN, GAS_CO2, GAS_HYDROGEN))
	roundstart = FALSE
	mysterious = TRUE

	seed_noun = pick(SEED_NOUN_SEEDS, SEED_NOUN_PITS, SEED_NOUN_NODES, SEED_NOUN_CUTTINGS)

	set_trait(TRAIT_POTENCY,rand(5,30),200,0)
	set_trait(TRAIT_PRODUCT_ICON,pick(SSplants.plant_product_sprites))
	set_trait(TRAIT_PLANT_ICON,pick(SSplants.plant_sprites))
	set_trait(TRAIT_PLANT_COLOUR,get_random_colour(0,75,190))
	set_trait(TRAIT_PRODUCT_COLOUR,get_random_colour(0,75,190))
	update_growth_stages()

	if(prob(20))
		set_trait(TRAIT_HARVEST_REPEAT,1)

	if(prob(15))
		if(prob(15))
			set_trait(TRAIT_JUICY,2)
		else
			set_trait(TRAIT_JUICY,1)

	if(prob(5))
		set_trait(TRAIT_STINGS,1)

	if(prob(5))
		set_trait(TRAIT_PRODUCES_POWER,1)

	if(prob(1))
		set_trait(TRAIT_EXPLOSIVE,1)
	else if(prob(1))
		set_trait(TRAIT_TELEPORTING,1)

	if(prob(5))
		consume_gasses = list()
		var/gas = pick_n_take(native_gases)
		consume_gasses[gas] = rand(3,9)

	if(prob(5))
		exude_gasses = list()
		var/gas = pick_n_take(native_gases)
		exude_gasses[gas] = rand(3,9)

	chems = list()
	if(prob(80))
		chems[/singleton/reagent/nutriment] = list(rand(1,10),rand(10,20))

	var/additional_chems = rand(0,5)

	if(additional_chems)
		var/list/possible_chems = list(
			/singleton/reagent/acetone,
			/singleton/reagent/alkysine,
			/singleton/reagent/bicaridine,
			/singleton/reagent/butazoline,
			/singleton/reagent/blood,
			/singleton/reagent/cryoxadone,
			/singleton/reagent/drugs/cryptobiolin,
			/singleton/reagent/toxin/cyanide,
			/singleton/reagent/dermaline,
			/singleton/reagent/dexalin,
			/singleton/reagent/ethylredoxrazine,
			/singleton/reagent/hydrazine,
			/singleton/reagent/hyperzine,
			/singleton/reagent/hyronalin,
			/singleton/reagent/drugs/impedrezene,
			/singleton/reagent/mercury,
			/singleton/reagent/drugs/mindbreaker,
			/singleton/reagent/inaprovaline,
			/singleton/reagent/peridaxon,
			/singleton/reagent/toxin/plasticide,
			/singleton/reagent/potassium,
			/singleton/reagent/radium,
			/singleton/reagent/rezadone,
			/singleton/reagent/ryetalyn,
			/singleton/reagent/slimejelly,
			/singleton/reagent/drugs/mms,
			/singleton/reagent/soporific,
			/singleton/reagent/sugar,
			/singleton/reagent/synaptizine,
			/singleton/reagent/thermite,
			/singleton/reagent/toxin,
			/singleton/reagent/mortaphenyl,
			/singleton/reagent/water,
			/singleton/reagent/woodpulp,
			/singleton/reagent/drugs/ambrosia_extract,
			/singleton/reagent/drugs/skrell_nootropic,
			/singleton/reagent/toxin/berserk
			)

		for(var/x=1;x<=additional_chems;x++)
			if(!possible_chems.len)
				break
			var/new_chem = pick(possible_chems)
			possible_chems -= new_chem
			chems[new_chem] = list(rand(1,10),rand(10,20))

	if(prob(90))
		set_trait(TRAIT_REQUIRES_NUTRIENTS,1)
		set_trait(TRAIT_NUTRIENT_CONSUMPTION,rand(25)/25)
	else
		set_trait(TRAIT_REQUIRES_NUTRIENTS,0)

	if(prob(90))
		set_trait(TRAIT_REQUIRES_WATER,1)
		set_trait(TRAIT_WATER_CONSUMPTION,rand(10))
	else
		set_trait(TRAIT_REQUIRES_WATER,0)

	set_trait(TRAIT_IDEAL_HEAT,       rand(100,400))
	set_trait(TRAIT_HEAT_TOLERANCE,   rand(10,30))
	set_trait(TRAIT_IDEAL_LIGHT,      rand(2,10))
	set_trait(TRAIT_LIGHT_TOLERANCE,  rand(2,7))
	set_trait(TRAIT_TOXINS_TOLERANCE, rand(2,7))
	set_trait(TRAIT_PEST_TOLERANCE,   rand(2,7))
	set_trait(TRAIT_WEED_TOLERANCE,   rand(2,7))
	set_trait(TRAIT_LOWKPA_TOLERANCE, rand(10,50))
	set_trait(TRAIT_HIGHKPA_TOLERANCE,rand(100,300))

	if(prob(5))
		set_trait(TRAIT_ALTER_TEMP,rand(-5,5))

	if(prob(1))
		set_trait(TRAIT_IMMUTABLE,-1)

	var/carnivore_prob = rand(100)
	if(carnivore_prob < 5)
		set_trait(TRAIT_CARNIVOROUS,2)
	else if(carnivore_prob < 10)
		set_trait(TRAIT_CARNIVOROUS,1)

	if(prob(10))
		set_trait(TRAIT_PARASITE,1)

	var/vine_prob = rand(100)
	if(vine_prob < 5)
		set_trait(TRAIT_SPREAD,2)
	else if(vine_prob < 10)
		set_trait(TRAIT_SPREAD,1)

	if(prob(5))
		set_trait(TRAIT_BIOLUM,1)
		set_trait(TRAIT_BIOLUM_COLOUR,get_random_colour(0,75,190))
		if(prob(5))
			set_trait(TRAIT_BIOLUM_PWR,rand(0,-5)-rand())
		else
			set_trait(TRAIT_BIOLUM_PWR,rand(0,5)+rand())

	if(prob(5))
		set_trait(TRAIT_SPOROUS,1)

	set_trait(TRAIT_ENDURANCE,rand(60,100))
	set_trait(TRAIT_YIELD,rand(3,15))
	set_trait(TRAIT_MATURATION,rand(5,15))
	set_trait(TRAIT_PRODUCTION,get_trait(TRAIT_MATURATION)+rand(2,5))

	generate_name()

/// Returns a key corresponding to an entry in the global seed list.
/datum/seed/proc/get_mutant_variant()
	if(!mutants || !mutants.len || get_trait(TRAIT_IMMUTABLE) > 0) return 0
	return pick(mutants)

/// Mutates the plant overall (randomly).
/datum/seed/proc/mutate(var/degree,var/turf/source_turf)

	if(!degree || get_trait(TRAIT_IMMUTABLE) > 0) return

	source_turf.visible_message(SPAN_NOTICE("\The [display_name] quivers!"))

	//This looks like shit, but it's a lot easier to read/change this way.
	var/total_mutations = rand(1,1+degree)
	for(var/i = 0;i<total_mutations;i++)
		switch(rand(0,11))
			if(0) //Plant cancer!
				set_trait(TRAIT_ENDURANCE,get_trait(TRAIT_ENDURANCE)-rand(10,20),null,0)
				source_turf.visible_message(SPAN_DANGER("\The [display_name] withers rapidly!"))
			if(1)
				set_trait(TRAIT_NUTRIENT_CONSUMPTION,get_trait(TRAIT_NUTRIENT_CONSUMPTION)+rand(-(degree*0.1),(degree*0.1)),5,0)
				set_trait(TRAIT_WATER_CONSUMPTION,   get_trait(TRAIT_WATER_CONSUMPTION)   +rand(-degree,degree),50,0)
				set_trait(TRAIT_JUICY,              !get_trait(TRAIT_JUICY))
				set_trait(TRAIT_STINGS,             !get_trait(TRAIT_STINGS))
			if(2)
				set_trait(TRAIT_IDEAL_HEAT,          get_trait(TRAIT_IDEAL_HEAT) +      (rand(-5,5)*degree),800,70)
				set_trait(TRAIT_HEAT_TOLERANCE,      get_trait(TRAIT_HEAT_TOLERANCE) +  (rand(-5,5)*degree),800,70)
				set_trait(TRAIT_LOWKPA_TOLERANCE,    get_trait(TRAIT_LOWKPA_TOLERANCE)+ (rand(-5,5)*degree),80,0)
				set_trait(TRAIT_HIGHKPA_TOLERANCE,   get_trait(TRAIT_HIGHKPA_TOLERANCE)+(rand(-5,5)*degree),500,110)
				set_trait(TRAIT_EXPLOSIVE,1)
			if(3)
				set_trait(TRAIT_IDEAL_LIGHT,         get_trait(TRAIT_IDEAL_LIGHT)+(rand(-1,1)*degree),30,0)
				set_trait(TRAIT_LIGHT_TOLERANCE,     get_trait(TRAIT_LIGHT_TOLERANCE)+(rand(-2,2)*degree),10,0)
			if(4)
				set_trait(TRAIT_TOXINS_TOLERANCE,    get_trait(TRAIT_TOXINS_TOLERANCE)+(rand(-2,2)*degree),10,0)
			if(5)
				set_trait(TRAIT_WEED_TOLERANCE,      get_trait(TRAIT_WEED_TOLERANCE)+(rand(-2,2)*degree),10, 0)
				if(prob(degree*5))
					set_trait(TRAIT_CARNIVOROUS,     get_trait(TRAIT_CARNIVOROUS)+rand(-degree,degree),2, 0)
					if(get_trait(TRAIT_CARNIVOROUS))
						source_turf.visible_message(SPAN_NOTICE("\The [display_name] shudders hungrily."))
			if(6)
				set_trait(TRAIT_WEED_TOLERANCE,      get_trait(TRAIT_WEED_TOLERANCE)+(rand(-2,2)*degree),10, 0)
				if(prob(degree*5))
					set_trait(TRAIT_PARASITE,!get_trait(TRAIT_PARASITE))
			if(7)
				if(get_trait(TRAIT_YIELD) != -1)
					set_trait(TRAIT_YIELD,           get_trait(TRAIT_YIELD)+(rand(-2,2)*degree),10,0)
			if(8)
				set_trait(TRAIT_ENDURANCE,           get_trait(TRAIT_ENDURANCE)+(rand(-5,5)*degree),100,10)
				set_trait(TRAIT_PRODUCTION,          get_trait(TRAIT_PRODUCTION)+(rand(-1,1)*degree),10, 1)
				set_trait(TRAIT_POTENCY,             get_trait(TRAIT_POTENCY)+(rand(-20,20)*degree),200, 0)
				if(prob(degree*5))
					set_trait(TRAIT_SPREAD,          get_trait(TRAIT_SPREAD)+rand(-1,1),2, 0)
					source_turf.visible_message(SPAN_NOTICE("\The [display_name] spasms visibly, shifting in the tray."))
				if(prob(degree*5))
					set_trait(TRAIT_SPOROUS,         !get_trait(TRAIT_SPOROUS))
			if(9)
				set_trait(TRAIT_MATURATION,          get_trait(TRAIT_MATURATION)+(rand(-1,1)*degree),30, 0)
				if(prob(degree*5))
					set_trait(TRAIT_HARVEST_REPEAT, !get_trait(TRAIT_HARVEST_REPEAT))
			if(10)
				if(prob(degree*2))
					set_trait(TRAIT_BIOLUM,         !get_trait(TRAIT_BIOLUM))
					if(get_trait(TRAIT_BIOLUM))
						source_turf.visible_message(SPAN_NOTICE("\The [display_name] begins to glow!"))
						if(prob(degree*2))
							set_trait(TRAIT_BIOLUM_COLOUR,get_random_colour(0,75,190))
							source_turf.visible_message("<span class='notice'>\The [display_name]'s glow </span><font color='[get_trait(TRAIT_BIOLUM_COLOUR)]'>changes colour</font>!")
					else
						source_turf.visible_message(SPAN_NOTICE("\The [display_name]'s glow dims..."))
			if(11)
				set_trait(TRAIT_TELEPORTING,1)

	return

/// Mutates a specific trait/set of traits.
/datum/seed/proc/apply_gene(var/datum/plantgene/gene)

	if(!gene || !gene.values || get_trait(TRAIT_IMMUTABLE) > 0) return

	// Splicing products has some detrimental effects on yield and lifespan.
	// We handle this before we do the rest of the looping, as normal traits don't really include lists.
	switch(gene.genetype)
		if(GENE_BIOCHEMISTRY)
			for(var/trait in list(TRAIT_YIELD, TRAIT_ENDURANCE))
				if(get_trait(trait) > 0) set_trait(trait,get_trait(trait),null,1,0.85)

			if(!chems) chems = list()

			var/list/gene_value = gene.values["[TRAIT_CHEMS]"]
			for(var/rid in gene_value)

				var/list/gene_chem = gene_value[rid]

				if(!chems[rid])
					chems[rid] = gene_chem.Copy()
					continue

				for(var/i=1;i<=gene_chem.len;i++)

					if(isnull(gene_chem[i])) gene_chem[i] = 0

					if(chems[rid][i])
						chems[rid][i] = max(1,round((gene_chem[i] + chems[rid][i])/2))
					else
						chems[rid][i] = gene_chem[i]

			var/list/new_gasses = gene.values["[TRAIT_EXUDE_GASSES]"]
			if(islist(new_gasses))
				if(!exude_gasses) exude_gasses = list()
				exude_gasses |= new_gasses
				for(var/gas in exude_gasses)
					exude_gasses[gas] = max(1,round(exude_gasses[gas]*0.8))

			gene.values["[TRAIT_EXUDE_GASSES]"] = null
			gene.values["[TRAIT_CHEMS]"] = null

		if(GENE_DIET)
			var/list/new_gasses = gene.values["[TRAIT_CONSUME_GASSES]"]
			consume_gasses |= new_gasses
			gene.values["[TRAIT_CONSUME_GASSES]"] = null
		if(GENE_METABOLISM)
			product_type = gene.values["product_type"]
			gene.values["product_type"] = null

	for(var/trait in gene.values)
		set_trait(trait,gene.values["[trait]"])

	update_growth_stages()

/// Returns a list of the desired trait values.
/datum/seed/proc/get_gene(var/genetype)

	if(!genetype) return 0

	var/list/traits_to_copy
	var/datum/plantgene/P = new()
	P.genetype = genetype
	P.values = list()

	switch(genetype)
		if(GENE_BIOCHEMISTRY)
			P.values["[TRAIT_CHEMS]"] =        chems
			P.values["[TRAIT_EXUDE_GASSES]"] = exude_gasses
			traits_to_copy = list(TRAIT_POTENCY)
		if(GENE_OUTPUT)
			traits_to_copy = list(TRAIT_PRODUCES_POWER,TRAIT_BIOLUM, TRAIT_BIOLUM_PWR)
		if(GENE_ATMOSPHERE)
			traits_to_copy = list(TRAIT_HEAT_TOLERANCE,TRAIT_LOWKPA_TOLERANCE,TRAIT_HIGHKPA_TOLERANCE)
		if(GENE_HARDINESS)
			traits_to_copy = list(TRAIT_TOXINS_TOLERANCE,TRAIT_PEST_TOLERANCE,TRAIT_WEED_TOLERANCE,TRAIT_ENDURANCE)
		if(GENE_METABOLISM)
			P.values["product_type"] = product_type
			traits_to_copy = list(TRAIT_REQUIRES_NUTRIENTS,TRAIT_REQUIRES_WATER,TRAIT_ALTER_TEMP)
		if(GENE_VIGOUR)
			traits_to_copy = list(TRAIT_PRODUCTION,TRAIT_MATURATION,TRAIT_YIELD,TRAIT_SPREAD)
		if(GENE_DIET)
			P.values["[TRAIT_CONSUME_GASSES]"] = consume_gasses
			traits_to_copy = list(TRAIT_CARNIVOROUS,TRAIT_PARASITE,TRAIT_NUTRIENT_CONSUMPTION,TRAIT_WATER_CONSUMPTION)
		if(GENE_ENVIRONMENT)
			traits_to_copy = list(TRAIT_IDEAL_HEAT,TRAIT_IDEAL_LIGHT,TRAIT_LIGHT_TOLERANCE)
		if(GENE_PIGMENT)
			traits_to_copy = list(TRAIT_PLANT_COLOUR,TRAIT_PRODUCT_COLOUR,TRAIT_BIOLUM_COLOUR,TRAIT_LEAVES_COLOUR)
		if(GENE_STRUCTURE)
			traits_to_copy = list(TRAIT_PLANT_ICON,TRAIT_PRODUCT_ICON,TRAIT_HARVEST_REPEAT, TRAIT_SPOROUS, TRAIT_LARGE)
		if(GENE_FRUIT)
			traits_to_copy = list(TRAIT_STINGS,TRAIT_EXPLOSIVE,TRAIT_FLESH_COLOUR,TRAIT_JUICY)
		if(GENE_SPECIAL)
			traits_to_copy = list(TRAIT_TELEPORTING)

	for(var/trait in traits_to_copy)
		P.values["[trait]"] = get_trait(trait)
	return (P ? P : 0)

/// Place the plant products at the feet of the user.
/datum/seed/proc/harvest(var/mob/user,var/yield_mod,var/harvest_sample,var/force_amount,var/stunted_status = FALSE)
	if(!user)
		return

	if(!force_amount && get_trait(TRAIT_YIELD) == 0 && !harvest_sample)
		if(istype(user)) to_chat(user, SPAN_DANGER("You fail to harvest anything useful."))
	else
		if(istype(user)) to_chat(user, "You [harvest_sample ? "take a sample" : "harvest"] from the [display_name].")

		//This may be a new line. Update the global if it is.
		if(name == "new line" || !(name in SSplants.seeds))
			uid = SSplants.seeds.len + 1
			name = "[uid]"
			SSplants.seeds[name] = src

		if(harvest_sample)
			var/obj/item/seeds/seeds = new(get_turf(user))
			seeds.seed_type = name
			seeds.update_seed()
			return

		var/total_yield = 0
		if(!isnull(force_amount))
			total_yield = force_amount
		else
			if(get_trait(TRAIT_YIELD) > -1)
				if(isnull(yield_mod) || yield_mod < 1)
					yield_mod = 0
					total_yield = get_trait(TRAIT_YIELD)
				else
					total_yield = get_trait(TRAIT_YIELD) + rand(yield_mod)
				total_yield = max(1,total_yield)

		// If the plant is stunted, you get half the yield.
		if(stunted_status)
			total_yield *= 0.5

		for(var/i = 0;i<total_yield;i++)
			spawn_seed(get_turf(user))

/datum/seed/proc/spawn_seed(var/turf/spawning_loc)
	var/obj/item/product = new product_type(spawning_loc, name)
	// Set descriptions
	if(product_desc)
		product.desc = product_desc
	if(product_desc_extended)
		product.desc_extended = product_desc_extended

	if(get_trait(TRAIT_PRODUCT_COLOUR))
		if(istype(product, /obj/item/reagent_containers/food))
			var/obj/item/reagent_containers/food/food = product
			food.color = get_trait(TRAIT_PRODUCT_COLOUR)
			food.filling_color = get_trait(TRAIT_PRODUCT_COLOUR)

	if(mysterious)
		product.name += "?"
		product.desc += " On second thought, something about this one looks strange."

	if(get_trait(TRAIT_BIOLUM))
		var/pwr
		if(get_trait(TRAIT_BIOLUM_PWR) == 0)
			pwr = get_trait(TRAIT_BIOLUM)
		else
			pwr = get_trait(TRAIT_BIOLUM_PWR)
		var/clr
		if(get_trait(TRAIT_BIOLUM_COLOUR))
			clr = get_trait(TRAIT_BIOLUM_COLOUR)
		product.set_light(get_trait(TRAIT_POTENCY)/10, pwr, clr)
		addtimer(CALLBACK(product, TYPE_PROC_REF(/atom, set_light), 0), rand(5 MINUTES, 7 MINUTES))

	//Handle spawning in living, mobile products (like dionaea).
	if(istype(product,/mob/living))
		product.visible_message(SPAN_NOTICE("The pod disgorges [product]!"))
		handle_living_product(product)
		if(istype(product,/mob/living/simple_animal/mushroom)) // Gross.
			var/mob/living/simple_animal/mushroom/mush = product
			mush.seed = src

/** When the seed in this machine mutates/is modified, the tray seed value
is set to a new datum copied from the original. This datum won't actually
be put into the global datum list until the product is harvested, though. */
/datum/seed/proc/diverge(var/modified)

	if(get_trait(TRAIT_IMMUTABLE) > 0) return

	//Set up some basic information.
	var/datum/seed/new_seed = new
	new_seed.name =            "new line"
	new_seed.uid =              0
	new_seed.roundstart =       0
	new_seed.can_self_harvest = can_self_harvest
	new_seed.kitchen_tag =      kitchen_tag
	new_seed.trash_type =       trash_type
	new_seed.product_type =     product_type
	//Copy over everything else.
	if(mutants)        new_seed.mutants = mutants.Copy()
	if(chems)          new_seed.chems = chems.Copy()
	if(consume_gasses) new_seed.consume_gasses = consume_gasses.Copy()
	if(exude_gasses)   new_seed.exude_gasses = exude_gasses.Copy()

	new_seed.seed_name =            "[(roundstart ? "[(modified ? "modified" : "mutant")] " : "")][seed_name]"
	new_seed.display_name =         "[(roundstart ? "[(modified ? "modified" : "mutant")] " : "")][display_name]"
	new_seed.seed_noun =            seed_noun
	new_seed.traits = traits.Copy()
	new_seed.update_growth_stages()
	return new_seed

/datum/seed/proc/update_growth_stages()
	if(get_trait(TRAIT_PLANT_ICON))
		growth_stages = SSplants.plant_sprites[get_trait(TRAIT_PLANT_ICON)]
	else
		growth_stages = 0

/datum/seed/proc/get_growth_type()
	SHOULD_NOT_SLEEP(TRUE)
	SHOULD_BE_PURE(TRUE)

	if(get_trait(TRAIT_SPREAD) == 2)
		switch(seed_noun)
			if(SEED_NOUN_CUTTINGS)
				return GROWTH_WORMS
			if(SEED_NOUN_NODES)
				return GROWTH_BIOMASS
			if(SEED_NOUN_SPORES)
				return GROWTH_MOLD
			else
				return GROWTH_VINES
	return 0

/**
 * A list of seed icons, to avoid regenerating images like there's no tomorrow
 *
 * Only access this by using the `SEED_ICON_CACHE_KEY` macro
 *
 * The structure is an associative list with the result of `SEED_ICON_CACHE_KEY` as the key
 * and an `/image` as the value
 */
GLOBAL_LIST_INIT(seed_icon_cache, list())

///Generates a text hash that works as the key for the `seed_icon_cache` GLOB list
#define SEED_ICON_CACHE_KEY(file, state, color, leaves_overlay) "[file]|||[state]|||[color]|||[leaves_overlay]"

/datum/seed/proc/get_icon(growth_stage)
	SHOULD_NOT_SLEEP(TRUE)
	RETURN_TYPE(/image)

	if(isnull(growth_stage))
		crash_with("No growth stage was supplied when getting the icon!")

	/* Setup a bunch of shit that should have been done in a very different way but alas */

	//The icon of the plant
	var/icon_trait = get_trait(TRAIT_PLANT_ICON)
	//The type of growth
	var/growth_type = get_growth_type()
	//If it's a vine
	var/is_vine = (get_trait(TRAIT_SPREAD) == 2)
	//If the icon is a large one
	var/is_large_icon = get_trait(TRAIT_LARGE)
	//The color of the leaves, if any
	var/leaves_color = get_trait(TRAIT_LEAVES_COLOUR)

	/* The part where we select what to request */

	//Pick what file we want
	var/icon_file_to_request
	if(is_vine)
		icon_file_to_request = 'icons/obj/hydroponics_vines.dmi'
	else if(is_large_icon)
		icon_file_to_request = 'icons/obj/hydroponics_large.dmi'
	else
		icon_file_to_request = 'icons/obj/hydroponics_growing.dmi'

	//Pick what icon state to request
	var/icon_state_to_request = (is_vine) ? "[growth_type]-[growth_stage]" : "[icon_trait]-[growth_stage]"

	//Pick the color to assign to the image
	var/color_to_request = get_trait(TRAIT_PLANT_COLOUR)

	//The leaves color overlay to request
	var/leaves_overlay_to_request = (leaves_color) ? "[icon_trait]-[growth_stage]-leaves" : null

	/* Find or generate the image and return it */

	//See if we have this in our cache
	if(SEED_ICON_CACHE_KEY(icon_file_to_request, icon_state_to_request, color_to_request, leaves_overlay_to_request) in GLOB.seed_icon_cache)
		return GLOB.seed_icon_cache[SEED_ICON_CACHE_KEY(icon_file_to_request, icon_state_to_request, color_to_request, leaves_overlay_to_request)]

	//No luck, it's not in the cache, time to generate it
	else

		//Check that there's a valid icon state we can use, abort otherwise
		var/valid_icon_states = icon_states(icon_file_to_request, 2)
		if(!(icon_state_to_request in valid_icon_states))
			crash_with("A seed icon was requested with an invalid icon state! Icon file: [icon_file_to_request] ---- Icon state: [icon_state_to_request]")

		var/image/generated_image = image(icon_file_to_request, icon_state_to_request)

		//Assign the requested
		generated_image.color = color_to_request

		//If it's a large icon, offset it
		if(is_large_icon)
			generated_image.pixel_x = -8
			generated_image.pixel_y = -16

		//If leaves are requested, add them as overlays
		if(leaves_overlay_to_request)
			var/image/leaves_image = image(icon_file_to_request, leaves_overlay_to_request)
			leaves_image.color = leaves_color
			leaves_image.appearance_flags = RESET_COLOR
			//Add ourself as overlays to the generated image
			generated_image.AddOverlays(leaves_image)

		//Store the image in the cache, so we won't have to keep generating it
		GLOB.seed_icon_cache[SEED_ICON_CACHE_KEY(icon_file_to_request, icon_state_to_request, color_to_request, leaves_overlay_to_request)] = generated_image

		//Return the image
		return generated_image

#undef SEED_ICON_CACHE_KEY
