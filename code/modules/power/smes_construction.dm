// BUILDABLE SMES(Superconducting Magnetic Energy Storage) UNIT
//
// Last Change 1.1.2015 by Atlantis - Happy New Year!
//
// This is subtype of SMES that should be normally used. It can be constructed, deconstructed and hacked.
// It also supports RCON System which allows you to operate it remotely, if properly set.

//MAGNETIC COILS - These things actually store and transmit power within the SMES. Different types have different
/obj/item/smes_coil
	name = "superconductive magnetic coil"
	desc = "Standard superconductive magnetic coil with balanced capacity and I/O rating."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "smes_coil"
	w_class = ITEMSIZE_LARGE 			// It's LARGE (backpack size)
	var/ChargeCapacity = 5000000
	var/IOCapacity = 250000

/obj/item/smes_coil/examine(mob/user, distance, is_adjacent)
	. = ..()
	if(is_adjacent)
		to_chat(user, "The label reads:\
			<div class='notice' style='padding-left:2rem'>Only certified professionals are allowed to handle and install this component.<br>\
			Charge capacity: [ChargeCapacity/1000000] MJ<br>\
			Input/Output rating: [IOCapacity/1000] kW</div>",
			trailing_newline = FALSE)

// 20% Charge Capacity, 60% I/O Capacity. Used for substation/outpost SMESs.
/obj/item/smes_coil/weak
	name = "basic superconductive magnetic coil"
	desc = "Cheaper model of the standard superconductive magnetic coil. Its capacity and I/O rating are considerably lower."
	icon_state = "smes_coil_weak"
	ChargeCapacity = 1000000
	IOCapacity = 150000

// 1000% Charge Capacity, 20% I/O Capacity
/obj/item/smes_coil/super_capacity
	name = "superconductive capacitance coil"
	desc = "Specialised version of the standard superconductive magnetic coil. It has significantly stronger containment field, allowing for immense power storage. However its I/O rating is much lower."
	icon_state = "smes_coil_capacitance"
	ChargeCapacity = 50000000
	IOCapacity = 50000

// 10% Charge Capacity, 400% I/O Capacity. Technically turns SMES into large super capacitor.Ideal for shields.
/obj/item/smes_coil/super_io
	name = "superconductive transmission coil"
	desc = "Specialised version of the standard superconductive magnetic coil. While it's almost useless for power storage it can rapidly transfer power, making it useful in systems that require large throughput."
	icon_state = "smes_coil_transmission"
	ChargeCapacity = 500000
	IOCapacity = 1000000


// SMES SUBTYPES - THESE ARE MAPPED IN AND CONTAIN DIFFERENT TYPES OF COILS

// These are used on individual outposts as backup should power line be cut, or engineering outpost lost power.
// 1M Charge, 150K I/O
/obj/machinery/power/smes/buildable/outpost_substation/Initialize()
	. = ..()
	component_parts += new /obj/item/smes_coil/weak(src)

// This one is pre-installed on engineering shuttle. Allows rapid charging/discharging for easier transport of power to outpost
// 11M Charge, 2.5M I/O
/obj/machinery/power/smes/buildable/power_shuttle/Initialize()
	. = ..()
	component_parts += new /obj/item/smes_coil/super_io(src)
	component_parts += new /obj/item/smes_coil/super_io(src)
	component_parts += new /obj/item/smes_coil(src)

/obj/machinery/power/smes/buildable/main_engine
	cur_coils = 4
	input_attempt = TRUE
	input_level = 500000
	output_attempt = TRUE
	output_level = 500000
	charge =1.5e+7

// For the substation SMES around the Horizon.
/obj/machinery/power/smes/buildable/substation
	input_level = 150000
	output_level = 140000

// The Horizon's shuttles want something with decent capacity to sustain themselves and enough transmission to meet their energy needs.
/obj/machinery/power/smes/buildable/horizon_shuttle/Initialize()
	. = ..()
	component_parts += new /obj/item/smes_coil/super_io(src)
	component_parts += new /obj/item/smes_coil/super_capacity(src)
	input_attempt = TRUE
	output_attempt = TRUE
	input_level = 1300000
	output_level = 1300000
	charge = 5.55e+007

