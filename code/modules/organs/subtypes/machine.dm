//////////////
// IPC limbs//
//////////////
/obj/item/organ/external/head/ipc
	dislocated = -1
	can_intake_reagents = 0
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/external/chest/ipc
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/external/groin/ipc
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/external/arm/ipc
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/external/arm/right/ipc
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/external/leg/ipc
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/external/leg/right/ipc
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/external/foot/ipc
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/external/foot/right/ipc
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/external/hand/ipc
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/external/hand/right/ipc
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/cell
	name = "microbattery"
	desc = "A small, powerful cell for use in fully prosthetic bodies."
	icon = 'icons/obj/power.dmi'
	icon_state = "scell"
	organ_tag = "cell"
	parent_organ = "chest"
	vital = 1
	var/emp_counter = 0

/obj/item/organ/cell/Initialize()
	robotize()
	. = ..()

/obj/item/organ/cell/process()
	..()
	if(emp_counter)
		emp_counter--

/obj/item/organ/cell/emp_act(severity)
	emp_counter += 30/severity
	if(emp_counter >= 30)
		owner.Paralyse(emp_counter/6)
		to_chat(owner, "<span class='danger'>%#/ERR: Power leak detected!$%^/</span>")


/obj/item/organ/surge
	name = "surge preventor"
	desc = "A small device that give immunity to EMP for few pulses."
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "surge_ipc"
	organ_tag = "surge"
	parent_organ = "chest"
	vital = 0
	var/surge_left = 0
	var/broken = 0

/obj/item/organ/surge/Initialize()
	if(!surge_left && !broken)
		surge_left = rand(2, 5)
	robotize()
	. = ..()


/obj/item/organ/eyes/optical_sensor
	name = "optical sensor"
	singular_name = "optical sensor"
	organ_tag = "optics"
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "camera"
	dead_icon = "camera_broken"

/obj/item/organ/eyes/optical_sensor/Initialize()
	robotize()
	. = ..()

/obj/item/organ/ipc_tag
	name = "identification tag"
	organ_tag = "ipc tag"
	parent_organ = "head"
	icon = 'icons/obj/telescience.dmi'
	icon_state = "gps-c"
	dead_icon = "gps-c"

/obj/item/organ/ipc_tag/Initialize()
	robotize()
	. = ..()

// Used for an MMI or posibrain being installed into a human.
/obj/item/organ/mmi_holder
	name = "brain"
	organ_tag = "brain"
	parent_organ = "head"
	vital = 1
	var/obj/item/device/mmi/stored_mmi

/obj/item/organ/mmi_holder/proc/update_from_mmi()
	if(!stored_mmi)
		return
	name = stored_mmi.name
	desc = stored_mmi.desc
	icon = stored_mmi.icon
	icon_state = stored_mmi.icon_state

/obj/item/organ/mmi_holder/removed(var/mob/living/user)

	if(stored_mmi)
		stored_mmi.forceMove(get_turf(src))
		if(owner.mind)
			owner.mind.transfer_to(stored_mmi.brainmob)
	. = ..()

	var/mob/living/holder_mob = loc
	if(istype(holder_mob))
		holder_mob.drop_from_inventory(src)
	qdel(src)

/obj/item/organ/mmi_holder/posibrain/Initialize()
	robotize()
	stored_mmi = new /obj/item/device/mmi/digital/posibrain(src)
	. = ..()
	addtimer(CALLBACK(src, .proc/setup_brain), 1)

/obj/item/organ/mmi_holder/posibrain/proc/setup_brain()
	if(owner)
		stored_mmi.name = "positronic brain ([owner.name])"
		stored_mmi.brainmob.real_name = owner.name
		stored_mmi.brainmob.name = stored_mmi.brainmob.real_name
		stored_mmi.icon_state = "posibrain-occupied"
		update_from_mmi()
	else
		stored_mmi.forceMove(get_turf(src))
		qdel(src)

//////////////
//Terminator//
//////////////

/obj/item/organ/mmi_holder/posibrain/terminator
	name = "brain"
	organ_tag = "brain"
	parent_organ = "chest"
	vital = 1
	emp_coeff = 0.1

