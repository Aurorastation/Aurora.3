/**
 * Component used for the Pharmacology Skill.
 * Governs chemical/pharmaceutical identification, pharmacy machinery operation, medication administration, and compounding quality.
 */
/datum/component/skill/pharmacology

/**
 * Helper to get a user's Pharmacology skill level, defaulting to SKILL_LEVEL_TRAINED if the mob does not use the skill system (e.g. ghosts/adminghosts).
 */
/proc/get_pharmacology_skill(mob/user)
	if(!istype(user))
		return SKILL_LEVEL_TRAINED
	var/level = GET_SKILL_LEVEL(user, PHARMACOLOGY_SKILL_COMPONENT)
	if(!level)
		return SKILL_LEVEL_TRAINED
	return level

/**
 * Helper to get the highest of a user's Pharmacology or Medicine skill level (for overlapping medical administration tasks like syringes, hyposprays, droppers, and IV drips).
 */
/proc/get_medical_injection_skill(mob/user)
	if(!istype(user))
		return SKILL_LEVEL_TRAINED
	var/pharm = GET_SKILL_LEVEL(user, PHARMACOLOGY_SKILL_COMPONENT)
	var/med = GET_SKILL_LEVEL(user, MEDICINE_SKILL_COMPONENT)
	if(!pharm && !med)
		return SKILL_LEVEL_TRAINED
	return max(pharm || SKILL_LEVEL_UNFAMILIAR, med || SKILL_LEVEL_UNFAMILIAR)

/**
 * Checks whether a reagent is an everyday household/food/drink chemical that even an Unfamiliar user in aChemMaster or Chemical Dispenser wouldn't be confused by.
 */
/proc/is_basic_everyday_reagent(singleton/reagent/R)
	if(!istype(R))
		return FALSE
	if(istype(R, /singleton/reagent/water) || istype(R, /singleton/reagent/sugar) || istype(R, /singleton/reagent/drink) || istype(R, /singleton/reagent/nutriment) || istype(R, /singleton/reagent/alcohol))
		return TRUE
	var/static/list/everyday_types = list(
		/singleton/reagent/iron,
		/singleton/reagent/carbon,
		/singleton/reagent/copper,
		/singleton/reagent/sodium,
		/singleton/reagent/sodiumchloride,
		/singleton/reagent/enzyme,
		/singleton/reagent/frostoil,
		/singleton/reagent/capsaicin
	)
	return is_type_in_list(R, everyday_types)

/**
 * Checks whether a Chemical Dispenser cartridge label is a basic everyday label recognizable at Unfamiliar (1).
 */
/proc/is_basic_dispenser_label(label)
	var/static/list/basic_labels = list(
		"Water",
		"Sugar",
		"Ethanol",
		"Iron",
		"Carbon",
		"Copper",
		"Sodium"
	)
	return (label in basic_labels)

/**
 * Determines whether a user can visually identify a specific reagent inside an open/transparent container or pill.
 * Note: `spectro_hidden` reagents are NEVER visually identifiable regardless of Pharmacology rank.
 */
/proc/can_identify_reagent_visually(mob/user, singleton/reagent/R, skill_level)
	if(!istype(R))
		return FALSE
	// Spectro-hidden reagents cannot be identified by naked-eye inspection even by Professionals
	if(R.spectro_hidden)
		return FALSE
	if(!skill_level)
		skill_level = get_pharmacology_skill(user)
	if(skill_level <= SKILL_LEVEL_UNFAMILIAR)
		return FALSE
	if(skill_level >= SKILL_LEVEL_PROFESSIONAL)
		return TRUE

	// Familiar (2): Common food/drinks, everyday chemicals, and basic first-aid / OTC meds
	if(is_basic_everyday_reagent(R))
		return TRUE
	var/static/list/familiar_reagents = list(
		/singleton/reagent/blood,
		/singleton/reagent/inaprovaline,
		/singleton/reagent/dylovene,
		/singleton/reagent/bicaridine,
		/singleton/reagent/kelotane,
		/singleton/reagent/dexalin,
		/singleton/reagent/tricordrazine,
		/singleton/reagent/perconol,
		/singleton/reagent/mortaphenyl,
		/singleton/reagent/tramarine,
		/singleton/reagent/antidexafen,
		/singleton/reagent/cetahydramine,
		/singleton/reagent/sterilizine,
		/singleton/reagent/spacecleaner
	)
	if(is_type_in_list(R, familiar_reagents))
		return TRUE

	if(skill_level == SKILL_LEVEL_FAMILIAR)
		return FALSE

	// Trained (3): All scannable medical reagents, psychiatric medications (except unethical truth serum), and standard dispenser elements/compounds
	if(R.scannable)
		return TRUE
	if(istype(R, /singleton/reagent/mental) && !istype(R, /singleton/reagent/mental/truthserum))
		return TRUE
	var/static/list/trained_dispenser_reagents = list(
		/singleton/reagent/acetone,
		/singleton/reagent/aluminum,
		/singleton/reagent/ammonia,
		/singleton/reagent/boron,
		/singleton/reagent/hydrazine,
		/singleton/reagent/lithium,
		/singleton/reagent/mercury,
		/singleton/reagent/phosphorus,
		/singleton/reagent/potassium,
		/singleton/reagent/radium,
		/singleton/reagent/acid,
		/singleton/reagent/silicon,
		/singleton/reagent/sulfur,
		/singleton/reagent/tungsten,
		/singleton/reagent/diethylamine,
		/singleton/reagent/glycerol
	)
	if(is_type_in_list(R, trained_dispenser_reagents))
		return TRUE

	return FALSE

