//cast_method flags
#define CAST_USE		1	// Clicking the spell in your hand.
#define CAST_MELEE		2	// Clicking an atom in melee range.
#define CAST_RANGED		4	// Clicking an atom beyond melee range.
#define CAST_THROW		8	// Throwing the spell and hitting an atom.
#define CAST_COMBINE	16	// Clicking another spell with this spell.
#define CAST_INNATE		32	// Activates upon verb usage, used for mobs without hands.

//Aspects
#define ASPECT_FIRE			"fire" 		//Damage over time and raising body-temp.  Firesuits protect from this.
#define ASPECT_FROST		"frost"		//Slows down the affected, also involves imbedding with icicles.  Winter coats protect from this.
#define ASPECT_SHOCK		"shock"		//Energy-expensive, usually stuns.  Insulated armor protects from this.
#define ASPECT_AIR			"air"		//Mostly involves manipulation of atmos, useless in a vacuum.  Magboots protect from this.
#define ASPECT_FORCE		"force" 	//Manipulates gravity to push things away or towards a location.
#define ASPECT_TELE			"tele"		//Teleportation of self, other objects, or other people.
#define ASPECT_DARK			"dark"		//Makes all those photons vanish using magic-- WITH SCIENCE.  Used for sneaky stuff.
#define ASPECT_LIGHT		"light"		//The opposite of dark, usually blinds, makes holo-illusions, or makes laser lightshows.
#define ASPECT_BIOMED		"biomed"	//Mainly concerned with healing and restoration.
#define ASPECT_EMP			"emp"		//Unused now.
#define ASPECT_UNSTABLE		"unstable"	//Heavily RNG-based, causes instability to the victim.
#define ASPECT_CHROMATIC	"chromatic"	//Used to combine with other spells.
#define ASPECT_UNHOLY		"unholy"	//Involves the dead, blood, and most things against divine beings.
#define ASPECT_PSIONIC      "psionics"  //Psionic power. Bypasses core checks.

/obj/item/spell
	name = "glowing particles"
	desc = "Your hands appear to be glowing brightly."
	icon = 'icons/obj/spells.dmi'
	icon_state = "generic"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_spells.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_spells.dmi',
		)
	throwforce = 0
	force = 0
	item_flags = ITEM_FLAG_NO_BLUDGEON
	var/mob/living/carbon/human/owner
	var/obj/item/technomancer_core/core
	var/cast_methods = null			// Controls how the spell is casted.
	var/aspect = null				// Used for combining spells.
	var/toggled = 0					// Mainly used for overlays.
	var/cooldown = 0 				// If set, will add a cooldown overlay and adjust click delay.  Must be a multiple of 5 for overlays.
	var/cast_sound = null			// Sound file played when this is used.
	var/psi_cost = 0				// Psi complexus cost to use this spell.

/obj/item/spell/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended) // Nothing on examine.
	SHOULD_CALL_PARENT(FALSE)

	return TRUE

// Proc: on_use_cast()
// Parameters: 1 (user - the technomancer casting the spell)
// Description: Override this for clicking the spell in your hands.
/obj/item/spell/proc/on_use_cast(mob/user, var/bypass_psi_check)
	SHOULD_CALL_PARENT(TRUE)
	if(aspect == ASPECT_PSIONIC && !bypass_psi_check)
		if(!owner.psi.spend_power(psi_cost))
			return FALSE
	return TRUE

// Proc: on_throw_cast()
// Parameters: 1 (hit_atom - the atom hit by the spell object)
// Description: Override this for throwing effects.
/obj/item/spell/proc/on_throw_cast(atom/hit_atom, var/bypass_psi_check)
	SHOULD_CALL_PARENT(TRUE)
	if(aspect == ASPECT_PSIONIC && !bypass_psi_check)
		if(!owner.psi.spend_power(psi_cost))
			return FALSE
	return TRUE

// Proc: on_ranged_cast()
// Parameters: 2 (hit_atom - the atom clicked on by the user, user - the technomancer that clicked hit_atom)
// Description: Override this for ranged effects.
/obj/item/spell/proc/on_ranged_cast(atom/hit_atom, mob/user, var/bypass_psi_check)
	SHOULD_CALL_PARENT(TRUE)
	if(aspect == ASPECT_PSIONIC && !bypass_psi_check)
		if(!owner.psi.spend_power(psi_cost))
			return FALSE
	return TRUE

