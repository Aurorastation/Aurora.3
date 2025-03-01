// Nullrod, Aspergillum, Burial Urn

/obj/item/nullrod
	name = "null rod"
	desc = "A rod of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon = 'icons/obj/weapons.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/weapons/lefthand_nullrod.dmi',
		slot_r_hand_str = 'icons/mob/items/weapons/righthand_nullrod.dmi',
		)
	icon_state = "nullrod"
	item_state = "nullrod"
	slot_flags = SLOT_BELT
	force = 22
	throw_speed = 1
	throw_range = 4
	throwforce = 10
	w_class = WEIGHT_CLASS_SMALL
	var/can_change_form = TRUE // For holodeck check.
	var/cooldown = 0 // Floor tap cooldown.
	var/list/null_choices = list( //Generic nullrods only here, religion-specific ones should be on the religion datum
		"Null Rod" = /obj/item/nullrod,
		"Null Staff" = /obj/item/nullrod/staff,
		"Null Orb" = /obj/item/nullrod/orb,
		"Null Athame" = /obj/item/nullrod/athame,
	)

/obj/item/nullrod/obsidianshards
	name = "obsidian shards"
	desc = "A loose pile of obsidian shards, waiting to be assembled into a religious focus."
	icon_state = "nullshards"
	item_state = "nullshards"

/obj/item/nullrod/dominia
	name = "tribunalist purification rod"
	desc = "A holy Symbol often carried by female Tribunalist clergy, the obsidian encased in the wooden handle is intended to ward off malevolent spirits and bless followers of the Goddess. The ornament on top depicts 'The Eye'\
	Moroz Holy Tribunal."
	desc_extended = "With origins in House Zhao, Tribunalist purification rods are a common sight throughout the Empire of Dominia. Intended to ward off malevolent entities and bless the \
	faithful a Tribunalist priestess is nothing without her rod, which is typically granted upon promotion to full priestess. This particular example has been built around an obsidian \
	core in the shaft, and is heavier than it seems."
	icon_state = "tribunalrod"
	item_state = "tribunalrod"

// Unreassembleable Variant for the Holodeck
/obj/item/nullrod/dominia/holodeck
	can_change_form = FALSE

/obj/item/nullrod/staff
	name = "null staff"
	desc = "A staff of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon_state = "nullstaff"
	item_state = "nullstaff"
	slot_flags = SLOT_BELT | SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY

/obj/item/nullrod/orb
	name = "null sphere"
	desc = "An orb of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon_state = "nullorb"
	item_state = "nullorb"

/obj/item/nullrod/athame
	name = "null athame"
	desc = "An athame of pure obsidian, its very presence disrupts and dampens the powers of paranormal phenomenae."
	icon_state = "nullathame"
	item_state = "nullathame"

/obj/item/nullrod/charm
	name = "obsidian charm"
	desc = "A tajaran charm created from obsidian created to ward off the supernatural and bring good fortune."
	desc_extended = "Talismans and charms are common among religious and superstitious tajara, with many believing them to be able to bring good fortune or ward off Raskara and other evils."
	icon = 'icons/obj/tajara_items.dmi'
	contained_sprite = TRUE
	item_icons = null
	icon_state = "stone_talisman"
	item_state = "stone_talisman"
	force = 4
	throw_range = 7
	throwforce = 2
	slot_flags = SLOT_MASK | SLOT_WRISTS | SLOT_EARS | SLOT_TIE
	w_class = WEIGHT_CLASS_TINY

/obj/item/nullrod/charm/get_mask_examine_text(mob/user)
	return "around [user.get_pronoun("his")] neck"

/obj/item/nullrod/matake
	name = "\improper Mata'ke spear"
	desc = "A ceremonial spear crafted after the image of Mata'ke's holy weapon."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "matake_spear"
	item_state = "matake_spear"
	contained_sprite = TRUE
	slot_flags = SLOT_BELT | SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY

/obj/item/nullrod/rredouane
	name = "\improper Rredouane sword"
	desc = "A ceremonial sword crafted after the image of Rredouane's holy sword."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "rredouane_sword"
	item_state = "rredouane_sword"
	contained_sprite = TRUE

/obj/item/nullrod/shumaila
	name = "\improper Shumaila hammer"
	desc = "A ceremonial hammer carried by the priesthood of Shumaila."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "shumaila_hammer"
	item_state = "shumaila_hammer"
	contained_sprite = TRUE

