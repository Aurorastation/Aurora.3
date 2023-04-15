/datum/bounty/reagent
	var/required_volume = 10
	var/shipped_volume = 0
	var/singleton/reagent/wanted_reagent
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
	shipped_volume += REAGENT_VOLUME(O.reagents, wanted_reagent.type)
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
		/singleton/reagent/alcohol/antifreeze,
		/singleton/reagent/alcohol/andalusia,
		/singleton/reagent/alcohol/coffee/b52,
		/singleton/reagent/alcohol/bananahonk,
		/singleton/reagent/alcohol/bilk,
		/singleton/reagent/alcohol/blackrussian,
		/singleton/reagent/alcohol/bloodymary,
		/singleton/reagent/alcohol/martini,
		/singleton/reagent/alcohol/cubalibre,
		/singleton/reagent/alcohol/erikasurprise,
		/singleton/reagent/alcohol/ginfizz,
		/singleton/reagent/alcohol/gintonic,
		/singleton/reagent/alcohol/grog,
		/singleton/reagent/alcohol/iced_beer,
		/singleton/reagent/alcohol/irishcarbomb,
		/singleton/reagent/alcohol/manhattan,
		/singleton/reagent/alcohol/margarita,
		/singleton/reagent/alcohol/gargleblaster,
		/singleton/reagent/alcohol/screwdrivercocktail,
		/singleton/reagent/alcohol/cobaltvelvet,
		/singleton/reagent/alcohol/snowwhite,
		/singleton/reagent/alcohol/sidewinderfang,
		/singleton/reagent/alcohol/gibsonhooch,
		/singleton/reagent/alcohol/manly_dorf,
		/singleton/reagent/alcohol/thirteenloko,
		/singleton/reagent/alcohol/vodkamartini,
		/singleton/reagent/alcohol/whiskeysoda,
		/singleton/reagent/alcohol/demonsblood,
		/singleton/reagent/alcohol/cinnamonapplewhiskey,
		/singleton/reagent/drink/coffee/soy_latte,
		/singleton/reagent/drink/coffee/cafe_latte,
		/singleton/reagent/drink/tea/coco_chaitea,
		/singleton/reagent/drink/tea/chaitealatte,
		/singleton/reagent/drink/tea/bureacratea,
		/singleton/reagent/drink/tea/desert_tea,
		/singleton/reagent/drink/tea/hakhma_tea,
		/singleton/reagent/drink/tea/portsvilleminttea,
		/singleton/reagent/drink/meatshake,
		/singleton/reagent/alcohol/butanol/sandgria,
		/singleton/reagent/alcohol/butanol/cactuscola,
		/singleton/reagent/alcohol/butanol/trizkizki_tea)

	var/singleton/reagent/reagent_type = pick(possible_reagents)
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
		/singleton/reagent/alcohol/hooch,
		/singleton/reagent/alcohol/atomicbomb,
		/singleton/reagent/alcohol/beepsky_smash,
		/singleton/reagent/alcohol/booger,
		/singleton/reagent/alcohol/hippiesdelight,
		/singleton/reagent/alcohol/goldschlager,
		/singleton/reagent/alcohol/manhattan_proj,
		/singleton/reagent/alcohol/neurotoxin,
		/singleton/reagent/alcohol/singulo,
		/singleton/reagent/alcohol/patron,
		/singleton/reagent/alcohol/silencer,
		/singleton/reagent/alcohol/cbsc,
		/singleton/reagent/alcohol/rixulin_sundae,
		/singleton/reagent/drink/xrim,
		/singleton/reagent/drink/tea/securitea,
		/singleton/reagent/drink/toothpaste/sedantian_firestorm,
		/singleton/reagent/alcohol/butanol/wastelandheat,
		/singleton/reagent/alcohol/butanol/contactwine,
		/singleton/reagent/alcohol/butanol/crocodile_booze)

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
		/singleton/reagent/leporazine,
		/singleton/reagent/clonexadone,
		/singleton/reagent/space_drugs,
		/singleton/reagent/thermite,
		/singleton/reagent/cetahydramine,
		/singleton/reagent/sterilizine,
		/singleton/reagent/mental/emoxanyl,
		/singleton/reagent/mental/minaphobin,
		/singleton/reagent/mental/neurapan,
		/singleton/reagent/rmt,
		/singleton/reagent/mortaphenyl,
		/singleton/reagent/oxycomorphine,
		/singleton/reagent/oculine,
		/singleton/reagent/peridaxon,
		/singleton/reagent/cataleptinol,
		/singleton/reagent/verunol,
		/singleton/reagent/hyperzine,
		/singleton/reagent/fluvectionem,
		/singleton/reagent/pacifier,
		/singleton/reagent/dexalin/plus,
		/singleton/reagent/ryetalyn,
		/singleton/reagent/pneumalin,
		/singleton/reagent/acid/polyacid,
		/singleton/reagent/mutagen,
		/singleton/reagent/impedrezene,
		/singleton/reagent/night_juice,
		/singleton/reagent/toxin/cardox,
		/singleton/reagent/toxin/stimm,
		/singleton/reagent/ambrosia_extract)

	var/reagent_type = pick(possible_reagents)
	wanted_reagent = new reagent_type
	name = wanted_reagent.name
	description = "One of our labs is in desperate need of [name]. Ship a container of it to be rewarded."
	required_volume = rand(2, 12) * 10
	reward += required_volume * 40		//range from +800(20u) to +4800(120u)
