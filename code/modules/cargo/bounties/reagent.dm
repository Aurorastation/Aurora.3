/datum/bounty/reagent
	var/required_volume = 10
	var/shipped_volume = 0
	var/datum/reagent/wanted_reagent
	var/list/possible_descriptions = list("We're interested in testing the quality of our stations' bartenders!",
	"We're holding an office party and need some drink variety.",
	"We're holding a mixing competition, and you'll receive a bonus for competing.",
	"One of our agents has had a hard day and needs to unwind so badly they're willing to put up for a bounty.",
	"We need some drinks for a PR campaign setup.",
	"One of our bartenders is having trouble getting inspired, and wants to see a different drink.")

/datum/bounty/reagent/completion_string()
	return {"[round(shipped_volume)]/[required_volume] Units"}

/datum/bounty/reagent/can_claim()
	return ..() && shipped_volume >= required_volume

/datum/bounty/reagent/applies_to(obj/O)
	if(!istype(O, /obj/item/reagent_containers))
		return FALSE
	if(!O.reagents || !O.reagents.has_reagent(wanted_reagent.type))
		return FALSE
	return shipped_volume < required_volume

/datum/bounty/reagent/ship(obj/O)
	if(!applies_to(O))
		return
	shipped_volume += O.reagents.get_reagent_amount(wanted_reagent.type)
	if(shipped_volume > required_volume)
		shipped_volume = required_volume

/datum/bounty/reagent/compatible_with(other_bounty)
	if(!istype(other_bounty, /datum/bounty/reagent))
		return TRUE
	var/datum/bounty/reagent/R = other_bounty
	return wanted_reagent.type != R.wanted_reagent.type

/datum/bounty/reagent/simple_drink
	name = "Simple Drink"
	reward_low = 1000
	reward_high = 1800

/datum/bounty/reagent/simple_drink/New()
	..()
	// Don't worry about making this comprehensive. It doesn't matter if some drinks are skipped.
	var/list/possible_reagents = list(
		/datum/reagent/alcohol/ethanol/antifreeze,
		/datum/reagent/alcohol/ethanol/andalusia,
		/datum/reagent/alcohol/ethanol/coffee/b52,
		/datum/reagent/alcohol/ethanol/bananahonk,
		/datum/reagent/alcohol/ethanol/bilk,
		/datum/reagent/alcohol/ethanol/blackrussian,
		/datum/reagent/alcohol/ethanol/bloodymary,
		/datum/reagent/alcohol/ethanol/martini,
		/datum/reagent/alcohol/ethanol/cubalibre,
		/datum/reagent/alcohol/ethanol/erikasurprise,
		/datum/reagent/alcohol/ethanol/ginfizz,
		/datum/reagent/alcohol/ethanol/gintonic,
		/datum/reagent/alcohol/ethanol/grog,
		/datum/reagent/alcohol/ethanol/iced_beer,
		/datum/reagent/alcohol/ethanol/irishcarbomb,
		/datum/reagent/alcohol/ethanol/manhattan,
		/datum/reagent/alcohol/ethanol/margarita,
		/datum/reagent/alcohol/ethanol/gargleblaster,
		/datum/reagent/alcohol/ethanol/screwdrivercocktail,
		/datum/reagent/alcohol/ethanol/cobaltvelvet,
		/datum/reagent/alcohol/ethanol/snowwhite,
		/datum/reagent/alcohol/ethanol/gibsonhooch,
		/datum/reagent/alcohol/ethanol/manly_dorf,
		/datum/reagent/alcohol/ethanol/thirteenloko,
		/datum/reagent/alcohol/ethanol/vodkamartini,
		/datum/reagent/alcohol/ethanol/whiskeysoda,
		/datum/reagent/alcohol/ethanol/demonsblood,
		/datum/reagent/alcohol/ethanol/cinnamonapplewhiskey,
		/datum/reagent/drink/coffee/soy_latte,
		/datum/reagent/drink/coffee/cafe_latte,
		/datum/reagent/drink/tea/coco_chaitea,
		/datum/reagent/drink/tea/chaitealatte,
		/datum/reagent/drink/tea/bureacratea,
		/datum/reagent/drink/tea/desert_tea,
		/datum/reagent/drink/tea/hakhma_tea,
		/datum/reagent/drink/tea/portsvilleminttea,
		/datum/reagent/drink/meatshake,
		/datum/reagent/alcohol/butanol/sandgria,
		/datum/reagent/alcohol/butanol/cactuscola,
		/datum/reagent/alcohol/butanol/trizkizki_tea)

	var/datum/reagent/reagent_type = pick(possible_reagents)
	wanted_reagent = new reagent_type
	name = wanted_reagent.name
	description = "[pick(possible_descriptions)] Send a shipment of [name]." //punctuation is already in pick()
	required_volume = rand(2, 12) * 10
	reward += required_volume * 20		//range from +400(20u) to +2400(120u)

