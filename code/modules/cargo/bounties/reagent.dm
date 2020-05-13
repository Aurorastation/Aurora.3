/datum/bounty/reagent
	var/required_volume = 10
	var/shipped_volume = 0
	var/datum/reagent/wanted_reagent

/datum/bounty/reagent/completion_string()
	return {"[round(shipped_volume)]/[required_volume] Units"}

/datum/bounty/reagent/can_claim()
	return ..() && shipped_volume >= required_volume

/datum/bounty/reagent/applies_to(obj/O)
	if(!istype(O, /obj/item/reagent_containers))
		return FALSE
	if(!O.reagents || !O.reagents.has_reagent(wanted_reagent.id))
		return FALSE
	return shipped_volume < required_volume

/datum/bounty/reagent/ship(obj/O)
	if(!applies_to(O))
		return
	shipped_volume += O.reagents.get_reagent_amount(wanted_reagent.id)
	if(shipped_volume > required_volume)
		shipped_volume = required_volume

/datum/bounty/reagent/compatible_with(other_bounty)
	if(!istype(other_bounty, /datum/bounty/reagent))
		return TRUE
	var/datum/bounty/reagent/R = other_bounty
	return wanted_reagent.id != R.wanted_reagent.id

/datum/bounty/reagent/simple_drink
	name = "Simple Drink"
	reward = 1500

/datum/bounty/reagent/simple_drink/New()
	// Don't worry about making this comprehensive. It doesn't matter if some drinks are skipped.
	var/static/list/possible_reagents = list(\
		/datum/reagent/alcohol/ethanol/antifreeze,\
		/datum/reagent/alcohol/ethanol/andalusia,\
		/datum/reagent/alcohol/ethanol/coffee/b52,\
		/datum/reagent/alcohol/ethanol/bananahonk,\
		/datum/reagent/alcohol/ethanol/beepsky_smash,\
		/datum/reagent/alcohol/ethanol/bilk,\
		/datum/reagent/alcohol/ethanol/black_russian,\
		/datum/reagent/alcohol/ethanol/bloody_mary,\
		/datum/reagent/alcohol/ethanol/martini,\
		/datum/reagent/alcohol/ethanol/cuba_libre,\
		/datum/reagent/alcohol/ethanol/erikasurprise,\
		/datum/reagent/alcohol/ethanol/ginfizz,\
		/datum/reagent/alcohol/ethanol/gintonic,\
		/datum/reagent/alcohol/ethanol/grog,\
		/datum/reagent/alcohol/ethanol/hooch,\
		/datum/reagent/alcohol/ethanol/iced_beer,\
		/datum/reagent/alcohol/ethanol/irishcarbomb,\
		/datum/reagent/alcohol/ethanol/manhattan,\
		/datum/reagent/alcohol/ethanol/margarita,\
		/datum/reagent/alcohol/ethanol/gargle_blaster,\
		/datum/reagent/alcohol/ethanol/screwdrivercocktail,\
		/datum/reagent/alcohol/ethanol/snowwhite,\
		/datum/reagent/drink/coffee/soy_latte,\
		/datum/reagent/drink/coffee/cafe_latte,\
		/datum/reagent/alcohol/ethanol/syndicatebomb,\
		/datum/reagent/alcohol/ethanol/manly_dorf,\
		/datum/reagent/alcohol/ethanol/thirteenloko,\
		/datum/reagent/alcohol/ethanol/vodkamartini,\
		/datum/reagent/alcohol/ethanol/whiskeysoda,\
		/datum/reagent/alcohol/ethanol/demonsblood,\
		/datum/reagent/alcohol/ethanol/singulo)

	var/reagent_type = pick(possible_reagents)
	wanted_reagent = new reagent_type
	name = wanted_reagent.name
	description = "%BOSSSHORT is thirsty! Send a shipment of [name] to %DOCKNAME to quench the company's thirst."
	reward += rand(0, 2) * 500
	..()

/datum/bounty/reagent/complex_drink
	name = "Complex Drink"
	reward = 4000

/datum/bounty/reagent/complex_drink/New()
	// Don't worry about making this comprehensive. It doesn't matter if some drinks are skipped.
	var/static/list/possible_reagents = list(\
		/datum/reagent/alcohol/ethanol/atomicbomb,\
		/datum/reagent/alcohol/ethanol/booger,\
		/datum/reagent/alcohol/ethanol/hippies_delight,\
		/datum/reagent/alcohol/ethanol/goldschlager,\
		/datum/reagent/alcohol/ethanol/manhattan_proj,\
		/datum/reagent/alcohol/ethanol/neurotoxin,\
		/datum/reagent/alcohol/ethanol/patron,\
		/datum/reagent/alcohol/ethanol/silencer)
		
	var/reagent_type = pick(possible_reagents)
	wanted_reagent = new reagent_type
	name = wanted_reagent.name
	description = "%BOSSSHORT is offering a reward for talented bartenders. Ship a container of [name] to claim the prize."
	reward += rand(0, 4) * 500
	..()

/datum/bounty/reagent/chemical
	name = "Chemical"
	reward = 4000
	required_volume = 30

/datum/bounty/reagent/chemical/New()
	// Don't worry about making this comprehensive. It doesn't matter if some chems are skipped.
	var/static/list/possible_reagents = list(\
		/datum/reagent/leporazine,\
		/datum/reagent/clonexadone,\
		/datum/reagent/rezadone,\
		/datum/reagent/space_drugs,\
		/datum/reagent/thermite,\
		/datum/reagent/nutriment/honey,\
		/datum/reagent/frostoil,\
		/datum/reagent/slimejelly,\
		/datum/reagent/toxin/cyanide)

	var/reagent_type = pick(possible_reagents)
	wanted_reagent = new reagent_type
	name = wanted_reagent.name
	description = "%BOSSSHORT is in desperate need of the chemical [name]. Ship a container of it to be rewarded."
	reward += rand(0, 4) * 500
	..()