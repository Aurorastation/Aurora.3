/obj/item/device/soulstone/cultify()
	return

/obj/item/device/soulstone
	name = "soul stone shard"
	desc = "A fragment of the legendary treasure known simply as the 'Soul Stone'. The shard still flickers with a fraction of the full artefacts power."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "soulstone"
	item_state = "electronic"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 4)
	appearance_flags = NO_CLIENT_COLOR
	var/imprinted = "empty"

//////////////////////////////Capturing////////////////////////////////////////////////////////

/obj/item/device/soulstone/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	user.setClickCooldown(20)
	if(!istype(M, /mob/living/carbon/human))//If target is not a human.
		return ..()
	if(istype(M, /mob/living/carbon/human/apparition))
		return..()

	if(M.has_brain_worms()) //Borer stuff - RR
		to_chat(user, "<span class='warning'>This being is corrupted by an alien intelligence and cannot be soul trapped.</span>")
		return..()

	M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their soul captured with [src.name] by [user.name] ([user.ckey])</font>")
	user.attack_log += text("\[[time_stamp()]\] <span class='warning'>Used the [src.name] to capture the soul of [M.name] ([M.ckey])</span>")
	msg_admin_attack("[user.name] ([user.ckey]) used the [src.name] to capture the soul of [M.name] ([M.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(src),ckey_target=key_name(M))

	transfer_soul("VICTIM", M, user)
	return


///////////////////Options for using captured souls///////////////////////////////////////

/obj/item/device/soulstone/attack_self(mob/user)
	if(!in_range(src, user))
		return
	user.set_machine(src)

	var/dat = ""
	for(var/mob/living/simple_animal/shade/A in src)
		dat += "Captured Soul: [A.name]<hr>"
		dat += "<A href='byond://?src=\ref[src];choice=Summon'>Summon Shade</A><br>"
		dat += "<i>This will summon the spirit of [A.name] in a pure energy form. Be cautious, for they will be weak without a protective construct to house them.</i><hr>"
	dat += "<a href='byond://?src=\ref[src];choice=Close'>Close</a>"

	var/datum/browser/soulstone_win = new(user, "soulstone", capitalize_first_letters(name))
	soulstone_win.set_content(dat)
	soulstone_win.add_stylesheet("cult", 'html/browser/cult.css')
	soulstone_win.open()

/obj/item/device/soulstone/Topic(href, href_list)
	var/mob/U = usr
	if (!in_range(src, U)||U.machine!=src)
		U << browse(null, "window=soulstone")
		U.unset_machine()
		return

	add_fingerprint(U)
	U.set_machine(src)

	switch(href_list["choice"])//Now we switch based on choice.
		if ("Close")
			U << browse(null, "window=soulstone")
			U.unset_machine()
			return

		if ("Summon")
			for(var/mob/living/simple_animal/shade/A in src)
				A.status_flags &= ~GODMODE
				A.canmove = 1
				to_chat(A, "<b>You have been released from your prison, but you are still bound to [U.name]'s will. Help them suceed in their goals at all costs.</b>")
				A.forceMove(U.loc)
				A.cancel_camera()
				src.icon_state = "soulstone"
	attack_self(U)

///////////////////////////Transferring to constructs/////////////////////////////////////////////////////
/obj/structure/constructshell
	name = "empty shell"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "construct"
	desc = "A wicked machine used by those skilled in magical arts. It is inactive."

/obj/structure/constructshell/cultify()
	return

/obj/structure/constructshell/cult
	appearance_flags = NO_CLIENT_COLOR
	icon_state = "construct-cult"
	desc = "This eerie contraption looks like it would come alive if supplied with a missing ingredient."

/obj/structure/constructshell/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/device/soulstone))
		var/obj/item/device/soulstone/S = O;
		S.transfer_soul("CONSTRUCT",src,user)


////////////////////////////Proc for moving soul in and out off stone//////////////////////////////////////
/obj/item/device/soulstone/proc/transfer_human(var/mob/living/carbon/human/T,var/mob/U)
	if(!istype(T))
		return
	if(src.imprinted != "empty")
		if(U)
			to_chat(U, "<span class='danger'>Capture failed!</span>: The soul stone has already been imprinted with [src.imprinted]'s mind!")
		return
	if(T.stat != DEAD && !T.is_asystole())
		if(U)
			to_chat(U, "<span class='danger'>Capture failed!</span>: Kill or maim the victim first!")
		return
	if(T.client == null)
		if(U)
			to_chat(U, "<span class='danger'>Capture failed!</span>: The soul has already fled its mortal frame.")
		return
	if(src.contents.len)
		if(U)
			to_chat(U, "<span class='danger'>Capture failed!</span>: The soul stone is full! Use or free an existing soul to make room.")
		return

	for(var/obj/item/W in T)
		T.drop_from_inventory(W)

	var/obj/effect/decal/remains/remains = T.species.remains_type //spawns a skeleton based on the species remain type
	new remains(T.loc)

	T.invisibility = 101

	var/atom/movable/overlay/animation = new /atom/movable/overlay( T.loc )
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = T
	flick("dust-h", animation)
	qdel(animation)

	var/mob/living/simple_animal/shade/S = new /mob/living/simple_animal/shade( T.loc )
	S.forceMove(src) //put shade in stone
	S.status_flags |= GODMODE //So they won't die inside the stone somehow
	S.canmove = 0//Can't move out of the soul stone
	S.name = "Shade of [T.real_name]"
	S.real_name = "Shade of [T.real_name]"
	S.icon = T.icon
	S.icon_state = T.icon_state
	S.overlays = T.overlays
	S.color = rgb(254,0,0)
	S.alpha = 127
	if (T.client)
		T.client.mob = S
	S.cancel_camera()


	src.icon_state = "soulstone2"
	src.name = "Soul Stone: [S.real_name]"
	if(U)
		to_chat(S, "Your soul has been captured! You are now bound to [U.name]'s will, help them suceed in their goals at all costs.")
		to_chat(U, "<span class='notice'>Capture successful!</span> : [T.real_name]'s soul has been ripped from their body and stored within the soul stone.")
		to_chat(U, "The soulstone has been imprinted with [S.real_name]'s mind, it will no longer react to other souls.")
	src.imprinted = "[S.name]"
	qdel(T)

