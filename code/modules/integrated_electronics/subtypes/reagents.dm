/obj/item/integrated_circuit/reagent
	category_text = "Reagent"
	var/volume = 0
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)

/obj/item/integrated_circuit/reagent/Initialize()
	. = ..()
	if(volume)
		create_reagents(volume)

/obj/item/integrated_circuit/reagent/smoke
	name = "smoke generator"
	desc = "Unlike most electronics, creating smoke is completely intentional."
	icon_state = "smoke"
	extended_desc = "This smoke generator creates clouds of smoke on command.  It can also hold liquids inside, which will go \
	into the smoke clouds when activated.  The reagents are consumed when smoke is made."
	flags = OPENCONTAINER
	complexity = 20
	cooldown_per_use = 30 SECONDS
	inputs = list()
	outputs = list("volume used" = IC_PINTYPE_NUMBER,"self reference" = IC_PINTYPE_REF)
	activators = list("create smoke" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3, TECH_BIO = 3)
	volume = 100
	power_draw_per_use = 20

/obj/item/integrated_circuit/reagent/smoke/on_reagent_change()
	set_pin_data(IC_OUTPUT, 1, reagents.total_volume)
	push_data()

/obj/item/integrated_circuit/reagent/smoke/interact(mob/user)
	set_pin_data(IC_OUTPUT, 2, src)
	push_data()
	..()

