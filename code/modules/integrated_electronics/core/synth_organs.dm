/obj/item/integrated_circuit/built_in/drain
	name = "drain"
	desc = "A drain to safely dispose of excess chemicals in organic or synthetic entities."
	outputs = list("self reference" = IC_PINTYPE_REF)

/obj/item/integrated_circuit/built_in/drain/interact(mob/user)
	set_pin_data(IC_OUTPUT, 1, WEAKREF(src))
	push_data()
	..()

/obj/item/integrated_circuit/built_in/drain/on_reagent_change()
	clear_reagents() // it's a drain!

/obj/item/integrated_circuit/built_in/organ/sensor/
	name = "reagent sensor"
	desc = "A sensor to detect the presence of reagents in an assembly."
	activators = list("on chemical presence")

///////////////////
// ORGAN DEFINES //
///////////////////

#define SYNTHORGAN(_tname, _par, _name)\
	obj/item/organ{\
		_tname/circuit {\
			name = _name ;\
			organ_tag = _tname;\
			robotic = 2;\
			robotic_name = _name;\
			parent_organ = _par;\
			var/opened = 0;\
			var/obj/item/device/electronic_assembly/medium/EA;\
			Initialize(){\
				EA = new(src);\
				EA.holder = src;\
				. = ..()\
			}\
			attackby(obj/item/I, mob/user){\
				if (I.iscrowbar()){ toggle_open(user) }\
				else if (opened){ EA.attackby(I, user) }\
				else {..()}\
			}\
			proc/toggle_open(mob/user){\
				playsound(get_turf(src), 'sound/items/Crowbar.ogg', 50, 1);\
				opened = !opened;\
				EA.opened = opened;\
				to_chat(user, "<span class='notice'>You [opened ? "open" : "close"] \the [src].</span>");\
				update_icon()\
			}\
			attack_self(mob/user as mob){\
				if(EA){	EA.attack_self(user) }\
				. = ..()\
			}\
			examine(mob/user){\
				. = ..(user, 1);\
				if(EA){\
					for(var/obj/item/integrated_circuit/IC in EA.contents){IC.external_examine(user)}\
					if(opened){interact(user)}\
				}\
			}\
		}\
	}

/obj/item/device/electronic_assembly/organ/
	icon_state = "setup_medium"
	desc = "It's a medium-sized electronic device for use in prosthetic lungs."
	w_class = ITEMSIZE_SMALL
	max_components = IC_COMPONENTS_BASE * 2
	max_complexity = IC_COMPLEXITY_BASE * 2

/obj/item/device/electronic_assembly/organ/check_interactivity(mob/user)
	if(!CanInteract(user, state = deep_inventory_state))
		return 0
	return 1

/obj/item/integrated_circuit/built_in/organ/
	outputs = list("container reference" = IC_PINTYPE_REF)

/obj/item/integrated_circuit/built_in/organ/interact(mob/user)
	if(!istype(loc, /obj/item/organ) || !loc.reagents)
		return
	set_pin_data(IC_OUTPUT, 1, WEAKREF(loc.reagents))
	push_data()
	..()

///////////////////////
// ORGANS BELOW HERE //
///////////////////////

SYNTHORGAN(lungs, "chest", "custom gas exchange system")
SYNTHORGAN(stomach, "stomach", "custom reagent processor")

/obj/item/organ/stomach/circuit
	icon_state = "innards-prosthetic"
	gender = NEUTER
	robotic_sprite = "innards-prosthetic"
	desc = "It's a stomach prosthetic with the ability to add custom circuitry."
	
/obj/item/device/electronic_assembly/organ/stomach
	name = "electronic reagent processor"
	desc = "It's a medium-sized electronic device for use in prosthetic stomachs."

/obj/item/integrated_circuit/built_in/organ/stomach/
	name = "reagent processor"
	desc = "A reagent processor for the handling of ingested chemicals."
	activators = list("flush to system" = IC_PINTYPE_PULSE_IN, "on chemical ingestion" = IC_PINTYPE_PULSE_OUT)
	
/obj/item/integrated_circuit/built_in/organ/stomach/do_work()
	

/obj/item/organ/stomach/circuit/process()
	return // everything should be handled by the circuit

/obj/item/device/electronic_assembly/organ/stomach/Initialize()
	. = ..()
	var/obj/item/integrated_circuit/built_in/organ/stomach/stomach = new(src)
	var/obj/item/integrated_circuit/built_in/drain/drain = new(src)
	var/obj/item/integrated_circuit/built_in/sensor/sensor = new(src)
	sensor.assembly = src
	drain.assembly = src
	stomach.assembly = src

/obj/item/organ/lungs/circuit
	icon_state = "lungs-prosthetic"
	gender = PLURAL
	robotic_sprite = "lungs-prosthetic"
	desc = "It's a lung prosthetic with the ability to add custom circuitry."

/obj/item/device/electronic_assembly/organ/lungs
	name = "electronic gas exchange system"
	icon_state = "setup_medium"
	desc = "It's a medium-sized electronic device for use in prosthetic lungs."

/obj/item/integrated_circuit/built_in/organ/lungs/
	name = "gas processor"
	desc = "A gas processor for the handling of inhaled chemicals."
	activators = list("flush to system" = IC_PINTYPE_PULSE_IN, "on chemical inhalation" = IC_PINTYPE_PULSE_OUT)

/obj/item/device/electronic_assembly/organ/lungs/Initialize()
	. = ..()
	var/obj/item/integrated_circuit/built_in/organ/lungs/lungs = new(src)
	var/obj/item/integrated_circuit/built_in/drain/drain = new(src)
	var/obj/item/integrated_circuit/built_in/sensor/sensor = new(src)
	sensor.assembly = src
	drain.assembly = src
	lungs.assembly = src

