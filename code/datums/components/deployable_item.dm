/**
 * Item deployment and recovery.
 * The original item stays inside its deployed representation and owns this component.
 */
/datum/component/deployable_item
	dupe_mode = COMPONENT_DUPE_UNIQUE
	/// Time required to deploy the item, in deciseconds.
	var/deploy_time = 0
	/// Time required to recover the item, in deciseconds.
	var/undeploy_time = 0
	/// Object type spawned as the deployed representation.
	var/obj/deploy_type
	/// Optional additional placement check: (mob/user, turf/location).
	var/datum/callback/deploy_check_callback
	/// User whose clicks are monitored for deployment.
	var/datum/weakref/deploy_user
	/// Deployed representation containing the original item.
	var/datum/weakref/deployed_machine
	/// Prevent overlapping deployment and recovery requests.
	var/changing_state = FALSE

/datum/component/deployable_item/Initialize(_deploy_type, _deploy_time = 5 SECONDS, _undeploy_time = 5 SECONDS, datum/callback/_deploy_check_callback)
	if(!isitem(parent) || !ispath(_deploy_type, /obj) || ispath(_deploy_type, /obj/item))
		return COMPONENT_INCOMPATIBLE
	if(!isnum(_deploy_time) || _deploy_time < 0 || !isnum(_undeploy_time) || _undeploy_time < 0)
		return COMPONENT_INCOMPATIBLE
	deploy_type = _deploy_type
	deploy_time = _deploy_time
	undeploy_time = _undeploy_time
	deploy_check_callback = _deploy_check_callback

/datum/component/deployable_item/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(register_for_deploy_signal))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(unregister_signals))
	RegisterSignal(parent, COMSIG_ITEM_DEPLOY, PROC_REF(self_deploy))
	var/obj/item/attached_item = parent
	if(attached_item.item_flags & DEPLOY_ON_INITIALIZE)
		INVOKE_ASYNC(src, PROC_REF(finish_deploy), attached_item, null, get_turf(attached_item), attached_item.dir)

/datum/component/deployable_item/UnregisterFromParent()
	unregister_signals()
	UnregisterSignal(parent, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED, COMSIG_ITEM_DEPLOY, COMSIG_MOVABLE_MOVED))
	var/obj/machine = deployed_machine?.resolve()
	if(machine)
		unregister_deployed_signals(machine)
		var/obj/item/item = parent
		if(item.loc == machine && !QDELETED(item))
			item.item_flags &= ~IS_DEPLOYED
			item.forceMove(get_turf(machine))
		qdel(machine)
	deployed_machine = null
	return ..()

// Equipped signals are sent for both hands and other inventory slots.
/datum/component/deployable_item/proc/register_for_deploy_signal(obj/item/item_equipped, mob/user, slot)
	SIGNAL_HANDLER
	unregister_signals()
	if(slot != slot_l_hand && slot != slot_r_hand)
		return
	deploy_user = WEAKREF(user)
	RegisterSignal(user, COMSIG_MOB_CLICKON, PROC_REF(deploy))

/datum/component/deployable_item/proc/unregister_signals()
	SIGNAL_HANDLER
	var/mob/user = deploy_user?.resolve()
	if(user)
		UnregisterSignal(user, COMSIG_MOB_CLICKON)
	deploy_user = null

// Allows the item to request deployment without relying on a mouse binding.
/datum/component/deployable_item/proc/self_deploy(obj/source, mob/user, turf/location)
	SIGNAL_HANDLER
	if(!isturf(location))
		return
	INVOKE_ASYNC(src, PROC_REF(finish_deploy), parent, user, location)

/datum/component/deployable_item/proc/deploy(mob/user, atom/object, list/modifiers)
	SIGNAL_HANDLER
	if(parent != user.get_active_hand() || !modifiers[CTRL_CLICK] || modifiers[RIGHT_CLICK] || modifiers[SHIFT_CLICK] || modifiers[ALT_CLICK] || modifiers[MIDDLE_CLICK])
		return
	var/turf/location = get_turf(object)
	if(!location || get_turf(user) == location || !(get_dir(user, location) in GLOB.cardinals) || !user.Adjacent(location))
		return
	INVOKE_ASYNC(src, PROC_REF(finish_deploy), parent, user, location)
	return COMSIG_MOB_CANCEL_CLICKON