/obj/item/nullrod/zhukamir
	name = "\improper Zhukamir ladle"
	desc = "A golden ladle used by Zhukamir's most faithful worshippers."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "zhukamir_ladle"
	item_state = "zhukamir_ladle"

/obj/item/nullrod/azubarre
	name = "\improper Azubarre torch"
	desc = "A ceremonial torch used by Azubarre's priesthood in their rituals."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "azubarre_torch"
	item_state = "azubarre_torch"
	contained_sprite = TRUE
	var/lit = FALSE

/obj/item/nullrod/azubarre/attack_self(mob/user)
	lit= !lit
	if(lit)
		to_chat(user, SPAN_NOTICE("You light \the [src]!"))
	else
		to_chat(user, SPAN_NOTICE("You extinguish \the [src]!"))

	update_icon()
	user.update_inv_l_hand(FALSE)
	user.update_inv_r_hand()

/obj/item/nullrod/azubarre/update_icon()
	if(lit)
		icon_state = "azubarre_torch-on"
		set_light(3, 1, LIGHT_COLOR_FIRE)
	else
		icon_state = "azubarre_torch-empty"
		set_light(0)
	item_state = icon_state

/obj/item/nullrod/azubarre/isFlameSource()
	return lit

/obj/item/nullrod/shaman
	name = "shaman staff"
	desc = "A seven foot staff traditionally carried by Unathi shamans both as a symbol of authority and to aid them in walking. It is made out of dark, polished wood and is curved at the end."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "shaman_staff"
	item_state = "shaman_staff"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = null

/obj/item/nullrod/skakh_warrior
	name = "\improper Sk'akh sword"
	desc = "A silver-bladed ceremonial sword, made in the image of the Warrior Mukari's holy weapon. These blades are often carried by Sk'akh Priests of the Warrior in representation of His strength, though they are of little use in practical combat."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "skakh_sword"
	item_state = "skakh_sword"
	slot_flags = SLOT_BACK|SLOT_BELT
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_BULKY

/obj/item/nullrod/skakh_healer
	name = "\improper Sk'akh staff"
	desc = "A long staff topped with a green gemstone set in silver, made in the image of the Healer Simi's holy item. These staves are often carried by Sk'akh Priestesses of the Healer, in representation of Her wisdom."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "skakh_staff"
	item_state = "skakh_staff"
	contained_sprite = TRUE
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = null

/obj/item/nullrod/skakh_fisher
	name = "\improper Sk'akh sickle"
	desc = "A silver-bladed ceremonial sickle, made in the image of the Fisher Verrix's holy item. These sickles are often carried by Sk'akh Priests of the Fisher, in representation of Their benevolence."
	icon = 'icons/obj/unathi_items.dmi'
	icon_state = "skakh_sickle"
	item_state = "skakh_sickle"
	contained_sprite = TRUE

/obj/item/nullrod/autakh //not included in the list as it's meant to be an augment
	name = "blessed cybernetic claw"
	desc = "A prosthetic limb etched in Sinta'Mador runes and inlayed with obsidian."
	icon = 'icons/obj/organs/augments.dmi'
	icon_state = "anchor"
	item_state = "anchor" //won't appear in-hand and looks suitably aut'akh spiritual
	can_change_form = FALSE //this is integrated so we dont want anything silly with it

/obj/item/nullrod/autakh/throw_at()
	usr.drop_from_inventory(src)

/obj/item/nullrod/autakh/dropped()
	. = ..()
	loc = null
	qdel(src)

/obj/item/nullrod/luceiansceptre
	name = "\improper Luminous Sceptre"
	desc = "The Luminous Sceptre is a ceremonial staff optionally carried by the ministerial clergy of Luceism. It is fashioned from cedar and 18-karat gold, wrapped in sacred luce vine, \
	and topped with a miniature, specialized warding sphere. Such sceptres are traditionally employed in Luceian exorcisms or rituals to rid a corrupted soul of the darkness in their body - often, curiously, to great effect."
	icon = 'icons/obj/luceian_sceptre.dmi'
	icon_state = "luceian_sceptre"
	item_state = "luceian_sceptre"
	contained_sprite = TRUE

	force = 25
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK
	light_range = 4
	light_power = 2
	light_color = LIGHT_COLOR_BLUE