/obj/machinery/power/smes/buildable/third_party_shuttle/Initialize() //Identical to the horizon_shuttle for now as we try to work out specifics
	. = ..()
	component_parts += new /obj/item/smes_coil/super_io(src)
	component_parts += new /obj/item/smes_coil/super_capacity(src)
	input_attempt = TRUE
	output_attempt = TRUE
	input_level = 1300000
	output_level = 1300000
	charge = 5.55e+007

/obj/machinery/power/smes/buildable/third_party_shuttle/empty/Initialize()
	. = ..()
	charge = 0

/obj/machinery/power/smes/buildable/autosolars/Initialize() //for third parties that have their solars autostart, It's slightly upgraded for them
	. = ..()
	component_parts += new /obj/item/smes_coil/super_capacity(src)
	component_parts += new /obj/item/smes_coil/super_io(src)
	input_attempt = TRUE
	output_attempt = TRUE
	input_level = 1000000
	output_level = 1000000
	charge = 3.02024e+006

// END SMES SUBTYPES

// SMES itself
/obj/machinery/power/smes/buildable
	max_coils = 6 				// 30M capacity, 1.5MW input/output when fully upgraded /w default coils
	var/cur_coils = 1 			// Current amount of installed coils
	var/safeties_enabled = 1 	// If 0 modifications can be done without discharging the SMES, at risk of critical failure.
	var/failing = 0 			// If 1 critical failure has occured and SMES explosion is imminent.
	var/datum/wires/smes/wires
	var/grounding = 1			// Cut to quickly discharge, at cost of "minor" electrical issues in output powernet.
	var/RCon = 1				// Cut to disable AI and remote control.
	var/RCon_tag = "NO_TAG"		// RCON tag, change to show it on SMES Remote control console.
	charge = 0
	should_be_mapped = 1
	component_types = list(
		/obj/item/stack/cable_coil,
		/obj/item/circuitboard/smes
	)

/obj/machinery/power/smes/buildable/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/power/smes/buildable/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	visible_message(SPAN_WARNING("\The [src] is hit by \the [P]!"))
	health_check(P.damage)

/obj/machinery/power/smes/buildable/proc/health_check(var/health_reduction = 0)
	health -= health_reduction
	if(health < 0)
		visible_message(SPAN_DANGER("\The [src] blows apart!"))
		for(var/thing in component_parts)
			var/obj/O = thing
			if(prob(40))
				O.forceMove(loc)
				O.throw_at_random(FALSE, 3, THROWNOBJ_KNOCKBACK_SPEED)
			else
				qdel(O)
		explosion(loc, 1, 2, 4, 8) //copied from the catastrophic failure code
		qdel(src)
	else if(is_badly_damaged() && !busted)
		busted = TRUE
		open_hatch = TRUE
		visible_message(SPAN_DANGER("\The [src]'s maintenance hatch [open_hatch ? "releases a torrent of sparks" : "blows open with a flurry of sparks"]!"))

// Proc: process()
// Parameters: None
// Description: Uses parent process, but if grounding wire is cut causes sparks to fly around.
// This also causes the SMES to quickly discharge, and has small chance of damaging output APCs.
/obj/machinery/power/smes/buildable/process()
	if(!grounding && (Percentage() > 5))
		spark(src, 5, GLOB.alldirs)
		charge -= (output_level_max * SMESRATE)
		if(prob(1)) // Small chance of overload occuring since grounding is disabled.
			apcs_overload(5,10,20)

	..()

// Proc: attack_ai()
// Parameters: None
// Description: AI requires the RCON wire to be intact to operate the SMES.
/obj/machinery/power/smes/buildable/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	if(RCon)
		..()
	else // RCON wire cut
		to_chat(usr, "<span class='warning'>Connection error: Destination Unreachable.</span>")

	// Cyborgs standing next to the SMES can play with the wiring.
	if(istype(usr, /mob/living/silicon/robot) && Adjacent(usr) && open_hatch)
		wires.interact(usr)

// Proc: Initialize()
// Parameters: 2 (dir - direction machine should face, install_coils - if coils should be spawned)
// Description: Adds standard components for this SMES, and forces recalculation of properties.
/obj/machinery/power/smes/buildable/Initialize(mapload, dir)
	wires = new /datum/wires/smes(src)
	..()

	LAZYINITLIST(component_parts)	// Parent machinery call won't initialize this list if this is a newly constructed SMES.

	for (var/i in 1 to cur_coils)
		component_parts += new /obj/item/smes_coil(src)

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/power/smes/buildable/LateInitialize()
	recalc_coils()

