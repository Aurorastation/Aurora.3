/atom/movable/screen/internals
	name = "internal"
	screen_loc = ui_internal
	icon_state = "internal0"

/**
 * Given how important Internals are, some clarifying comments on their behavior are worthwhile.
 *
 * When a character clicks on the Internals button on their UI and so long as they have an appropriate breathing mask, the game will
 * see what tanks they have available to choose from and try to pick the best one. It will look in the following places:
 * * suit storage, back, belt, both hands, both pockets, vaurca reserve tank, and hardsuit (if worn on back)
 * Then it will look at the contents of each tank (by mole) and try to pick the tank with the most breathable gas (for your species) in it.
 *
 * However, there are some caveats to this; the game tries to understand whether or not your character would know the contents of a given
 * tank. It can approximate this thanks to the fact that gas tanks of all types remember who touched them last; if you're the last person to
 * have pulled it from a canister or scanned it with a gas analyzer, the game assumes that your character knows what's inside it. This will
 * make your Internals button be a bit more intelligent about how it ranks gas tanks.
 *
 * By default, if your character is 'ignorant' of the contents, it will just dump all your available tanks in a list and try to find which
 * one contains the most moles of gas. It doesn't care what that gas mixture is.
 *
 * However, if your character 'knows' what's in a gas tank, it will try to discriminate; only tanks containing your species' breathable gas
 * (and trying to rule out oxygen + phoron for O2-breathers, though other poisons are not accounted for) will be considered, and sorted by
 * how many total moles of oxygen are available.
 *
 * For this reason, checking the contents of jetpacks and gas tanks with analyzers is probably a wise SOP, or else not equipping a jetpack
 * until after you're EVA and internals have been enabled.
 */
