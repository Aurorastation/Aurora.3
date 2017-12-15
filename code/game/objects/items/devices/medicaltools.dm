/*
Contains:
- Handheld suit sensor monitor
- Space Klot

*/
//HANDHELD SUIT SENSOR
/obj/item/device/handheld_medical
	name = "hand-held suit sensor monitor"
	desc = "A miniature machine that tracks suit sensors across the station."
	icon = 'icons/obj/device.dmi'
	icon_state = "scanner"
	w_class = 2
	slot_flags = SLOT_BELT
	var/datum/nano_module/crew_monitor/crew_monitor

/obj/item/device/handheld_medical/Initialize()
	. = ..()
	crew_monitor = new(src)

/obj/item/device/handheld_medical/Destroy()
	qdel(crew_monitor)
	crew_monitor = null
	return ..()

/obj/item/device/handheld_medical/attack_self(mob/user)
	crew_monitor.ui_interact(user)

// SPACE KLOT. This stops bleeding and has a small chance to stop some internal bleeding, but it will be locked behind a tech tree + does not disinfect like a normal bruise pack.
/obj/item/stack/medical/advanced/bruise_pack/spaceklot
	name = "space klot"
	singular_name = "space klot"
	desc = "A powder that, when poured on an open wound, quickly stops the bleeding. Combine with bandages for the best effect."
	icon = 'icons/obj/items.dmi'
	icon_state = "powderbag"
	heal_brute = 15
	origin_tech = list(TECH_BIO = 4)
	var/open = 0
	var/used = 0

/obj/item/stack/medical/advanced/bruise_pack/spaceklot/attack(mob/living/carbon/M as mob, mob/user as mob)
	if(..())
		return 1
	if(used)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

		if(affecting.open == 0)
			if(affecting.is_bandaged())
				user << "<span class='warning'>The wounds on [M]'s [affecting.name] have already been treated.</span>"
				return 1
			else
				user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				user.visible_message("<span class='notice'>\The [user] starts treating [M]'s [affecting.name].</span>", \
						             "<span class='notice'>You start treating [M]'s [affecting.name].</span>" )
				if(!do_after(user, 100, act_target = M))
					return
				for (var/datum/wound/W in affecting.wounds)
					if (W.internal)
						if(prob(25)) // Space Klot technology.
							W.heal_damage(heal_brute, 1)
					if (W.bandaged)
						continue
					if(used == amount)
						break
					if(!do_mob(user, M, W.damage/5))
						user << "<span class='notice'>You must stand still to bandage wounds.</span>"
						break
					if (W.current_stage <= W.max_bleeding_stage)
						user.visible_message("<span class='notice'>\The [user] pours the powder \a [W.desc] on [M]'s [affecting.name].</span>", \
						                     "<span class='notice'>You pour the powder \a [W.desc] on [M]'s [affecting.name].</span>" )

					W.bandage()
					W.heal_damage(heal_brute, 0)
					used = 1
				affecting.update_damages()