// Proc: attack_hand()
// Parameters: None
// Description: Opens the UI as usual, and if cover is removed opens the wiring panel.
/obj/machinery/power/smes/buildable/attack_hand()
	..()
	if(open_hatch)
		wires.interact(usr)

// Proc: recalc_coils()
// Parameters: None
// Description: Updates properties (IO, capacity, etc.) of this SMES by checking internal components.
/obj/machinery/power/smes/buildable/proc/recalc_coils()
	if ((cur_coils <= max_coils) && (cur_coils >= 1))
		capacity = 0
		input_level_max = 0
		output_level_max = 0
		for(var/obj/item/smes_coil/C in component_parts)
			capacity += C.ChargeCapacity
			input_level_max += C.IOCapacity
			output_level_max += C.IOCapacity
		charge = between(0, charge, capacity)
		return 1
	else
		return 0

// Proc: total_system_failure()
// Parameters: 2 (intensity - how strong the failure is, user - person which caused the failure)
// Description: Checks the sensors for alerts. If change (alerts cleared or detected) occurs, calls for icon update.
/obj/machinery/power/smes/buildable/proc/total_system_failure(var/intensity = 0, var/mob/user as mob)
	// SMESs store very large amount of power. If someone screws up (ie: Disables safeties and attempts to modify the SMES) very bad things happen.
	// Bad things are based on charge percentage.
	// Possible effects:
	// Sparks - Lets out few sparks, mostly fire hazard if phoron present. Otherwise purely aesthetic.
	// Shock - Depending on intensity harms the user. Insultated Gloves protect against weaker shocks, but strong shock bypasses them.
	// EMP Pulse - Lets out EMP pulse discharge which screws up nearby electronics.
	// Light Overload - X% chance to overload each lighting circuit in connected powernet. APC based.
	// APC Failure - X% chance to destroy APC causing very weak explosion too. Won't cause hull breach or serious harm.
	// SMES Explosion - X% chance to destroy the SMES, in moderate explosion. May cause small hull breach.

	if (!intensity)
		return

	var/mob/living/carbon/human/h_user = null
	if (!istype(user, /mob/living/carbon/human))
		return
	else
		h_user = user


	// Preparations
	// Check if user has protected gloves.
	var/user_protected = 0
	if(h_user.gloves)
		var/obj/item/clothing/gloves/G = h_user.gloves
		if(G.siemens_coefficient == 0)
			user_protected = 1
	log_game("SMES FAILURE: <b>[src.x]X [src.y]Y [src.z]Z</b> User: [usr.ckey], Intensity: [intensity]/100",ckey=key_name(usr))
	message_admins("SMES FAILURE: <b>[src.x]X [src.y]Y [src.z]Z</b> User: [usr.ckey], Intensity: [intensity]/100 - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>")


	switch (intensity)
		if (0 to 15)
			// Small overcharge
			// Sparks, Weak shock
			small_spark.queue()	// This belongs to the parent SMES type.
			if (user_protected && prob(80))
				to_chat(h_user, "Small electrical arc almost burns your hand. Luckily you had your gloves on!")
			else
				to_chat(h_user, "Small electrical arc sparks and burns your hand as you touch the [src]!")
				h_user.adjustFireLoss(rand(5,10))
				h_user.Paralyse(2)
			charge = 0

		if (16 to 35)
			// Medium overcharge
			// Sparks, Medium shock, Weak EMP
			big_spark.queue()
			if (user_protected && prob(25))
				to_chat(h_user, "Medium electrical arc sparks and almost burns your hand. Luckily you had your gloves on!")
			else
				to_chat(h_user, "Medium electrical sparks as you touch the [src], severely burning your hand!")
				h_user.adjustFireLoss(rand(10,25))
				h_user.Paralyse(5)
			spawn(0)
				empulse(src.loc, 2, 4)
			apcs_overload(0, 5, 10)
			charge = 0

		if (36 to 60)
			// Strong overcharge
			// Sparks, Strong shock, Strong EMP, 10% light overload. 1% APC failure
			big_spark.queue()
			big_spark.queue()
			if (user_protected)
				to_chat(h_user, "Strong electrical arc sparks between you and [src], ignoring your gloves and burning your hand!")
				h_user.adjustFireLoss(rand(25,60))
				h_user.Paralyse(8)
			else
				to_chat(h_user, "Strong electrical arc sparks between you and [src], knocking you out for a while!")
				h_user.adjustFireLoss(rand(35,75))
				h_user.Paralyse(12)
			spawn(0)
				empulse(src.loc, 8, 16)
			charge = 0
			apcs_overload(1, 10, 20)
			energy_fail(10)
			src.ping("Caution. Output regulators malfunction. Uncontrolled discharge detected.")

		if (61 to INFINITY)
			// Massive overcharge
			// Sparks, Near - instantkill shock, Strong EMP, 25% light overload, 5% APC failure. 50% of SMES explosion. This is bad.
			big_spark.queue()
			big_spark.queue()
			to_chat(h_user, "A massive electrical arc sparks between you and \the [src]. The last thing that goes through your mind is \"Oh shit...\".")
			// Remember, we have few gigajoules of electricity here.. Turn them into crispy toast.
			h_user.adjustFireLoss(rand(150,195))
			h_user.Paralyse(25)
			spawn(0)
				empulse(src.loc, 32, 64)
			charge = 0
			apcs_overload(5, 25, 100)
			energy_fail(30)
			src.ping("Caution. Output regulators malfunction. Significant uncontrolled discharge detected.")

			if (prob(50))
				// Added admin-notifications so they can stop it when griffed.
				log_game("SMES explosion imminent.")
				message_admins("SMES explosion imminent.")
				src.ping("DANGER! Magnetic containment field unstable! Containment field failure imminent!")
				failing = 1
				// 30 - 60 seconds and then BAM!
				spawn(rand(300,600))
					if(!failing) // Admin can manually set this var back to 0 to stop overload, for use when griffed.
						update_icon()
						src.ping("Magnetic containment stabilised.")
						return
					src.ping("DANGER! Magnetic containment field failure in 3 ... 2 ... 1 ...")
					explosion(src.loc,1,2,4,8)
					// Not sure if this is necessary, but just in case the SMES *somehow* survived..
					qdel(src)