/obj/item/organ/data
	name = "data core"
	organ_tag = "data core"
	parent_organ = "groin"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "harddisk"
	vital = 0
	emp_coeff = 0.1

/obj/item/organ/data/Initialize()
	robotize()
	. = ..()

/obj/item/organ/diagnosticsunit
	name = "diagnostics unit"
	organ_tag = "diagnostics unit"
	parent_organ = "head"
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "diagnostics_unit"
	vital = 0
	emp_coeff = 0.1

/obj/item/organ/diagnosticsunit/Initialize()
	robotize()
	. = ..()


/obj/item/organ/coolantpump
	name = "coolant pump"
	organ_tag = "coolant pump"
	parent_organ = "chest"
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "coolantpump"
	vital = 0
	emp_coeff = 0.1
	var/coolantbaseamount = 200
	var/coolantdangeramount = 50
	var/coolantuserate = 0.5
	var/coolantamount = 200
	var/pumphealth = 150
	var/installed = 0
	var/burn_cooldown = 0

/obj/item/organ/coolantpump/Initialize()
	START_PROCESSING(SSfast_process, src)
	robotize()
	. = ..()

/obj/item/organ/coolantpump/proc/coolant_check()
	var/mob/living/carbon/human/H = owner
	if(!H) 
		return
	var/obj/item/organ/external/O = pick(H.organs)
	if(world.time < burn_cooldown)
		return
	else
		if(coolantamount <= 0)
			burn_cooldown = world.time+300
			sleep(200)
			to_chat(H, "<span class='danger'>You're [O.name] begins to slowly glow red hot</span>")
			if(prob(80))
				H.apply_damage(10,BURN,O)
			else
				H.apply_damage(20,BURN,O)
		if(pumphealth <= 0 )
			burn_cooldown = world.time+300
			to_chat(H, "<span class='danger'>Critical melt down! Pump integrity at [pumphealth]% </span>")
			H.IgniteMob(15)
			H.bodytemperature += 200

	

/obj/item/organ/coolantpump/process()
	var/mob/living/carbon/human/H = owner

	if(owner.m_intent == "run" || (H.bodytemperature <= H.species.cold_level_1 || (H.bodytemperature >= H.species.heat_level_1)))
		coolantamount -= coolantuserate / 10
	if(owner.m_intent == "run" || (H.bodytemperature <= H.species.cold_level_2 || (H.bodytemperature >= H.species.heat_level_2)))
		coolantamount -= coolantuserate / 3
	if(owner.m_intent == "run" || (H.bodytemperature <= H.species.cold_level_3 || (H.bodytemperature >= H.species.heat_level_3)))
		coolantamount -= coolantuserate *2
	coolantamount = max(coolantamount, 0)
	coolant_check()

/obj/item/organ/coolant_pump/removed(var/mob/living/carbon/human/target)
	to_chat(target, "<span class='warning'>Your entire body shuts down, leaving you lifeless.</span>")
	target.update_canmove()


/obj/item/organ/coolant_pump/replaced(var/mob/living/carbon/human/target)
	to_chat(target, "<span class='warning'>You feel a cool sensation overcome you.</span>")
	target.update_canmove()


/obj/item/organ/coolantpump/attackby(var/obj/I as obj, var/mob/user as mob)
	if(istype(I, /obj/item/stack/nanopaste))
		var/choice = alert("What do you want to do with the nanopaste?","Coolant Pump","Fix coolant gasket")
		if(choice == "Fix coolant gasket")
			var/obj/item/stack/nanopaste/N = I
			var/amount_used = min(N.get_amount(), 10 - pumphealth / 10)
			N.use(amount_used)
			pumphealth = round(pumphealth + amount_used * 10)
			return
	if(istype(I, /obj/item/weapon/reagent_containers) && I.reagents)
		for (var/datum/reagent/R in I.reagents.reagent_list)
			if (coolantamount >= coolantbaseamount)
				to_chat(user, "<span class='info'>You can't put anymore coolant into the [src].</span>")
				return
			if (istype(R, /datum/reagent/coolant))
				var/obj/item/weapon/reagent_containers/glass/G = I
				var/amount_transferred = min(I.reagents.maximum_volume - I.reagents.total_volume, G.reagents.total_volume)
				G.reagents.trans_to(src, amount_transferred)
				I.reagents.remove_reagent(R.id, amount_transferred)
				coolantamount += amount_transferred
				to_chat(user, "<span class='info'>You empty [amount_transferred]u of coolant into [src].</span>")
				coolant_check()


