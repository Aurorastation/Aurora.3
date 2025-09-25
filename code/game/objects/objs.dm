/obj
	layer = OBJ_LAYER
	animate_movement = 2

	/// Used to store information about the contents of the object.
	var/list/matter
	/// Whether the object can be recycled (eaten) by something like the Autolathe.
	var/recyclable = FALSE
	/// Size of the object.
	var/w_class
	///Used by R&D to determine what research bonuses it grants.
	var/list/origin_tech = null
	/// Universal "unacidabliness" var, here so you can use it in any obj. As xeno acid is gone, this is now only used for chemistry acid.
	var/unacidable = 0

	/// Special flags such as whether or not this object can be rotated.
	var/obj_flags
	/// The object's force when thrown.
	var/throwforce = 1
	/// Used in attackby() to say how something was attacked "[x] has been [z.attack_verb] by [y] with [z]".
	var/list/attack_verb
	/// Whether this object creates CUT wounds.
	var/sharp = 0
	/// Whether this object is more likely to dismember.
	var/edge = FALSE
	/// If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!
	var/in_use = 0
	/// The type of damage this object deals.
	var/damtype = DAMAGE_BRUTE
	/// The damage this object deals.
	var/force = 0
	/// The armour penetration this object has.
	var/armor_penetration = 0
	/// To make it not able to slice things. Used for curtains, flaps, pumpkins... why the fuck aren't you just using edge?
	var/noslice = FALSE
	/// The health of this object. If this is null, it will set health to maxhealth on Initialize. Otherwise, you can set a custom health value to use at initialize.
	var/health
	/// The maximum health of this object. If null, health is not used.
	var/maxhealth
	/// The armor of this object, turned into an armor component.
	var/list/armor
	/// The sound played when this object is destroyed.
	var/destroy_sound
	/// Set to TRUE when shocked by the tesla ball, to not repeatedly shock the object.
	var/being_shocked = 0

	/// The slot the object will equip to.
	var/equip_slot = 0
	/// If set, this holds the 3-letter shortname of a species, used for species-specific worn icons
	var/icon_species_tag = ""
	/// If 1, this item will automatically change its species tag to match the wearer's species. Requires that the wearer's species is listed in icon_supported_species_tags.
	var/icon_auto_adapt = 0

	/**
	 * A list of strings used with icon_auto_adapt, a list of species which have differing appearances for this item,
	 * based on the species short name
	 */
	var/list/icon_supported_species_tags

	///If `TRUE`, will use the `icon_species_tag` var for rendering this item in the left/right hand
	var/icon_species_in_hand = FALSE


	///Played when the item is used, for example tools
	var/usesound
	/// The speed of the tool. This is generally a divisor.
	var/toolspeed = 1

	/// The sound this tool makes in surgery.
	var/surgerysound

	/* START BUCKLING VARS */
	/// A list of things that can buckle to this atom.
	var/list/can_buckle
	/// If the buckled atom can move, and thus face directions.
	var/buckle_movable = 0
	/// The direction forced on a buckled atom.
	var/buckle_dir = 0
	/// Causesbed-like behavior, forces mob.lying = buckle_lying if != -1.
	var/buckle_lying = -1
	/// Require people to be handcuffed before being able to buckle. eg: pipes.
	var/buckle_require_restraints = 0
	/// The atom buckled to us.
	var/atom/movable/buckled = null
	/**
	* Stores the original layer of a buckled atom.
	*
	* Set in `/obj/proc/buckle` when the atom's layer is adjusted.
	*
	* Used in `/unbuckle()` to restore the original layer.
	*/
	var/buckled_original_layer = null
	/// How much extra time to buckle someone to this object.
	var/buckle_delay = 0
	/* END BUCKLING VARS */

	/* START ACCESS VARS */
	/// Required access.
	var/list/req_access
	/// Only require one of these accesses.
	var/list/req_one_access
	/* END ACCESS VARS */

	/* START PERSISTENCE VARS */
	/// State check if the subsystem is tracking the object, used for easy state checking without iterating the register
	var/persistence_track_active = FALSE
	/// Tracking ID of the object used by the persistence subsystem
	var/persistence_track_id = 0
	/// Author ckey of the object used in persistence subsystem
	/// Note: Not every type can have an author, like generated dirt for example
	/// Additionally, the ckey is only an indicator, for example: A player could pin a paper without having written it
	/// This should be considered for any moderation purpose
	var/persistence_author_ckey = null
	/// Expiration time used when saving/updating a persistent type, this can be changed depending on the use case by assigning a new value
	var/persistance_expiration_time_days = PERSISTENT_DEFAULT_EXPIRATION_DAYS
	/* END PERSISTENCE VARS */