/obj/item/integrated_circuit/reagent/smoke/do_work()
	playsound(src.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
	var/datum/effect/effect/system/smoke_spread/chem/smoke_system = new()
	smoke_system.set_up(reagents, 10, 0, get_turf(src))
	spawn(0)
		for(var/i = 1 to 8)
			smoke_system.start()
		reagents.clear_reagents()

/obj/item/integrated_circuit/reagent/injector
	name = "integrated hypo-injector"
	desc = "This scary looking thing is able to pump liquids into whatever it's pointed at."
	icon_state = "injector"
	extended_desc = "This autoinjector can push reagents into another container or someone else outside of the machine.  The target \
	must be adjacent to the machine, and if it is a person, they cannot be wearing thick clothing."
	flags = OPENCONTAINER
	complexity = 20
	cooldown_per_use = 6 SECONDS
	inputs = list("target" = IC_PINTYPE_REF, "injection amount" = IC_PINTYPE_NUMBER)
	inputs_default = list("2" = 5)
	outputs = list("volume used" = IC_PINTYPE_NUMBER,"self reference" = IC_PINTYPE_REF)
	activators = list("inject" = IC_PINTYPE_PULSE_IN, "on injected" = IC_PINTYPE_PULSE_OUT, "on fail" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	volume = 30
	power_draw_per_use = 15
	var/direc = 1
	var/transfer_amount = 10

/obj/item/integrated_circuit/reagent/injector/interact(mob/user)
	set_pin_data(IC_OUTPUT, 2, src)
	push_data()
	..()

/obj/item/integrated_circuit/reagent/injector/on_reagent_change()
	set_pin_data(IC_OUTPUT, 1, reagents.total_volume)
	push_data()


/obj/item/integrated_circuit/reagent/injector/on_data_written()
	var/new_amount = get_pin_data(IC_INPUT, 2)
	if(new_amount < 0)
		new_amount = -new_amount
		direc = 0
	else
		direc = 1
	if(isnum(new_amount))
		new_amount = Clamp(new_amount, 0, volume)
		transfer_amount = new_amount

/obj/item/integrated_circuit/reagent/injector/do_work()
	set waitfor = 0 // Don't sleep in a proc that is called by a processor without this set, otherwise it'll delay the entire thing

	var/atom/movable/AM = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	if(!istype(AM)) //Invalid input
		activate_pin(3)
		return

	if(direc == 1)

		if(!istype(AM)) //Invalid input
			activate_pin(3)
			return
		if(!reagents.total_volume) // Empty
			activate_pin(3)
			return
		if(AM.can_be_injected_by(src))
			if(isliving(AM))
				var/mob/living/L = AM
				var/turf/T = get_turf(AM)
				T.visible_message("<span class='warning'>[assembly] is trying to inject [L]!</span>")
				sleep(3 SECONDS)
				if(!L.can_be_injected_by(src))
					activate_pin(3)
					return
				var/contained = reagents.get_reagents()
				var/trans = reagents.trans_to_mob(L, transfer_amount, CHEM_BLOOD)
				message_admins("[assembly] injected \the [L] with [trans]u of [contained].")
				to_chat(AM, "<span class='notice'>You feel a tiny prick!</span>")
				visible_message("<span class='warning'>[assembly] injects [L]!</span>")
			else
				reagents.trans_to(AM, transfer_amount)
	else

		if(reagents.total_volume >= volume) // Full
			activate_pin(3)
			return
		var/obj/target = AM
		if(!target.reagents)
			activate_pin(3)
			return
		var/turf/TS = get_turf(src)
		var/turf/TT = get_turf(AM)
		if(!TS.Adjacent(TT))
			activate_pin(3)
			return
		var/tramount = Clamp(min(transfer_amount, REAGENTS_FREE_SPACE(reagents)), 0, reagents.maximum_volume)
		if(ismob(target))//Blood!
			if(istype(target, /mob/living/carbon))
				var/mob/living/carbon/T = target
				if(!T.dna)
					if(T.reagents.trans_to_obj(src, tramount))
						activate_pin(2)
					else
						activate_pin(3)
					return
				if(NOCLONE in T.mutations) //target done been et, no more blood in him
					if(T.reagents.trans_to_obj(src, tramount))
						activate_pin(2)
					else
						activate_pin(3)
					return
				T.take_blood(src,tramount)
				visible_message( "<span class='notice'>[assembly] takes a blood sample from [target].</span>")
			else
				activate_pin(3)
				return

		else //if not mob
			if(!target.reagents.total_volume)
				visible_message( "<span class='notice'>[target] is empty.</span>")
				activate_pin(3)
				return
			target.reagents.trans_to_obj(src, tramount)
	activate_pin(2)

/obj/item/integrated_circuit/reagent/pump
	name = "reagent pump"
	desc = "Moves liquids safely inside a machine, or even nearby it."
	icon_state = "reagent_pump"
	extended_desc = "This is a pump, which will move liquids from the source ref to the target ref.  The third pin determines \
	how much liquid is moved per pulse, between 0 and 50.  The pump can move reagents to any open container inside the machine, or \
	outside the machine if it is next to the machine.  Note that this cannot be used on entities."
	flags = OPENCONTAINER
	complexity = 8
	inputs = list(
		"source" = IC_PINTYPE_REF,
		"target" = IC_PINTYPE_REF,
		"injection amount" = IC_PINTYPE_NUMBER
	)
	inputs_default = list("3" = 5)
	outputs = list()
	activators = list(
		"transfer reagents" = IC_PINTYPE_PULSE_IN,
		"on transfer" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)
	var/transfer_amount = 10
	var/direc = 1
	power_draw_per_use = 10

/obj/item/integrated_circuit/reagent/pump/on_data_written()
	var/new_amount = get_pin_data(IC_INPUT, 3)
	if(new_amount < 0)
		new_amount = -new_amount
		direc = 0
	else
		direc = 1
	if(isnum(new_amount))
		new_amount = Clamp(new_amount, 0, 50)
		transfer_amount = new_amount

/obj/item/integrated_circuit/reagent/pump/do_work()
	var/atom/movable/source = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	var/atom/movable/target = get_pin_data_as_type(IC_INPUT, 2, /atom/movable)
	if(!source)
		return

	var/obj/item/integrated_circuit/insert_slot/beaker_holder/beaker_slot = source
	if(istype(beaker_slot))
		source = beaker_slot.get_item(FALSE)
	if(!istype(source) || (!istype(target))) //Invalid input
		return
	if((src.Adjacent(source)  || istype(beaker_slot)) && src.Adjacent(target))
		if(!source.reagents || !target.reagents)
			return
		if(ismob(source) || ismob(target))
			return
		if(!source.is_open_container() || !target.is_open_container())
			return
		if(direc)
			if(!REAGENTS_FREE_SPACE(target.reagents))
				return
			source.reagents.trans_to(target, transfer_amount)
		else
			if(!REAGENTS_FREE_SPACE(source.reagents))
				return
			target.reagents.trans_to(source, transfer_amount)
		activate_pin(2)

/obj/item/integrated_circuit/reagent/storage
	name = "reagent storage"
	desc = "Stores liquid inside, and away from electrical components.  Can store up to 60u."
	icon_state = "reagent_storage"
	extended_desc = "This is effectively an internal beaker."
	flags = OPENCONTAINER
	complexity = 4
	inputs = list()
	outputs = list("volume used" = IC_PINTYPE_NUMBER, "self reference" = IC_PINTYPE_REF)
	activators = list()
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)
	volume = 60

/obj/item/integrated_circuit/reagent/storage/on_reagent_change()
	set_pin_data(IC_OUTPUT, 1, reagents.total_volume)
	push_data()

/obj/item/integrated_circuit/reagent/storage/interact(mob/user)
	set_pin_data(IC_OUTPUT, 2, src)
	push_data()
	..()

/obj/item/integrated_circuit/reagent/storage/cryo
	name = "cryo reagent storage"
	desc = "Stores liquid inside, and away from electrical components.  Can store up to 60u.  This will also suppress reactions."
	icon_state = "reagent_storage_cryo"
	extended_desc = "This is effectively an internal cryo beaker."
	flags = OPENCONTAINER | NOREACT
	complexity = 8
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)