// Deploys a representation containing the same item, rather than consuming it.
/datum/component/deployable_item/proc/finish_deploy(obj/item/item_to_deploy, mob/user, turf/location, direction)
	if(changing_state || QDELETED(item_to_deploy) || item_to_deploy != parent || deployed_machine?.resolve())
		return FALSE
	if(user && (item_to_deploy.use_check_and_message(user, USE_FORCE_SRC_IN_USER) || user.get_active_hand() != item_to_deploy || !user.canUnEquip(item_to_deploy)))
		return FALSE
	if(!can_deploy_at(location, user))
		location?.balloon_alert(user, "no room here!")
		return FALSE

	var/direction_to_deploy = user ? get_dir(user, location) : (direction || item_to_deploy.dir)
	changing_state = TRUE
	if(user)
		item_to_deploy.balloon_alert(user, "deploying...")
		playsound(item_to_deploy, 'sound/items/Ratchet.ogg', 50, TRUE)
		user.set_dir(direction_to_deploy)
		var/completed = do_after(user, deploy_time, item_to_deploy, DO_DEPLOY | DO_USER_UNIQUE_ACT)
		if(QDELETED(src) || QDELETED(item_to_deploy))
			return FALSE
		if(!completed || QDELETED(user) || user.get_active_hand() != item_to_deploy || item_to_deploy.use_check(user, USE_FORCE_SRC_IN_USER) || !user.canUnEquip(item_to_deploy))
			changing_state = FALSE
			return FALSE
		if(!can_deploy_at(location, user))
			location.balloon_alert(user, "no room here!")
			changing_state = FALSE
			return FALSE

	var/obj/machine = new deploy_type(location)
	if(QDELETED(machine))
		changing_state = FALSE
		return FALSE
	machine.set_dir(direction_to_deploy)
	if(item_to_deploy.should_use_health)
		machine.maxhealth = item_to_deploy.maxhealth
		machine.health = item_to_deploy.health
	if(item_to_deploy.reagents && machine.reagents)
		item_to_deploy.reagents.trans_to(machine, item_to_deploy.reagents.total_volume)

	if(user)
		if(!user.unEquip(item_to_deploy, FALSE, machine))
			qdel(machine)
			changing_state = FALSE
			return FALSE
	else
		item_to_deploy.forceMove(machine)
	if(QDELETED(src) || QDELETED(item_to_deploy) || QDELETED(machine) || item_to_deploy.loc != machine)
		qdel(machine)
		return FALSE

	unregister_signals()
	item_to_deploy.item_flags |= IS_DEPLOYED
	deployed_machine = WEAKREF(machine)
	RegisterSignal(machine, COMSIG_ITEM_UNDEPLOY, PROC_REF(undeploy))
	RegisterSignal(machine, COMSIG_QDELETING, PROC_REF(on_machine_deleted))
	RegisterSignal(machine, COMSIG_MOUSEDROP_ONTO, PROC_REF(on_mouse_drop))
	RegisterSignal(machine, COMSIG_ATOM_TOOL_ACT(TOOL_WRENCH), PROC_REF(on_wrench))
	RegisterSignal(item_to_deploy, COMSIG_MOVABLE_MOVED, PROC_REF(on_item_move))
	changing_state = FALSE
	machine.update_icon()
	if(user)
		machine.balloon_alert(user, "deployed")
	return TRUE

// Deleting a representation clears the item-side listeners and state.
/datum/component/deployable_item/proc/on_machine_deleted(obj/source)
	SIGNAL_HANDLER
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	unregister_deployed_signals(source)
	deployed_machine = null
	var/obj/item/item = parent
	item.item_flags &= ~IS_DEPLOYED
	changing_state = FALSE
	if(item.loc == source)
		qdel(item)

/datum/component/deployable_item/proc/unregister_deployed_signals(obj/machine)
	UnregisterSignal(machine, list(COMSIG_ITEM_UNDEPLOY, COMSIG_QDELETING, COMSIG_MOUSEDROP_ONTO, COMSIG_ATOM_TOOL_ACT(TOOL_WRENCH)))

/datum/component/deployable_item/proc/on_mouse_drop(obj/source, atom/over, mob/user)
	SIGNAL_HANDLER
	if(over != user || !ishuman(user) || source.use_check_and_message(user))
		return
	var/obj/item/item = parent
	if(item.item_flags & DEPLOYED_WRENCH_DISASSEMBLE)
		source.balloon_alert(user, "requires a wrench!")
	else
		SEND_SIGNAL(source, COMSIG_ITEM_UNDEPLOY, user)
	return COMPONENT_CANCEL_MOUSEDROP_ONTO

