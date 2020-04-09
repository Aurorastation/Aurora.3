/obj/item
	name = "item"
	icon = 'icons/obj/items.dmi'
	w_class = 3.0

	var/image/blood_overlay //this saves our blood splatter overlay, which will be processed not to go over the edges of the sprite
	var/randpixel = 6
	var/abstract = 0
	var/r_speed = 1.0
	var/health
	var/burn_point
	var/burning
	var/hitsound
	var/storage_cost
	var/slot_flags = 0		//This is used to determine on which slots an item can fit.
	var/no_attack_log = 0			//If it's an item we don't want to log attack_logs with, set this to 1
	pass_flags = PASSTABLE
	var/obj/item/master
	var/autodrobe_no_remove = 0

	var/heat_protection = 0 //flags which determine which body parts are protected from heat. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/cold_protection = 0 //flags which determine which body parts are protected from cold. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/max_heat_protection_temperature //Set this variable to determine up to which temperature (IN KELVIN) the item protects against heat damage. Keep at null to disable protection. Only protects areas set by heat_protection flags
	var/min_cold_protection_temperature //Set this variable to determine down to which temperature (IN KELVIN) the item protects against cold damage. 0 is NOT an acceptable number due to if(varname) tests!! Keep at null to disable protection. Only protects areas set by cold_protection flags

	var/datum/action/item_action/action
	var/action_button_name //It is also the text which gets displayed on the action button. If not set it defaults to 'Use [name]'. If it's not set, there'll be no button.
	var/default_action_type = /datum/action/item_action // Specify the default type and behavior of the action button for this atom.

	//This flag is used to determine when items in someone's inventory cover others. IE helmets making it so you can't see glasses, etc.
	//It should be used purely for appearance. For gameplay effects caused by items covering body parts, use body_parts_covered.
	var/flags_inv = 0
	var/body_parts_covered = 0 //see setup.dm for appropriate bit flags

	var/item_flags = 0 //Miscellaneous flags pertaining to equippable objects.

	//var/heat_transfer_coefficient = 1 //0 prevents all transfers, 1 is invisible
	var/gas_transfer_coefficient = 1 // for leaking gas from turf to mask and vice-versa (for masks right now, but at some point, i'd like to include space helmets)
	var/permeability_coefficient = 1 // for chemicals/diseases
	var/siemens_coefficient = 1 // for electrical admittance/conductance (electrocution checks and shit)
	var/slowdown = 0 // How much clothing is slowing you down. Negative values speeds you up
	var/canremove = 1 //Mostly for Ninja code at this point but basically will not allow the item to be removed if set to 0. /N
	var/can_embed = 1//If zero, this item/weapon cannot become embedded in people when you hit them with it
	var/list/armor //= list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)	If null, object has 0 armor.
	var/list/allowed = null //suit storage stuff.
	var/obj/item/device/uplink/hidden/hidden_uplink // All items can have an uplink hidden inside, just remember to add the triggers.
	var/zoomdevicename //name used for message when binoculars/scope is used
	var/zoom = 0 //1 if item is actively being used to zoom. For scoped guns and binoculars.
	var/contained_sprite = 0 //1 if item_state, lefthand, righthand, and worn sprite are all in one dmi
	var/drop_sound = 'sound/items/drop/device.ogg' // drop sound - this is the default

	//Item_state definition moved to /obj
	//var/item_state = null // Used to specify the item state for the on-mob overlays.
	var/item_state_slots //overrides the default item_state for particular slots.


	//ITEM_ICONS ARE DEPRECATED. USE CONTAINED SPRITES IN FUTURE
	// Used to specify the icon file to be used when the item is worn. If not set the default icon for that slot will be used.
	// If icon_override or sprite_sheets are set they will take precendence over this, assuming they apply to the slot in question.
	// Only slot_l_hand/slot_r_hand are implemented at the moment. Others to be implemented as needed.
	var/list/item_icons

	//** These specify item/icon overrides for _species_

	/* Species-specific sprites, concept stolen from Paradise//vg/.
	ex:
	sprite_sheets = list(
		"Tajara" = 'icons/cat/are/bad'
		)
	If index term exists and icon_override is not set, this sprite sheet will be used.
	*/
	var/list/sprite_sheets

	// Species-specific sprite sheets for inventory sprites
	// Works similarly to worn sprite_sheets, except the alternate sprites are used when the clothing/refit_for_species() proc is called.
	var/list/sprite_sheets_obj

	var/icon_override  //Used to override hardcoded clothing dmis in human clothing pr

	var/charge_failure_message = " cannot be recharged."

	var/cleaving = FALSE
	var/reach = 1 // Length of tiles it can reach, 1 is adjacent.
	var/lock_picking_level = 0 //used to determine whether something can pick a lock, and how well.
	// Its vital that if you make new power tools or new recipies that you include this