/obj/item/integrated_circuit/reagent/storage/big
	name = "big reagent storage"
	desc = "Stores liquid inside, and away from electrical components.  Can store up to 180u."
	icon_state = "reagent_storage_big"
	extended_desc = "This is effectively an internal beaker."
	flags = OPENCONTAINER
	complexity = 16
	volume = 180
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)

/obj/item/integrated_circuit/reagent/storage/scan
	name = "reagent scanner"
	desc = "Stores liquid inside, and away from electrical components.  Can store up to 60u.  On pulse this beaker will send list of contained reagents, as well as analyse their taste."
	icon_state = "reagent_scan"
	extended_desc = "Mostly useful for reagent filters."
	flags = OPENCONTAINER
	complexity = 8
	outputs = list("volume used" = IC_PINTYPE_NUMBER,"self reference" = IC_PINTYPE_REF,"list of reagents" = IC_PINTYPE_LIST,"taste" = IC_PINTYPE_STRING)
	activators = list("scan" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)

/obj/item/integrated_circuit/reagent/storage/scan/do_work()
	var/list/cont = list()
	for(var/_RE in reagents.reagent_volumes)
		var/decl/reagent/RE = decls_repository.get_decl(_RE)
		cont += RE.name
	set_pin_data(IC_OUTPUT, 3, cont)
	set_pin_data(IC_OUTPUT, 4, reagents.generate_taste_message(src))
	push_data()


/obj/item/integrated_circuit/reagent/filter
	name = "reagent filter"
	desc = "Filtering liquids by list of desired or unwanted reagents."
	icon_state = "reagent_filter"
	extended_desc = "This is a filter which will move liquids from the source ref to the target ref. \
	It will move all reagents, except list, given in fourth pin if amount value is positive.\
	Or it will move only desired reagents if amount is negative, The third pin determines \
	how much reagent is moved per pulse, between 0 and 50. Amount is given for each separate reagent."
	flags = OPENCONTAINER
	complexity = 8
	inputs = list("source" = IC_PINTYPE_REF, "target" = IC_PINTYPE_REF, "injection amount" = IC_PINTYPE_NUMBER, "list of reagents" = IC_PINTYPE_LIST)
	inputs_default = list("3" = 5)
	outputs = list()
	activators = list("transfer reagents" = IC_PINTYPE_PULSE_IN, "on transfer" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)
	var/transfer_amount = 10
	var/direc = 1
	power_draw_per_use = 10

/obj/item/integrated_circuit/reagent/filter/on_data_written()
	var/new_amount = get_pin_data(IC_INPUT, 3)
	if(new_amount < 0)
		new_amount = -new_amount
		direc = 0
	else
		direc = 1
	if(isnum(new_amount))
		new_amount = Clamp(new_amount, 0, 50)
		transfer_amount = new_amount

/obj/item/integrated_circuit/reagent/filter/do_work()
	var/atom/movable/source = get_pin_data_as_type(IC_INPUT, 1, /atom/movable)
	var/atom/movable/target = get_pin_data_as_type(IC_INPUT, 2, /atom/movable)
	var/list/demand = get_pin_data(IC_INPUT, 4)
	if(!istype(source) || !istype(target)) //Invalid input
		return
	var/turf/T = get_turf(src)
	if(source.Adjacent(T) && target.Adjacent(T))
		if(!source.reagents || !target.reagents)
			return
		if(ismob(source) || ismob(target))
			return
		if(!source.is_open_container() || !target.is_open_container())
			return
		if(!REAGENTS_FREE_SPACE(target.reagents))
			return
		for(var/_G in source.reagents.reagent_volumes)
			var/decl/reagent/G = decls_repository.get_decl(_G)
			if (!direc)
				if(lowertext(G.name) in demand)
					source.reagents.trans_type_to(target, _G, transfer_amount)
			else
				if(!(lowertext(G.name) in demand))
					source.reagents.trans_type_to(target, _G, transfer_amount)
		activate_pin(2)
		push_data()
