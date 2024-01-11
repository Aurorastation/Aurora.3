/****************************************************
				EXTERNAL ORGANS
****************************************************/

//These control the damage thresholds for the various ways of removing limbs
#define DROPLIMB_THRESHOLD_EDGE 5
#define DROPLIMB_THRESHOLD_TEAROFF 2
#define DROPLIMB_THRESHOLD_DESTROY 1
#define DROPLIMB_THRESHOLD_DESTROY_PROJECTILE 2

#define FRACTURE_AND_TENDON_DAM_THRESHOLD 30 // if a weapon does more than this amount of damage, it's powerful enough to sever the tendon AND fracture the bone, if it's a sharp weapon

/obj/item/organ/external
	name = "external"
	min_broken_damage = 30
	max_damage = 0
	dir = SOUTH
	organ_tag = "limb"

	var/force_prosthetic_name

	var/icon_name = null
	var/body_part = null
	var/icon_position = 0

	var/damage_state = "00"

	//Damage variables.
	var/brute_mod = 1

	///Actual current brute damage
	var/brute_dam = 0

	///Ratio of current brute damage to max damage
	var/brute_ratio = 0


	var/burn_mod = 1

	///Actual current burn damage
	var/burn_dam = 0

	///Ratio of current burn damage to max damage
	var/burn_ratio = 0

	var/last_dam = -1

	///Amount of current genetic damage
	var/genetic_degradation = 0

	///How much the limb hurts
	var/pain = 0

	///The amount of `pain` at which a limb becomes unusable
	var/pain_disability_threshold

	///Organ behaviour flags, see `ORGAN_CAN_*` and `ORGAN_HAS_*` in `code\__DEFINES\damage_organs.dm`
	var/limb_flags = ORGAN_CAN_AMPUTATE | ORGAN_CAN_BREAK | ORGAN_CAN_MAIM

	var/max_size = 0

	///The `/icon` of the mob that has this organ
	var/icon/mob_icon

	var/gendered_icon = 0
	var/force_icon

	var/limb_name
	var/disfigured = 0

	var/s_tone
	var/skin_color
	var/hair_color

	///A `/list` of wounds
	var/list/datum/wound/wounds = list()

	///A list of implants present in this organ
	var/list/implants = list()

	///Cache the number of wounds, which is NOT wounds.len!
	var/number_wounds = 0

	var/perma_injury = 0

	///The parent organ
	var/obj/item/organ/external/parent

	///A `/list` of organs that have this organ as a parent
	var/list/obj/item/organ/external/children

	///Boolean, if this organ supports childrens, which will be added in `children`
	var/supports_children = TRUE

	///Internal organs of this body part
	var/list/obj/item/organ/internal/internal_organs = list()

	///The tendon
	var/datum/tendon/tendon

	///A path of the type of tendon to create when this organ is created
	var/tendon_path = /datum/tendon

	///Name of the limb's tendon. Achilles heel, etc.
	var/tendon_name = "tendon"

	///HP value of the limb's tendon
	var/tendon_health = 30

	var/list/tendon_msgs = list("tore apart", "ripped away")

	var/damage_msg = "<span class='warning'>You feel an intense pain!</span>"
	var/broken_description
	var/open = 0
	var/stage = 0
	var/cavity = 0

	///Boolean, if it was sabotaged (emagged), make it detonate when it fails
	var/sabotaged = FALSE

	///Needs to be opened with a saw to access the organs
	var/encased

	///Descriptive string used in dislocation
	var/joint = "joint"

	///Name of the artery. Cartoid, etc.
	var/artery_name = "artery"

	///Multiplier for bleeding in a limb
	var/arterial_bleed_severity = 1

	///Descriptive string used in amputation
	var/amputation_point

	///If the joint is dislocated
	var/dislocated = FALSE

	///How often wounds should be updated, a higher number means less often
	var/wound_update_accuracy = 1
	var/body_hair
	var/painted = 0

	///For special projectile gibbing calculation, dubbed "maiming"
	var/maim_bonus = 0

	///Markings (body_markings) to apply to the icon
	var/list/genetic_markings

	///Same as `genetic_markings`, but not preserved when cloning
	var/list/temporary_markings

	///The `genetic_markings` and `temporary_markings` cached for perf. reasons
	var/list/cached_markings

	var/list/image/additional_images

	///Pressure applied to wounds. It'll make them bleed less, generally.
	var/atom/movable/applied_pressure

	var/image/hud_damage_image

	///How many augments you can fit inside this limb
	var/augment_limit

	var/obj/item/organ/internal/infect_target_internal //make internal organs become infected one at a time instead of all at once
	var/obj/item/organ/external/infect_target_external //make child and parent organs become infected one at a time instead of all at once

	///Dionae limb
	var/mob/living/carbon/alien/diona/nymph

	var/nymph_child

/obj/item/organ/external/proc/invalidate_marking_cache()
	cached_markings = null

/obj/item/organ/external/Destroy()
	if(parent?.children)
		parent.children -= src

	if(istype(owner) && owner.bad_external_organs)
		owner.bad_external_organs -= src

	if(limb_name && istype(owner, /mob/living/carbon) && owner.organs_by_name)
		owner.organs_by_name[limb_name] = null
		owner.organs_by_name -= limb_name

	parent = null

	//Remove the images from the owner and clear them
	if(istype(owner))
		cut_additional_images(owner)
	additional_images = null

	genetic_markings = null
	temporary_markings = null
	cached_markings = null
	mob_icon = null

	QDEL_NULL_LIST(children)
	QDEL_NULL_LIST(internal_organs)
	QDEL_NULL_LIST(wounds)
	QDEL_NULL_LIST(implants)

	infect_target_internal = null
	infect_target_external = null

	applied_pressure = null

	QDEL_NULL(nymph)

	QDEL_NULL(tendon)

	. = ..()


/obj/item/organ/external/attack_self(var/mob/user)
	if(!contents.len)
		return ..()
	var/list/removable_objects = list()
	for(var/obj/item/organ/external/E in (contents + src))
		if(!istype(E))
			continue
		for(var/obj/item/I in E.contents)
			if(istype(I,/obj/item/organ))
				continue
			removable_objects |= I
	if(removable_objects.len)
		var/obj/item/I = pick(removable_objects)
		I.forceMove(get_turf(user)) //just in case something was embedded that is not an item
		if(istype(I))
			if(!(user.l_hand && user.r_hand))
				user.put_in_hands(I)
		user.visible_message("<span class='danger'>\The [user] rips \the [I] out of \the [src]!</span>")
		return //no eating the limb until everything's been removed
	return ..()

/obj/item/organ/external/examine(mob/user, distance, is_adjacent)
	. = ..()
	if(distance <= 1)
		for(var/obj/item/I in contents)
			if(istype(I, /obj/item/organ))
				continue
			to_chat(usr, "<span class='danger'>There is \a [I] sticking out of it.</span>")
	return

/obj/item/organ/external/attackby(obj/item/W as obj, mob/user as mob)
	switch(stage)
		if(0)
			if(istype(W,/obj/item/surgery/scalpel))
				user.visible_message("<span class='danger'><b>[user]</b> cuts [src] open with [W]!</span>")
				stage++
				return
		if(1)
			if(istype(W,/obj/item/surgery/retractor))
				user.visible_message("<span class='danger'><b>[user]</b> cracks [src] open like an egg with [W]!</span>")
				stage++
				return
		if(2)
			if(istype(W,/obj/item/surgery/hemostat))
				if(contents.len)
					var/obj/item/removing = pick(contents)
					removing.forceMove(get_turf(user.loc))
					if(!(user.l_hand && user.r_hand))
						user.put_in_hands(removing)
					user.visible_message("<span class='danger'><b>[user]</b> extracts [removing] from [src] with [W]!</span>")
				else
					user.visible_message("<span class='danger'><b>[user]</b> fishes around fruitlessly in [src] with [W].</span>")
				return
	..()