/obj/item/Destroy()
	if(ismob(loc))
		var/mob/m = loc
		m.drop_from_inventory(src)
		m.update_inv_r_hand()
		m.update_inv_l_hand()
		src.loc = null
	return ..()


/obj/item/device
	icon = 'icons/obj/device.dmi'

/atom/proc/get_cell()
	return DEVICE_NO_CELL

//Checks if the item is being held by a mob, and if so, updates the held icons
/obj/item/proc/update_held_icon()
	if(ismob(src.loc))
		var/mob/M = src.loc
		if(M.l_hand == src)
			M.update_inv_l_hand()
		if(M.r_hand == src)
			M.update_inv_r_hand()

/obj/item/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				qdel(src)
				return
		else
	return

/obj/item/verb/move_to_top(obj/item/I in range(1))
	set name = "Move To Top"
	set category = "Object"

	if (!I in view(1, src))
		return
	if(!istype(I.loc, /turf) || usr.stat || usr.restrained() )
		return
	var/turf/T = I.loc

	I.loc = null

	I.forceMove(T)

/obj/item/examine(mob/user, var/distance = -1)
	var/size
	switch(src.w_class)
		if (5.0 to INFINITY)
			size = "huge"
		if (4.0 to 5.0)
			size = "bulky"
		if (3.0 to 4.0)
			size = "normal-sized"
		if (2.0 to 3.0)
			size = "small"
		if (0 to 2.0)
			size = "tiny"
	//Changed this switch to ranges instead of tiered values, to cope with granularity and also
	//things outside its range ~Nanako


	return ..(user, distance, "", "It is a [size] item.")

/obj/item/attack_hand(mob/user)
	if (!user) return
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]
		if (user.hand)
			temp = H.organs_by_name[BP_L_HAND]
		if(temp && !temp.is_usable())
			to_chat(user, "<span class='notice'>You try to move your [temp.name], but cannot!</span>")
			return
		if(!temp)
			to_chat(user, "<span class='notice'>You try to use your hand, but realize it is no longer attached!</span>")
			return
	if(!src.Adjacent(user))
		to_chat(user, span("notice", "\The [src] slips out of your grasp before you can grab it!")) // because things called before this can move it
		return // please don't pick things up
	src.pickup(user)
	if (istype(src.loc, /obj/item/storage))
		var/obj/item/storage/S = src.loc
		S.remove_from_storage(src)

	src.throwing = 0
	if (src.loc == user)
		if(!user.prepare_for_slotmove(src))
			return
	else if(isliving(src.loc))
		return

	// If equipping onto active hand fails, drop it on the floor.
	if (!user.put_in_active_hand(src))
		forceMove(user.loc)
	return

/obj/item/attack_ai(mob/user as mob)
	if (istype(src.loc, /obj/item/robot_module))
		//If the item is part of a cyborg module, equip it
		if(!isrobot(user))
			return
		var/mob/living/silicon/robot/R = user
		R.activate_module(src)
		R.hud_used.update_robot_modules_display()

