/obj/item/organ
	name = "organ"
	icon = 'icons/obj/surgery.dmi'
	drop_sound = 'sound/items/drop/flesh.ogg'
	default_action_type = /datum/action/item_action/organ
	germ_level = 0

	var/mob/living/carbon/human/owner = null

	//Organ stats.
	var/status = 0
	var/vital //Lose a vital limb, die immediately.
	var/rejecting   // Is this organ already being rejected?
	var/is_augment = FALSE

	//Organ damage stats.
	var/damage = 0 // amount of damage to the organ
	var/min_broken_damage = 30
	var/min_bruised_damage = 10 // Damage before considered bruised
	var/max_damage = 30

	//Strings.
	var/organ_tag = "organ"
	var/parent_organ = BP_CHEST

	//Robot organ stuff.
	var/robotic = 0 //For being a robot
	var/robotize_type		// If set, this organ type will automatically be roboticized with this manufacturer.
	var/robotic_name
	var/robotic_sprite
	var/emp_coeff = 1 //coefficient for damages taken by EMP, if the organ is robotic.

	//Lists.
	var/list/transplant_data
	var/list/datum/autopsy_data/autopsy_data = list()
	var/list/organ_verbs	//verb that are added when you gain the organ
	var/list/trace_chemicals = list() // traces of chemicals in the organ,
									  // links chemical IDs to number of ticks for which they'll stay in the blood

	//DNA stuff.
	var/datum/dna/dna
	var/datum/species/species
	var/force_skintone = FALSE		// If true, icon generation will skip is-robotic checks. Used for synthskin limbs.
	var/list/species_restricted //used by augments and biomods to see what species can have this augment

/obj/item/organ/New(loc, ...)
	..()
	if (!initialized && istype(loc, /mob/living/carbon/human/dummy/mannequin))
		args[1] = TRUE
		SSatoms.InitAtom(src, args)

	if(max_damage)
		min_broken_damage = Floor(max_damage / 2)
	else
		max_damage = min_broken_damage * 2

/obj/item/organ/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	if(!owner)
		return ..()

	if(istype(owner, /mob/living/carbon))
		if(owner.internal_organs)
			owner.internal_organs -= src
		if(istype(owner, /mob/living/carbon/human))
			if(owner.internal_organs_by_name)
				owner.internal_organs_by_name -= src
			if(owner.organs)
				owner.organs -= src
			if(owner.organs_by_name)
				owner.organs_by_name -= src

	owner = null
	QDEL_NULL(dna)

	return ..()

/obj/item/organ/proc/refresh_action_button()
	return action

/obj/item/organ/attack_self(var/mob/user)
	return (owner && loc == owner && owner == user)

/obj/item/organ/proc/update_health()
	return

/obj/item/organ/Initialize(mapload, internal)
	. = ..()
	var/mob/living/carbon/holder = loc
	create_reagents(5)
	if(!max_damage)
		max_damage = min_broken_damage * 2
	if(istype(holder))
		src.owner = holder
		species = all_species["Human"]
		if(holder.dna)
			dna = holder.dna.Clone()
			species = all_species[dna.species]
		else
			log_debug("[src] at [loc] spawned without a proper DNA.")
		var/mob/living/carbon/human/H = holder
		if(istype(H))
			if(internal)
				var/obj/item/organ/external/E = H.get_organ(parent_organ)
				if(E)
					if(E.internal_organs == null)
						E.internal_organs = list()
					E.internal_organs |= src
			if(dna)
				if(!blood_DNA)
					blood_DNA = list()
				blood_DNA[dna.unique_enzymes] = dna.b_type
		if(internal)
			holder.internal_organs |= src

/obj/item/organ/proc/set_dna(var/datum/dna/new_dna)
	if(new_dna)
		dna = new_dna.Clone()
		blood_DNA.Cut()
		blood_DNA[dna.unique_enzymes] = dna.b_type

/obj/item/organ/proc/die()
	if(status & ORGAN_ROBOT)
		return
	damage = max_damage
	status |= ORGAN_DEAD
	STOP_PROCESSING(SSprocessing, src)
	if(owner && vital)
		owner.death()

/obj/item/organ/proc/is_bruised()
	return damage >= min_bruised_damage

/obj/item/organ/proc/bruise()
	damage = max(damage, min_bruised_damage)

/obj/item/organ/proc/can_feel_pain()
	return (!BP_IS_ROBOTIC(src) && (!species || !(species.flags & NO_PAIN)))

/obj/item/organ/proc/can_recover()
	return max_damage > 0