/**
 * Applies the effects of the Pharmacology skill to a freshly compounded pill in the ChemMaster 3000.
 */
/proc/apply_pharmacology_skill_to_pill(obj/item/reagent_containers/pill/pill, skill_level)
	if(!istype(pill) || QDELETED(pill))
		return
	if(!skill_level || skill_level < SKILL_LEVEL_TRAINED)
		return

	var/ranks_above_familiar = skill_level - SKILL_LEVEL_FAMILIAR
	var/moodlet_value = PHARMACOLOGY_MOODLET_VALUE_PER_RANK * ranks_above_familiar
	pill.AddComponent(/datum/component/pill_moodlet_provider, moodlet_value, skill_level)

/datum/moodlet/formulated_pill
	moodlet_descriptor = SPAN_GOOD("Took well-formulated, easy-to-swallow medication.")
	initial_descriptor = SPAN_GOOD("The smooth pharmaceutical coating on the pill makes it go down effortlessly without any bitter chemical aftertaste.")

/datum/component/pill_moodlet_provider
	/// The morale boosting value of the moodlet this pill will provide (+5 for Trained, +10 for Professional).
	var/moodlet_value = 5
	/// The Pharmacology skill level of the pharmacist who compounded the pill.
	var/compounder_skill = SKILL_LEVEL_TRAINED
	/// The pleasant coating taste used to mask bitter chemical tastes.
	var/taste_override = "a smooth, lightly sweetened sugar coating"
	/// Description suffix added to the pill.
	var/desc_suffix

/datum/component/pill_moodlet_provider/Initialize(value = 5, skill_level = SKILL_LEVEL_TRAINED)
	. = ..()
	if(!parent)
		return

	moodlet_value = value
	compounder_skill = skill_level
	if(compounder_skill >= SKILL_LEVEL_PROFESSIONAL)
		taste_override = "a pleasant, expertly formulated pharmaceutical glaze"
		desc_suffix = " It has a flawless, glossy pharmaceutical coating."
	else
		taste_override = "a smooth, lightly sweetened sugar coating"
		desc_suffix = " It has a smooth sugar coating."

	RegisterSignal(parent, COMSIG_PILL_SWALLOWED, PROC_REF(handle_swallowed), override = TRUE)

	if(isatom(parent))
		var/atom/owner = parent
		owner.desc += desc_suffix

/datum/component/pill_moodlet_provider/Destroy()
	if(parent)
		UnregisterSignal(parent, COMSIG_PILL_SWALLOWED)
	return ..()

/datum/component/pill_moodlet_provider/proc/handle_swallowed(obj/item/reagent_containers/pill/owner, mob/living/carbon/target, mob/living/user)
	SIGNAL_HANDLER
	if(QDELING(src) || !istype(target))
		return

	// Mask bitter chemical taste by setting last_taste_time right before ingest() runs
	if(target.last_taste_time + 50 < world.time)
		target.last_taste_time = world.time
		target.last_taste_text = taste_override
		to_chat(target, SPAN_NOTICE("You can taste [taste_override]."))

	var/datum/component/morale/morale_comp = target.GetComponent(MORALE_COMPONENT)
	if(!morale_comp)
		return

	var/datum/moodlet/existing_moodlet = locate(/datum/moodlet/formulated_pill) in morale_comp.moodlets
	if(existing_moodlet?.get_morale_modifier() > moodlet_value)
		return

	var/datum/moodlet/new_moodlet = morale_comp.load_moodlet(/datum/moodlet/formulated_pill, moodlet_value)
	new_moodlet.refresh_moodlet()

