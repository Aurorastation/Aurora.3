//Define a macro that we can use to assemble all the circuit board names
#ifdef T_BOARD
#error T_BOARD already defined elsewhere, we can't use it.
#endif
#define T_BOARD(name)	"circuit board (" + (name) + ")"

/obj/item/circuitboard
	name = "circuit board"
	desc = "A circuitboard, an electronic device which forms the backbone of most modern machinery."
	icon = 'icons/obj/module.dmi'
	icon_state = "id_mod"
	item_state = "electronic"
	origin_tech = list(TECH_DATA = 2)
	w_class = ITEMSIZE_SMALL
	flags = CONDUCT
	force = 5
	throwforce = 5
	throw_speed = 3
	throw_range = 15
	var/build_path
	var/board_type = "computer"
	var/list/req_components
	var/contain_parts = 1

/obj/item/circuitboard/examine(mob/user)
	..()
	if(build_path)
		var/obj/machine = new build_path // instantiate to get the name and desc
		to_chat(user, FONT_SMALL(SPAN_NOTICE("This circuitboard will build a <b>[capitalize_first_letters(machine.name)]</b>: [machine.desc]")))
	if(board_type == BOARD_COMPUTER) // does not have build components, only goes into a frame
		to_chat(user, SPAN_NOTICE("This board is used inside a <b>computer frame</b>."))
	else if(req_components)
		to_chat(user, SPAN_NOTICE("To build this machine, you will require:"))
		for(var/I in req_components)
			if(req_components[I] > 0)
				var/obj/component = new I // instantiate to get the name
				to_chat(user, SPAN_NOTICE("- [num2text(req_components[I])] <b>[capitalize_first_letters(component.name)]</b>"))

//Called when the circuitboard is used to contruct a new machine.
/obj/item/circuitboard/proc/construct(var/obj/machinery/M)
	if (istype(M, build_path))
		return 1
	return 0

//Called when a computer is deconstructed to produce a circuitboard.
//Only used by computers, as other machines store their circuitboard instance.
/obj/item/circuitboard/proc/deconstruct(var/obj/machinery/M)
	if (istype(M, build_path))
		return 1
	return 0