//Complex drinks. Requires coordination with other departments for ingredients
/datum/bounty/reagent/complex_drink
	name = "Complex Drink"
	reward_low = 2000
	reward_high = 3200

/datum/bounty/reagent/complex_drink/New()
	..()
	// Don't worry about making this comprehensive. It doesn't matter if some drinks are skipped.
	var/list/possible_reagents = list(
		/datum/reagent/alcohol/ethanol/hooch,
		/datum/reagent/alcohol/ethanol/atomicbomb,
		/datum/reagent/alcohol/ethanol/beepsky_smash,
		/datum/reagent/alcohol/ethanol/booger,
		/datum/reagent/alcohol/ethanol/hippiesdelight,
		/datum/reagent/alcohol/ethanol/goldschlager,
		/datum/reagent/alcohol/ethanol/manhattan_proj,
		/datum/reagent/alcohol/ethanol/neurotoxin,
		/datum/reagent/alcohol/ethanol/singulo,
		/datum/reagent/alcohol/ethanol/patron,
		/datum/reagent/alcohol/ethanol/silencer,
		/datum/reagent/alcohol/ethanol/cbsc,
		/datum/reagent/alcohol/ethanol/rixulin_sundae,
		/datum/reagent/drink/xrim,
		/datum/reagent/drink/tea/securitea,
		/datum/reagent/drink/toothpaste/sedantian_firestorm,
		/datum/reagent/alcohol/butanol/wastelandheat,
		/datum/reagent/alcohol/butanol/contactwine,
		/datum/reagent/alcohol/butanol/crocodile_booze)
		
	var/reagent_type = pick(possible_reagents)
	wanted_reagent = new reagent_type
	name = wanted_reagent.name
	description = "[pick(possible_descriptions)] Send a shipment of [name]." //punctuation is already in pick()
	required_volume = rand(2, 12) * 10
	reward += required_volume * 30		//range from +600(20u) to +3600(120u)

//Medicines, toxins, and drugs
/datum/bounty/reagent/chemical
	name = "Chemical"
	reward_low = 2000
	reward_high = 3200

/datum/bounty/reagent/chemical/New()
	..()
	// Don't worry about making this comprehensive. It doesn't matter if some chems are skipped.
	var/list/possible_reagents = list(
		/datum/reagent/leporazine,
		/datum/reagent/clonexadone,
		/datum/reagent/space_drugs,
		/datum/reagent/thermite,
		/datum/reagent/antihistamine,
		/datum/reagent/sterilizine,
		/datum/reagent/mental/duloxetine,
		/datum/reagent/mental/escitalopram,
		/datum/reagent/mental/risperidone,
		/datum/reagent/rmt,
		/datum/reagent/tramadol,
		/datum/reagent/oxycodone,
		/datum/reagent/imidazoline,
		/datum/reagent/peridaxon,
		/datum/reagent/mannitol,
		/datum/reagent/ipecac,
		/datum/reagent/hyperzine,
		/datum/reagent/calomel,
		/datum/reagent/pacifier,
		/datum/reagent/dexalin/plus,
		/datum/reagent/ryetalyn,
		/datum/reagent/pneumalin,
		/datum/reagent/acid/polyacid,
		/datum/reagent/mutagen,
		/datum/reagent/impedrezene,
		/datum/reagent/night_juice,
		/datum/reagent/toxin/cardox,
		/datum/reagent/toxin/lean,
		/datum/reagent/toxin/stimm)

	var/reagent_type = pick(possible_reagents)
	wanted_reagent = new reagent_type
	name = wanted_reagent.name
	description = "One of our labs is in desperate need of [name]. Ship a container of it to be rewarded."
	required_volume = rand(2, 12) * 10
	reward += required_volume * 40		//range from +800(20u) to +4800(120u)