// Due to storage type consolidation this should get used more now.
// I have cleaned it up a little, but it could probably use more.  -Sayu
/obj/item/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/storage))
		var/obj/item/storage/S = W
		if(S.use_to_pickup)
			if(S.collection_mode && !is_type_in_list(src, S.pickup_blacklist)) //Mode is set to collect all items on a tile and we clicked on a valid one.
				if(isturf(loc))
					var/list/rejections = list()
					var/success = FALSE
					var/failure = FALSE
					var/original_loc = user ? user.loc : null

					for(var/obj/item/I in loc)
						if (user && user.loc != original_loc)
							break

						if(rejections[I.type]) // To limit bag spamming: any given type only complains once
							continue

						if(!S.can_be_inserted(I))	// Note can_be_inserted still makes noise when the answer is no
							rejections[I.type] = TRUE	// therefore full bags are still a little spammy
							failure = TRUE
							CHECK_TICK
							continue

						success = TRUE
						S.handle_item_insertion_deferred(I, user)	//The 1 stops the "You put the [src] into [S]" insertion message from being displayed.
						CHECK_TICK	// Because people insist on picking up huge-ass piles of stuff.

					S.handle_storage_deferred(user)
					if(success && !failure)
						to_chat(user, "<span class='notice'>You put everything in [S].</span>")
					else if(success)
						to_chat(user, "<span class='notice'>You put some things in [S].</span>")
					else
						to_chat(user, "<span class='notice'>You fail to pick anything up with \the [S].</span>")

			else if(S.can_be_inserted(src))
				S.handle_item_insertion(src)

//Called when the user alt-clicks on something with this item in their active hand
//this function is designed to be overridden by individual weapons
/obj/item/proc/alt_attack(var/atom/target, var/mob/user)
	return 1
	//A return value of 1 continues on to do the normal alt-click action.
	//A return value of 0 does not continue, and will not do the alt-click

/obj/item/proc/talk_into(mob/M as mob, text)
	return

/obj/item/proc/moved(mob/user as mob, old_loc as turf)
	return

/obj/item/throw_impact(atom/hit_atom)
	..()
	if(drop_sound)
		playsound(src, drop_sound, 50, 0, required_asfx_toggles = ASFX_DROPSOUND)

//Apparently called whenever an item is dropped on the floor, thrown, or placed into a container.
//It is called after loc is set, so if placed in a container its loc will be that container.
/obj/item/proc/dropped(var/mob/user)
	if(zoom)
		zoom(user) //binoculars, scope, etc

// Called whenever an object is moved around inside the mob's contents.
// Linker proc: mob/proc/prepare_for_slotmove, which is referenced in proc/handle_item_insertion and obj/item/attack_hand.
// This shit exists so that dropped() could almost exclusively be called when an item is dropped.
/obj/item/proc/on_slotmove(var/mob/user)
	if (zoom)
		zoom(user)

// called just as an item is picked up (loc is not yet changed)
/obj/item/proc/pickup(mob/user)
	pixel_x = 0
	pixel_y = 0
	return

// called when this item is removed from a storage item, which is passed on as S. The loc variable is already set to the new destination before this is called.
/obj/item/proc/on_exit_storage(obj/item/storage/S as obj)
	return

// called when this item is added into a storage item, which is passed on as S. The loc variable is already set to the storage item.
/obj/item/proc/on_enter_storage(obj/item/storage/S as obj)
	return

// called when "found" in pockets and storage items. Returns 1 if the search should end.
/obj/item/proc/on_found(mob/finder as mob)
	return

// called after an item is placed in an equipment slot
// user is mob that equipped it
// slot uses the slot_X defines found in setup.dm
// for items that can be placed in multiple slots
/obj/item/proc/equipped(var/mob/user, var/slot)
	layer = SCREEN_LAYER+0.01
	equip_slot = slot
	if(user.client)	user.client.screen |= src
	if(user.pulling == src) user.stop_pulling()
	return

