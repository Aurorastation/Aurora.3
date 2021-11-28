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
	var/distance = 10
	var/search_interval = 30 SECONDS

/obj/item/clothing/accessory/buddytag/Initialize()
	. = ..()
	id = round(rand(1, 1000))

/obj/item/clothing/accessory/buddytag/update_icon()
	icon_state = "buddytag[on]"

/obj/item/clothing/accessory/buddytag/attack_self(mob/user)
	if(use_check_and_message(user))
		return

	var/list/dat = "<A href='?src=\ref[src];toggle=1;'>[on ? "Disable" : "Enable"]</a>"
	dat += "<br>ID: <A href='?src=\ref[src];setcode=1;'>[id]</a>"
	dat += "<br>Search Interval: <A href='?src=\ref[src];set_interval=1;'>[search_interval/10] seconds</a>"
	dat += "<br>Search Distance: <A href='?src=\ref[src];set_distance=1;'>[distance]</a>"

	var/datum/browser/popup = new(user, "buddytag", "Buddy Tag", 290, 200)
	popup.set_content(JOINTEXT(dat))
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
		var/newcode = input("Set new buddy ID number.", "Buddy Tag ID", id) as num|null
		if(isnull(newcode) || !CanInteract(usr, state))
			return
		id = newcode
	if(href_list["set_distance"])
		var/newdist = input("Set new maximum range.", "Buddy Tag Range", distance) as num|null
		if(isnull(newdist) || !CanInteract(usr, state))
			return
		distance = newdist
	if(href_list["set_interval"])
		var/newtime = input("Set new search interval in seconds (minimum 30s).", "Buddy Tag Time Interval", search_interval / 10) as num|null
		if(isnull(newtime) || !CanInteract(usr, state))
			return
		newtime = max(30, newtime)
		search_interval = newtime SECONDS
	attack_self(usr)

/obj/item/clothing/accessory/buddytag/process()
	if(!on)
		return PROCESS_KILL
	if(world.time < next_search)
		return
	next_search = world.time + search_interval
	var/has_friend
	for(var/obj/item/clothing/accessory/buddytag/buddy as anything in active_buddy_tags - src)
		if(buddy.id != id)
			continue
		if(GET_Z(buddy) != GET_Z(src))
			continue
		if(get_dist(get_turf(src), get_turf(buddy)) <= distance)
			has_friend = TRUE
			break
	if(!has_friend)
		playsound(src, 'sound/machines/twobeep.ogg', 10)
		var/turf/T = get_turf(src)
		if(T)
			T.visible_message(SPAN_WARNING("[src] beeps anxiously."), range = 3)