/obj/item/nullrod/verb/change(mob/living/user)
	set name = "Reassemble Null Item"
	set category = "Object"
	set src in usr

	// Holodeck/Augment Check
	if(!can_change_form)
		to_chat(user, SPAN_NOTICE("You can't change this item's form!"))
		return

	if(use_check_and_message(user, USE_FORCE_SRC_IN_USER))
		return

	var/mob/living/carbon/human/H = user
	if(istype(H))
		var/datum/religion/R = SSrecords.religions[H.religion]
		if(R.nulloptions)
			null_choices.Add(R.nulloptions)

	var/picked = tgui_input_list(user, "What form would you like your obsidian relic to take?", "Reassembling your obsidian relic", null_choices)

	if(use_check_and_message(user, USE_FORCE_SRC_IN_USER))
		return
	if(!ispath(null_choices[picked]))
		return

	to_chat(user, SPAN_NOTICE("You start reassembling your obsidian relic."))
	if(!do_after(user, 2 SECONDS))
		return

	var/nullrodpath = null_choices[picked]
	var/obj/item/nullrod/chosenitem = new nullrodpath(get_turf(user))
	qdel(src)
	user.put_in_hands(chosenitem)

/obj/item/nullrod/attack(mob/living/target_mob, mob/living/user, target_zone)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(target_mob)

	if(LAZYLEN(user.spell_list))
		user.silence_spells(300) //30 seconds
		to_chat(user, SPAN_DANGER("You've been silenced!"))
		return

	if(!user.IsAdvancedToolUser())
		to_chat(user, SPAN_DANGER("You don't have the dexterity to use this!"))
		return

	if((user.is_clumsy()) && prob(50))
		to_chat(user, SPAN_DANGER("The [src] slips out of your hand and you hit yourself!"))
		visible_message(SPAN_DANGER("[user] fumbles with the [src] and hits themselves in the process!"))
		user.take_organ_damage(10)
		user.Paralyse(20)
		return

	if(target_mob.stat != DEAD && ishuman(target_mob) && user.a_intent != I_HURT)
		var/mob/living/K = target_mob
		var/datum/vampire/vampire = K.mind.antag_datums[MODE_VAMPIRE]
		if(vampire)
			if(vampire.status & VAMP_ISTHRALL)
				if(do_after(user, 1.5 SECONDS))
					K.visible_message(SPAN_DANGER("[user] waves \the [src] over \the [K]'s head, [K] looks captivated by it."), SPAN_WARNING("[user] waves the [src] over your head. <b>You see a foreign light, asking you to follow it. Its presence burns and blinds.</b>"))
				var/choice = alert(K,"Do you want to give into the light and be freed from your vampiric master?","Become cleansed","Resist","Give in")
				switch(choice)
					if("Resist")
						K.visible_message(SPAN_WARNING("The gaze in [K]'s eyes remains determined."), SPAN_NOTICE("You turn away from the light, remaining true to your vampiric master!"))
						K.say("*scream")
						K.take_overall_damage(5, 15)
						admin_attack_log(user, target_mob, "attempted to deconvert", "was unsuccessfully deconverted by", "attempted to deconvert")
					if("Give in")
						K.visible_message(SPAN_NOTICE("[K]'s eyes become clearer, the evil gone, but not without leaving scars."))
						K.take_overall_damage(10, 20)
						GLOB.thralls.remove_antagonist(K.mind)
						admin_attack_log(user, target_mob, "successfully deconverted", "was successfully deconverted by", "successfully deconverted")
			else if (vampire.status & VAMP_FRENZIED)
				K.visible_message(SPAN_DANGER("[user] thrusts \the [src] towards [K], who recoils in horror as they erupt into flames!"), SPAN_DANGER("[user] thrusts \the [src] towards you, its holy light scorching your corrupted flesh!"))
				K.adjust_fire_stacks(10)
				K.IgniteMob()
		else if(GLOB.cult && (K.mind in GLOB.cult.current_antagonists) && prob(75))
			if(do_after(user, 1.5 SECONDS))
				K.visible_message(SPAN_DANGER("[user] waves \the [src] over \the [K]'s head, [K] looks captivated by it."), SPAN_WARNING("[user] waves the [src] over your head. <b>You see a foreign light, asking you to follow it. Its presence burns and blinds.</b>"))
				var/choice = alert(K,"Do you want to give up your goal?","Become cleansed","Resist","Give in")
				switch(choice)
					if("Resist")
						K.visible_message(SPAN_WARNING("The gaze in [K]'s eyes remains determined."), SPAN_NOTICE("You turn away from the light, remaining true to the Geometer!"))
						K.say("*scream")
						K.take_overall_damage(5, 15)
						admin_attack_log(user, target_mob, "attempted to deconvert", "was unsuccessfully deconverted by", "attempted to deconvert")
					if("Give in")
						K.visible_message(SPAN_NOTICE("[K]'s eyes become clearer, the evil gone, but not without leaving scars."))
						K.take_overall_damage(10, 20)
						GLOB.cult.remove_antagonist(K.mind)
						admin_attack_log(user, target_mob, "successfully deconverted", "was successfully deconverted by", "successfully deconverted")
			else
				user.visible_message(SPAN_WARNING("[user]'s concentration is broken!"), SPAN_WARNING("Your concentration is broken! You and your target need to stay uninterrupted for longer!"))
				return

		else
			to_chat(user, SPAN_DANGER("The [src] appears to do nothing."))
			target_mob.visible_message(SPAN_DANGER("\The [user] waves \the [src] over \the [target_mob]'s head."))
			return
	else if(user.a_intent != I_HURT) // to prevent the chaplain from hurting peoples accidentally
		to_chat(user, SPAN_NOTICE("The [src] appears to do nothing."))
		return
	else
		return ..()