/obj/Initialize(mapload, ...)
	. = ..()
	if(maxhealth)
		if(!health)
			// Allows you to set dynamic health states on initialize.
			health = maxhealth
	if(islist(armor))
		for(var/type in armor)
			if(armor[type])
				AddComponent(/datum/component/armor, armor)
				break

/obj/Destroy()
	if(persistence_track_active) // Prevent hard deletion of references in the persistence register by removing it preemptively
		SSpersistence.deregister_track(src)
	STOP_PROCESSING(SSprocessing, src)
	unbuckle()
	QDEL_NULL(talking_atom)
	return ..()

/obj/Topic(href, href_list, var/datum/ui_state/state = GLOB.default_state)
	if(..())
		return 1

	// In the far future no checks are made in an overriding Topic() beyond if(..()) return
	// Instead any such checks are made in CanUseTopic()
	if(CanUseTopic(usr, state, href_list) == STATUS_INTERACTIVE)
		CouldUseTopic(usr)
		return 0

	CouldNotUseTopic(usr)
	return 1

/obj/CanUseTopic(var/mob/user, var/datum/ui_state/state)
	if(user.CanUseObjTopic(src))
		return ..()
	to_chat(user, SPAN_DANGER("[icon2html(src, user)]Access denied!"))
	return STATUS_CLOSE

/mob/living/silicon/CanUseObjTopic(var/obj/O)
	var/id = src.GetIdCard()
	return O.check_access(id)

/mob/proc/CanUseObjTopic()
	return 1

/**
 * This proc is called to add damage to an object. If there is no health left, it calls on_death().
 */
/obj/proc/add_damage(damage, damage_flags, damage_type, armor_penetration, obj/weapon)
	if(!damage || !maxhealth)
		return FALSE

	var/datum/component/armor/armor = GetComponent(/datum/component/armor)
	if(armor)
		var/blocked = armor.get_blocked(damage_type, damage_flags, armor_penetration, damage)
		damage *= 1 - blocked

	health = max(health - damage, 0)
	update_health()
	if(!health)
		if(destroy_sound)
			playsound(src, destroy_sound, 75)
		on_death()
	return TRUE

/obj/condition_hints(mob/user, distance, is_adjacent)
	. += ..()
	if(health < maxhealth)
		. += get_damage_condition_hints(user, distance, is_adjacent)

/**
 * For custom damage condition hints. Some structures may want different ones than the default, like the cult crystal.
 */
/obj/proc/get_damage_condition_hints(mob/user, distance, is_adjacent)
	if(health < maxhealth * 0.25)
		. = SPAN_DANGER("\The [src] looks like it's about to break!")
	else if(health < maxhealth * 0.5)
		. = SPAN_ALERT("\The [src] looks seriously damaged!")
	else if(health < maxhealth * 0.75)
		. = SPAN_WARNING("\The [src] shows signs of damage!")

/**
 * This proc is called when object health changes. Use this to set custom states, do messages, etc.
 */
/obj/proc/update_health()
	return

/**
 * This proc is called by update_health() when the health of the object hits zero. Handles the destruction of the object, or you can override it to do different effects.
 */
/obj/proc/on_death(damage, damage_flags, damage_type, armor_penetration, obj/weapon)
	qdel(src)

/**
 * This proc is called to set the object's health directly.
 */
/obj/proc/change_health(new_health)
	if(!maxhealth)
		return

	if(health >= maxhealth)
		return FALSE

	health = min(new_health, maxhealth)
	return TRUE

/**
 * This proc is called to directly add to an object's health (basically, to add it).
 */
/obj/proc/add_health(repair_amount)
	if(!maxhealth)
		return

	if(health >= maxhealth)
		return FALSE

	health = min(health + repair_amount, maxhealth)
	return TRUE