/atom/movable/screen/internals/Click()
	if(!iscarbon(usr))
		return
	var/mob/living/carbon/C = usr
	if(!C.stat && !C.stunned && !C.paralysis && !C.restrained())
		if(C.internal)
			C.internal = null
			to_chat(C, SPAN_NOTICE("No longer running on internals."))
			if(C.internals)
				C.internals.icon_state = "internal0"
		else
			if(!has_internals_mask(C))
				to_chat(C, SPAN_NOTICE("You are not wearing a suitable mask or helmet."))
				return 1
			else
				var/list/nicename = null
				var/list/tankcheck = null
				var/breathes = GAS_OXYGEN    //default, we'll check later
				var/list/contents = list()
				var/from = "on"

				if(ishuman(C))
					var/mob/living/carbon/human/H = C
					breathes = H.species.breath_type
					nicename = list ("suit", "back", "belt", "right hand", "left hand", "left pocket", "right pocket")
					tankcheck = list (H.s_store, C.back, H.belt, C.r_hand, C.l_hand, H.l_store, H.r_store)
					if(H.species.has_organ[BP_PHORON_RESERVE])
						var/obj/item/organ/internal/vaurca/preserve/preserve = H.internal_organs_by_name[BP_PHORON_RESERVE]
						if(preserve && preserve.air_contents)
							from = "in"
							nicename |= "sternum"
							tankcheck |= preserve

				else
					nicename = list("right hand", "left hand", "back")
					tankcheck = list(C.r_hand, C.l_hand, C.back)

				// Rigs are a fucking pain since they keep an air tank in nullspace.
				if(istype(C.back,/obj/item/rig))
					var/obj/item/rig/rig = C.back
					if(rig.air_supply)
						from = "in"
						nicename |= "hardsuit"
						tankcheck |= rig.air_supply

				for(var/i in 1 to tankcheck.len)
					if(istype(tankcheck[i], /obj/item/tank))
						var/obj/item/tank/t = tankcheck[i]
						// This tank has been set to not distribute any gas to internals. Skip it so we don't instantly detonate a pair of lungs.
						if(t.distribute_pressure == 0)
							contents.Add(0)
							continue

						// Someone messed with the tank and put unknown gases in it, so we're going to believe the tank is what it says it is.
						if(!isnull(t.manipulated_by) && t.manipulated_by != C.real_name && findtext(t.desc,breathes))
							contents.Add(t.air_contents.total_moles)
							continue

						// These tanks we're sure of their contents, so we're a bit more picky about them.
						switch(breathes)
							if(GAS_NITROGEN)
								if(t.air_contents.gas[GAS_NITROGEN] && !t.air_contents.gas[GAS_OXYGEN])
									contents.Add(t.air_contents.gas[GAS_NITROGEN])
								else
									contents.Add(0)

							if(GAS_OXYGEN)
								if(t.air_contents.gas[GAS_OXYGEN] && !t.air_contents.gas[GAS_PHORON])
									contents.Add(t.air_contents.gas[GAS_OXYGEN])
								else
									contents.Add(0)

							// No races breath this, but never know about downstream servers.
							if(GAS_CO2)
								if(t.air_contents.gas[GAS_CO2] && !t.air_contents.gas[GAS_PHORON])
									contents.Add(t.air_contents.gas[GAS_CO2])
								else
									contents.Add(0)

							if(GAS_PHORON)
								if(t.air_contents.gas[GAS_CO2] && !t.air_contents.gas[GAS_NITROGEN])
									contents.Add(t.air_contents.gas[GAS_PHORON])
								else
									contents.Add(0)

					if(istype(tankcheck[i], /obj/item/organ/internal/vaurca/preserve))
						var/obj/item/organ/internal/vaurca/preserve/t = tankcheck[i]

						// This tank has been set to not distribute any gas to internals. Skip it so we don't instantly detonate a pair of lungs.
						if(t.distribute_pressure == 0)
							contents.Add(0)
							continue

						// Someone messed with the tank and put unknown gases in it, so we're going to believe the tank is what it says it is.
						if(!isnull(t.manipulated_by) && t.manipulated_by != C.real_name && findtext(t.desc,breathes))
							contents.Add(t.air_contents.total_moles)
							continue

						// These tanks we're sure of their contents, so we're a bit more picky about them.
						switch(breathes)
							if(GAS_NITROGEN)
								if(t.air_contents.gas[GAS_NITROGEN] && !t.air_contents.gas[GAS_OXYGEN])
									contents.Add(t.air_contents.gas[GAS_NITROGEN])
								else
									contents.Add(0)

							if(GAS_OXYGEN)
								if(t.air_contents.gas[GAS_OXYGEN] && !t.air_contents.gas[GAS_PHORON])
									contents.Add(t.air_contents.gas[GAS_OXYGEN])
								else
									contents.Add(0)

							// No races breath this, but never know about downstream servers.
							if(GAS_CO2)
								if(t.air_contents.gas[GAS_CO2] && !t.air_contents.gas[GAS_PHORON])
									contents.Add(t.air_contents.gas[GAS_CO2])
								else
									contents.Add(0)

							if(GAS_PHORON)
								if(t.air_contents.gas[GAS_PHORON] && !t.air_contents.gas[GAS_NITROGEN])
									contents.Add(t.air_contents.gas[GAS_PHORON])
								else
									contents.Add(0)

					if(!(istype(tankcheck[i], /obj/item/organ/internal/vaurca/preserve)) && !(istype(tankcheck[i], /obj/item/tank)))
						//no tank so we set contents to 0
						contents.Add(0)

				//Alright now we know the contents of the tanks so we have to pick the best one.

				var/best = 0
				var/bestcontents = 0
				for(var/i=1, i <  contents.len + 1 , ++i)
					if(!contents[i])
						continue
					if(contents[i] > bestcontents)
						best = i
						bestcontents = contents[i]

				//We've determined the best container now we set it as our internals

				if(best)
					to_chat(C, SPAN_NOTICE("You are now running on internals from [tankcheck[best]] [from] your [nicename[best]]."))
					playsound(usr, 'sound/effects/internals.ogg', 100, 1)
					C.internal = tankcheck[best]


				if(C.internal)
					if(C.internals)
						C.internals.icon_state = "internal1"
				else
					to_chat(C, SPAN_NOTICE("You don't have a[breathes==GAS_OXYGEN ? "n oxygen" : addtext(" ",breathes)] tank."))

/atom/movable/screen/internals/proc/lose_internals(var/mob/living/carbon/human/user)
	icon_state = "internal0"
	user.internal = null

/atom/movable/screen/internals/proc/has_internals_mask(var/mob/living/carbon/human/user)
	if(user.wear_mask && (user.wear_mask.item_flags & ITEM_FLAG_AIRTIGHT))
		return TRUE
	if(user.head && (user.head.item_flags & ITEM_FLAG_AIRTIGHT))
		return TRUE
	return FALSE