/obj/item/organ/external/proc/dislocate(var/primary)
	if(dislocated == -1)
		return
	if(primary)
		dislocated = 2
	else
		dislocated = 1
	add_verb(owner, /mob/living/carbon/human/proc/undislocate)
	if(children && children.len)
		for(var/obj/item/organ/external/child in children)
			child.dislocate()

/obj/item/organ/external/proc/undislocate()
	if(dislocated == -1)
		return

	dislocated = 0
	if(children && children.len)
		for(var/obj/item/organ/external/child in children)
			if(child.dislocated == 1)
				child.undislocate()
	if(owner)
		owner.shock_stage += 20
		for(var/obj/item/organ/external/limb in owner.organs)
			if(limb.dislocated == 2)
				return
		remove_verb(owner, /mob/living/carbon/human/proc/undislocate)

/obj/item/organ/external/update_health()
	damage = min(max_damage, (brute_dam + burn_dam))
	return

/obj/item/organ/external/Initialize(mapload)
	if(robotize_type)
		robotize(robotize_type)
		drop_sound = 'sound/items/drop/prosthetic.ogg'
		pickup_sound = 'sound/items/pickup/prosthetic.ogg'

	. = ..(mapload, FALSE)
	if(isnull(pain_disability_threshold))
		pain_disability_threshold = (max_damage * 0.75)
	if(owner)
		replaced(owner)
		sync_colour_to_human(owner)

	if ((status & ORGAN_PLANT))
		limb_flags &= ~ORGAN_CAN_BREAK

	get_icon()

	if((limb_flags & ORGAN_HAS_TENDON) && !BP_IS_ROBOTIC(src) && tendon_path)
		tendon = new tendon_path(src, tendon_name, tendon_health, tendon_msgs)
	else if(limb_flags & ORGAN_HAS_TENDON)
		limb_flags &= ~ORGAN_HAS_TENDON

/obj/item/organ/external/replaced(var/mob/living/carbon/human/target)
	..()
	if(istype(owner))
		owner.organs_by_name[limb_name] = src
		owner.organs |= src
		for(var/obj/item/organ/organ in src)
			organ.replaced(owner,src)

	if(!parent && parent_organ)
		parent = owner.organs_by_name[src.parent_organ]
		if(parent)
			if(!parent.children)
				parent.children = list()
			parent.children.Add(src)
			//Remove all stump wounds since limb is not missing anymore
			for(var/datum/wound/lost_limb/W in parent.wounds)
				parent.wounds -= W
				qdel(W)
				break
			parent.update_damages()

	action_button_name = initial(action_button_name)
	owner.update_action_buttons()

/****************************************************
					DAMAGE PROCS
****************************************************/

/obj/item/organ/external/proc/is_damageable(var/additional_damage = 0)
	//Continued damage to vital organs can kill you, and robot organs don't count towards total damage so no need to cap them.
	return (BP_IS_ROBOTIC(src) || brute_dam + burn_dam + additional_damage < max_damage * 4)

/obj/item/organ/external/take_damage(brute, burn, damage_flags, used_weapon = null, list/forbidden_limbs = list(), var/silent)
	if((brute <= 0) && (burn <= 0))
		return 0

	brute *= brute_mod
	burn *= burn_mod

	var/laser = (damage_flags & DAMAGE_FLAG_LASER)
	var/sharp = (damage_flags & DAMAGE_FLAG_SHARP)
	var/edge = (damage_flags & DAMAGE_FLAG_EDGE)
	var/psionic = HAS_FLAG(damage_flags, DAMAGE_FLAG_PSIONIC)
	var/blunt = !!(brute && !sharp && !edge)

	/// Psionics and psionically deaf species take varying amounts of damage from psionic abilities.
	if(psionic)
		if(!owner.has_psionics())
			brute *= 0.9
			burn *= 0.9
		else if(owner.psi)
			var/psi_rank = owner.psi.get_rank()
			if(psi_rank == PSI_RANK_SENSITIVE)
				brute *= 1.05
				burn *= 1.05
			else if(psi_rank == PSI_RANK_HARMONIOUS)
				brute *= 1.1
				burn *= 1.1
			else if(psi_rank == PSI_RANK_APEX)
				brute *= 1.2
				burn *= 1.2

	if(status & ORGAN_BROKEN && prob(40) && brute)
		if(owner && (owner.can_feel_pain()) && owner.stat == CONSCIOUS)
			owner.emote(pick("scream", "groan"))	//getting hit on broken hand hurts

	if(used_weapon)
		add_autopsy_data("[used_weapon]", brute + burn)

	var/spillover = 0
	if(!is_damageable(brute + burn))
		spillover = brute_dam + burn_dam + brute - max_damage
		if(spillover > 0)
			brute = max(brute - spillover, 0)
		else
			spillover = brute_dam + burn_dam + brute + burn - max_damage
			if(spillover > 0)
				burn = max(burn - spillover, 0)

	handle_limb_gibbing(used_weapon, brute, burn)

	if(brute_dam + brute > min_broken_damage && prob(brute_dam + brute * (1 + blunt)))
		if(blunt || brute > FRACTURE_AND_TENDON_DAM_THRESHOLD)
			fracture()

	// High brute damage or sharp objects may damage internal organs
	if(length(internal_organs))
		if(damage_internal_organs(brute, burn, damage_flags))
			brute /= 2
			burn /= 2

	var/can_cut = !BP_IS_ROBOTIC(src) && (sharp || prob(brute))
	if(brute)
		var/to_create = BRUISE
		if(can_cut)
			to_create = CUT
			//need to check sharp again here so that blunt damage that was strong enough to break skin doesn't give puncture wounds
			if(sharp && !edge)
				to_create = PIERCE
		createwound(to_create, brute)

	if(burn)
		if(laser)
			createwound(LASER, burn)
		else
			createwound(DAMAGE_BURN, burn)

	add_pain(0.6 * burn + 0.4 * brute)

	//If there are still hurties to dispense
	if (spillover)
		owner.shock_stage += spillover * GLOB.config.organ_damage_spillover_multiplier

	// sync the organ's damage with its wounds
	update_damages()
	if(owner)
		owner.updatehealth() //droplimb will call updatehealth() again if it does end up being called
	if(status & ORGAN_BLEEDING)
		owner.update_bandages()

	return update_icon()

