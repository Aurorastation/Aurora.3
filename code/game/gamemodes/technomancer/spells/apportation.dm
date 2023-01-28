/datum/technomancer/spell/apportation
	name = "Apportation"
	desc = "This allows you to teleport objects into your hand, or to pull people towards you.  If they're close enough, the function \
	will grab them automatically."
	enhancement_desc = "Range is unlimited."
	cost = 25
	ability_icon_state = "wiz_subj"
	obj_path = /obj/item/spell/apportation
	category = UTILITY_SPELLS

/obj/item/spell/apportation
	name = "apportation"
	icon_state = "apportation"
	desc = "Allows you to reach through Bluespace with your hand, and grab something, bringing it to you instantly."
	cast_methods = CAST_RANGED
	aspect = ASPECT_TELE

/obj/item/spell/apportation/on_ranged_cast(atom/hit_atom, mob/user)
	if(istype(hit_atom, /atom/movable))
		var/atom/movable/AM = hit_atom

		if(!AM.loc) //Don't teleport HUD telements to us.
			return
		if(AM.anchored)
			to_chat(user, "<span class='warning'>\The [hit_atom] is firmly secured and anchored, you can't move it!</span>")
			return

		if(!within_range(hit_atom) && !check_for_scepter())
			to_chat(user, "<span class='warning'>\The [hit_atom] is too far away.</span>")
			return

		//Teleporting an item.
		if(isitem(hit_atom))
			var/obj/item/I = hit_atom

			spark(I, 5, cardinal)
			spark(user, 5, cardinal)
			I.visible_message("<span class='danger'>\The [I] vanishes into thin air!</span>")
			I.forceMove(get_turf(user))
			user.drop_item(src)
			src.loc = null
			user.put_in_hands(I)
			user.visible_message("<span class='notice'>\A [I] appears in \the [user]'s hand!</span>")
			log_and_message_admins("has stolen [I] with [src].")
			qdel(src)
		//Now let's try to teleport a living mob.
		else if(isliving(hit_atom))
			var/mob/living/L = hit_atom
			to_chat(L, "<span class='danger'>You are teleported towards \the [user]!</span>")
			spark(L, 5, cardinal)
			spark(user, 5, cardinal)
			L.throw_at(get_step(get_turf(src), get_dir(src, L)), 4, 1, src)
			addtimer(CALLBACK(src, PROC_REF(seize_mob), L, user), 1 SECOND)
			user.drop_item(src)
			src.loc = null

/obj/item/spell/apportation/proc/seize_mob(var/mob/living/L, var/mob/user)
	if(!user.Adjacent(L))
		to_chat(user, "<span class='warning'>\The [L] is out of your reach.</span>")
		qdel(src)
		return

	L.Weaken(3)
	user.visible_message("<span class='warning'><b>\The [user]</b> seizes [L]!</span>")

	var/obj/item/grab/G = new(user, L)

	user.put_in_hands(G)

	G.state = GRAB_PASSIVE
	G.icon_state = "grabbed1"
	G.synch()
	qdel(src)