/obj/item/organ/cell/terminator
	name = "shielded microbattery"
	desc = "A small, powerful cell for use in fully prosthetic bodies. Equipped with a Faraday shield."
	icon = 'icons/obj/power.dmi'
	icon_state = "scell"
	organ_tag = "shielded cell"
	parent_organ = "chest"
	vital = 1
	emp_coeff = 0.1

/obj/item/organ/cell/Initialize()
	robotize()
	. = ..()

/obj/item/organ/external/head/terminator
	dislocated = -1
	can_intake_reagents = 0
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/eyes/optical_sensor/terminator
	emp_coeff = 0.5

/obj/item/organ/external/chest/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/groin/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/arm/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/arm/right/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/leg/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/leg/right/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/foot/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/foot/right/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/hand/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/hand/right/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

//////////////
//Industrial//
//////////////

/obj/item/organ/external/head/industrial
	dislocated = -1
	can_intake_reagents = 0
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

/obj/item/organ/external/chest/industrial
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

/obj/item/organ/external/groin/industrial
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

/obj/item/organ/external/arm/industrial
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

/obj/item/organ/external/arm/right/industrial
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

/obj/item/organ/external/leg/industrial
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

/obj/item/organ/external/leg/right/industrial
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

/obj/item/organ/external/foot/industrial
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

/obj/item/organ/external/foot/right/industrial
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

/obj/item/organ/external/hand/industrial
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

/obj/item/organ/external/hand/right/industrial
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

///////////////
//Shell limbs//
///////////////

/obj/item/organ/external/head/shell
	dislocated = -1
	can_intake_reagents = 0
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

/obj/item/organ/external/chest/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

/obj/item/organ/external/groin/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

/obj/item/organ/external/arm/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

/obj/item/organ/external/arm/right/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

/obj/item/organ/external/leg/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

/obj/item/organ/external/leg/right/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

/obj/item/organ/external/foot/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

/obj/item/organ/external/foot/right/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

/obj/item/organ/external/hand/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

/obj/item/organ/external/hand/right/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

//unbranded

/obj/item/organ/external/head/unbranded
	dislocated = -1
	can_intake_reagents = 0
	encased = "support frame"
	robotize_type = "Unbranded"

/obj/item/organ/external/chest/unbranded
	dislocated = -1
	encased = "support frame"
	robotize_type = "Unbranded"

/obj/item/organ/external/groin/unbranded
	dislocated = -1
	encased = "support frame"
	robotize_type = "Unbranded"

/obj/item/organ/external/arm/unbranded
	dislocated = -1
	encased = "support frame"
	robotize_type = "Unbranded"

/obj/item/organ/external/arm/right/unbranded
	dislocated = -1
	encased = "support frame"
	robotize_type = "Unbranded"

/obj/item/organ/external/leg/unbranded
	dislocated = -1
	encased = "support frame"
	robotize_type = "Unbranded"

/obj/item/organ/external/leg/right/unbranded
	dislocated = -1
	encased = "support frame"
	robotize_type = "Unbranded"

/obj/item/organ/external/foot/unbranded
	dislocated = -1
	encased = "support frame"
	robotize_type = "Unbranded"

/obj/item/organ/external/foot/right/unbranded
	dislocated = -1
	encased = "support frame"
	robotize_type = "Unbranded"

/obj/item/organ/external/hand/unbranded
	dislocated = -1
	encased = "support frame"
	robotize_type = "Unbranded"

/obj/item/organ/external/hand/right/unbranded
	dislocated = -1
	encased = "support frame"
	robotize_type = "Unbranded"