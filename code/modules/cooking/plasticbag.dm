/obj/item/evidencebag/plasticbag
	name = "resealable plastic bag"
	desc = "An Idris Quiklok plastic bag."

/obj/item/evidencebag/plasticbag/attack_self(mob/user)
	if(contents.len)
		var/obj/item/I = contents[1]
		user.visible_message("<b>[user]</b> takes \the [I] out of \the [src].", SPAN_NOTICE("You take \the [I] out of \the [src]."),\
		"You hear someone rustle around in a plastic bag, and remove something.")
		cut_overlays()	//remove the overlays

		user.put_in_hands(I)
		stored_item = null

		w_class = initial(w_class)
		icon_state = "evidenceobj"
		desc = "An empty Idris Quicklok plastic bag."
	else
		to_chat(user, "[src] is empty.")
		icon_state = "evidenceobj"
	return

/obj/item/storage/box/plasticbag
	name = "resealable plastic bag box"
	desc = "A box advertising its dazzling contents: 20 resealable Idris Incorporated brand Quiklok bags!"
	illustration = "evidence"
	storage_slots = 20

/obj/item/storage/box/plasticbag/fill()
	..()
	for(var/i=0;i < storage_slots, i++)
		new /obj/item/evidencebag/plasticbag(src)