/obj/item/organ/external/proc/damage_internal_organs(brute, burn, damage_flags)
	if(!length(internal_organs))
		return FALSE

	var/damage_amt = brute
	var/cur_damage = brute_dam
	var/sharp = (damage_flags & DAMAGE_FLAG_SHARP)
	var/laser = (damage_flags & DAMAGE_FLAG_LASER)

	if(BP_IS_ROBOTIC(src) || laser)
		damage_amt += burn
		cur_damage += burn_dam

	if(!damage_amt)
		return FALSE

	var/organ_damage_threshold = 10
	if(sharp)
		organ_damage_threshold *= 0.5
	if(laser)
		organ_damage_threshold *= 1.25

	if(!(cur_damage + damage_amt >= max_damage) && !(damage_amt >= organ_damage_threshold))
		return FALSE

	var/list/victims = list()
	var/organ_hit_chance = 0
	for(var/obj/item/organ/internal/I in internal_organs)
		if(I.damage < I.max_damage)
			victims[I] = I.relative_size
			organ_hit_chance += I.relative_size

	//No damageable organs
	if(!length(victims))
		return FALSE

	organ_hit_chance += 5 * damage_amt / organ_damage_threshold

	if(encased && !(status & ORGAN_BROKEN)) //ribs protect
		organ_hit_chance *= 0.2

	organ_hit_chance = min(organ_hit_chance, 100)
	if(prob(organ_hit_chance))
		var/obj/item/organ/internal/victim = pickweight(victims)
		damage_amt -= max(damage_amt*victim.damage_reduction, 0)
		victim.take_internal_damage(damage_amt)
		return TRUE

/obj/item/organ/external/proc/handle_limb_gibbing(var/used_weapon, var/brute, var/burn)
	//If limb took enough damage, try to cut or tear it off
	if(owner && loc == owner && !is_stump())
		if((limb_flags & ORGAN_CAN_AMPUTATE) && GLOB.config.limbs_can_break)

			if((brute_dam + burn_dam) >= (max_damage * GLOB.config.organ_health_multiplier))

				var/edge_eligible = FALSE
				var/blunt_eligible = FALSE
				var/maim_bonus = 0
				var/dam_flags = 0

				if(isitem(used_weapon))
					var/obj/item/W = used_weapon
					dam_flags = W.damage_flags()
					if(isprojectile(W))
						var/obj/item/projectile/P = W
						if(dam_flags & DAMAGE_FLAG_BULLET)
							blunt_eligible = TRUE
						maim_bonus += P.maim_rate
					if(W.w_class >= w_class && (dam_flags & DAMAGE_FLAG_EDGE))
						edge_eligible = TRUE

				if(!blunt_eligible && edge_eligible && (brute >= max_damage / (DROPLIMB_THRESHOLD_EDGE + maim_bonus)))
					droplimb(0, DROPLIMB_EDGE)
				else if(burn >= max_damage / ((dam_flags & DAMAGE_FLAG_LASER ? DROPLIMB_THRESHOLD_DESTROY_PROJECTILE :  DROPLIMB_THRESHOLD_DESTROY) + maim_bonus))
					droplimb(0, DROPLIMB_BURN)
				else if(blunt_eligible && brute >= max_damage / ((dam_flags & DAMAGE_FLAG_BULLET ? DROPLIMB_THRESHOLD_DESTROY_PROJECTILE :  DROPLIMB_THRESHOLD_DESTROY) + maim_bonus))
					droplimb(0, DROPLIMB_BLUNT)
				else if(brute >= max_damage / (DROPLIMB_THRESHOLD_TEAROFF + maim_bonus))
					droplimb(0, DROPLIMB_EDGE)

/obj/item/organ/external/heal_damage(brute, burn, internal = 0, robo_repair = 0)
	if(status & ORGAN_ROBOT && !robo_repair)
		return

	//Heal damage on the individual wounds
	for(var/datum/wound/W in wounds)
		if(brute == 0 && burn == 0)
			break

		// heal brute damage
		if(W.damage_type == DAMAGE_BURN)
			burn = W.heal_damage(burn)
		else
			brute = W.heal_damage(brute)

	if(internal)
		status &= ~ORGAN_BROKEN
		perma_injury = 0

	//Sync the organ's damage with its wounds
	update_damages()
	owner.updatehealth()

	return update_icon()

/*
This function completely restores a damaged organ to perfect condition.
*/
/obj/item/organ/external/rejuvenate()
	damage_state = "00"
	status &= ~ORGAN_DAMAGE_STATES
	perma_injury = 0
	brute_dam = 0
	burn_dam = 0
	germ_level = 0
	wounds.Cut()
	number_wounds = 0

	// handle internal organs
	for(var/obj/item/organ/current_organ in internal_organs)
		current_organ.rejuvenate()

	// remove embedded objects and drop them on the floor
	for(var/obj/implanted_object in implants)
		if(!istype(implanted_object,/obj/item/implant))	// We don't want to remove REAL implants. Just shrapnel etc.
			implanted_object.forceMove(owner.loc)
			implants -= implanted_object

	if(istype(tendon))
		tendon.rejuvenate()

	owner.updatehealth()


/obj/item/organ/external/proc/createwound(var/type = CUT, var/damage)
	if(damage <= 0 || !owner)
		return

	//moved this before the open_wound check so that having many small wounds for example doesn't somehow protect you from taking internal damage (because of the return)
	//Possibly trigger an internal wound, too.
	var/local_damage = brute_dam + burn_dam + damage

	if(damage > (min_broken_damage / 2) && local_damage > min_broken_damage && !(status & ORGAN_ROBOT))
		if(!(type in list(DAMAGE_BURN, LASER)))
			if(prob(damage) && sever_artery())
				owner.custom_pain("You feel something rip in your [name]!", 25)

		if(istype(tendon) && type == CUT)
			var/new_brute = damage
			if(min_broken_damage - brute_dam > 0)
				// Only pass on damage that goes over the broken threshold
				new_brute = brute_dam + damage - min_broken_damage
			tendon.damage(new_brute)

	//Burn damage can cause fluid loss due to blistering and cook-off
	if((type in list(DAMAGE_BURN, LASER)) && (damage > 5 || damage + burn_dam >= 15) && !BP_IS_ROBOTIC(src))
		var/fluid_loss_severity
		switch(type)
			if(DAMAGE_BURN)
				fluid_loss_severity = FLUIDLOSS_WIDE_BURN
			if(LASER)
				fluid_loss_severity = FLUIDLOSS_CONC_BURN
		var/fluid_loss = (damage/(owner.maxHealth - GLOB.config.health_threshold_dead)) * DEFAULT_BLOOD_AMOUNT * fluid_loss_severity
		owner.remove_blood_simple(fluid_loss)

	// first check whether we can widen an existing wound
	if(wounds.len > 0 && prob(max(50+(number_wounds-1)*10,90)))
		if((type == CUT || type == BRUISE) && damage >= 5)
			//we need to make sure that the wound we are going to worsen is compatible with the type of damage...
			var/list/compatible_wounds = list()
			for (var/datum/wound/W in wounds)
				if (W.can_worsen(type, damage))
					compatible_wounds += W

			if(compatible_wounds.len)
				var/datum/wound/W = pick(compatible_wounds)
				W.open_wound(damage)
				if(prob(25))
					if(status & ORGAN_ROBOT)
						owner.visible_message("<span class='warning'>The damage to [owner.name]'s [name] worsens.</span>",\
						"<span class='warning'>The damage to your [name] worsens.</span>",\
						"You hear the screech of abused metal.")
					else
						owner.visible_message("<span class='warning'>The wound on [owner.name]'s [name] widens with a nasty ripping noise.</span>",\
						"<span class='warning'>The wound on your [name] widens with a nasty ripping noise.</span>",\
						"You hear a nasty ripping noise, as if flesh is being torn apart.")
				return

	//Creating wound
	var/wound_type = get_wound_type(type, damage)

	if(wound_type)
		var/datum/wound/W = new wound_type(damage)

		//Check whether we can add the wound to an existing wound
		for(var/datum/wound/other in wounds)
			if(other.can_merge(W))
				other.merge_wound(W)
				W = null // to signify that the wound was added
				break
		if(W)
			wounds += W