// Proc: apcs_overload()
// Parameters: 3 (failure_chance - chance to actually break the APC, overload_chance - Chance of breaking lights, reboot_chance - Chance of temporarily disabling the APC)
// Description: Damages output powernet by power surge. Destroys few APCs and lights, depending on parameters.
/obj/machinery/power/smes/buildable/proc/apcs_overload(var/failure_chance, var/overload_chance, var/reboot_chance)
	if (!src.powernet)
		return

	for(var/obj/machinery/power/terminal/T in src.powernet.nodes)
		if(istype(T.master, /obj/machinery/power/apc))
			var/obj/machinery/power/apc/A = T.master
			if (prob(overload_chance))
				A.overload_lighting()
			if (prob(failure_chance))
				A.set_broken()
			if(prob(reboot_chance))
				A.energy_fail(rand(30,60))

// Proc: update_icon()
// Parameters: None
// Description: Allows us to use special icon overlay for critical SMESs
/obj/machinery/power/smes/buildable/update_icon()
	if(failing)
		cut_overlays()
		add_overlay("smes-crit")
		add_overlay("smes-crit_screen")
	else
		..()

// Proc: attackby()
// Parameters: 2 (W - object that was used on this machine, user - person which used the object)
// Description: Handles tool interaction. Allows deconstruction/upgrading/fixing.
/obj/machinery/power/smes/buildable/attackby(var/obj/item/W as obj, var/mob/user as mob)
	// No more disassembling of overloaded SMESs. You broke it, now enjoy the consequences.
	if (failing)
		to_chat(user, "<span class='warning'>The [src]'s screen is flashing with alerts. It seems to be overloaded! Touching it now is probably not a good idea.</span>")
		return
	// If parent returned 1:
	// - Hatch is open, so we can modify the SMES
	// - No action was taken in parent function (terminal de/construction atm).
	if (..())
		if(W.iswelder())
			if(health == initial(health))
				to_chat(user, SPAN_WARNING("\The [src] is already repaired."))
				return
			var/obj/item/weldingtool/WT = W
			if(!WT.welding)
				to_chat(user, SPAN_WARNING("\The [src] isn't lit."))
				return
			if(WT.get_fuel() < 2)
				to_chat(user, SPAN_WARNING("You don't have enough fuel to repair \the [src]."))
				return
			if(WT.use_tool(src, user, 50, volume = 50) && WT.use(2, user))
				health = min(health + 100, initial(health))
				to_chat(user, SPAN_NOTICE("You repair \the [src], it is now [round((health / initial(health)) * 100)]% repaired."))
				if(health == initial(health))
					busted = FALSE
				return
		// Multitool - change RCON tag
		if(W.ismultitool())
			var/newtag = input(user, "Enter new RCON tag. Use \"NO_TAG\" to disable RCON or leave empty to cancel.", "SMES RCON system") as text
			if(newtag)
				RCon_tag = newtag
				to_chat(user, "<span class='notice'>You changed the RCON tag to: [newtag]</span>")
			return
		// Charged above 1% and safeties are enabled.
		if((charge > (capacity/100)) && safeties_enabled)
			to_chat(user, "<span class='warning'>Safety circuit of [src] is preventing modifications while it's charged!</span>")
			return

		if (output_attempt || input_attempt)
			to_chat(user, "<span class='warning'>Turn off the [src] first!</span>")
			return

		// Probability of failure if safety circuit is disabled (in %)
		var/failure_probability = round((charge / capacity) * 100)

		// If failure probability is below 5% it's usually safe to do modifications
		if (failure_probability < 5)
			failure_probability = 0

		// Crowbar - Disassemble the SMES.
		if(W.iscrowbar())
			if (terminal)
				to_chat(user, "<span class='warning'>You have to disassemble the terminal first!</span>")
				return

			playsound(get_turf(src), W.usesound, 50, 1)
			to_chat(user, "<span class='warning'>You begin to disassemble the [src]!</span>")
			if (do_after(usr, 100 * cur_coils, src, DO_REPAIR_CONSTRUCT)) // More coils = takes longer to disassemble. It's complex so largest one with 5 coils will take 50s

				if (failure_probability && prob(failure_probability))
					total_system_failure(failure_probability, user)
					return

				to_chat(usr, "<span class='warning'>You have disassembled the SMES cell!</span>")
				var/obj/machinery/constructable_frame/machine_frame/M = new /obj/machinery/constructable_frame/machine_frame(src.loc)
				M.state = 2
				M.icon_state = "box_1"
				for(var/obj/I in component_parts)
					I.forceMove(src.loc)
					component_parts -= I
				qdel(src)
				return

		// Superconducting Magnetic Coil - Upgrade the SMES
		else if(istype(W, /obj/item/smes_coil))
			if (cur_coils < max_coils)

				if (failure_probability && prob(failure_probability))
					total_system_failure(failure_probability, user)
					return

				to_chat(usr, "You install the coil into the SMES unit!")
				user.drop_from_inventory(W,src)
				cur_coils ++
				component_parts += W
				recalc_coils()
			else
				to_chat(usr, "<span class='warning'>You can't insert more coils to this SMES unit!</span>")

// Proc: toggle_input()
// Parameters: None
// Description: Switches the input on/off depending on previous setting
/obj/machinery/power/smes/buildable/proc/toggle_input()
	inputting(!input_attempt)
	update_icon()

// Proc: toggle_output()
// Parameters: None
// Description: Switches the output on/off depending on previous setting
/obj/machinery/power/smes/buildable/proc/toggle_output()
	outputting(!output_attempt)
	update_icon()

// Proc: set_input()
// Parameters: 1 (new_input - New input value in Watts)
// Description: Sets input setting on this SMES. Trims it if limits are exceeded.
/obj/machinery/power/smes/buildable/proc/set_input(var/new_input = 0)
	input_level = between(0, new_input, input_level_max)
	update_icon()

// Proc: set_output()
// Parameters: 1 (new_output - New output value in Watts)
// Description: Sets output setting on this SMES. Trims it if limits are exceeded.
/obj/machinery/power/smes/buildable/proc/set_output(var/new_output = 0)
	output_level = between(0, new_output, output_level_max)
	update_icon()