/obj/proc/CouldUseTopic(var/mob/user)
	user.AddTopicPrint(src)

/mob/proc/AddTopicPrint(var/obj/target)
	target.add_hiddenprint(src)

/mob/living/AddTopicPrint(var/obj/target)
	if(Adjacent(target))
		target.add_fingerprint(src)
	else
		target.add_hiddenprint(src)

/mob/living/silicon/ai/AddTopicPrint(var/obj/target)
	target.add_hiddenprint(src)

/obj/proc/CouldNotUseTopic(var/mob/user)
	// Nada

/obj/proc/ai_can_interact(var/mob/user)
	if(!Adjacent(user) && within_jamming_range(src, FALSE)) // if not adjacent to it, it uses wireless signal
		to_chat(user, SPAN_WARNING("Something in the area of \the [src] is blocking the remote signal!"))
		return FALSE
	return TRUE

/obj/item/proc/is_used_on(obj/O, mob/user)

/obj/assume_air(datum/gas_mixture/giver)
	if(loc)
		return loc.assume_air(giver)
	else
		return null

/obj/remove_air(amount)
	if(loc)
		return loc.remove_air(amount)
	else
		return null

/obj/return_air()
	if(loc)
		return loc.return_air()

/obj/proc/updateUsrDialog()
	if(in_use)
		var/is_in_use = 0
		var/list/nearby = viewers(1, src)
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				is_in_use = 1
				src.attack_hand(M)
		if (istype(usr, /mob/living/silicon/ai) || istype(usr, /mob/living/silicon/robot))
			if (!(usr in nearby))
				if (usr.client && usr.machine==src) // && M.machine == src is omitted because if we triggered this by using the dialog, it doesn't matter if our machine changed in between triggering it and this - the dialog is probably still supposed to refresh.
					is_in_use = 1
					src.attack_ai(usr)
		in_use = is_in_use

/obj/proc/updateDialog()
	// Check that people are actually using the machine. If not, don't update anymore.
	if(in_use)
		var/list/nearby = viewers(1, src)
		var/is_in_use = 0
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				is_in_use = 1
				src.interact(M)
		var/ai_in_use = AutoUpdateAI(src)

		if(!ai_in_use && !is_in_use)
			in_use = 0

/obj/attack_ghost(mob/user)
	ui_interact(user)
	..()

/obj/proc/interact(mob/user)
	return

/mob/proc/unset_machine()
	src.machine = null

/mob/proc/set_machine(var/obj/O)
	if(src.machine)
		unset_machine()
	src.machine = O
	if(istype(O))
		O.in_use = 1

/obj/item/proc/updateSelfDialog()
	var/mob/M = src.loc
	if(istype(M) && M.client && M.machine == src)
		src.attack_self(M)

/obj/proc/hide(var/hide)
	set_invisibility(hide ? INVISIBILITY_MAXIMUM : initial(invisibility))
	level = hide ? 1 : initial(level)

/obj/proc/hides_under_flooring()
	return level == 1

/obj/proc/hear_talk(mob/M as mob, text, verb, datum/language/speaking)
	if(talking_atom)
		talking_atom.catchMessage(text, M)

/obj/proc/see_emote(mob/M as mob, text, var/emote_type)
	return

/obj/proc/tesla_act(var/power, var/melt = FALSE)
	if(melt)
		visible_message(SPAN_DANGER("\The [src] melts down until ashes are left!"))
		new /obj/effect/decal/cleanable/ash(loc)
		qdel(src)
		return
	being_shocked = 1
	var/power_bounced = power / 2
	tesla_zap(src, 3, power_bounced)
	addtimer(CALLBACK(src, PROC_REF(reset_shocked)), 10)

/obj/proc/reset_shocked()
	being_shocked = 0


/obj/show_message(msg, type, alt, alt_type)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)
	return

//To be called from things that spill objects on the floor.
//Makes an object move around randomly for a couple of tiles
/obj/proc/tumble(var/dist)
	if (dist >= 1)
		spawn()
			dist += rand(0,1)
			for(var/i = 1, i <= dist, i++)
				if(src)
					step(src, pick(NORTH,SOUTH,EAST,WEST))
					sleep(rand(2,4))

