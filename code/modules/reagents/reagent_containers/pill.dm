////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/pill
	name = "pill"
	desc = "a pill."
	icon = 'icons/obj/chemical.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/stacks/lefthand_medical.dmi',
		slot_r_hand_str = 'icons/mob/items/stacks/righthand_medical.dmi',
		)
	icon_state = null
	item_state = "pill"
	possible_transfer_amounts = null
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	volume = 60
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'

	New()
		..()
		if(!icon_state)
			icon_state = "pill[rand(1, 20)]"

	attack(mob/M as mob, mob/user as mob, def_zone)
		//TODO: replace with standard_feed_mob() call.

		if(M == user)
			if(!M.can_eat(src))
				return

			M.visible_message("<b>[M]</b> swallows a pill.", SPAN_NOTICE("You swallow \the [src]."), null, 2)
			if(reagents.total_volume)
				reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
			qdel(src)
			return 1

		else if(istype(M, /mob/living/carbon/human))
			if(!M.can_force_feed(user, src))
				return

			user.visible_message(SPAN_WARNING("[user] attempts to force [M] to swallow \the [src]!"))

			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			if(!do_mob(user, M))
				return

			user.visible_message(SPAN_WARNING("[user] forces [M] to swallow \the [src]."))

			var/contained = reagentlist()
			M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [name] by [key_name(user)] Reagents: [contained]</font>")
			user.attack_log += text("\[[time_stamp()]\] <span class='warning'>Fed [name] to [key_name(M)] Reagents: [contained]</span>")
			msg_admin_attack("[key_name_admin(user)] fed [key_name_admin(M)] with [name] Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(M))

			if(reagents.total_volume)
				reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
			qdel(src)

			return 1

		return 0

	afterattack(obj/target, mob/user, proximity)

		if(proximity && target.is_open_container() && target.reagents)
			if(!target.reagents.total_volume)
				to_chat(user, SPAN_NOTICE("You can't dissolve \the [src] in an empty [target]."))
				return
			to_chat(user, SPAN_NOTICE("You dissolve \the [src] in [target]."))

			user.attack_log += text("\[[time_stamp()]\] <span class='warning'>Spiked \a [target] with a pill. Reagents: [reagentlist()]</span>")
			msg_admin_attack("[user.name] ([user.ckey]) spiked \a [target] with a pill. Reagents: [reagentlist()] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)",ckey=key_name(user),ckey_target=key_name(target))

			reagents.trans_to(target, reagents.total_volume)
			for(var/mob/O in viewers(2, user))
				O.show_message(SPAN_WARNING("[user] puts something in \the [target]."), 1)

			qdel(src)
			return

		. = ..()

////////////////////////////////////////////////////////////////////////////////
/// Pills. END
////////////////////////////////////////////////////////////////////////////////

//Pills
/obj/item/reagent_containers/pill/antitox
	name = "10u Dylovene Pill"
	desc = "Neutralizes many common toxins."
	icon_state = "pill17"
	reagents_to_add = list(/decl/reagent/dylovene = 10)

/obj/item/reagent_containers/pill/tox
	name = "Toxins Pill"
	desc = "Highly toxic."
	icon_state = "pill5"
	reagents_to_add = list(/decl/reagent/toxin = 50)

/obj/item/reagent_containers/pill/cyanide
	icon_state = "pill5"
	reagents_to_add = list(/decl/reagent/toxin/cyanide = 50)
	desc_antag = "A cyanide pill. Deadly if swallowed."

/obj/item/reagent_containers/pill/adminordrazine
	name = "Adminordrazine Pill"
	desc = "It's magic. We don't have to explain it."
	icon_state = "pill16"
	reagents_to_add = list(/decl/reagent/adminordrazine = 50)

/obj/item/reagent_containers/pill/stox
	name = "15u Soporific Pill"
	desc = "Commonly used to treat insomnia."
	icon_state = "pill8"
	reagents_to_add = list(/decl/reagent/soporific = 15)

/obj/item/reagent_containers/pill/kelotane
	name = "10u Kelotane Pill"
	desc = "Used to treat minor burns."
	icon_state = "pill11"
	reagents_to_add = list(/decl/reagent/kelotane = 10)

/obj/item/reagent_containers/pill/perconol
	name = "10u Perconol Pill"
	desc = "A light painkiller available over-the-counter."
	icon_state = "pill8"
	reagents_to_add = list(/decl/reagent/perconol = 10)

/obj/item/reagent_containers/pill/mortaphenyl
	name = "10u Mortaphenyl Pill"
	desc = "A mortaphenyl pill, it's a potent painkiller."
	icon_state = "pill8"
	reagents_to_add = list(/decl/reagent/mortaphenyl = 10)

/obj/item/reagent_containers/pill/corophenidate
	name = "2u Corophenidate Pill"
	desc = "Improves the ability to concentrate."
	icon_state = "pill22"
	reagents_to_add = list(/decl/reagent/mental/corophenidate = 2)

/obj/item/reagent_containers/pill/emoxanyl
	name = "2u Emoxanyl Pill"
	desc = "Used to treat anxiety disorders, depression and epilepsy."
	icon_state = "pill22"
	reagents_to_add = list(/decl/reagent/mental/emoxanyl = 2)

/obj/item/reagent_containers/pill/minaphobin
	name = "2u Minaphobin Pill"
	desc = "Used to treat anxiety disorders and depression."
	icon_state = "pill22"
	reagents_to_add = list(/decl/reagent/mental/minaphobin = 2)

/obj/item/reagent_containers/pill/nerospectan
	name = "2u Nerospectan Pill"
	desc = "Used to treat a large variety of disorders including tourettes, depression, anxiety and psychosis."
	icon_state = "pill22"
	reagents_to_add = list(/decl/reagent/mental/nerospectan = 2)

/obj/item/reagent_containers/pill/neurapan
	name = "2u Neurapan Pill"
	desc = "Used to treat a large variety of disorders including tourettes, depression, anxiety and psychosis."
	icon_state = "pill22"
	reagents_to_add = list(/decl/reagent/mental/neurapan = 2)

/obj/item/reagent_containers/pill/neurostabin
	name = "2u Neurostabin Pill"
	desc = "Used to treat psychosis and muscle weakness."
	icon_state = "pill8"
	reagents_to_add = list(/decl/reagent/mental/neurostabin = 2)

/obj/item/reagent_containers/pill/orastabin
	name = "2u Orastabin Pill"
	desc = "Used to treat anxiety disorders and speech impediments."
	icon_state = "pill22"
	reagents_to_add = list(/decl/reagent/mental/orastabin = 2)

/obj/item/reagent_containers/pill/parvosil
	name = "2u Parvosil Pill"
	desc = "Used to treat anxiety disorders such as phobias and social anxiety."
	icon_state = "pill22"
	reagents_to_add = list(/decl/reagent/mental/parvosil = 2)

/obj/item/reagent_containers/pill/inaprovaline
	name = "10u Inaprovaline Pill"
	desc = "Used to stabilize heart activity."
	icon_state = "pill20"
	reagents_to_add = list(/decl/reagent/inaprovaline = 10)

/obj/item/reagent_containers/pill/dexalin
	name = "15u Dexalin Pill"
	desc = "Used to treat oxygen deprivation."
	icon_state = "pill16"
	reagents_to_add = list(/decl/reagent/dexalin = 15)

/obj/item/reagent_containers/pill/dexalin_plus
	name = "15u Dexalin Plus Pill"
	desc = "Used to treat extreme oxygen deprivation."
	icon_state = "pill8"
	reagents_to_add = list(/decl/reagent/dexalin/plus = 15)

/obj/item/reagent_containers/pill/dermaline
	name = "10u Dermaline Pill"
	desc = "Used to treat severe burn wounds."
	icon_state = "pill12"
	reagents_to_add = list(/decl/reagent/dermaline = 10)

/obj/item/reagent_containers/pill/dylovene
	name = "15u Dylovene Pill"
	desc = "A broad-spectrum anti-toxin."
	icon_state = "pill13"
	reagents_to_add = list(/decl/reagent/dylovene = 15)

/obj/item/reagent_containers/pill/butazoline
	name = "10u Butazoline Pill"
	desc = "Used to treat major injuries and bleeding."
	icon_state = "pill18"
	reagents_to_add = list(/decl/reagent/butazoline = 10)

/obj/item/reagent_containers/pill/bicaridine
	name = "10u Bicaridine Pill"
	desc = "Used to treat minor injuries and bleeding."
	icon_state = "pill18"
	reagents_to_add = list(/decl/reagent/bicaridine = 10)

/obj/item/reagent_containers/pill/happy
	name = "Happy Pill"
	desc = "Happy happy joy joy!"
	icon_state = "pill_happy"
	reagents_to_add = list(/decl/reagent/space_drugs = 15, /decl/reagent/sugar = 15)

/obj/item/reagent_containers/pill/zoom
	name = "Zoom Pill"
	desc = "Zoooom!"
	icon_state = "pill18"
	reagents_to_add = list(/decl/reagent/impedrezene = 5, /decl/reagent/synaptizine = 5, /decl/reagent/hyperzine = 5)

obj/item/reagent_containers/pill/joy
	name = "Joy Pill"
	desc = "Peace, at last."
	icon_state = "pill8"
	reagents_to_add = list(/decl/reagent/joy = 5)

/obj/item/reagent_containers/pill/thetamycin
	name = "15u Thetamycin Pill"
	desc = "Used to treat infections and septicaemia."
	icon_state = "pill19"
	reagents_to_add = list(/decl/reagent/thetamycin = 15)

/obj/item/reagent_containers/pill/bio_vitamin
	name = "Vitamin Pill"
	desc = "Contains a meal's worth of nutrients."
	icon_state = "pill11"
	reagents_to_add = list(/decl/reagent/nutriment = 20)

/obj/item/reagent_containers/pill/bio_vitamin/Initialize()
	. = ..()
	var/juice = pick(/decl/reagent/drink/banana, /decl/reagent/drink/berryjuice, /decl/reagent/drink/grapejuice, /decl/reagent/drink/lemonjuice, /decl/reagent/drink/limejuice, /decl/reagent/drink/orangejuice, /decl/reagent/drink/watermelonjuice)
	reagents.add_reagent(juice, 1)

/obj/item/reagent_containers/pill/rmt
	name = "15u Regenerative-Muscular Tissue Supplement Pill"
	desc = "Commonly abbreviated to RMT, it contains chemicals rampantly used by those seeking to remedy the effects of prolonged zero-gravity adaptations."
	icon_state = "pill19"
	reagents_to_add = list(/decl/reagent/rmt = 15)

/obj/item/reagent_containers/pill/cetahydramine
	name = "5u Cetahydramine Pill"
	desc = "Used to treat coughing, sneezing and itching."
	icon_state = "pill19"
	reagents_to_add = list(/decl/reagent/cetahydramine = 5)

/obj/item/reagent_containers/pill/skrell_nootropic
	name = "5u Co'qnixq Wuxi Pill"
	desc = "Used to treat dementia."
	icon_state = "pill8"
	reagents_to_add = list(/decl/reagent/skrell_nootropic = 5)
