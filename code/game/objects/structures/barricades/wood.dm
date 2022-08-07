/obj/structure/barricade/wooden
	name = "wooden barricade"
	desc = "A wall made out of wooden planks nailed together. Not very sturdy, but can provide some concealment."
	icon_state = "wooden"
	health = 100
	maxhealth = 100
	layer = OBJ_LAYER
	stack_type = /obj/item/stack/material/wood
	stack_amount = 5
	build_amt = 5
	destroyed_stack_amount = 3
	barricade_hitsound = 'sound/effects/woodhit.ogg'
	can_change_dmg_state = 0
	barricade_type = "wooden"
	can_wire = FALSE
	metallic = FALSE

/obj/structure/barricade/wooden/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/stack/material/wood))
		var/obj/item/stack/material/wood/D = W
		if(health < maxhealth)
			if(D.get_amount() < 1)
				to_chat(user, SPAN_WARNING("You need one plank of wood to repair [src]."))
				return
			visible_message(SPAN_NOTICE("[user] begins to repair [src]."))
			if(do_after(user, 2 SECONDS, act_target = src) && (health < maxhealth))
				if(D.use(1))
					update_health(-0.5*maxhealth)
					update_damage_state()
					visible_message(SPAN_NOTICE("[user] clumsily repairs [src]."))
		return

	. = ..()