/**
 * Sets the `icon_species_tag` on the `/obj` based on the wearer specie, which is
 * then used by the icon generator to select the correct overlay of the object
 *
 * * wearer - A `/mob/living/carbon/human` to adapt the object to the specie of
 *
 * Returns `TRUE` on successful adaptation, `FALSE` otherwise
 */
/obj/proc/auto_adapt_species(mob/living/carbon/human/wearer)
	SHOULD_NOT_SLEEP(TRUE)
	if(icon_auto_adapt)
		icon_species_tag = ""
		if(wearer && length(icon_supported_species_tags))
			if(wearer.species.short_name in icon_supported_species_tags)
				icon_species_tag = wearer.species.short_name
				return TRUE
	return FALSE


//This function should be called on an item when it is:
//Built, autolathed, protolathed, crafted or constructed. At runtime, by players or machines

//It should NOT be called on things that:
//spawn at roundstart, are adminspawned, arrive on shuttles, spawned from vendors, removed from fridges and containers, etc
//This is useful for setting special behaviour for built items that shouldn't apply to those spawned at roundstart
/obj/proc/Created()
	return

/obj/proc/rotate(var/mob/user, var/anchored_ignore = FALSE)
	if(use_check_and_message(user))
		return

	if(anchored && !anchored_ignore)
		to_chat(user, SPAN_WARNING("\The [src] is bolted down to the floor!"))
		return

	set_dir(turn(dir, 90))
	update_icon()
	return TRUE

/obj/AltClick(var/mob/user)
	if(obj_flags & OBJ_FLAG_ROTATABLE)
		rotate(user)
		return
	if(obj_flags & OBJ_FLAG_ROTATABLE_ANCHORED)
		rotate(user, TRUE)
		return
	..()

/obj/get_examine_text(mob/user, distance, is_adjacent, infix, suffix, get_extended = FALSE)
	. = ..()
	if((obj_flags & OBJ_FLAG_ROTATABLE) || (obj_flags & OBJ_FLAG_ROTATABLE_ANCHORED))
		. += SPAN_SUBTLE("Can be rotated with alt-click.")
	if(contaminated)
		. += SPAN_ALIEN("\The [src] has been contaminated!")

// whether mobs can unequip and drop items into us or not
/obj/proc/can_hold_dropped_items()
	return TRUE

/obj/proc/damage_flags()
	. = 0
	if(has_edge(src))
		. |= DAMAGE_FLAG_EDGE
	if(is_sharp(src))
		. |= DAMAGE_FLAG_SHARP
		if(damtype == DAMAGE_BURN)
			. |= DAMAGE_FLAG_LASER

/obj/proc/set_pixel_offsets()
	return

//wash an object
/obj/proc/clean()
	clean_blood()
	color = initial(color)

/obj/proc/output_spoken_message(var/message, var/message_verb = "transmits", var/display_overhead = TRUE, var/overhead_time = 2 SECONDS)
	audible_message("\The <b>[src.name]</b> [message_verb], \"[message]\"")
	if(display_overhead)
		var/list/hearers = get_hearers_in_view(7, src)
		var/list/clients_in_hearers = list()
		for(var/mob/mob in hearers)
			if(mob.client)
				clients_in_hearers += mob.client
		if(length(clients_in_hearers))
			langchat_speech(message, hearers, GLOB.all_languages, skip_language_check = TRUE)

/// Override this to customize the effects an activated signaler has.
/obj/proc/do_signaler()
	return

/*#############################################
				PERSISTENT
#############################################*/

/**
 * Called by the persistence subsystem to retrieve relevant persistent information to be stored in the database.
 * Expected to be overriden by derived objects.
 * RETURN: Associated list with custom information (e.g.: ["test" = "abc", "counter" = 123])
 */
/obj/proc/persistence_get_content()
	return

/**
 * Called by the persistence subsystem to apply persistent data on the created object.
 * Expected to be overriden by derived objects.
 * PARAMS:
 * 	content = Associated list with custom information (e.g.: ["test" = "abc", "counter" = 123]).
 *	x,y,z = x-y-z coordinates of object, can be null.
 */
/obj/proc/persistence_apply_content(content, x, y, z)
	return
