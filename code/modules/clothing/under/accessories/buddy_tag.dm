var/list/active_buddy_tags = list()

/obj/item/clothing/accessory/buddytag
	name = "buddy tag"
	desc = "A tiny device, paired up with a counterpart set to same code. When the paired devices are too far apart, they start beeping."
	icon = 'icons/clothing/accessories/buddy_tag.dmi'
	icon_state = "buddytag0"
	item_state = "buddytag"
	contained_sprite = TRUE
	slot = ACCESSORY_SLOT_UTILITY_MINOR
	var/next_search = 0
	var/on = FALSE
	var/id = 1

/obj/item/clothing/accessory/buddytag/Initialize()
	. = ..()
	id = round(rand(1, 1000))

/obj/item/clothing/accessory/buddytag/update_icon()
	icon_state = "buddytag[on]"

/obj/item/clothing/accessory/buddytag/attack_self(mob/user)
	if(use_check_and_message(user))
		return

	var/dat = "<A href='?src=\ref[src];toggle=1;'>[on ? "Disable" : "Enable"]</a><br>"
	dat += "ID: <A href='?src=\ref[src];setcode=1;'>[id]</a>"

	var/datum/browser/popup = new(user, "buddytag", "Buddy Tag", 290, 200)
	popup.set_content(dat)
	popup.open()

/obj/item/clothing/accessory/buddytag/Topic(href, href_list, state)
	if(..())
		return

	if(href_list["toggle"])
		on = !on
		if(on)
			next_search = world.time
			active_buddy_tags += src
			START_PROCESSING(SSprocessing, src)
		else
			active_buddy_tags -= src
		update_icon()
	if(href_list["setcode"])
		var/newcode = input("Set new buddy ID number." , "Buddy Tag ID" , "") as num|null
		if(isnull(newcode) || !CanInteract(usr, state))
			return
		id = newcode
	attack_self(usr)

/obj/item/clothing/accessory/buddytag/process()
	if(!on)
		return PROCESS_KILL
	if(world.time < next_search)
		return
	next_search = world.time + 30 SECONDS
	var/has_friend
	for(var/obj/item/clothing/accessory/buddytag/buddy as anything in active_buddy_tags - src)
		if(buddy.id != id)
			continue
		if(GET_Z(buddy) != GET_Z(src))
			continue
		if(get_dist(get_turf(src), get_turf(buddy)) <= 10)
			has_friend = TRUE
			break
	if(!has_friend)
		playsound(src, 'sound/machines/twobeep.ogg', 10)
		var/turf/T = get_turf(src)
		if(T)
			T.visible_message(SPAN_WARNING("[src] beeps anxiously."), range = 3)