/obj/item/nullrod/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(istype(A, /turf/simulated/floor) && (cooldown + 5 SECONDS < world.time))
		cooldown = world.time
		user.visible_message(SPAN_NOTICE("[user] loudly taps their [src.name] against the floor."))
		playsound(user.loc, 'sound/effects/shieldbash.ogg', 50, 1)
		var/rune_found = FALSE
		for(var/obj/effect/rune/R in orange(2, get_turf(src)))
			if(R == src)
				continue
			rune_found = TRUE
			R.set_invisibility(0)
		if(rune_found)
			visible_message(SPAN_NOTICE("A holy glow permeates the air!"))
		return
	if(user.mind && (user.mind.assigned_role == "Chaplain"))
		if(A.reagents && A.reagents.has_reagent(/singleton/reagent/water)) //blesses all the water in the holder
			if(REAGENT_VOLUME(A.reagents, /singleton/reagent/water) > 60)
				to_chat(user, SPAN_NOTICE("There's too much water for you to bless at once!"))
			else
				to_chat(user, SPAN_NOTICE("You bless the water in [A], turning it into holy water."))
				var/water2holy = REAGENT_VOLUME(A.reagents, /singleton/reagent/water)
				A.reagents.del_reagent(/singleton/reagent/water)
				A.reagents.add_reagent(/singleton/reagent/water/holywater, water2holy)

/obj/item/reagent_containers/spray/aspergillum
	name = "aspergillum"
	desc = "A ceremonial item for sprinkling holy water, or other liquids, on a subject."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "aspergillum"
	item_state = "aspergillum"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = null
	spray_size = 1
	volume = 10
	spray_sound = 'sound/effects/jingle.ogg'

/obj/item/material/urn
	name = "urn"
	desc = "A vase used to store the ashes of the deceased."
	desc_extended = "To store ashes in an urn, click on the ash pile with the urn in your active hand. To empty an urn, use the urn in your active hand. Make sure you've labeled the urn so you know who's ashes are inside!"
	icon = 'icons/obj/urn.dmi'
	icon_state = "urn"
	applies_material_colour = TRUE
	w_class = WEIGHT_CLASS_SMALL
	item_flags = ITEM_FLAG_NO_BLUDGEON

/obj/item/material/urn/afterattack(var/obj/A, var/mob/user, var/proximity)
	if(!istype(A, /obj/effect/decal/cleanable/ash))
		return ..()
	else if(proximity)
		if(contents.len)
			to_chat(user, SPAN_WARNING("\The [src] is already full!"))
			return
		user.visible_message("[user] scoops \the [A] into \the [src], securing the lid.", "You scoop \the [A] into \the [src], securing the lid.")
		desc = "A vase used to store the ashes of the deceased. It contains some ashes."
		desc_extended = "To store ashes in an urn, click on the ash pile with the urn in your active hand. To empty an urn, use the urn in your active hand. Make sure you've labeled the urn so you know who's ashes are inside!"
		A.forceMove(src)

/obj/item/material/urn/attack_self(mob/user)
	if(!contents.len)
		to_chat(user, SPAN_WARNING("\The [src] is empty!"))
		return
	else
		for(var/obj/effect/decal/cleanable/ash/A in contents)
			A.dropInto(loc)
			user.visible_message("[user] pours \the [A] out from \the [src].", "You pour \the [A] out from \the [src].")
			desc = "A vase used to store the ashes of the deceased."
			desc_extended = "To store ashes in an urn, click on the ash pile with the urn in your active hand. To empty an urn, use the urn in your active hand. Make sure you've labeled the urn so you know who's ashes are inside!"