// Proc: on_melee_cast()
// Parameters: 3 (hit_atom - the atom clicked on by the user, user - the technomancer that clicked hit_atom, def_zone - unknown)
// Description: Override this for effects that occur at melee range.
/obj/item/spell/proc/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	SHOULD_CALL_PARENT(TRUE)
	if(aspect == ASPECT_PSIONIC)
		if(!owner.psi.spend_power(psi_cost))
			return FALSE
	return TRUE

// Proc: on_combine_cast()
// Parameters: 2 (I - the item trying to merge with the spell, user - the technomancer who initiated the merge)
// Description: Override this for combining spells, like Aspect spells.
/obj/item/spell/proc/on_combine_cast(obj/item/I, mob/user)
	SHOULD_CALL_PARENT(TRUE)
	if(aspect == ASPECT_PSIONIC)
		if(!owner.psi.spend_power(psi_cost))
			return FALSE
	return TRUE

// Proc: on_innate_cast()
// Parameters: 1 (user - the entity who is casting innately (without using hands).)
// Description: Override this for casting without using hands (and as a result not using spell objects).
/obj/item/spell/proc/on_innate_cast(mob/user)
	SHOULD_CALL_PARENT(TRUE)
	if(aspect == ASPECT_PSIONIC)
		if(!owner.psi.spend_power(psi_cost))
			return FALSE
	return TRUE

// Proc: on_scepter_use_cast()
// Parameters: 1 (user - the holder of the Scepter that clicked.)
// Description: Override this for spell casts which have additional functionality when a Scepter is held in the offhand, and the
// scepter is being clicked by the technomancer in their hand.
/obj/item/spell/proc/on_scepter_use_cast(mob/user)
	return

// Proc: on_scepter_use_cast()
// Parameters: 2 (hit_atom - the atom clicked by user, user - the holder of the Scepter that clicked.)
// Description: Similar to the above proc, however this is for when someone with a Scepter clicks something far away with the scepter
// while holding a spell in the offhand that reacts to that.
/obj/item/spell/proc/on_scepter_ranged_cast(atom/hit_atom, mob/user)
	return

// Proc: pay_energy()
// Parameters: 1 (amount - how much to test and drain if there is enough)
// Description: Use this to make spells cost energy.  It returns false if the technomancer cannot pay for the spell for any reason, and
// if they are able to pay, it is deducted automatically.
/obj/item/spell/proc/pay_energy(var/amount)
	if(!core)
		if(aspect == ASPECT_PSIONIC)
			return owner.psi.spend_power(amount)
		return amount
	return core.pay_energy(amount)

// Proc: give_energy()
// Parameters: 1 (amount - how much to give to the technomancer)
// Description: Redirects the call to the core's give_energy().
/obj/item/spell/proc/give_energy(var/amount)
	if(!core)
		return amount
	return core.give_energy(amount)

// Proc: adjust_instability()
// Parameters: 1 (amount - how much instability to give)
// Description: Use this to quickly add or subtract instability from the caster of the spell.  Owner is set by New().
/obj/item/spell/proc/adjust_instability(var/amount)
	if(!owner || !core)
		return 0
	amount = round(amount * core.instability_modifier, 0.1)
	owner.adjust_instability(amount)

// Proc: get_technomancer_core()
// Parameters: 0
// Description: Returns the technomancer's core, assuming it is being worn properly.
/mob/proc/get_technomancer_core()
	if(istype(back, /obj/item/technomancer_core))
		return back
	return null

/mob/living/carbon/human/get_technomancer_core()
	. = ..()
	if(!.)
		if(istype(wrists, /obj/item/technomancer_core))
			return wrists

// Proc: New()
// Parameters: 0
// Description: Sets owner to equal its loc, links to the owner's core, then applies overlays if needed.
/obj/item/spell/Initialize()
	. = ..()
	if(isliving(loc))
		owner = loc
	if(owner)
		if(aspect != ASPECT_PSIONIC)
			core = owner.get_technomancer_core()
			if(!core)
				to_chat(owner, SPAN_WARNING("You need a Core to do that."))
				return INITIALIZE_HINT_QDEL
		else
			if(owner.psi.get_rank() >= PSI_RANK_APEX)
				if(force)
					force *= 1.1
					armor_penetration *= 1.1
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(check_owner))

	update_icon()