/****************************************************
				PROCESSING & UPDATING
****************************************************/

//external organs handle brokenness a bit differently when it comes to damage. Instead brute_dam is checked inside process()
//this also ensures that an external organ cannot be "broken" without broken_description being set.
/obj/item/organ/external/is_broken()
	if(status & ORGAN_CUT_AWAY)
		return TRUE
	if((status & ORGAN_BROKEN) && !(status & ORGAN_SPLINTED))
		for(var/obj/item/organ/internal/augment/aug in internal_organs)
			if(aug.supports_limb)
				if(aug.is_broken())
					continue
				if(aug.is_bruised() && prob(60))
					continue
				return FALSE
		return TRUE
	return FALSE

//Determines if we even need to process this organ.
/obj/item/organ/external/proc/need_process()
	if((status & ORGAN_ASSISTED) && surge_damage)
		return TRUE
	if(BP_IS_ROBOTIC(src))
		return FALSE
	if(get_pain())
		return TRUE
	if(status & (ORGAN_CUT_AWAY|ORGAN_BLEEDING|ORGAN_BROKEN|ORGAN_DESTROYED|ORGAN_SPLINTED|ORGAN_DEAD|ORGAN_MUTATED))
		return TRUE
	if(brute_dam || burn_dam)
		return TRUE
	if(last_dam != brute_dam + burn_dam) // Process when we are fully healed up.
		last_dam = brute_dam + burn_dam
		return TRUE
	else
		last_dam = brute_dam + burn_dam
	if(germ_level)
		return TRUE
	return FALSE

/obj/item/organ/external/process()
	if(owner)
		// Process wounds, doing healing etc. Only do this every few ticks to save processing power
		if(owner.life_tick % wound_update_accuracy == 0)
			update_wounds()

		//Chem traces slowly vanish
		if(owner.life_tick % 10 == 0)
			for(var/chemID in trace_chemicals)
				trace_chemicals[chemID] = trace_chemicals[chemID] - 1
				if(trace_chemicals[chemID] <= 0)
					trace_chemicals.Remove(chemID)

		if(!(status & ORGAN_BROKEN))
			perma_injury = 0

		if(status & ORGAN_NYMPH)
			var/datum/component/nymph_limb/N = GetComponent(/datum/component/nymph_limb)
			N.handle_nymph(src)

		if(surge_damage && (status & ORGAN_ASSISTED))
			tick_surge_damage() //Yes, this being here is intentional since this proc does not call ..() unless the owner is null.

		//Infections
		update_germs()

		//check if an online RIG can splint the broken bone
		check_rigsplints()
	else
		..()

/obj/item/organ/external/do_surge_effects()
	if(prob(surge_damage))
		owner.custom_pain("The artificial nerves in your [name] scream out in pain!", surge_damage/6)

