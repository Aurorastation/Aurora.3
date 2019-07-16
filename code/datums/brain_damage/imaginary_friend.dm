/datum/brain_trauma/special/imaginary_friend
	name = "Imaginary Friend"
	desc = "Patient can see and hear an imaginary person."
	scan_desc = "partial schizophrenia"
	gain_text = "<span class='notice'>You feel in good company, for some reason.</span>"
	lose_text = "<span class='warning'>You feel lonely again.</span>"
	cure_type = CURE_SOLITUDE
	var/mob/abstract/mental/friend/friend

/datum/brain_trauma/special/imaginary_friend/on_gain()
	..()
	make_friend()
	get_ghost()

/datum/brain_trauma/special/imaginary_friend/on_life()
	if(get_dist(owner, friend) > 9)
		friend.yank()
	if(!friend)
		qdel(src)

/datum/brain_trauma/special/imaginary_friend/on_lose()
	..()
	QDEL_NULL(friend)

/datum/brain_trauma/special/imaginary_friend/proc/make_friend()
	friend = new(get_turf(src), src)

/datum/brain_trauma/special/imaginary_friend/proc/get_ghost()
	set waitfor = FALSE
	var/datum/ghosttrap/G = get_ghost_trap("friend")
	G.request_player(friend, "Would you like to play as [owner]'s imaginary friend?", 60 SECONDS)
	addtimer(CALLBACK(src, .proc/reset_search), 60 SECONDS)

/datum/brain_trauma/special/imaginary_friend/proc/reset_search()
	if(src.friend && src.friend.key)
		return
	else
		qdel(src)

/mob/abstract/mental
	universal_understand = 1
	incorporeal_move = 1
	density = 0

/mob/abstract/mental/friend
	name = "imaginary friend"
	real_name = "imaginary friend"
	desc = "A wonderful yet fake friend."
	see_in_dark = 0
	see_invisible = SEE_INVISIBLE_LIVING
	var/icon/human_image
	var/image/current_image
	var/mob/living/carbon/owner
	var/datum/brain_trauma/special/imaginary_friend/trauma

/mob/abstract/mental/friend/Login()
	..()
	to_chat(src, "<span class='notice'><b>You are the imaginary friend of [owner]!</b></span>")
	to_chat(src, "<span class='notice'>You are absolutely loyal to your friend, no matter what.</span>")
	to_chat(src, "<span class='notice'>You cannot directly influence the world around you, but you can see what [owner] cannot.</span>")

/mob/abstract/mental/friend/Initialize(mapload, _trauma)
	. = ..()
	trauma = _trauma
	owner = trauma.owner
	var/gender = pick(MALE, FEMALE)
	real_name = owner.species.get_random_name(gender)
	name = real_name
	var/list/candidates = list()
	for(var/mob/living/L in living_mob_list)
		candidates += L
	var/mob/abstract/buddy = pick(candidates)
	human_image = getFlatIcon(buddy)
	Show()

/mob/abstract/mental/friend/proc/Show()
	if(owner.client)
		owner.client.images.Remove(current_image)
	if(client)
		client.images.Remove(current_image)
	current_image = image(human_image, src, null, MOB_LAYER)
	current_image.override = TRUE
	current_image.name = name
	if(owner.client)
		owner.client.images |= current_image
	if(client)
		client.images |= current_image

/mob/abstract/mental/friend/Destroy()
	if(owner.client)
		owner.client.images.Remove(human_image)
	if(client)
		client.images.Remove(human_image)
	return ..()

/mob/abstract/mental/friend/proc/yank()
	if(!client) //don't bother the user with a braindead ghost every few steps
		return
	forceMove(get_turf(owner))

/mob/abstract/mental/friend/say(message)
	if (!message)
		return

	message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))

	if(!message)
		return

	var/rendered = "<span class='game say'><span class='name'>[name] says,</span> <span class='message'>\"[message]\"</span></span>"

	to_chat(owner, "[rendered]")
	to_chat(src, "[rendered]")

/mob/abstract/mental/friend/emote(act,m_type=1,message = null)
	return

/mob/abstract/mental/friend/Move(NewLoc, Dir = 0)
	loc = NewLoc
	dir = Dir
	if(get_dist(src, owner) > 9)
		yank()
		return TRUE
	return TRUE

/mob/abstract/mental/friend/movement_delay()
	return 2
