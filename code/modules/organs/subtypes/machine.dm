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
	action_button_name = "Use diagnostics unit"
	vital = 0
	var/diagnosticshp = 10  // A very very fragile piece of equipment

/obj/item/organ/diagnosticsunit/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "diagnostics_unit"
		if(action.button)
			action.button.UpdateIcon()


/obj/item/organ/diagnosticsunit/attack_self(var/mob/user)
	. = ..()

	if(.)
		var/mob/living/carbon/human/H = owner

		if(diagnosticshp <= 0)
			to_chat(H, "<span class='danger'>\The [src] shudders and sparks, unable to change its sensors!</span>")
			return
		else

			to_chat(H, "<span class='notice'>Performing self-diagnostic, please wait...</span>")
			if (do_after(H, 10))
				var/output = "<span class='notice'>Self-Diagnostic Results:\n</span>"

				output += "Internal Temperature: [convert_k2c(H.bodytemperature)] Degrees Celsius\n"

				output += "Current Charge Level: [H.nutrition]\n"

				var/toxDam = H.getToxLoss()
				if(toxDam)
					output += "Blood Toxicity: <span class='warning'>[toxDam > 25 ? "Severe" : "Moderate"]</span>. Seek medical facilities for cleanup.\n"
				else
					output += "Blood Toxicity: <span style='color:green;'>OK</span>\n"

				for(var/obj/item/organ/external/EO in H.organs)
					if(EO.brute_dam || EO.burn_dam)
						output += "[EO.name] - <span class='warning'>[EO.burn_dam + EO.brute_dam > ROBOLIMB_SELF_REPAIR_CAP ? "Heavy Damage" : "Light Damage"]</span>\n"
					else
						output += "[EO.name] - <span style='color:green;'>OK</span>\n"

				for(var/obj/item/organ/IO in H.internal_organs)
					if(IO.damage)
						output += "[IO.name] - <span class='warning'>[IO.damage > 10 ? "Heavy Damage" : "Light Damage"]</span>\n"
					else
						output += "[IO.name] - <span style='color:green;'>OK</span>\n"

				to_chat(H, output)



/obj/item/organ/diagnosticsunit/Initialize()
	START_PROCESSING(SSfast_process, src)
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
	action_button_name = "Expunge/Fill Coolant Pump"
	var/coolantbaseamount = 100
	var/coolantuserate = 0.9
	var/coolantamount = 100
	var/pumphealth = 30
	var/failure_timer = FALSE
	var/pumpdmg_timer = FALSE

/obj/item/organ/coolantpump/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "expungefill"
		if(action.button)
			action.button.UpdateIcon()

