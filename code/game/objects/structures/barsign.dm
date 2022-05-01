/*
/obj/structure/sign/double/barsign
	icon = 'icons/obj/barsigns.dmi'
	icon_state = "empty"
	anchored = 1
	var/cult = 0
	req_access = list(access_bar) //Has to initalize at first, this is updated by instance's req_access

/obj/structure/sign/double/barsign/proc/get_valid_states(initial=1)
	. = icon_states(icon)
	. -= "on"
	. -= "narsiebistro"
	. -= "empty"
	if(initial)
		. -= "Off"

/obj/structure/sign/double/barsign/examine(mob/user)
	..()
	switch(icon_state)
		if("Off")
			to_chat(user, "It appears to be switched off.")
		if("narsiebistro")
			to_chat(user, "It shows a picture of a large black and red being. Spooky!")
		if("on", "empty")
			to_chat(user, "The lights are on, but there's no picture.")
		else
			to_chat(user, "It says '[icon_state]'")

/obj/structure/sign/double/barsign/Initialize()
	. = ..()
	icon_state = pick(get_valid_states())

/obj/structure/sign/double/barsign/attackby(obj/item/I, mob/user)
	if(cult)
		return ..()

	var/obj/item/card/id/card = I.GetID()
	if(istype(card))
		if(check_access(card))
			var/sign_type = input(user, "What would you like to change the barsign to?") as null|anything in get_valid_states(0)
			if(!sign_type)
				return
			icon_state = sign_type
			to_chat(user, "<span class='notice'>You change the barsign.</span>")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
		return

	return ..()
	*/

/obj/structure/sign/double/barsign
	icon = 'icons/obj/barsigns.dmi'
	icon_state = "Off"
	anchored = 1
	var/cult = 0
	req_access = list(access_bar) //Has to initalize at first, this is updated by instance's req_access
	var/choice_types = /decl/sign/double/bar

/obj/structure/sign/double/barsign/kitchensign
	icon = 'icons/obj/kitchensigns.dmi'
	icon_state = "Off"
	choice_types = /decl/sign/double/kitchen

/obj/structure/sign/double/barsign/attackby(obj/item/I, mob/user)
	if(cult)
		return ..()	
	var/obj/item/card/id/card = I.GetID()
	if(istype(card))
		if(check_access(card))
			set_sign()
			to_chat(user, "<span class='notice'>You change the sign.</span>")
		else
			to_chat(user, "<span class='warning'>Access denied.</span>")
		return

	return ..()

/decl/sign/double
	var/name = "Holographic Projector"
	var/icon_state = "Off"
	var/desc = "A holographic projector, displaying different saved themes. It is turned off right now."
	var/desc_fluff = "To change the displayed theme, use your bartender's or chef's ID on it and select something from the menu. There are two different selections for the bar and the kitchen."

/decl/sign/double/off
	name = "Holgraphic Projector"
	icon_state = "Off"
	desc = "A holographic projector, displaying different saved themes. It is turned off right now."
	desc_fluff = "To change the displayed theme, use your bartender's or chef's ID on it and select something from the menu. There are two different selections for the bar and the kitchen."

/decl/sign/double/bar/whiskey_implant
	name = "Whiskey Implant"
	icon_state = "Whiskey Implant"	
	desc = "This bar is called Whiskey Implant!"
	desc_fluff = "Specializes in whiskey!"

/decl/sign/double/kitchen/event_horizon
	name = "Event Horizon"
	icon_state = "Event Horizon"
	desc = "The SCCV Horizon's Kitchen franchise sign."
	desc_fluff = "Since the start of the SCCV Horizon, the SCC has been trying to establish a proper franchise on board of it's long-range vessels. Since the first test runs were done on the Horizon, the name 'Event Horizon' has been chosen to commemorate this."

/obj/structure/sign/double/barsign/proc/get_sign_choices()
	var/list/sign_choices = decls_repository.get_decls_of_subtype(choice_types)
	return sign_choices

/obj/structure/sign/double/barsign/proc/set_sign()  // -- player picks a sign name they want from the list of 'sign choices', bar or kitchen
    var/list/sign_choices = get_sign_choices()

    var/list/sign_index = list()
    for(var/sign in sign_choices)
        var/decl/sign/double/B = decls_repository.get_decl(sign)
        sign_index["[B.name]"] = B

    var/sign_choice = input("What should the sign be changed to?") as null|anything in sign_index
    if(!sign_choice)
        return
    var/decl/sign/double/signselect = sign_index[sign_choice]
    
    name = signselect.name
    desc = signselect.desc
    desc_fluff = signselect.desc_fluff
    icon_state = signselect.icon_state
    update_icon()
