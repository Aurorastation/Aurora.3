/obj/abstract
	name          = ""
	icon          = 'icons/effects/landmarks.dmi'
	icon_state    = "x2"
	simulated     = FALSE
	density       = FALSE
	anchored      = TRUE
	abstract_type = /obj/abstract
	invisibility  = INVISIBILITY_ABSTRACT

/obj/abstract/Initialize()
	. = ..()
	verbs.Cut()
	//Let mappers see the damn thing by just making them invisible here
	opacity       =  FALSE
	alpha         =  0
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/abstract/ex_act()
	SHOULD_CALL_PARENT(FALSE)
	return