//Defines which slots correspond to which slot flags
var/list/global/slot_flags_enumeration = list(
	"[slot_wear_mask]" = SLOT_MASK,
	"[slot_back]" = SLOT_BACK,
	"[slot_wear_suit]" = SLOT_OCLOTHING,
	"[slot_gloves]" = SLOT_GLOVES,
	"[slot_shoes]" = SLOT_FEET,
	"[slot_belt]" = SLOT_BELT,
	"[slot_glasses]" = SLOT_EYES,
	"[slot_head]" = SLOT_HEAD,
	"[slot_l_ear]" = SLOT_EARS|SLOT_TWOEARS,
	"[slot_r_ear]" = SLOT_EARS|SLOT_TWOEARS,
	"[slot_w_uniform]" = SLOT_ICLOTHING,
	"[slot_wear_id]" = SLOT_ID,
	"[slot_tie]" = SLOT_TIE
	)

//the mob M is attempting to equip this item into the slot passed through as 'slot'. Return 1 if it can do this and 0 if it can't.
//If you are making custom procs but would like to retain partial or complete functionality of this one, include a 'return ..()' to where you want this to happen.
//Set disable_warning to 1 if you wish it to not give you outputs.
//Should probably move the bulk of this into mob code some time, as most of it is related to the definition of slots and not item-specific
/obj/item/proc/mob_can_equip(M as mob, slot, disable_warning = FALSE, bypass_blocked_check = FALSE)
	if(!slot) return 0
	if(!M) return 0

	if(!ishuman(M)) return 0

	var/mob/living/carbon/human/H = M
	var/list/mob_equip = list()
	if(H.species.hud && H.species.hud.equip_slots)
		mob_equip = H.species.hud.equip_slots

	if(H.species && !(slot in mob_equip))
		return 0

	//First check if the item can be equipped to the desired slot.
	if("[slot]" in slot_flags_enumeration)
		var/req_flags = slot_flags_enumeration["[slot]"]
		if(!(req_flags & slot_flags))
			return 0

	//Next check that the slot is free
	if(H.get_equipped_item(slot))
		return 0

	//Next check if the slot is accessible.
	var/mob/_user = disable_warning? null : H
	if(!bypass_blocked_check && !H.slot_is_accessible(slot, src, _user))
		return 0

	//Lastly, check special rules for the desired slot.
	switch(slot)
		if(slot_l_ear, slot_r_ear)
			var/slot_other_ear = (slot == slot_l_ear)? slot_r_ear : slot_l_ear
			if( (w_class > 1) && !(slot_flags & SLOT_EARS) )
				return 0
			if( (slot_flags & SLOT_TWOEARS) && H.get_equipped_item(slot_other_ear) )
				return 0
		if(slot_wear_id)
			return 1
		if(slot_l_store, slot_r_store)
			if(!H.w_uniform && (slot_w_uniform in mob_equip))
				if(!disable_warning)
					to_chat(H, "<span class='warning'>You need a jumpsuit before you can attach this [name].</span>")
				return 0
			if(slot_flags & SLOT_DENYPOCKET)
				return 0
			if( w_class > 2 && !(slot_flags & SLOT_POCKET) )
				return 0
		if(slot_s_store)
			if(isvaurca(H) && src.w_class <= ITEMSIZE_SMALL)
				return TRUE
			if(!H.wear_suit && (slot_wear_suit in mob_equip))
				if(!disable_warning)
					to_chat(H, "<span class='warning'>You need a suit before you can attach this [name].</span>")
				return 0
			if(!H.wear_suit.allowed)
				if(!disable_warning)
					to_chat(usr, "<span class='warning'>You somehow have a suit with no defined allowed items for suit storage, stop that.</span>")
				return 0
			if( !(istype(src, /obj/item/device/pda) || src.ispen() || is_type_in_list(src, H.wear_suit.allowed)) )
				return 0
		if(slot_handcuffed)
			if(!istype(src, /obj/item/handcuffs))
				return 0
		if(slot_legcuffed)
			if(!istype(src, /obj/item/legcuffs))
				return 0
		if(slot_in_backpack) //used entirely for equipping spawned mobs or at round start
			var/allow = 0
			if(H.back && istype(H.back, /obj/item/storage/backpack))
				var/obj/item/storage/backpack/B = H.back
				if(B.can_be_inserted(src,1))
					allow = 1
			if(!allow)
				return 0
		if(slot_in_belt)
			var/allow = 0
			if(istype(H.belt, /obj/item/storage/belt))
				var/obj/item/storage/belt/B = H.belt
				if(B.can_be_inserted(src,1))
					allow = 1
			if(!allow)
				return 0
		if(slot_tie)
			if(!H.w_uniform && (slot_w_uniform in mob_equip))
				if(!disable_warning)
					to_chat(H, "<span class='warning'>You need a jumpsuit before you can attach this [name].</span>")
				return 0
			var/obj/item/clothing/under/uniform = H.w_uniform
			if(LAZYLEN(uniform.accessories) && !uniform.can_attach_accessory(src))
				if (!disable_warning)
					to_chat(H, "<span class='warning'>You already have an accessory of this type attached to your [uniform].</span>")
				return 0
	return 1

