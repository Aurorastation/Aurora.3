////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/pill
	name = "pill"
	desc = "a pill."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	item_state = "pill"
	possible_transfer_amounts = null
	w_class = 1
	slot_flags = SLOT_EARS
	volume = 60
	drop_sound = 'sound/items/drop/food.ogg'

	New()
		..()
		if(!icon_state)
			icon_state = "pill[rand(1, 20)]"

	attack(mob/M as mob, mob/user as mob, def_zone)
		//TODO: replace with standard_feed_mob() call.

		if(M == user)
			if(!M.can_eat(src))
				return

			M.visible_message(span("notice", "[M] swallows a pill."), span("notice", "You swallow \the [src]."), null, 2)
			if(reagents.total_volume)
				reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
			qdel(src)
			return 1

		else if(istype(M, /mob/living/carbon/human))
			if(!M.can_force_feed(user, src))
				return

			user.visible_message(span("warning", "[user] attempts to force [M] to swallow \the [src]."))

			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			if(!do_mob(user, M))
				return

			user.visible_message(span("warning", "[user] forces [M] to swallow \the [src]."))

			var/contained = reagentlist()
			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [name] by [key_name(user)] Reagents: [contained]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [name] to [key_name(M)] Reagents: [contained]</font>")
			msg_admin_attack("[key_name_admin(user)] fed [key_name_admin(M)] with [name] Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(M))

			if(reagents.total_volume)
				reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
			qdel(src)

			return 1

		return 0

	afterattack(obj/target, mob/user, proximity)

		if(proximity && target.is_open_container() && target.reagents)
			if(!target.reagents.total_volume)
				to_chat(user, span("notice", "[target] is empty. Can't dissolve \the [src]."))
				return
			to_chat(user, span("notice", "You dissolve \the [src] in [target]."))

			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Spiked \a [target] with a pill. Reagents: [reagentlist()]</font>")
			msg_admin_attack("[user.name] ([user.ckey]) spiked \a [target] with a pill. Reagents: [reagentlist()] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target))

			reagents.trans_to(target, reagents.total_volume)
			for(var/mob/O in viewers(2, user))
				O.show_message(span("warning", "[user] puts something in \the [target]."), 1)

			qdel(src)
			return

		. = ..()

////////////////////////////////////////////////////////////////////////////////
/// Pills. END
////////////////////////////////////////////////////////////////////////////////

//Pills
/obj/item/reagent_containers/pill/antitox
	name = "Anti-toxins pill"
	desc = "Neutralizes many common toxins."
	icon_state = "pill17"
	Initialize()
		. = ..()
		reagents.add_reagent("dylovene", 25)

/obj/item/reagent_containers/pill/tox
	name = "Toxins pill"
	desc = "Highly toxic."
	icon_state = "pill5"
	Initialize()
		. = ..()
		reagents.add_reagent("toxin", 50)

/obj/item/reagent_containers/pill/cyanide
	name = "Cyanide pill"
	desc = "Don't swallow this."
	icon_state = "pill5"
	Initialize()
		. = ..()
		reagents.add_reagent("cyanide", 50)

/obj/item/reagent_containers/pill/adminordrazine
	name = "Adminordrazine pill"
	desc = "It's magic. We don't have to explain it."
	icon_state = "pill16"
	Initialize()
		. = ..()
		reagents.add_reagent("adminordrazine", 50)

/obj/item/reagent_containers/pill/stox
	name = "Sleeping pill"
	desc = "Commonly used to treat insomnia."
	icon_state = "pill8"
	Initialize()
		. = ..()
		reagents.add_reagent("stoxin", 15)

/obj/item/reagent_containers/pill/kelotane
	name = "Kelotane pill"
	desc = "Used to treat burns."
	icon_state = "pill11"
	Initialize()
		. = ..()
		reagents.add_reagent("kelotane", 15)

/obj/item/reagent_containers/pill/paracetamol
	name = "Paracetamol pill"
	desc = "Tylenol! A painkiller for the ages. Chewables!"
	icon_state = "pill8"
	Initialize()
		. = ..()
		reagents.add_reagent("paracetamol", 15)

/obj/item/reagent_containers/pill/tramadol
	name = "Tramadol pill"
	desc = "A simple painkiller."
	icon_state = "pill8"
	Initialize()
		. = ..()
		reagents.add_reagent("tramadol", 15)


/obj/item/reagent_containers/pill/methylphenidate
	name = "Methylphenidate pill"
	desc = "Improves the ability to concentrate."
	icon_state = "pill8"
	Initialize()
		. = ..()
		reagents.add_reagent("methylphenidate", 15)

/obj/item/reagent_containers/pill/escitalopram
	name = "Escitalopram pill"
	desc = "Mild anti-depressant."
	icon_state = "pill8"
	Initialize()
		. = ..()
		reagents.add_reagent("escitalopram", 15)

/obj/item/reagent_containers/pill/escitalopram
	name = "Escitalopram pill"
	desc = "Mild anti-depressant."
	icon_state = "pill8"
	Initialize()
		. = ..()
		reagents.add_reagent("escitalopram", 15)

/obj/item/reagent_containers/pill/norepinephrine
	name = "norepinephrine pill"
	desc = "Used to stabilize patients."
	icon_state = "pill20"
	Initialize()
		. = ..()
		reagents.add_reagent("norepinephrine", 30)

/obj/item/reagent_containers/pill/dexalin
	name = "Dexalin pill"
	desc = "Used to treat oxygen deprivation."
	icon_state = "pill16"
	Initialize()
		. = ..()
		reagents.add_reagent("dexalin", 15)

/obj/item/reagent_containers/pill/dexalin_plus
	name = "Dexalin Plus pill"
	desc = "Used to treat extreme oxygen deprivation."
	icon_state = "pill8"
	Initialize()
		. = ..()
		reagents.add_reagent("dexalinp", 15)

/obj/item/reagent_containers/pill/dermaline
	name = "Dermaline pill"
	desc = "Used to treat burn wounds."
	icon_state = "pill12"
	Initialize()
		. = ..()
		reagents.add_reagent("dermaline", 15)

/obj/item/reagent_containers/pill/dylovene
	name = "Dylovene pill"
	desc = "A broad-spectrum anti-toxin."
	icon_state = "pill13"
	Initialize()
		. = ..()
		reagents.add_reagent("dylovene", 15)

/obj/item/reagent_containers/pill/bicaridine
	name = "Bicaridine pill"
	desc = "Used to treat physical injuries."
	icon_state = "pill18"
	Initialize()
		. = ..()
		reagents.add_reagent("bicaridine", 20)

/obj/item/reagent_containers/pill/happy
	name = "Happy pill"
	desc = "Happy happy joy joy!"
	icon_state = "pill18"
	Initialize()
		. = ..()
		reagents.add_reagent("space_drugs", 15)
		reagents.add_reagent("sugar", 15)

/obj/item/reagent_containers/pill/zoom
	name = "Zoom pill"
	desc = "Zoooom!"
	icon_state = "pill18"
	Initialize()
		. = ..()
		reagents.add_reagent("impedrezene", 10)
		reagents.add_reagent("synaptizine", 5)
		reagents.add_reagent("hyperzine", 5)

/obj/item/reagent_containers/pill/deltamivir
	name = "Deltamivir pill"
	desc = "Contains antiviral agents."
	icon_state = "pill19"
	Initialize()
		. = ..()
		reagents.add_reagent("deltamivir", 15)

/obj/item/reagent_containers/pill/thetamycin
	name = "thetamycin pill"
	desc = "Contains theta-lactam antibiotics."
	icon_state = "pill19"
	Initialize()
		. = ..()
		reagents.add_reagent("thetamycin", 15)

/obj/item/reagent_containers/pill/bio_vitamin
	name = "Vitamin pill"
	desc = "Contains a meal's worth of nutrients."
	icon_state = "pill11"
	Initialize()
		. = ..()
		reagents.add_reagent("nutriment", 20)
		reagents.add_reagent(pick("banana","berryjuice","grapejuice","lemonjuice","limejuice","orangejuice","watermelonjuice"),1)

/obj/item/reagent_containers/pill/rmt
	name = "RMT pill"
	desc = "Contains chemical rampantly used by those seeking to remedy the effects of prolonged zero-gravity adaptations."
	icon_state = "pill19"

/obj/item/reagent_containers/pill/rmt/Initialize()
	. = ..()
	reagents.add_reagent("rmt", 15)

/obj/item/reagent_containers/pill/antihistamine
	name = "antihistamine"
	desc = "Contains diphenhydramine, also known as Benadryl. Helps with sneezing, can cause drowsiness."
	icon_state = "pill19"

/obj/item/reagent_containers/pill/antihistamine/Initialize()
	. = ..()
	reagents.add_reagent("diphenhydramine", 5)