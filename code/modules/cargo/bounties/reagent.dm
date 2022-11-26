/datum/bounty/reagent
	var/required_volume = 10
	var/shipped_volume = 0
	var/decl/reagent/wanted_reagent
	var/list/possible_descriptions = list("We're interested in testing the quality of our vessels' bartenders!",
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
		/decl/reagent/alcohol/antifreeze,
		/decl/reagent/alcohol/andalusia,
		/decl/reagent/alcohol/coffee/b52,
		/decl/reagent/alcohol/bananahonk,
		/decl/reagent/alcohol/bilk,
		/decl/reagent/alcohol/blackrussian,
		/decl/reagent/alcohol/bloodymary,
		/decl/reagent/alcohol/martini,
		/decl/reagent/alcohol/cubalibre,
		/decl/reagent/alcohol/erikasurprise,
		/decl/reagent/alcohol/ginfizz,
		/decl/reagent/alcohol/gintonic,
		/decl/reagent/alcohol/grog,
		/decl/reagent/alcohol/iced_beer,
		/decl/reagent/alcohol/irishcarbomb,
		/decl/reagent/alcohol/manhattan,
		/decl/reagent/alcohol/margarita,
		/decl/reagent/alcohol/gargleblaster,
		/decl/reagent/alcohol/screwdrivercocktail,
		/decl/reagent/alcohol/cobaltvelvet,
		/decl/reagent/alcohol/snowwhite,
		/decl/reagent/alcohol/sidewinderfang,
		/decl/reagent/alcohol/gibsonhooch,
		/decl/reagent/alcohol/manly_dorf,
		/decl/reagent/alcohol/thirteenloko,
		/decl/reagent/alcohol/vodkamartini,
		/decl/reagent/alcohol/whiskeysoda,
		/decl/reagent/alcohol/demonsblood,
		/decl/reagent/alcohol/cinnamonapplewhiskey,
		/decl/reagent/drink/coffee/soy_latte,
		/decl/reagent/drink/coffee/cafe_latte,
		/decl/reagent/drink/tea/coco_chaitea,
		/decl/reagent/drink/tea/chaitealatte,
		/decl/reagent/drink/tea/bureacratea,
		/decl/reagent/drink/tea/desert_tea,
		/decl/reagent/drink/tea/hakhma_tea,
		/decl/reagent/drink/tea/portsvilleminttea,
		/decl/reagent/drink/meatshake,
		/decl/reagent/alcohol/butanol/sandgria,
		/decl/reagent/alcohol/butanol/cactuscola,
		/decl/reagent/alcohol/butanol/trizkizki_tea)

	var/decl/reagent/reagent_type = pick(possible_reagents)
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
		/decl/reagent/alcohol/hooch,
		/decl/reagent/alcohol/atomicbomb,
		/decl/reagent/alcohol/beepsky_smash,
		/decl/reagent/alcohol/booger,
		/decl/reagent/alcohol/hippiesdelight,
		/decl/reagent/alcohol/goldschlager,
		/decl/reagent/alcohol/manhattan_proj,
		/decl/reagent/alcohol/neurotoxin,
		/decl/reagent/alcohol/singulo,
		/decl/reagent/alcohol/patron,
		/decl/reagent/alcohol/silencer,
		/decl/reagent/alcohol/cbsc,
		/decl/reagent/alcohol/rixulin_sundae,
		/decl/reagent/drink/xrim,
		/decl/reagent/drink/tea/securitea,
		/decl/reagent/drink/toothpaste/sedantian_firestorm,
		/decl/reagent/alcohol/butanol/wastelandheat,
		/decl/reagent/alcohol/butanol/contactwine,
		/decl/reagent/alcohol/butanol/crocodile_booze)

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
		/decl/reagent/leporazine,
		/decl/reagent/clonexadone,
		/decl/reagent/space_drugs,
		/decl/reagent/thermite,
		/decl/reagent/cetahydramine,
		/decl/reagent/sterilizine,
		/decl/reagent/mental/emoxanyl,
		/decl/reagent/mental/minaphobin,
		/decl/reagent/mental/neurapan,
		/decl/reagent/rmt,
		/decl/reagent/mortaphenyl,
		/decl/reagent/oxycomorphine,
		/decl/reagent/oculine,
		/decl/reagent/peridaxon,
		/decl/reagent/cataleptinol,
		/decl/reagent/verunol,
		/decl/reagent/hyperzine,
		/decl/reagent/fluvectionem,
		/decl/reagent/pacifier,
		/decl/reagent/dexalin/plus,
		/decl/reagent/ryetalyn,
		/decl/reagent/pneumalin,
		/decl/reagent/acid/polyacid,
		/decl/reagent/mutagen,
		/decl/reagent/impedrezene,
		/decl/reagent/night_juice,
		/decl/reagent/toxin/cardox,
		/decl/reagent/toxin/stimm,
		/decl/reagent/ambrosia_extract)

	var/reagent_type = pick(possible_reagents)
	wanted_reagent = new reagent_type
	name = wanted_reagent.name
	description = "One of our labs is in desperate need of [name]. Ship a container of it to be rewarded."
	required_volume = rand(2, 12) * 10
	reward += required_volume * 40		//range from +800(20u) to +4800(120u)