/obj/item/proc/mob_can_unequip(mob/M, slot, disable_warning = 0)
	if(!slot) return 0
	if(!M) return 0

	if(!canremove)
		return 0
	if(!M.slot_is_accessible(slot, src, disable_warning? null : M))
		return 0
	return 1

/*
/obj/item/verb/verb_pickup()
	set src in oview(1)
	set category = "Object"
	set name = "Pick up"
	if(!(usr)) //BS12 EDIT
		return
	if(!usr.canmove || usr.stat || usr.restrained() || !Adjacent(usr))
		return
	if((!istype(usr, /mob/living/carbon)) || (istype(usr, /mob/living/carbon/brain)))//Is humanoid, and is not a brain
		to_chat(usr, "<span class='warning'>You can't pick things up!</span>")
		return
	if( usr.stat || usr.restrained() )//Is not asleep/dead and is not restrained
		to_chat(usr, "<span class='warning'>You can't pick things up!</span>")
		return
	if(src.anchored) //Object isn't anchored
		to_chat(usr, "<span class='warning'>You can't pick that up!</span>")
		return
	if(!usr.hand && usr.r_hand) //Right hand is not full
		to_chat(usr, "<span class='warning'>Your right hand is full.</span>")
		return
	if(usr.hand && usr.l_hand) //Left hand is not full
		to_chat(usr, "<span class='warning'>Your left hand is full.</span>")
		return
	if(!istype(src.loc, /turf)) //Object is on a turf
		to_chat(usr, "<span class='warning'>You can't pick that up!</span>")
		return
	//All checks are done, time to pick it up!
	usr.UnarmedAttack(src)
	return
*/

/mob/living/carbon/verb/verb_pickup(obj/item/I in range(1))
	set category = "Object"
	set name = "Pick up"

	if(!(usr)) //BS12 EDIT
		return
	if (!I in view(1, src))
		return
	if (istype(I, /obj/item/storage/internal))
		return
	if(!usr.canmove || usr.stat || usr.restrained() || !Adjacent(usr))
		return
	if((!istype(usr, /mob/living/carbon)) || (istype(usr, /mob/living/carbon/brain)))//Is humanoid, and is not a brain
		to_chat(usr, "<span class='warning'>You can't pick things up!</span>")
		return
	if( usr.stat || usr.restrained() )//Is not asleep/dead and is not restrained
		to_chat(usr, "<span class='warning'>You can't pick things up!</span>")
		return
	if(I.anchored) //Object isn't anchored
		to_chat(usr, "<span class='warning'>You can't pick that up!</span>")
		return
	if(!usr.hand && usr.r_hand) //Right hand is not full
		to_chat(usr, "<span class='warning'>Your right hand is full.</span>")
		return
	if(usr.hand && usr.l_hand) //Left hand is not full
		to_chat(usr, "<span class='warning'>Your left hand is full.</span>")
		return
	if(!istype(I.loc, /turf)) //Object is on a turf
		to_chat(usr, "<span class='warning'>You can't pick that up!</span>")
		return
	//All checks are done, time to pick it up!
	usr.UnarmedAttack(I)
	return