/obj/item/organ/external/proc/check_rigsplints()
	if((status & ORGAN_BROKEN) && !(status & ORGAN_SPLINTED))
		if(istype(owner,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = owner
			if(H.back && istype(H.back, /obj/item/rig))
				var/obj/item/rig/R = H.back
				if(R.offline)
					return
			if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
				var/obj/item/clothing/suit/space/suit = H.wear_suit
				if(isnull(suit.supporting_limbs))
					return
				to_chat(owner, SPAN_WARNING("You feel \the [suit] constrict about your [name], supporting it."))
				status |= ORGAN_SPLINTED
				suit.supporting_limbs |= src
				owner.update_hud_hands()

//Updating germ levels. Handles organ germ levels and necrosis.
/*
The INFECTION_LEVEL values defined in setup.dm control the time it takes to reach the different
infection levels. Since infection growth is exponential, you can adjust the time it takes to get
from one germ_level to another using the rough formula:

desired_germ_level = initial_germ_level*e^(desired_time_in_seconds/1000)

So if I wanted it to take an average of 15 minutes to get from level one (100) to level two
I would set INFECTION_LEVEL_TWO to 100*e^(15*60/1000) = 245. Note that this is the average time,
the actual time is dependent on RNG.

INFECTION_LEVEL_ONE		below this germ level nothing happens, and the infection doesn't grow
INFECTION_LEVEL_TWO		above this germ level the infection will start to spread to internal and adjacent organs
INFECTION_LEVEL_THREE	above this germ level the player will take additional toxin damage per second, and will die in minutes without
						antitox. also, above this germ level you will need to overdose on thetamycin to reduce the germ_level.

Note that amputating the affected organ does in fact remove the infection from the player's body.
*/
/obj/item/organ/external/proc/update_germs()

	if(status & (ORGAN_ROBOT) || (owner.species && owner.species.flags & NO_BLOOD)) //Robotic limbs shouldn't be infected, nor should nonexistant limbs, or bloodless species.
		germ_level = 0
		return

	if(germ_level <= 0) //Catch any weirdness that might happen with negative values
		germ_level = 0

	if(owner.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
		//** Syncing germ levels with external wounds
		handle_germ_sync()

		//** Handle antibiotics and curing infections
		handle_antibiotics()

		//** Handle the effects of infections
		handle_germ_effects()

/obj/item/organ/external/proc/handle_germ_sync()
	var/antibiotics = 0
	if(CE_ANTIBIOTIC in owner.chem_effects)
		antibiotics = owner.chem_effects[CE_ANTIBIOTIC]
	for(var/datum/wound/W in wounds)
		//Open wounds can become infected
		if (owner.germ_level > W.germ_level && W.infection_check())
			W.germ_level++

	if(antibiotics < 5)
		for(var/datum/wound/W in wounds)
			//Infected wounds raise the organ's germ level
			if (W.germ_level > germ_level && W.infection_check())
				germ_level++
				break	//limit increase to a maximum of one per second

/obj/item/organ/external/proc/get_infect_target(var/list/infect_candidates = list())
	var/obj/item/organ/temp_target
	shuffle(infect_candidates) //Slightly randomizes since if all germ levels are zero, it'll always be the first pick of the list

	//figure out which organs we can spread germs to
	for (var/obj/item/organ/I in infect_candidates)
		if(I.germ_level < min(germ_level, INFECTION_LEVEL_TWO)) //Only choose organs that have less germs than us AND are below level two
			//The below will always be the organ with the highest germ level. It picks a temp_target first then cycles through to find which, if any, has more germs.
			if(!temp_target || I.germ_level > temp_target.germ_level)
				temp_target = I //This will always be the organ with the highest germ level

	return temp_target

/obj/item/organ/external/handle_germ_effects()

	var/antibiotics = 0
	if(CE_ANTIBIOTIC in owner.chem_effects)
		antibiotics = owner.chem_effects[CE_ANTIBIOTIC]

	if(germ_level < INFECTION_LEVEL_TWO)
		//null out the infect targets since at this point we're not in danger of spreading our infection.
		infect_target_internal = null
		infect_target_external = null
		return ..()

	germ_level++

	if(germ_level >= INFECTION_LEVEL_TWO && REAGENT_VOLUME(owner.reagents, /singleton/reagent/thetamycin) < 5) //The presence of 5 units of thetamycin will stop infections spreading
		//SPREADING TO INTERNAL ORGANS
		if(isnull(infect_target_internal) || QDELETED(infect_target_internal))
			infect_target_internal = get_infect_target(internal_organs)

		else
			if(prob(25) || !infect_target_internal.is_infected()) //Increase steadily until infection_level_one, then only bump the germ level now and then
				infect_target_internal.germ_level++ //slowly increase the infection level
			//Check to see if the other organ is as infected or more infected than us. If so, we need to get a new target on the next process
			if(infect_target_internal.germ_level >= min(germ_level, INFECTION_LEVEL_TWO))
				infect_target_internal = null

		//SPREADING TO CHILD AND PARENT EXTERNAL ORGANS
		if(isnull(infect_target_external) || QDELETED(infect_target_internal))
			var/list/temp_targets = list()
			if(children)
				for (var/obj/item/organ/external/child in children)
					if (child.germ_level < germ_level && !(child.status & ORGAN_ROBOT))
						temp_targets += child

			if(parent)
				if(parent.germ_level < germ_level && !(parent.status & ORGAN_ROBOT))
					temp_targets += parent
			if(length(temp_targets))
				infect_target_external = get_infect_target(temp_targets)

		else
			if(prob(25) || !infect_target_external.is_infected()) //Increase steadily until sufficiently infected, then only bump the germ level now and then
				infect_target_external.germ_level++ //slowly increase the infection level
			//Check to see if the other organ is as infected or more infected than us. If so, we need to get a new target on the next process
			if(infect_target_external.germ_level >= min(germ_level, INFECTION_LEVEL_TWO))
				infect_target_external = null

	if(germ_level >= INFECTION_LEVEL_THREE && antibiotics < 20)	//overdosing is necessary to stop severe infections
		if (!(status & ORGAN_DEAD))
			status |= ORGAN_DEAD
			to_chat(owner, "<span class='notice'>You can't feel your [name] anymore...</span>")
			owner.update_body(1)

		germ_level++
		owner.adjustToxLoss(1)

/obj/item/organ/external/proc/body_part_class()
	return null

/obj/item/organ/external/proc/covered_bleed_report(var/blood_type)
	return "[owner.get_pronoun("has")] [blood_type] soaking through the clothes on their [src]!"

//Updating wounds. Handles wound natural I had some free spachealing, internal bleedings and infections
/obj/item/organ/external/proc/update_wounds()

	if((status & ORGAN_ROBOT) || (status & ORGAN_ADV_ROBOT) || (status & ORGAN_PLANT)) //Robotic limbs don't heal or get worse. Diona limbs heal using their own mechanic
		return
	var/updatehud
	for(var/datum/wound/W in wounds)
		// wounds can disappear after 10 minutes at the earliest
		if(W.damage <= 0 && W.created + 6000 <= world.time)
			wounds -= W
			continue
			// let the GC handle the deletion of the wound

		if (W.damage > 0)
			updatehud = 1//If there are any wounds with damage to heal, then we'll update health huds

		// slow healing
		var/heal_amt = 0

		// if damage >= 50 AFTER treatment then it's probably too severe to heal within the timeframe of a round.
		if (W.can_autoheal() && W.wound_damage() < 50)
			heal_amt += 0.5

		//we only update wounds once in [wound_update_accuracy] ticks so have to emulate realtime
		heal_amt = heal_amt * wound_update_accuracy
		//configurable regen speed woo, no-regen hardcore or instaheal hugbox, choose your destiny
		heal_amt = heal_amt * GLOB.config.organ_regeneration_multiplier
		// amount of healing is spread over all the wounds
		heal_amt = heal_amt / (wounds.len + 1)
		// making it look prettier on scanners
		heal_amt = round(heal_amt,0.1)
		W.heal_damage(heal_amt)

		// Salving also helps against infection
		if(W.germ_level > 0 && W.salved && prob(2))
			W.disinfected = 1
			W.germ_level = 0

	// sync the organ's damage with its wounds
	src.update_damages()
	if (updatehud)
		owner.hud_updateflag = 1022

	if(update_icon())
		owner.UpdateDamageIcon(1)

//Updates brute_damn and burn_damn from wound damages. Updates BLEEDING status.
/obj/item/organ/external/proc/update_damages()
	number_wounds = 0
	brute_dam = 0
	burn_dam = 0
	var/cut_dam = 0
	status &= ~ORGAN_BLEEDING
	var/clamped = 0

	var/mob/living/carbon/human/H
	if(istype(owner,/mob/living/carbon/human))
		H = owner

	//update damage counts
	for(var/datum/wound/W in wounds)
		if(W.damage_type == DAMAGE_BURN)
			burn_dam += W.damage
		else
			brute_dam += W.damage
			if(W.damage_type == CUT)
				cut_dam += W.damage

		if(!(status & ORGAN_ROBOT) && W.bleeding() && (H && !(H.species.flags & NO_BLOOD)))
			W.bleed_timer--
			status |= ORGAN_BLEEDING

		clamped |= W.clamped

		number_wounds += W.amount

	//things tend to bleed if they are CUT OPEN
	if (open && !clamped && (H && !(H.species.flags & NO_BLOOD) && !(status & ORGAN_ROBOT)))
		status |= ORGAN_BLEEDING

	if (istype(tendon))
		tendon.update_damage(cut_dam - min_broken_damage)

	update_damage_ratios()

/obj/item/organ/external/proc/update_damage_ratios()
	var/limb_loss_threshold = max_damage
	brute_ratio = brute_dam / (limb_loss_threshold * 2)
	burn_ratio = burn_dam / (limb_loss_threshold * 2)

// new damage icon system
// adjusted to set damage_state to brute/burn code only (without r_name0 as before)
/obj/item/organ/external/update_icon()
	var/n_is = damage_state_text()
	if (n_is != damage_state)
		damage_state = n_is
		return 1
	return 0

// new damage icon system
// returns just the brute/burn damage code
/obj/item/organ/external/proc/damage_state_text()

	var/tburn = 0
	var/tbrute = 0

	if(burn_dam ==0)
		tburn =0
	else if (burn_dam < (max_damage * 0.25 / 2))
		tburn = 1
	else if (burn_dam < (max_damage * 0.75 / 2))
		tburn = 2
	else
		tburn = 3

	if (brute_dam == 0)
		tbrute = 0
	else if (brute_dam < (max_damage * 0.25 / 2))
		tbrute = 1
	else if (brute_dam < (max_damage * 0.75 / 2))
		tbrute = 2
	else
		tbrute = 3
	return "[tbrute][tburn]"

/****************************************************
					DISMEMBERMENT
****************************************************/

/obj/item/organ/external/proc/post_droplimb(mob/living/carbon/human/victim)
	victim.updatehealth()
	victim.UpdateDamageIcon()
	victim.regenerate_icons()
	dir = 2

//Handles dismemberment
/obj/item/organ/external/proc/droplimb(var/clean, var/disintegrate = DROPLIMB_EDGE, var/ignore_children = null)
	if(!(limb_flags & ORGAN_CAN_AMPUTATE) || !owner)
		return

	switch(disintegrate)
		if(DROPLIMB_EDGE)
			if(!clean)
				var/gore_sound = "[(status & ORGAN_ROBOT) ? "tortured metal" : "ripping tendons and flesh"]"
				owner.visible_message(
					"<span class='danger'>\The [owner]'s [src.name] flies off in an arc!</span>",\
					"<span class='moderate'><b><font size=2>Your [src.name] goes flying off!</font></b></span>",\
					"<span class='danger'>You hear the terrible sound of [gore_sound].</span>")
		if(DROPLIMB_BURN)
			var/gore = "[(status & ORGAN_ROBOT) ? "": " of burning flesh"]"
			owner.visible_message(
				"<span class='danger'>\The [owner]'s [src.name] flashes away into ashes!</span>",\
				"<span class='moderate'><b><font size=2>Your [src.name] flashes away into ashes!</font></b></span>",\
				"<span class='danger'>You hear the crackling sound[gore].</span>")
		if(DROPLIMB_BLUNT)
			var/gore = "[(status & ORGAN_ROBOT) ? "": " in a shower of gore"]"
			var/gore_sound = "[(status & ORGAN_ROBOT) ? "rending sound of tortured metal" : "sickening splatter of gore"]"
			owner.visible_message(
				"<span class='danger'>\The [owner]'s [src.name] explodes[gore]!</span>",\
				"<span class='moderate'><b><font size=3>Your [src.name] explodes[gore]!</font></b></span>",\
				"<span class='danger'>You hear the [gore_sound].</span>")

	var/mob/living/carbon/human/victim = owner //Keep a reference for post-removed().
	var/obj/item/organ/external/parent_organ = parent

	if(!clean)
		victim.shock_stage += min_broken_damage
		victim.flash_strong_pain()

	var/mob/living/carbon/human/last_owner = owner
	removed(null, ignore_children)
	if(istype(last_owner) && !QDELETED(last_owner) && length(last_owner.organs) <= 1)
		last_owner.drop_all_limbs(disintegrate) // drops the last remaining part, usually the torso, as an item

	if(parent_organ)
		var/datum/wound/lost_limb/W = new(src, disintegrate, clean)
		if(clean)
			parent_organ.wounds |= W
			parent_organ.update_damages()
		else
			var/obj/item/organ/external/stump/stump = new(victim, 0, src)
			if(status & ORGAN_ROBOT)
				stump.robotize()
			stump.wounds |= W
			victim.organs |= stump
			stump.update_damages()

	post_droplimb(victim)

	switch(disintegrate)
		if(DROPLIMB_EDGE)
			// compile_icon() used to be here, but it's causing issues, so RIP.
			add_blood(victim)
			var/matrix/M = matrix()
			M.Turn(rand(180))
			src.transform = M
			if(!clean)
				//Throw limb around.
				if(src && isturf(loc))
					INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, throw_at), get_edge_target_turf(src,pick(GLOB.alldirs)), rand(1,3), 4)
				dir = 2
		if(DROPLIMB_BURN)
			new /obj/effect/decal/cleanable/ash(get_turf(victim))
			for(var/obj/item/I in src)
				if(I.w_class > 2 && !istype(I,/obj/item/organ))
					I.forceMove(get_turf(src))
			qdel(src)
		if(DROPLIMB_BLUNT)
			var/obj/effect/decal/cleanable/blood/gibs/gore = new victim.species.single_gib_type(get_turf(victim))
			if(victim.species.flesh_color)
				gore.fleshcolor = victim.species.flesh_color
			if(victim.species.blood_color)
				gore.basecolor = victim.species.blood_color
			gore.update_icon()
			INVOKE_ASYNC(gore, TYPE_PROC_REF(/atom/movable, throw_at), get_edge_target_turf(src, pick(GLOB.alldirs)), rand(1,3), 4)

			for(var/obj/item/organ/I in internal_organs)
				I.removed()
				if(istype(loc,/turf))
					INVOKE_ASYNC(I, TYPE_PROC_REF(/atom/movable, throw_at), get_edge_target_turf(src, pick(GLOB.alldirs)), rand(1,3), 4)

			var/turf/Tloc = get_turf(src)
			for(var/obj/item/I in src)
				if(I.w_class <= 2)
					qdel(I)
					continue
				I.forceMove(Tloc)
				INVOKE_ASYNC(I, TYPE_PROC_REF(/atom/movable, throw_at), get_edge_target_turf(src, pick(GLOB.alldirs)), rand(1,3), 4)

			qdel(src)

/****************************************************
						HELPERS
****************************************************/

/obj/item/organ/external/proc/is_stump()
	return FALSE

/obj/item/organ/external/proc/release_restraints(var/mob/living/carbon/human/holder)
	if(!holder)
		holder = owner
	if(!holder)
		return
	if (holder.handcuffed && (body_part in list(ARM_LEFT, ARM_RIGHT, HAND_LEFT, HAND_RIGHT)))
		holder.visible_message(\
			"\The [holder.handcuffed.name] falls off of [holder.name].",\
			"\The [holder.handcuffed.name] falls off you.")
		holder.drop_from_inventory(holder.handcuffed)
	if (holder.legcuffed && (body_part in list(FOOT_LEFT, FOOT_RIGHT, LEG_LEFT, LEG_RIGHT)))
		holder.visible_message(\
			"\The [holder.legcuffed.name] falls off of [holder.name].",\
			"\The [holder.legcuffed.name] falls off you.")
		holder.drop_from_inventory(holder.legcuffed)

// checks if all wounds on the organ are bandaged
/obj/item/organ/external/proc/is_bandaged()
	for(var/datum/wound/W in wounds)
		if(!W.bandaged)
			return 0
	return 1

// checks if all wounds on the organ are salved
/obj/item/organ/external/proc/is_salved()
	for(var/datum/wound/W in wounds)
		if(!W.salved)
			return 0
	return 1

// checks if all wounds on the organ are disinfected
/obj/item/organ/external/proc/is_disinfected()
	for(var/datum/wound/W in wounds)
		if(!W.disinfected)
			return 0
	return 1

/obj/item/organ/external/proc/bandage()
	var/rval = 0
	status &= ~ORGAN_BLEEDING
	for(var/datum/wound/W in wounds)
		rval |= !W.bandaged
		W.bandaged = 1
	return rval

/obj/item/organ/external/proc/salve()
	var/rval = 0
	for(var/datum/wound/W in wounds)
		rval |= !W.salved
		W.salved = 1
	return rval

/obj/item/organ/external/proc/disinfect()
	var/rval = 0
	for(var/datum/wound/W in wounds)
		rval |= !W.disinfected
		W.disinfected = 1
		W.germ_level = 0
	return rval

/obj/item/organ/external/proc/clamp_organ()
	var/rval = 0
	src.status &= ~ORGAN_BLEEDING
	for(var/datum/wound/W in wounds)
		rval |= !W.clamped
		W.clamped = 1
	return rval

/obj/item/organ/external/proc/fracture()
	if(status & ORGAN_ROBOT)
		return	//ORGAN_BROKEN doesn't have the same meaning for robot limbs
	if((status & ORGAN_BROKEN) || !(limb_flags & ORGAN_CAN_BREAK))
		return
	if(QDELETED(owner))
		return

	var/message = pick("broke in half", "shattered")
	owner.visible_message(\
		"<span class='warning'><font size=2>You hear a loud cracking sound coming from \the [owner]!</font></span>",\
		"<span class='danger'><font size=3>Something feels like it [message] in your [name]!</font></span>",\
		"You hear a sickening crack!")
	if(owner.species && owner.can_feel_pain())
		owner.emote("scream")
		owner.flash_strong_pain()

	playsound(src.loc, /singleton/sound_category/fracture_sound, 100, 1, -2)
	status |= ORGAN_BROKEN
	broken_description = pick("broken", "fracture", "hairline fracture")
	perma_injury = brute_dam

	// Fractures have a chance of getting you out of restraints
	if(prob(25))
		release_restraints()

	// This is mostly for the ninja suit to stop ninja being so crippled by breaks.
	check_rigsplints()

/obj/item/organ/external/proc/mend_fracture()
	if(status & ORGAN_ROBOT)
		return 0	//ORGAN_BROKEN doesn't have the same meaning for robot limbs
	if(brute_dam > min_broken_damage * GLOB.config.organ_health_multiplier)
		return 0	//will just immediately fracture again

	status &= ~ORGAN_BROKEN

	return 1

/obj/item/organ/external/robotize(var/company)
	..()

	if(company)
		model = company
		var/datum/robolimb/R = GLOB.all_robolimbs[company]

		if(R)
			if(!force_skintone)
				force_icon = R.icon
			if(R.lifelike)
				status |= ORGAN_LIFELIKE
				if(force_prosthetic_name)
					name = force_prosthetic_name
				else
					name = "[initial(name)]"
			else
				if(force_prosthetic_name)
					name = force_prosthetic_name
				else
					name = "[R.company] [initial(name)]"
				desc = "[R.desc]"
			if(R.paintable)
				painted = 1
			brute_mod = R.brute_mod
			burn_mod = R.burn_mod
			robotize_type = company
			augment_limit += 1	//robotic limbs get one extra augment capacity

	dislocated = -1 //TODO, make robotic limbs a separate type, remove snowflake
	limb_flags &= ~ORGAN_CAN_BREAK
	get_icon()
	unmutate()
	for (var/obj/item/organ/external/T in children)
		if(T)
			T.robotize(company)

/obj/item/organ/external/mechassist()
	..()
	limb_flags |= ORGAN_CAN_BREAK

/obj/item/organ/external/proc/robotize_advanced()
	status |= ORGAN_ADV_ROBOT
	for (var/obj/item/organ/external/T in children)
		if (T)
			T.robotize_advanced()

/obj/item/organ/external/proc/mutate()
	if(BP_IS_ROBOTIC(src))
		return
	src.status |= ORGAN_MUTATED
	if(owner) owner.update_body()

/obj/item/organ/external/proc/unmutate()
	if(!BP_IS_ROBOTIC(src))
		src.status &= ~ORGAN_MUTATED
		if(owner) owner.update_body()

/obj/item/organ/external/proc/get_damage()	//returns total damage
	return max(brute_dam + burn_dam - perma_injury, perma_injury)	//could use max_damage?

/obj/item/organ/external/proc/has_infected_wound()
	for(var/datum/wound/W in wounds)
		if(W.germ_level > INFECTION_LEVEL_ONE)
			return 1
	return 0

/obj/item/organ/external/is_usable()
	if(is_stump())
		return FALSE
	if(ORGAN_IS_DISLOCATED(src))
		return FALSE
	if(tendon_status() & TENDON_CUT)
		return FALSE
	if(parent && (parent.tendon_status() & TENDON_CUT))
		return FALSE
	if(get_pain() > pain_disability_threshold)
		return FALSE
	if(brute_ratio > 1)
		return FALSE
	if(burn_ratio > 1)
		return FALSE
	return ..()

/obj/item/organ/external/proc/is_malfunctioning()
	if(BP_IS_ROBOTIC(src) && (brute_ratio + burn_ratio) >= 0.3 && prob(brute_dam + burn_dam) || (surge_damage > (MAXIMUM_SURGE_DAMAGE * 0.25)))
		return TRUE
	if(robotize_type)
		var/datum/robolimb/R = GLOB.all_robolimbs[robotize_type]
		if(R.malfunctioning_check(owner))
			return TRUE
	else
		return FALSE

/obj/item/organ/external/proc/embed(var/obj/item/W, var/silent = 0, var/supplied_message)
	if(!owner || loc != owner)
		return
	if(!W.canremove || is_robot_module(W)) //Modules and augments cannot embed
		return
	if(species.flags & NO_EMBED)
		return
	if(!silent)
		if(supplied_message)
			owner.visible_message("<span class='danger'>[supplied_message]</span>")
		else
			owner.visible_message("<span class='danger'>\The [W] sticks in [owner]'s wound!</span>", "<span class='danger'>\The [W] sticks in your wound!</span>")
	implants += W
	owner.embedded_flag = 1
	add_verb(owner, /mob/proc/yank_out_object)
	W.add_blood(owner)
	if(ismob(W.loc))
		var/mob/living/H = W.loc
		H.drop_from_inventory(W,owner)
	else
		W.forceMove(owner)

/obj/item/organ/external/removed(var/mob/living/user, var/ignore_children = 0)

	if(!owner)
		return
	var/is_robotic = status & ORGAN_ROBOT
	var/mob/living/carbon/human/victim = owner

	..(null, user)

	victim.bad_external_organs -= src

	for(var/atom/movable/implant in implants)
		//large items and non-item objs fall to the floor, everything else stays
		var/obj/item/I = implant
		if(istype(I) && I.w_class < 3)
			implant.forceMove(get_turf(victim.loc))
		else
			implant.forceMove(src)
	implants.Cut()

	// Attached organs also fly off.
	if(!ignore_children)
		for(var/obj/item/organ/external/O in children)
			O.removed()
			if(O)
				O.forceMove(src)
				for(var/obj/item/I in O.contents)
					I.forceMove(src)

	// Grab all the internal giblets too.
	for(var/obj/item/organ/organ in internal_organs)
		organ.removed()
		organ.forceMove(src)

	// Remove parent references
	parent?.children -= src
	parent = null

	release_restraints(victim)
	victim.organs -= src
	victim.organs_by_name[limb_name] = null // Remove from owner's vars.

	//Robotic limbs explode if sabotaged.
	if(is_robotic && sabotaged)
		victim.visible_message(
			"<span class='danger'>\The [victim]'s [src.name] explodes violently!</span>",\
			"<span class='danger'>Your [src.name] explodes!</span>",\
			"<span class='danger'>You hear an explosion!</span>")
		explosion(get_turf(owner),-1,-1,2,3)
		spark(victim, 5)
		qdel(src)

/obj/item/organ/external/proc/disfigure(var/type = "brute")
	if (disfigured)
		return
	if(owner)
		if(type == "brute")
			owner.visible_message("<span class='warning'>You hear a sickening cracking sound coming from \the [owner]'s [name].</span>",	\
			"<span class='danger'>Your [name] becomes a mangled mess!</span>",	\
			"<span class='warning'>You hear a sickening crack.</span>")
		else
			owner.visible_message("<span class='warning'>\The [owner]'s [name] melts away, turning into a mangled mess!</span>",	\
			"<span class='danger'>Your [name] melts away!</span>",	\
			"<span class='warning'>You hear a sickening sizzle.</span>")
	disfigured = 1

/obj/item/organ/external/proc/get_wounds_desc()
	. = ""
	if(status & ORGAN_DESTROYED && !is_stump())
		. += "tear at [amputation_point] so severe that it hangs by a scrap of flesh"
	//Handle robotic and synthetic organ damage
	if(status & ORGAN_ASSISTED)
		var/LL = status & ORGAN_LIFELIKE
		if(brute_dam)
			switch(brute_dam)
				if(0 to 20)
					. += "some [LL ? pick ("cuts","bruises","scars") : "dents"]"
				if(21 to INFINITY)
					. += "[LL ? pick("exposed wiring","torn-back synthflesh") : pick("a lot of dents","severe denting")]"
		if(brute_dam && burn_dam)
			. += " and "
		if(burn_dam)
			switch(burn_dam)
				if(0 to 20)
					. += "some [LL ? pick ("fresh skins","burn scars","healing burns") : "burns"]"
				if(21 to INFINITY)
					. += "[LL ? pick("roasted synth-flesh","melted internal wiring") : pick("many burns","scorched metal")]"
		if(open)
			if(brute_dam || burn_dam)
				. += " and "
			if(open == 1)
				. += "some exposed screws"
			else
				. += "an open panel"

		return

	var/list/wound_descriptors = list()
	if(open > 1)
		wound_descriptors["an open incision"] = 1
	else if (open)
		wound_descriptors["an incision"] = 1
	for(var/datum/wound/W in wounds)
		var/this_wound_desc = W.desc
		if(W.damage_type == DAMAGE_BURN && W.salved) this_wound_desc = "salved [this_wound_desc]"
		if(W.bleeding()) this_wound_desc = "bleeding [this_wound_desc]"
		if(W.bandaged == 1)
			this_wound_desc = "bandaged [this_wound_desc]"
		else if(W.bandaged != 0)
			this_wound_desc = "[W.bandaged] [this_wound_desc]"
		if(W.germ_level > 600) this_wound_desc = "badly infected [this_wound_desc]"
		else if(W.germ_level > 330) this_wound_desc = "lightly infected [this_wound_desc]"
		if(wound_descriptors[this_wound_desc])
			wound_descriptors[this_wound_desc] += W.amount
		else
			wound_descriptors[this_wound_desc] = W.amount

	if(open > 1)
		var/bone = encased ? encased : "bone"
		if(status & ORGAN_BROKEN)
			bone = "broken [bone]"
		wound_descriptors["a [bone] exposed"] = 1

		if(!encased || open > 1)
			var/list/bits = list()
			for(var/obj/item/organ/internal/organ in internal_organs)
				bits += organ.get_visible_state()
			if(bits.len)
				wound_descriptors["[english_list(bits)] visible in the wounds"] = 1

	if(wound_descriptors.len)
		var/list/flavor_text = list()
		var/list/no_exclude = list("gaping wound", "big gaping wound", "massive wound", "large bruise",\
		"huge bruise", "massive bruise", "severe burn", "large burn", "deep burn", "carbonised area") //note to self make this more robust
		for(var/wound in wound_descriptors)
			switch(wound_descriptors[wound])
				if(1)
					flavor_text += "[prob(10) && !(wound in no_exclude) ? "what might be " : ""]a [wound]"
				if(2)
					flavor_text += "[prob(10) && !(wound in no_exclude) ? "what might be " : ""]a pair of [wound]s"
				if(3 to 5)
					flavor_text += "several [wound]s"
				if(6 to INFINITY)
					flavor_text += "a ton of [wound]\s"
		return english_list(flavor_text)

/obj/item/organ/external/listen()
	var/list/sounds = list()
	for(var/obj/item/organ/internal/I in internal_organs)
		var/gutsound = I.listen()
		if(gutsound)
			sounds += gutsound
	if(!sounds.len)
		if(owner.pulse())
			sounds += "faint pulse"
	return sounds

/obj/item/organ/external/proc/sever_artery()
	if((status & ORGAN_ROBOT) || (status & ORGAN_ARTERY_CUT) || !species || species.flags & NO_BLOOD || species.flags & NO_ARTERIES)
		return FALSE
	else
		status |= ORGAN_ARTERY_CUT
		return TRUE

/obj/item/organ/external/proc/tendon_status()
	if(!(limb_flags & ORGAN_HAS_TENDON))
		return

	if(!istype(tendon))
		// Somehow this limb should have a tendon but doesn't. Assume it was destroyed
		return TENDON_CUT

	return tendon.status

// Damage procs
/obj/item/organ/external/proc/get_brute_damage()
	return brute_dam

/obj/item/organ/external/proc/get_burn_damage()
	return burn_dam

/obj/item/organ/external/proc/get_genetic_damage()
	return BP_IS_ROBOTIC(src) ? 0 : genetic_degradation

/obj/item/organ/external/proc/remove_genetic_damage(var/amount)
	if(BP_IS_ROBOTIC(src) || (species.flags & NO_SCAN))
		genetic_degradation = 0
		status &= ~ORGAN_MUTATED
		return
	var/last_gene_dam = genetic_degradation
	genetic_degradation = min(100,max(0,genetic_degradation - amount))
	if(genetic_degradation <= 30)
		if(status & ORGAN_MUTATED)
			unmutate()
			to_chat(src, "<span class = 'notice'>Your [name] is shaped normally again.</span>")
	return -(genetic_degradation - last_gene_dam)

/obj/item/organ/external/proc/add_genetic_damage(var/amount)
	if(BP_IS_ROBOTIC(src) || (species.flags & NO_SCAN))
		genetic_degradation = 0
		status &= ~ORGAN_MUTATED
		return
	var/last_gene_dam = genetic_degradation
	genetic_degradation = min(100,max(0,genetic_degradation + amount))
	if(genetic_degradation > 30)
		if(!(status & ORGAN_MUTATED) && prob(genetic_degradation))
			mutate()
			to_chat(owner, "<span class = 'notice'>Something is not right with your [name]...</span>")
	return (genetic_degradation - last_gene_dam)

// Pain/halloss
/obj/item/organ/external/proc/get_pain()
	if(!ORGAN_CAN_FEEL_PAIN(src) || BP_IS_ROBOTIC(src))
		return 0
	. = pain + 0.7 * brute_dam + 0.8 * burn_dam + 0.5 * get_genetic_damage()
	if(is_broken())
		. += 10
	else if(ORGAN_IS_DISLOCATED(src))
		. += 5
	for(var/obj/item/organ/internal/I as anything in internal_organs)
		. += 0.3 * I.getToxLoss()

/obj/item/organ/external/proc/remove_pain(var/amount)
	if(!ORGAN_CAN_FEEL_PAIN(src))
		pain = 0
		return
	var/last_pain = pain
	pain = max(0, min(species.total_health * 2, pain - amount))
	return -(pain-last_pain)

/obj/item/organ/external/proc/add_pain(var/amount)
	if(!ORGAN_CAN_FEEL_PAIN(src))
		pain = 0
		return
	var/last_pain = pain
	if(owner)
		amount *= owner.species.pain_mod
		amount -= (owner.chem_effects[CE_PAINKILLER]/3)
		if(amount <= 0)
			return
	pain = max(0, min(pain + amount, species.total_health * 2))
	if(owner && ((amount > 15 && prob(20)) || (amount > 30 && prob(60))))
		owner.emote("scream")
	if(amount > 5 && owner)
		owner.undo_srom_pull()
	return pain-last_pain

/mob/living/carbon/human/proc/undo_srom_pull()
	if(srom_pulled_by)
		to_chat(src, SPAN_DANGER("You are ripped out of the Srom by a sudden shock!"))
		var/mob/living/carbon/human/srom_puller = srom_pulling.resolve()
		srom_puller.srom_pulling = null
		to_chat(srom_puller, SPAN_WARNING("A vibration like a jackhammer resonates in your consciousness, and the person you pulled into the Srom disappears in the next instant."))
		srom_pulled_by = null
	if(srom_pulling)
		to_chat(src, SPAN_DANGER("Your Srom pull is disturbed by a sudden shock!"))
		var/mob/living/carbon/human/victim = srom_pulling.resolve()
		victim.srom_pulled_by = null
		srom_pulling = null