// Proc: Destroy()
// Parameters: 0
// Description: Nulls object references so it can qdel() cleanly.
/obj/item/spell/Destroy()
	if(owner)
		owner.unref_spell(src)
	owner = null

	core = null

	. = ..()

/// Check if we're still being held. Otherwise... time to qdel.
/obj/item/spell/proc/check_owner()
	if(!QDELETED(src) && !(loc == owner) && !(cast_methods & CAST_THROW))
		qdel_self()

// Proc: unref_spells()
// Parameters: 0
// Description: Nulls object references on specific mobs so it can qdel() cleanly.
/mob/proc/unref_spell(var/obj/item/spell/the_spell)
	return

// Proc: update_icon()
// Parameters: 0
// Description: Applys an overlay if it is a passive spell.
/obj/item/spell/update_icon()
	if(toggled)
		var/image/new_overlay = image('icons/obj/spells.dmi',"toggled")
		overlays |= new_overlay
	else
		overlays.Cut()
	..()

// Proc: run_checks()
// Parameters: 0
// Description: Ensures spells should not function if something is wrong.  If a core is missing, it will try to find one, then fail
// if it still can't find one.  It will also check if the core is being worn properly, and finally checks if the owner is a technomancer.
/obj/item/spell/proc/run_checks()
	if(!owner)
		return FALSE
	if(aspect != ASPECT_PSIONIC)
		if(!core)
			core = locate(/obj/item/technomancer_core) in owner
			if(!core)
				to_chat(owner, SPAN_DANGER("You need to be wearing a core on your back or your wrists!"))
				return FALSE
		if(core.loc != owner || (owner.back != core && owner.wrists != core)) //Make sure the core's being worn.
			to_chat(owner, SPAN_DANGER("You need to be wearing a core on your back or your wrists!"))
			return FALSE
		if(!core.simple_operation && !GLOB.technomancers.is_technomancer(owner.mind)) //Now make sure the person using this is the actual antag.
			to_chat(owner, SPAN_DANGER("You can't seem to figure out how to make the machine work properly."))
			return FALSE
	else
		if(!owner.psi)
			return FALSE
	return TRUE

// Proc: check_for_scepter()
// Parameters: 0
// Description: Terrible code to check if a scepter is in the offhand, returns 1 if yes.
/obj/item/spell/proc/check_for_scepter()
	if(!src || !owner)
		return FALSE
	if(owner.r_hand == src)
		if(istype(owner.l_hand, /obj/item/scepter))
			return TRUE
	else
		if(istype(owner.r_hand, /obj/item/scepter))
			return TRUE
	return FALSE

// Proc: get_other_hand()
// Parameters: 1 (I - item being compared to determine what the offhand is)
// Description: Helper for Aspect spells.
/mob/living/carbon/human/proc/get_other_hand(var/obj/item/I)
	if(r_hand == I)
		return l_hand
	else
		return r_hand

// Proc: attack_self()
// Parameters: 1 (user - the Technomancer that invoked this proc)
// Description: Tries to call on_use_cast() if it is allowed to do so.  Don't override this, override on_use_cast() instead.
/obj/item/spell/attack_self(mob/user)
	if(run_checks() && (cast_methods & CAST_USE))
		on_use_cast(user)
	..()

// Proc: attackby()
// Parameters: 2 (W - the item this spell object is hitting, user - the technomancer who clicked the other object)
// Description: Tries to combine the spells, if W is a spell, and has CHROMATIC aspect.
/obj/item/spell/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/spell))
		var/obj/item/spell/spell = attacking_item
		if(run_checks() & (cast_methods & CAST_COMBINE))
			spell.on_combine_cast(src, user)
		return TRUE
	else
		return ..()