/datum/component/deployable_item/proc/on_wrench(obj/source, mob/living/user, obj/item/tool)
	SIGNAL_HANDLER
	var/obj/item/item = parent
	if(!(item.item_flags & DEPLOYED_WRENCH_DISASSEMBLE))
		return
	if(!source.use_check_and_message(user))
		SEND_SIGNAL(source, COMSIG_ITEM_UNDEPLOY, user)
	return ITEM_INTERACT_SUCCESS

/datum/component/deployable_item/proc/can_undeploy(obj/machine, mob/user)
	var/obj/item/item = parent
	if(item.loc != machine || (item.item_flags & DEPLOYED_NO_PICKUP))
		return FALSE
	return !(SEND_SIGNAL(machine, COMSIG_ITEM_UNDEPLOY_CHECK, user) & COMPONENT_BLOCK_UNDEPLOY)

// Removes the representation if its internal item is moved out externally.
/datum/component/deployable_item/proc/on_item_move(obj/item/source, atom/old_loc)
	SIGNAL_HANDLER
	if(source.loc == old_loc)
		return
	var/obj/machine = deployed_machine?.resolve()
	if(old_loc != machine || !machine)
		return
	if(source.should_use_health)
		source.maxhealth = machine.maxhealth
		source.health = machine.health
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)
	qdel(machine)

/datum/component/deployable_item/proc/undeploy(datum/source, mob/user)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(finish_undeploy), source, user)

// Recovers the original item after an interruptible disassembly delay.
/datum/component/deployable_item/proc/finish_undeploy(obj/machine, mob/user)
	var/obj/item/undeployed_item = parent
	if(changing_state || QDELETED(machine) || machine != deployed_machine?.resolve() || undeployed_item.loc != machine)
		return FALSE
	if(!ishuman(user) || machine.use_check_and_message(user))
		return FALSE
	if(!can_undeploy(machine, user))
		machine.balloon_alert(user, "can't disassemble!")
		return FALSE
	changing_state = TRUE
	machine.balloon_alert(user, "disassembling...")
	playsound(machine, 'sound/items/Ratchet.ogg', 50, TRUE)
	var/completed = do_after(user, undeploy_time, machine, DO_DEPLOY | DO_USER_UNIQUE_ACT)
	if(QDELETED(src) || QDELETED(undeployed_item))
		return FALSE
	changing_state = FALSE
	if(!completed || QDELETED(machine) || QDELETED(user) || machine != deployed_machine?.resolve() || undeployed_item.loc != machine || machine.use_check(user) || !can_undeploy(machine, user))
		return FALSE

	changing_state = TRUE
	SEND_SIGNAL(machine, COMSIG_ITEM_UNDEPLOYED, undeployed_item, user)
	if(QDELETED(src) || QDELETED(undeployed_item) || QDELETED(machine))
		return FALSE
	undeployed_item.maxhealth = machine.maxhealth
	undeployed_item.health = machine.health
	if(machine.reagents && undeployed_item.reagents)
		machine.reagents.trans_to(undeployed_item, machine.reagents.total_volume)
	UnregisterSignal(undeployed_item, COMSIG_MOVABLE_MOVED)
	unregister_deployed_signals(machine)
	deployed_machine = null
	undeployed_item.item_flags &= ~IS_DEPLOYED
	undeployed_item.forceMove(get_turf(machine))
	user.put_in_hands(undeployed_item)
	undeployed_item.balloon_alert(user, "disassembled")
	qdel(machine)
	changing_state = FALSE
	undeployed_item.update_icon()
	return TRUE

/datum/component/deployable_item/proc/can_deploy_at(turf/location, mob/user)
	if(!isturf(location) || location.density || (user && (!user.Adjacent(location) || LinkBlocked(get_turf(user), location))))
		return FALSE
	var/obj/deployed_type = deploy_type
	var/obj/item/item = parent
	var/is_border = initial(deployed_type.atom_flags) & ATOM_FLAG_CHECKS_BORDER
	var/direction = user ? get_dir(user, location) : item.dir
	for(var/obj/object in location)
		if(!object.density)
			continue
		if(!(object.atom_flags & ATOM_FLAG_CHECKS_BORDER) || (is_border && object.dir == direction))
			return FALSE
	return !deploy_check_callback || deploy_check_callback.Invoke(user, location)
