/obj/item/melee/flip_knife
	name = "flip knife"
	desc = "A simple pocket knife, opened with a flipping motion."
	icon_state = "chain"
	item_state = "chain"
	slot_flags = SLOT_POCKET
	throwforce = 1
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("patted", "tapped")
	var/active = 1
	hitsound = null
	active = 0

/obj/item/melee/flip_knife/update_force()
	if(active)
		edge = TRUE
		sharp = 1
		..() //Updates force.
		throwforce = max(3,force-3)
		icon_state += "_open"
		item_state = icon_state
		hitsound = 'sound/weapons/bladeslice.ogg'
		w_class = WEIGHT_CLASS_NORMAL
		attack_verb = list("attacked", "slashed", "stabbed", "sliced", "cut")
	else
		force = 3
		edge = FALSE
		sharp = 0
		hitsound = initial(hitsound)
		icon_state = initial(icon_state)
		item_state = initial(item_state)
		w_class = initial(w_class)
		attack_verb = initial(attack_verb)

/obj/item/melee/flip_knife/attack_self(mob/user)
	active = !active
	if(active)
		to_chat(user, SPAN_NOTICE("You flip out \the [src]."))
		playsound(user, 'sound/weapons/blade_open.ogg', 15, 1)
	else
		to_chat(user, SPAN_NOTICE("\The [src] can now be concealed."))
		playsound(user, 'sound/weapons/blade_close.ogg', 15, 1)
	update_force()
	add_fingerprint(user)

/obj/item/melee/flip_knife/pocket_knife
	name = "pocket knife"
	desc = "A traditional pocket knife, perfect for opening letter, cutting up boxes, whittling wood, or anything else. The handle comes in 24 different colors."
	desc_extended = "The H30V4 pocket knife, produced by Hephaestus Industries, is credited as the single most produced pocket knife in human history. \
	With a tanto style blade, high quality steel, and a surprisingly sturdy textured plastic handle, its a true every person tool. Titanius Aeson himself \
	carries one, with a customized handle, on his person. He's even frequently seen using it both on and off camera. Critics of the knife are quick to point\
	out that the plastic used is prone to becoming brittle after about 10 years. However, fans of the blade point to its easy disassembly and readily\
	available replacement handles as providing an easy way to simply replace the worn out piece yourself."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "pocketgreen"

/obj/item/melee/flip_knife/pocket_knife/blue
	icon_state = "pocketblue"

/obj/item/melee/flip_knife/pocket_knife/red
	icon_state = "pocketred"