/obj/item/assunzioneorb
	name = "warding sphere"
	desc = "A religious artefact commonly associated with Luceism, this transparent globe gives off a faint ghostly white light at all times."
	desc_extended = "Luceian warding spheres are made on the planet of Assunzione in the great domed city of Guelma, and are carried by followers of the faith heading abroad. \
	Constructed out of glass and a luce vine bulb, these spheres can burn for years upon years, and it is said that the lights in the truly faithful's warding sphere will always \
	point towards Assunzione. It is considered extremely bad luck to have one's warding sphere break, to extinguish its flame, or to relinquish it (permanently) to an unbeliever."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "assunzioneorb"
	item_state = "assunzioneorb"
	throwforce = 5
	force = 11
	light_range = 1.4
	light_power = 1.4
	light_color = LIGHT_COLOR_BLUE
	w_class = WEIGHT_CLASS_SMALL
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/assunzioneorb/proc/shatter()
	visible_message(SPAN_WARNING("\The [src] shatters!"), SPAN_WARNING("You hear a small glass object shatter!"))
	playsound(get_turf(src), 'sound/effects/glass_hit.ogg', 75, TRUE)
	new /obj/item/material/shard(get_turf(src))
	qdel(src)

/obj/item/assunzioneorb/throw_impact(atom/hit_atom)
	..()
	shatter()

/obj/item/assunzioneorb/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if(user.a_intent != I_HURT)
		return

	shatter()

/obj/item/storage/assunzionesheath
	name = "warding sphere casing"
	desc = "A small metal shell designed to protect the warding sphere inside. The all-seeing eye of Ennoia, a common symbol of Luceism, is engraved upon the front of the casing."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "assunzionesheath_empty"
	can_hold = list(/obj/item/assunzioneorb)
	storage_slots = 1
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'

/obj/item/storage/assunzionesheath/update_icon()
	if(contents.len)
		icon_state = "assunzionesheath"
	else
		icon_state = "assunzionesheath_empty"

/obj/item/storage/assunzionesheath/filled
	starts_with = list(
		/obj/item/assunzioneorb = 1
	)

/obj/item/storage/assunzionesheath/Initialize()
	. = ..()
	update_icon()

/obj/item/storage/altar
	name = "altar"
	desc = "A small portable altar."
	icon = 'icons/obj/cult.dmi'
	icon_state = "talismanaltar"
	can_hold = list(/obj/item/nullrod)
	storage_slots = 1
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'

/obj/item/storage/altar/attack_hand(mob/user)
	if(!isturf(loc))
		..()
	if(use_check_and_message(user))
		return FALSE
	else
		open(user)

/obj/item/storage/altar/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
	if(use_check_and_message(over))
		return
	if(ishuman(over))
		forceMove(get_turf(user))
		user.put_in_hands(src)

/obj/item/storage/altar/kraszar
	name = "\improper Kraszar altar"
	desc = "An altar with a book honoring Kraszar, the Ma'ta'ke deity of joy, stories, and language."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "kraszar_bookstand"
	can_hold = list(/obj/item/storage/bible)
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'

/obj/item/storage/altar/rredouane
	name = "\improper Rredouane altar"
	desc = "An altar honoring Rredouane, the Ma'ta'ke deity of valor, triumph, and victory. It has a slot for a ceremonial sword."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "rredouane_altar_e"
	can_hold = list(/obj/item/nullrod/rredouane)

/obj/item/storage/altar/rredouane/update_icon()
	if(contents.len)
		icon_state = "rredouane_altar_s"
	else
		icon_state = "rredouane_altar_e"

/obj/item/storage/altar/dharmela
	name = "\improper Dharmela altar"
	desc = "An anvil-altar honoring Dharmela, the Ma'ta'ke deity of forges, anvils, and craftsmanship."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "dharmela_anvil"
	can_hold = list(/obj/item/nullrod/shumaila)

/obj/item/storage/altar/minharzzka
	name = "\improper Minharzzka altar"
	desc = "An small altar honoring Minharzzka, the Ma'ta'ke deity of waters and sailors."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "minharzzka_altar"

/obj/item/storage/altar/marryam
	name = "\improper Marryam altar"
	desc = "A poppyvase used as an altar to honor Marryam, the Ma'ta'ke deity of settlements, sleep, and parenthood."
	icon = 'icons/obj/tajara_items.dmi'
	icon_state = "marryam_poppyvase"
