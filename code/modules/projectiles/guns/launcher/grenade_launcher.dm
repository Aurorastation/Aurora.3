	name = "grenade launcher"
	desc = "A bulky pump-action grenade launcher. Holds up to 6 grenades in a revolving magazine."
	icon_state = "riotgun"
	item_state = "riotgun"
	w_class = 4
	force = 10

	fire_sound_text = "a metallic thunk"
	recoil = 0
	throw_distance = 7
	release_force = 5

	var/blacklisted_grenades = list(

	var/list/grenades = new/list()
	var/max_grenades = 5 //holds this + one in the chamber
	matter = list(DEFAULT_WALL_MATERIAL = 2000)

//revolves the magazine, allowing players to choose between multiple grenade types

	if(grenades.len)
		next = grenades[1] //get this first, so that the chambered grenade can still be removed if the grenades list is empty
	if(chambered)
		grenades += chambered //rotate the revolving magazine
		chambered = null
	if(next)
		grenades -= next //Remove grenade from loaded list.
		chambered = next
		M << "<span class='warning'>You pump [src], loading \a [next] into the chamber.</span>"
	else
		M << "<span class='warning'>You pump [src], but the magazine is empty.</span>"
	update_icon()

	if(..(user, 2))
		var/grenade_count = grenades.len + (chambered? 1 : 0)
		user << "Has [grenade_count] grenade\s remaining."
		if(chambered)
			user << "\A [chambered] is chambered."

	if(!can_load_grenade_type(G, user))
		return
	if(grenades.len >= max_grenades)
		user << "<span class='warning'>[src] is full.</span>"
		return
	user.remove_from_mob(G)
	G.loc = src
	grenades.Insert(1, G) //add to the head of the list, so that it is loaded on the next pump
	user.visible_message("[user] inserts \a [G] into [src].", "<span class='notice'>You insert \a [G] into [src].</span>")

	if(grenades.len)
		grenades.len--
		user.put_in_hands(G)
		user.visible_message("[user] removes \a [G] from [src].", "<span class='notice'>You remove \a [G] from [src].</span>")
	else
		user << "<span class='warning'>[src] is empty.</span>"

	if(is_type_in_list(G, blacklisted_grenades))
		user << "<span class='warning'>\The [G] doesn't seem to fit in \the [src]!</span>"
		return FALSE
	return TRUE

	pump(user)

		load(I, user)
	else
		..()

	if(user.get_inactive_hand() == src)
		unload(user)
	else
		..()

	if(chambered)
		chambered.det_time = 10
		chambered.activate(null)
	return chambered

	message_admins("[key_name_admin(user)] fired a grenade ([chambered.name]) from a grenade launcher ([src.name]).")
	log_game("[key_name_admin(user)] used a grenade ([chambered.name]).",ckey=key_name(user))
	chambered = null

//Underslung grenade launcher to be used with the Z8
	name = "underslung grenade launcher"
	desc = "Not much more than a tube and a firing mechanism, this grenade launcher is designed to be fitted to a rifle."
	w_class = 3
	force = 5
	max_grenades = 0

	return

//load and unload directly into chambered
	if(chambered)
		user << "<span class='warning'>[src] is already loaded.</span>"
		return
	user.remove_from_mob(G)
	G.loc = src
	chambered = G
	user.visible_message("[user] load \a [G] into [src].", "<span class='notice'>You load \a [G] into [src].</span>")

	if(chambered)
		user.put_in_hands(chambered)
		user.visible_message("[user] removes \a [chambered] from [src].", "<span class='notice'>You remove \a [chambered] from [src].</span>")
		chambered = null
	else
		user << "<span class='warning'>[src] is empty.</span>"