//This proc is executed when someone clicks the on-screen UI button. To make the UI button show, set the 'icon_action_button' to the icon_state of the image of the button in screen1_action.dmi
//The default action is attack_self().
//Checks before we get to here are: mob is alive, mob is not restrained, paralyzed, asleep, resting, laying, item is on the mob.
/obj/item/proc/ui_action_click()
	attack_self(usr)

//RETURN VALUES
//handle_shield should return a positive value to indicate that the attack is blocked and should be prevented.
//If a negative value is returned, it should be treated as a special return value for bullet_act() and handled appropriately.
//For non-projectile attacks this usually means the attack is blocked.
//Otherwise should return 0 to indicate that the attack is not affected in any way.
/obj/item/proc/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	return 0

/obj/item/proc/get_loc_turf()
	var/atom/L = loc
	while(L && !istype(L, /turf/))
		L = L.loc
	return loc

/obj/item/proc/eyestab(mob/living/carbon/M as mob, mob/living/carbon/user as mob)

	var/mob/living/carbon/human/H = M
	if(istype(H))
		for(var/obj/item/protection in list(H.head, H.wear_mask, H.glasses))
			if(protection && (protection.body_parts_covered & EYES))
				// you can't stab someone in the eyes wearing a mask!
				to_chat(user, "<span class='warning'>You're going to need to remove the eye covering first.</span>")
				return

	if(!M.has_eyes())
		to_chat(user, "<span class='warning'>You cannot locate any eyes on [M]!</span>")
		return

	admin_attack_log(user, M, "attacked [key_name(M)] with [src]", "was attacked by [key_name(user)] using \a [src]", "used \a [src] to eyestab")

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(M)

	src.add_fingerprint(user)
	//if((CLUMSY in user.mutations) && prob(50))
	//	M = user
		/*
		to_chat(M, "<span class='warning'>You stab yourself in the eye.</span>")
		M.sdisabilities |= BLIND
		M.weakened += 4
		M.adjustBruteLoss(10)
		*/

	if(istype(H))
		var/obj/item/organ/internal/eyes/eyes = H.get_eyes()

		if(H != user)
			M.visible_message(
				"<span class='danger'>[user] stabs [M] in the [eyes.singular_name] with [src]!</span>",
				"<span class='danger'>[user] stabs you in the [eyes.singular_name] with [src]!</span>"
			)
		else
			user.visible_message( \
				"<span class='danger'>[user] stabs themself in the [eyes.singular_name] with [src]!</span>", \
				"<span class='danger'>You stab yourself in the [eyes.singular_name] with [src]!</span>" \
			)

		eyes.damage += rand(3,4)
		if(eyes.damage >= eyes.min_bruised_damage)
			if(M.stat != 2)
				if(eyes.robotic <= 1) //robot eyes bleeding might be a bit silly
					to_chat(M, "<span class='danger'>Your eyes start to bleed profusely!</span>")
			if(prob(50))
				if(M.stat != 2)
					to_chat(M, "<span class='warning'>You drop what you're holding and clutch at your eyes!</span>")
					M.drop_item()
				M.eye_blurry += 10
				M.Paralyse(1)
				M.Weaken(4)
			if (eyes.damage >= eyes.min_broken_damage)
				if(M.stat != 2)
					to_chat(M, "<span class='warning'>You go blind!</span>")
		var/obj/item/organ/external/affecting = H.get_organ(BP_HEAD)
		if(affecting.take_damage(7))
			M:UpdateDamageIcon()
	else
		M.take_organ_damage(7)
	M.eye_blurry += rand(3,4)
	return