/obj/item/device/soulstone/proc/transfer_shade(var/mob/living/simple_animal/shade/T,var/mob/U)
	if(!istype(T))
		return;
	if (T.stat == DEAD)
		to_chat(U, "<span class='danger'>Capture failed!</span>: The shade has already been banished!")
		return
	if(src.contents.len)
		to_chat(U, "<span class='danger'>Capture failed!</span>: The soul stone is full! Use or free an existing soul to make room.")
		return
	if(T.name != src.imprinted)
		to_chat(U, "<span class='danger'>Capture failed!</span>: The soul stone has already been imprinted with [src.imprinted]'s mind!")
		return

	T.forceMove(src) //put shade in stone
	T.status_flags |= GODMODE
	T.canmove = 0
	T.health = T.maxHealth
	src.icon_state = "soulstone2"

	to_chat(T, "Your soul has been recaptured by the soul stone, its arcane energies are reknitting your ethereal form")
	to_chat(U, "<span class='notice'>Capture successful!</span> : [T.name]'s has been recaptured and stored within the soul stone.")

/obj/item/device/soulstone/proc/transfer_construct(var/obj/structure/constructshell/T,var/mob/U)
	var/mob/living/simple_animal/shade/A = locate() in src
	if(!A)
		to_chat(U, "<span class='danger'>Capture failed!</span>: The soul stone is empty! Go kill someone!")
		return;
	var/construct_class = alert(U, "Please choose which type of construct you wish to create.",,"Juggernaut","Wraith","Artificer")
	switch(construct_class)
		if("Juggernaut")
			var/mob/living/simple_animal/construct/armored/Z = new /mob/living/simple_animal/construct/armored (get_turf(T.loc))
			if(A.key)
				Z.key = A.key
			else
				SSghostroles.add_spawn_atom("construct", Z)
				SSghostroles.remove_spawn_atom("shade", A)
			qdel(T)
			to_chat(Z, "<B>You are playing a Juggernaut. Though slow, you can withstand extreme punishment, and rip apart enemies and walls alike.</B>")
			to_chat(Z, "<B>You are still bound to serve your creator, follow their orders and help them complete their goals at all costs.</B>")
			Z.cancel_camera()
			qdel(src)
		if("Wraith")
			var/mob/living/simple_animal/construct/wraith/Z = new /mob/living/simple_animal/construct/wraith (get_turf(T.loc))
			if(A.key)
				Z.key = A.key
			else
				SSghostroles.add_spawn_atom("construct", Z)
				SSghostroles.remove_spawn_atom("shade", A)
			qdel(T)
			to_chat(Z, "<B>You are playing a Wraith. Though relatively fragile, you are fast, deadly, and even able to phase through walls.</B>")
			to_chat(Z, "<B>You are still bound to serve your creator, follow their orders and help them complete their goals at all costs.</B>")
			Z.cancel_camera()
			qdel(src)
		if("Artificer")
			var/mob/living/simple_animal/construct/builder/Z = new /mob/living/simple_animal/construct/builder (get_turf(T.loc))
			if(A.key)
				Z.key = A.key
			else
				SSghostroles.add_spawn_atom("construct", Z)
				SSghostroles.remove_spawn_atom("shade", A)
			qdel(T)
			to_chat(Z, "<B>You are playing an Artificer. You are incredibly weak and fragile, but you are able to construct fortifications, repair allied constructs (by clicking on them), and even create new constructs</B>")
			to_chat(Z, "<B>You are still bound to serve your creator, follow their orders and help them complete their goals at all costs.</B>")
			Z.cancel_camera()
			qdel(src)

/obj/item/device/soulstone/proc/transfer_soul(var/choice as text, var/target, var/mob/U as mob)
	switch(choice)
		if("VICTIM")
			transfer_human(target,U)
		if("SHADE")
			transfer_shade(target,U)
		if("CONSTRUCT")
			transfer_construct(target,U)