/obj/item/organ/coolantpump/attack_self(var/mob/user)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(.)


		if(pumphealth <= 0)
			to_chat(H, "<span class='danger'>\The [src] is far too damaged to be used</span>")
			return

		var/list/expungefill = list("Use Coolant Reserves", "Fill Coolant From Enviroment", "Cancel")

		var/coolantmode = input("Select Coolant Operation.", "Coolant Pump Integrated System") as null|anything in expungefill

		switch(coolantmode)


			if("Use Coolant Reserves")
				if(coolantamount <= 0)
					to_chat(H, "<span class='danger'>\The [src] is empty!</span>") // Out of coolant
					return
				else

					var/datum/reagents/R = new/datum/reagents(15)
					R.my_atom = H.loc
					R.add_reagent("coolant", 2)
					var/datum/effect/effect/system/smoke_spread/chem/smoke = new
					smoke.set_up(R, 5, 0, H.loc, 4)
					visible_message("<span class='warning'>[H] emmits a large cloud of coolant.</span>", "<span class='warning'>You quickly expunge coolant outwards, cooling yourself.</span>")
					playsound(H.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
					smoke.start()
					R.set_temperature(H.bodytemperature)
					coolantamount -= (rand(15,20))
					H.bodytemperature -= (rand(80,120))
					qdel(R)
					return
			if("Fill Coolant From Enviroment")
				if(coolantamount >= coolantbaseamount)
					to_chat(H, "<span class='danger'>\The [src] is full already!</span>")
					return
				else

					to_chat(H, "<span class='warning'>Remain still while enviroment pump engages.....</span>")
					if (do_after(H, 10))
						playsound(H.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
						coolantamount += (rand(15,20))
						H.bodytemperature += (rand(120,160))
						return


/obj/item/organ/coolantpump/Initialize()
	START_PROCESSING(SSfast_process, src)
	robotize()
	. = ..()




/obj/item/organ/coolantpump/proc/coolant_check()
	var/mob/living/carbon/human/H = owner
	var/obj/item/organ/external/UB = H.organs_by_name["chest"]
	if(!H) 
		return
	if((coolantamount <= 0 || pumphealth <= 0) && !failure_timer)
		addtimer(CALLBACK(src, .proc/coolant_failure), rand(100, 150))
		failure_timer = TRUE
	if((UB.brute_dam >= 20 ) && !pumpdmg_timer)
		addtimer(CALLBACK(src, .proc/damage_pump), rand(100, 150))
		pumpdmg_timer = TRUE

/obj/item/organ/coolantpump/proc/coolant_failure()
	var/mob/living/carbon/human/H = owner
	if(!H) 
		return
	var/obj/item/organ/external/O = pick(H.organs)
	if(coolantamount <= 0)
		to_chat(H, "<span class='danger'>You're [O.name] begins to slowly glow red hot</span>")
		if(prob(80))
			H.apply_damage(10,BURN,O)
		else
			H.apply_damage(20,BURN,O)
		
	if(pumphealth <= 0 )
		to_chat(H, "<span class='danger'>Critical melt down! Pump integrity at [pumphealth]% </span>")
		H.bodytemperature += 200
	failure_timer = FALSE

/obj/item/organ/coolantpump/proc/damage_pump()
	var/mob/living/carbon/human/H = owner
	var/obj/item/organ/external/UB = H.organs_by_name["chest"]
	if(!H) 
		return
	if(UB.brute_dam >= 20 )
		pumphealth -= 0.4
	pumpdmg_timer = FALSE

/obj/item/organ/coolantpump/process()
	var/mob/living/carbon/human/H = owner

	if(coolantamount >= coolantbaseamount)
		coolantamount = coolantbaseamount

	if(H.bodytemperature <= H.species.cold_level_1 || (H.bodytemperature >= H.species.heat_level_1))
		coolantamount -= coolantuserate * 2
	if(H.bodytemperature <= H.species.cold_level_2 || (H.bodytemperature >= H.species.heat_level_2))
		coolantamount -= coolantuserate * 4
	if(H.bodytemperature <= H.species.cold_level_3 || (H.bodytemperature >= H.species.heat_level_3))
		coolantamount -= coolantuserate * 6
	coolantamount = max(coolantamount, 0)
	coolant_check()

/obj/item/organ/coolant_pump/removed(var/mob/living/carbon/human/target)
	var/mob/living/carbon/human/H = target
	to_chat(H, "<span class='warning'>Your entire body shuts down, leaving you lifeless.</span>")
	H.Weaken(120)


/obj/item/organ/coolant_pump/replaced(var/mob/living/carbon/human/target)
	var/mob/living/carbon/human/H = owner
	to_chat(target, "<span class='warning'>You feel a cool sensation overcome you.</span>")
	target.update_canmove()
	H.Weaken(0)


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



/obj/item/organ/powercontrolunit
	name = "central power calibration system"
	organ_tag = "calibration system"
	parent_organ = "head"
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "navmesh"
	vital = 0
	action_button_name = "Re-Build Powernet"
	var/calibrated = 1
	var/powernetinteg = 10
	var/powernetglitch_timer = FALSE

/obj/item/organ/powercontrolunit/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "rebuildmesh"
		if(action.button)
			action.button.UpdateIcon()

/obj/item/organ/powercontrolunit/attack_self(var/mob/user)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(.)


		var/list/calibrateoptions = list("Re-Build Powernet", "View Powernet integrity", "Cancel")

		var/calibrationmode = input("Select Powernet Operation.", "Hephaestus Industries Nav-Mesh OS V1.22") as null|anything in calibrateoptions

		var/integprecent = powernetinteg * 10

		switch(calibrationmode)


			if("View Powernet integrity")
				to_chat(H, "<span class='warning'>\The [src] is at [integprecent]%</span>")
				if(calibrated == 0)
					to_chat(H, "<span class='warning'>Calibration is reccomended</span>")
				return
			if("Re-Build Powernet")
				if(calibrated == 1)
					to_chat(H, "<span class='warning'>\The [src]'s powernet is already intact!</span>")
					return

				if(powernetinteg == 0)
					to_chat(H, "<span class='warning'>\The [src]'s powernet is broken or missing!</span>")
					return
				else

					to_chat(H, "<span class='warning'>Remain still while powernet rebuilds.....</span>")
					if (do_after(H, 50))
						calibrated = 1
						to_chat(H, "<span class='notice'>\The [src]'s powernet is rebuilt!</span>")
						H.confused = 0
						H.drowsyness = 0
						return


/obj/item/organ/powercontrolunit/Initialize()
	START_PROCESSING(SSfast_process, src)
	calibrated = 1
	robotize()
	. = ..()




/obj/item/organ/powercontrolunit/proc/calibration_check()
	var/mob/living/carbon/human/H = owner
	if(!H) 
		return
	if((calibrated == 0 && !powernetglitch_timer))
		addtimer(CALLBACK(src, .proc/calibration_failure), rand(20, 60))
		powernetglitch_timer = TRUE

/obj/item/organ/powercontrolunit/proc/calibration_failure()
	var/mob/living/carbon/human/H = owner
	if(!H) 
		return
	if(calibrated <= 0)
		H.confused += 9
		H.drowsyness += 2
	powernetglitch_timer = FALSE

/obj/item/organ/powercontrolunit/proc/calibration_dmgcheck()
	var/mob/living/carbon/human/H = owner
	var/obj/item/organ/NV = H.internal_organs_by_name["calibration system"]
	var/obj/item/organ/external/UB = H.organs_by_name["head"]
	if(!H) 
		return
	if(UB.brute_dam >= 10 )
		calibrated = 0		
	if(UB.brute_dam >= 28)
		powernetinteg = 0
		name = "broken power calibration system"
		icon_state = "camera_broken"
		H.Weaken(6)
		NV.forceMove(H.loc)

/obj/item/organ/powercontrolunit/process()
	calibration_check()
	calibration_dmgcheck()






/*
##You know this is illegal you know?##
##Illegal Parts should go under this section, this includes terminator parts##
*/



/obj/item/organ/cell/terminator
	name = "shielded microbattery"
	desc = "A small, powerful cell for use in fully prosthetic bodies. Equipped with a Faraday shield."
	icon = 'icons/obj/power.dmi'
	icon_state = "scell"
	organ_tag = "shielded cell"
	parent_organ = "chest"
	vital = 1
	emp_coeff = 0

/obj/item/organ/cell/Initialize()
	robotize()
	. = ..()

/obj/item/organ/external/head/terminator
	dislocated = -1
	can_intake_reagents = 0
	encased = "reinforced support frame"
	emp_coeff = 0
	robotize_type = PROSTHETIC_HK

/obj/item/organ/eyes/optical_sensor/terminator
	emp_coeff = 0

/obj/item/organ/external/chest/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/groin/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/arm/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/arm/right/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/leg/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/leg/right/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/foot/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/foot/right/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/hand/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/hand/right/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0
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