/obj/item/clean_blood()
	. = ..()
	if(blood_overlay)
		cut_overlay(blood_overlay, TRUE)
	if(istype(src, /obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/G = src
		G.transfer_blood = 0

/obj/item/reveal_blood()
	if(was_bloodied && !fluorescent)
		fluorescent = 1
		blood_color = COLOR_LUMINOL
		blood_overlay.color = COLOR_LUMINOL
		update_icon()

/obj/item/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0

	if(istype(src, /obj/item/melee/energy))
		return

	//if we haven't made our blood_overlay already
	if(!blood_overlay)
		generate_blood_overlay()

	//apply the blood-splatter overlay if it isn't already in there
	if(!blood_DNA.len)
		blood_overlay.color = blood_color
		add_overlay(blood_overlay, TRUE)	// Priority overlay so we don't lose it somehow.

	//if this blood isn't already in the list, add it
	if(istype(M))
		if(blood_DNA[M.dna.unique_enzymes])
			return 0 //already bloodied with this blood. Cannot add more.
		blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
	return 1 //we applied blood to the item

/obj/item/proc/generate_blood_overlay()
	if(blood_overlay)
		return

	blood_overlay = SSicon_cache.bloody_cache[type]
	if (blood_overlay)
		blood_overlay = image(blood_overlay)	// Copy instead of getting a ref, we're going to mutate this.
		return

	var/icon/I = new /icon(icon, icon_state)
	I.Blend(new /icon('icons/effects/blood.dmi', rgb(255,255,255)),ICON_ADD) //fills the icon_state with white (except where it's transparent)
	I.Blend(new /icon('icons/effects/blood.dmi', "itemblood"),ICON_MULTIPLY) //adds blood and the remaining white areas become transparent

	blood_overlay = image(I)
	SSicon_cache.bloody_cache[type] = blood_overlay

/obj/item/proc/showoff(mob/user)
	for (var/mob/M in view(user))
		M.show_message("[user] holds up [src]. <a HREF=?src=\ref[M];lookitem=\ref[src]>Take a closer look.</a>",1)

/mob/living/carbon/verb/showoff()
	set name = "Show Held Item"
	set category = "Object"

	var/obj/item/I = get_active_hand()
	if(I && !I.abstract)
		I.showoff(src)

/*
For zooming with scope or binoculars. This is called from
modules/mob/mob_movement.dm if you move you will be zoomed out
modules/mob/living/carbon/human/life.dm if you die, you will be zoomed out.
*/
//Looking through a scope or binoculars should /not/ improve your periphereal vision. Still, increase viewsize a tiny bit so that sniping isn't as restricted to NSEW
/obj/item/proc/zoom(var/mob/M, var/tileoffset = 14, var/viewsize = 9) //tileoffset is client view offset in the direction the user is facing. viewsize is how far out this thing zooms. 7 is normal view
	if (!M)
		return

	var/devicename

	if(zoomdevicename)
		devicename = zoomdevicename
	else
		devicename = src.name

	var/cannotzoom

	if(M.stat || !(istype(M,/mob/living/carbon/human)))
		to_chat(M, "You are unable to focus through the [devicename]")
		cannotzoom = 1
	else if(!zoom && global_hud.darkMask[1] in M.client.screen)
		to_chat(M, "Your visor gets in the way of looking through the [devicename]")
		cannotzoom = 1
	else if(!zoom && M.get_active_hand() != src)
		to_chat(M, "You are too distracted to look through the [devicename], perhaps if it was in your active hand this might work better")
		cannotzoom = 1

	if(!zoom && !cannotzoom)
		if(M.hud_used.hud_shown)
			M.toggle_zoom_hud()	// If the user has already limited their HUD this avoids them having a HUD when they zoom in
		M.client.view = viewsize
		zoom = 1

		var/tilesize = 32
		var/viewoffset = tilesize * tileoffset

		switch(M.dir)
			if (NORTH)
				M.client.pixel_x = 0
				M.client.pixel_y = viewoffset
			if (SOUTH)
				M.client.pixel_x = 0
				M.client.pixel_y = -viewoffset
			if (EAST)
				M.client.pixel_x = viewoffset
				M.client.pixel_y = 0
			if (WEST)
				M.client.pixel_x = -viewoffset
				M.client.pixel_y = 0

		M.visible_message("[M] peers through the [zoomdevicename ? "[zoomdevicename] of the [src.name]" : "[src.name]"].")

	else
		M.client.view = world.view
		if(!M.hud_used.hud_shown)
			M.toggle_zoom_hud()
		zoom = 0

		M.client.pixel_x = 0
		M.client.pixel_y = 0

		if(!cannotzoom)
			M.visible_message("[zoomdevicename ? "[M] looks up from the [src.name]" : "[M] lowers the [src.name]"].")

/obj/item/proc/pwr_drain()
	return 0 // Process Kill


//a proc that any worn thing can call to update its itemstate
//Should be cheaper than calling regenerate icons on the mob
/obj/item/proc/update_worn_icon()
	if (!equip_slot || !istype(loc, /mob))
		return

	var/mob/M = loc
	switch (equip_slot)
		if (slot_back)
			M.update_inv_back()
		if (slot_wear_mask)
			M.update_inv_wear_mask()
		if (slot_l_hand)
			M.update_inv_l_hand()
		if (slot_r_hand)
			M.update_inv_r_hand()
		if (slot_belt)
			M.update_inv_belt()
		if (slot_wear_id)
			M.update_inv_wear_id()
		if (slot_l_ear)
			M.update_inv_ears()
		if (slot_r_ear)
			M.update_inv_ears()
		if (slot_glasses)
			M.update_inv_glasses()
		if (slot_gloves)
			M.update_inv_gloves()
		if (slot_head)
			M.update_inv_head()
		if (slot_shoes)
			M.update_inv_shoes()
		if (slot_wear_suit)
			M.update_inv_wear_suit()
		if (slot_w_uniform)
			M.update_inv_w_uniform()
		if (slot_l_store)
			M.update_inv_pockets()
		if (slot_r_store)
			M.update_inv_pockets()
		if (slot_s_store)
			M.update_inv_s_store()

// Attacks mobs that are adjacent to the target and user.
/obj/item/proc/cleave(var/mob/living/user, var/mob/living/target)
	if(cleaving)
		return // We're busy.
	cleaving = TRUE
	var/hit_mobs = 0
	for(var/mob/living/SA in orange(get_turf(target), 1))
		if(SA.stat == DEAD) // Don't beat a dead horse.
			continue
		if(SA == user) // Don't hit ourselves.  Simple mobs shouldn't be able to do this but that might change later to be able to hit all mob/living-s.
			continue
		if(SA == target) // We (presumably) already hit the target before cleave() was called.  orange() should prevent this but just to be safe...
			continue
		if(!SA.Adjacent(user) || !SA.Adjacent(target)) // Cleaving only hits mobs near the target mob and user.
			continue
		if(resolve_attackby(SA, user)) // Hit them with the weapon.  This won't cause recursive cleaving due to the cleaving variable being set to true.
			hit_mobs++

	if(hit_mobs)
		to_chat(user, "<span class='danger'>You used \the [src] to attack [hit_mobs] other target\s!</span>")
	cleaving = FALSE

// Used for non-adjacent melee attacks with specific weapons capable of reaching more than one tile.
// This uses changeling range string A* but for this purpose its also applicable.
/obj/item/proc/attack_can_reach(var/atom/us, var/atom/them, var/range)
	if(us.Adjacent(them))
		return TRUE // Already adjacent.
	if(AStar(get_turf(us), get_turf(them), /turf/proc/AdjacentTurfsRanged, /turf/proc/Distance, max_nodes=25, max_node_depth=range))
		return TRUE
	return FALSE

//Used for selecting a random pixel placement, usually on initialize. Checks for pixel_x/y to not interfere with mapped in items.
/obj/item/proc/randpixel_xy()
	if(!pixel_x && !pixel_y)
		pixel_x = rand(-randpixel, randpixel)
		pixel_y = rand(-randpixel, randpixel)
		return TRUE
	else
		return FALSE

/obj/item/do_simple_ranged_interaction(var/mob/user)
	if(user)
		attack_self(user)
	return TRUE