/obj/item/organ/process()

	if(loc != owner)
		owner = null

	if (QDELETED(src))
		log_debug("QDELETED organ [DEBUG_REF(src)] had process() called!")
		STOP_PROCESSING(SSprocessing, src)
		return

	//dead already, no need for more processing
	if(status & ORGAN_DEAD)
		return
	// Don't process if we're in a freezer, an MMI or a stasis bag.or a freezer or something I dunno
	if(istype(loc,/obj/item/device/mmi))
		return
	if(istype(loc,/obj/structure/closet/body_bag/cryobag) || istype(loc,/obj/structure/closet/crate/freezer) || istype(loc,/obj/item/storage/box/freezer))
		return
	//Process infections
	if ((status & ORGAN_ROBOT) || (owner && owner.species && (owner.species.flags & IS_PLANT)))
		germ_level = 0
		return

	if(!owner)
		if (QDELETED(reagents))
			log_debug("Organ [DEBUG_REF(src)] had QDELETED reagents! Regenerating.")
			create_reagents(5)

		var/datum/reagent/blood/B = locate(/datum/reagent/blood) in reagents.reagent_list
		if(B && !(status & ORGAN_ROBOT) && prob(40))
			reagents.remove_reagent("blood",0.1)
			if (isturf(loc))
				blood_splatter(src,B,1)
		if(config.organs_decay) damage += rand(1,3)
		if(damage >= max_damage)
			damage = max_damage
		germ_level += rand(2,6)
		if(germ_level >= INFECTION_LEVEL_TWO)
			germ_level += rand(2,6)
		if(germ_level >= INFECTION_LEVEL_THREE)
			die()


	else if(owner.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
		//** Handle antibiotics and curing infections
		handle_antibiotics()
		handle_rejection()
		handle_germ_effects()

	//check if we've hit max_damage
	if(damage >= max_damage)
		die()

/obj/item/organ/examine(mob/user)
	..(user)
	if(status & ORGAN_DEAD)
		to_chat(user, "<span class='notice'>The decay has set in.</span>")

/obj/item/organ/proc/handle_germ_effects()
	//** Handle the effects of infections
	var/antibiotics = 0
	if(!owner)
		return
	if (CE_ANTIBIOTIC in owner.chem_effects)
		antibiotics = owner.chem_effects[CE_ANTIBIOTIC]

	if (germ_level > 0 && germ_level < INFECTION_LEVEL_ONE/2 && prob(30))
		germ_level--

	if (germ_level >= INFECTION_LEVEL_ONE/2)
		//aiming for germ level to go from ambient to INFECTION_LEVEL_TWO in an average of 15 minutes
		if(antibiotics < 5 && prob(round(germ_level/6)))
			germ_level++

	if(germ_level >= INFECTION_LEVEL_ONE)
		owner.add_chemical_effect(CE_FEVER, germ_level/INFECTION_LEVEL_ONE) //10u of paracetamol minimum for a level 3 infection

	if (germ_level >= INFECTION_LEVEL_TWO)
		var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
		//spread germs
		if (antibiotics < 5 && parent.germ_level < germ_level && ( parent.germ_level < INFECTION_LEVEL_ONE*2 || prob(30) ))
			parent.germ_level++

		if (prob(3))	//about once every 30 seconds
			take_damage(1,silent=prob(30))

/obj/item/organ/proc/handle_rejection()
	// Process unsuitable transplants. TODO: consider some kind of
	// immunosuppressant that changes transplant data to make it match.
	if(dna)
		if(!rejecting)
			if(blood_incompatible(dna.b_type, owner.dna.b_type, species, owner.species))
				rejecting = 1
		else
			rejecting++ //Rejection severity increases over time.
			if(rejecting % 10 == 0) //Only fire every ten rejection ticks.
				switch(rejecting)
					if(1 to 50)
						germ_level++
					if(51 to 200)
						germ_level += rand(1,2)
					if(201 to 500)
						germ_level += rand(2,3)
					if(501 to INFINITY)
						germ_level += rand(3,5)
						owner.reagents.add_reagent("toxin", rand(1,2))

/obj/item/organ/proc/receive_chem(chemical as obj)
	return 0

/obj/item/organ/proc/rejuvenate()
	damage = 0

/obj/item/organ/proc/heal_damage(amount)
	if(can_recover())
		damage = between(0, damage - round(amount, 0.1), max_damage)

/obj/item/organ/proc/is_broken()
	return (damage >= min_broken_damage || (status & ORGAN_CUT_AWAY) || (status & ORGAN_BROKEN))

/obj/item/organ/proc/is_usable()
	return !(status & (ORGAN_CUT_AWAY|ORGAN_MUTATED|ORGAN_DEAD))

//Germs
/obj/item/organ/proc/handle_antibiotics()
	if(!owner)
		return

	var/antibiotics = owner.reagents?.get_reagent_amount("thetamycin")

	if (!germ_level || antibiotics < 5)
		return

	if (germ_level < INFECTION_LEVEL_ONE)
		germ_level = 0	//cure instantly
	else if (germ_level < INFECTION_LEVEL_TWO)
		germ_level -= 6	//at germ_level == 500, this should cure the infection in a minute
	else
		germ_level -= 2 //at germ_level == 1000, this will cure the infection in 5 minutes

//Adds autopsy data for used_weapon.
/obj/item/organ/proc/add_autopsy_data(var/used_weapon, var/damage)
	var/datum/autopsy_data/W = autopsy_data[used_weapon]
	if(!W)
		W = new()
		W.weapon = used_weapon
		autopsy_data[used_weapon] = W

	W.hits += 1
	W.damage += damage
	W.time_inflicted = world.time

//Note: external organs have their own version of this proc
/obj/item/organ/proc/take_damage(amount, var/silent=0)
	if(src.status & ORGAN_ROBOT)
		src.damage = between(0, src.damage + (amount * 0.8), max_damage)
	else
		src.damage = between(0, src.damage + amount, max_damage)

		//only show this if the organ is not robotic
		if(owner && parent_organ && amount > 0)
			var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
			if(parent && !silent)
				owner.custom_pain("Something inside your [parent.name] hurts a lot.", 1)

/obj/item/organ/proc/robotize() //Being used to make robutt hearts, etc
	robotic = 2
	status = ORGAN_ROBOT
	status |= ORGAN_ASSISTED
	if(robotic_name)
		name = robotic_name
	if(robotic_sprite)
		icon_state = robotic_sprite

/obj/item/organ/proc/mechassist() //Used to add things like pacemakers, etc
	robotize()
	status = ORGAN_ASSISTED
	robotic = 1
	if(!robotize_type)
		name = initial(name)
		icon_state = initial(icon_state)

/obj/item/organ/emp_act(severity)
	if(!(status & ORGAN_ASSISTED))
		return

	var/organ_fragility = 0.5

	if((status & ORGAN_ROBOT))	//fully robotic organs take the normal emp damage, assited ones only suffer half of it
		organ_fragility = 1

	switch (severity)
		if (1.0)
			take_damage(rand(7,20) * emp_coeff * organ_fragility)
		if (2.0)
			take_damage(rand(3,7) * emp_coeff * organ_fragility)
		if(3.0)
			take_damage(rand(3) * emp_coeff * organ_fragility)

/obj/item/organ/proc/removed(var/mob/living/carbon/human/target,var/mob/living/user)

	if(!istype(owner))
		return

	action_button_name = null

	owner.internal_organs_by_name[organ_tag] = null
	owner.internal_organs_by_name -= organ_tag
	owner.internal_organs_by_name -= null
	owner.internal_organs -= src

	var/obj/item/organ/external/affected = owner.get_organ(parent_organ)
	if(affected) affected.internal_organs -= src

	loc = get_turf(owner)
	START_PROCESSING(SSprocessing, src)
	rejecting = null
	if (!reagents)
		create_reagents(5)

	var/datum/reagent/blood/organ_blood = locate(/datum/reagent/blood) in reagents.reagent_list
	if(!organ_blood || !organ_blood.data["blood_DNA"])
		owner.vessel.trans_to(src, 5, 1, 1)

	if(owner && vital)
		if(user)
			user.attack_log += "\[[time_stamp()]\]<font color='red'> removed a vital organ ([src]) from [owner.name] ([owner.ckey]) [user ? "(INTENT: [uppertext(user.a_intent)])" : ""]</font>"
			owner.attack_log += "\[[time_stamp()]\]<font color='orange'> had a vital organ ([src]) removed by [user.name] ([user.ckey]) (INTENT: [uppertext(user.a_intent)])</font>"
			msg_admin_attack("[user.name] ([user.ckey]) removed a vital organ ([src]) from [owner.name] ([owner.ckey]) (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(owner))
		owner.death()

	owner.update_action_buttons()
	owner = null

/obj/item/organ/proc/replaced(var/mob/living/carbon/human/target, var/obj/item/organ/external/affected)
	owner = target
	action_button_name = initial(action_button_name)
	forceMove(owner) //just in case
	if(BP_IS_ROBOTIC(src))
		set_dna(owner.dna)
	return 1

/obj/item/organ/internal/eyes/replaced(var/mob/living/carbon/human/target)

	// Apply our eye colour to the target.
	if(istype(target) && eye_colour)
		target.r_eyes = eye_colour[1]
		target.g_eyes = eye_colour[2]
		target.b_eyes = eye_colour[3]
		target.update_eyes()
	..()

/obj/item/organ/attack(var/mob/target, var/mob/user)

	if(robotic || !istype(target) || !istype(user) || (user != target && user.a_intent == I_HELP))
		return ..()

	if(alert("Do you really want to use this organ as food? It will be useless for anything else afterwards.",,"No.","Yes.") == "No.")
		to_chat(user, "<span class='notice'>You successfully repress your cannibalistic tendencies.</span>")
		return

	user.drop_from_inventory(src)
	var/obj/item/reagent_containers/food/snacks/organ/O = new(get_turf(src))
	O.name = name
	O.appearance = src
	reagents.trans_to(O, reagents.total_volume)
	if(fingerprints)
		O.fingerprints = fingerprints.Copy()
	if(fingerprintshidden)
		O.fingerprintshidden = fingerprintshidden.Copy()
	if(fingerprintslast)
		O.fingerprintslast = fingerprintslast
	user.put_in_active_hand(O)
	qdel(src)
	target.attackby(O, user)

//used by stethoscope
/obj/item/organ/proc/listen()
	return