// Proc: afterattack()
// Parameters: 4 (target - the atom clicked on by user, user - the technomancer who clicked with the spell, proximity - argument
// telling the proc if target is adjacent to user, click_parameters - information on where exactly the click occured on the screen.)
// Description: Tests to make sure it can cast, then casts a combined, ranged, or melee spell based on what it can do and the
// range the click occured.  Melee casts have higher priority than ranged if both are possible.  Sets cooldown at the end.
// Don't override this for spells, override the on_*_cast() spells shown above.
/obj/item/spell/afterattack(atom/target, mob/user, proximity, click_parameters)
	if(!run_checks())
		return
	if(!proximity)
		if(cast_methods & CAST_RANGED)
			on_ranged_cast(target, user)
	else
		if(istype(target, /obj/item/spell))
			var/obj/item/spell/spell = target
			if(spell.cast_methods & CAST_COMBINE)
				spell.on_combine_cast(src, user)
				return
		else if(cast_methods & CAST_MELEE)
			on_melee_cast(target, user)
		if(cast_methods & CAST_RANGED) //Try to use a ranged method if a melee one doesn't exist.
			on_ranged_cast(target, user)
	if(cooldown)
		apply_cooldown(user)

/obj/item/spell/proc/apply_cooldown(mob/user)
	var/effective_cooldown
	if(aspect == ASPECT_PSIONIC)
		effective_cooldown = cooldown
	else
		effective_cooldown = round(cooldown * core.cooldown_modifier, 5)
	user.setClickCooldown(effective_cooldown)
	flick("cooldown_[effective_cooldown]",src)

/obj/item/spell/apply_hit_effect(mob/living/target, mob/living/user, hit_zone)
	. = ..()
	if(cast_methods & CAST_MELEE)
		on_melee_cast(target, user) //afterattack is not called if the target isn't the user and this proc isn't called if the target is the user

// Proc: place_spell_in_hand()
// Parameters: 1 (path - the type path for the spell that is desired.)
// Description: Returns immediately, this is here to override for other mobs as needed.
/mob/living/proc/place_spell_in_hand(var/path)
	return

// Proc: place_spell_in_hand()
// Parameters: 1 (path - the type path for the spell that is desired.)
// Description: Gives the spell to the human mob, if it is allowed to have spells, hands are not full, etc.  Otherwise it deletes itself.
/mob/living/carbon/human/place_spell_in_hand(var/path)
	if(!path || !ispath(path))
		return 0

	//var/obj/item/spell/S = new path(src)
	var/obj/item/spell/S = new path(src)

	//No hands needed for innate casts.
	if(S.cast_methods & CAST_INNATE)
		if(S.run_checks())
			S.on_innate_cast(src)

	if(l_hand && r_hand) //Make sure our hands aren't full.
		if(istype(r_hand, /obj/item/spell)) //If they are full, perhaps we can still be useful.
			var/obj/item/spell/r_spell = r_hand
			if(r_spell.aspect == ASPECT_CHROMATIC) //Check if we can combine the new spell with one in our hands.
				r_spell.on_combine_cast(S, src)
		else if(istype(l_hand, /obj/item/spell))
			var/obj/item/spell/l_spell = l_hand
			if(l_spell.aspect == ASPECT_CHROMATIC) //Check the other hand too.
				l_spell.on_combine_cast(S, src)
		else //Welp
			to_chat(src, SPAN_WARNING("You require a free hand to use this function."))
			return 0

	if(S.run_checks())
		put_in_hands(S)
		return 1
	else
		qdel(S)
		return 0

// Proc: dropped()
// Parameters: 0
// Description: Deletes the spell object immediately.
/obj/item/spell/dropped()
	. = ..()
	if(!QDELETED(src))
		qdel_self()


// Proc: throw_impact()
// Parameters: 1 (hit_atom - the atom that got hit by the spell as it was thrown)
// Description: Calls on_throw_cast() on whatever was hit, then deletes itself incase it missed.
/obj/item/spell/throw_impact(atom/hit_atom)
	..()
	if(cast_methods & CAST_THROW)
		on_throw_cast(hit_atom)

	// If we miss or hit an obstacle, we still want to delete the spell.
	spawn(20)
		if(!QDELETED(src))
			qdel(src)

/obj/item/spell/damage_flags()
	. = ..()
	if(aspect == ASPECT_PSIONIC)
		. |= DAMAGE_FLAG_PSIONIC
