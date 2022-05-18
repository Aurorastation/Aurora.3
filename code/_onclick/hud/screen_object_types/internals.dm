/obj/screen/internals
	name = "internal"
	screen_loc = ui_internal
	icon_state = "internal0"

/obj/screen/internals/Click()
	if(!iscarbon(usr))
		return
	var/mob/living/carbon/C = usr
	if(!C.stat && !C.stunned && !C.paralysis && !C.restrained())
		if(C.internal)
			C.internal = null
			to_chat(C, "<span class='notice'>No longer running on internals.</span>")
			if(C.internals)
				C.internals.icon_state = "internal0"
		else

			var/no_mask
			if(!(C.wear_mask && C.wear_mask.item_flags & AIRTIGHT))
				var/mob/living/carbon/human/H = C
				if(!(H.head && H.head.item_flags & AIRTIGHT))
					no_mask = 1

			if(no_mask)
				to_chat(C, "<span class='notice'>You are not wearing a suitable mask or helmet.</span>")
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
						if (!isnull(t.manipulated_by) && t.manipulated_by != C.real_name && findtext(t.desc,breathes))
							contents.Add(t.air_contents.total_moles)	//Someone messed with the tank and put unknown gasses
							continue					//in it, so we're going to believe the tank is what it says it is
						switch(breathes)
															//These tanks we're sure of their contents
							if(GAS_NITROGEN) 							//So we're a bit more picky about them.

								if(t.air_contents.gas[GAS_NITROGEN] && !t.air_contents.gas[GAS_OXYGEN])
									contents.Add(t.air_contents.gas[GAS_NITROGEN])
								else
									contents.Add(0)

							if (GAS_OXYGEN)
								if(t.air_contents.gas[GAS_OXYGEN] && !t.air_contents.gas[GAS_PHORON])
									contents.Add(t.air_contents.gas[GAS_OXYGEN])
								else
									contents.Add(0)

							// No races breath this, but never know about downstream servers.
							if (GAS_CO2)
								if(t.air_contents.gas[GAS_CO2] && !t.air_contents.gas[GAS_PHORON])
									contents.Add(t.air_contents.gas[GAS_CO2])
								else
									contents.Add(0)

							if (GAS_PHORON)
								if(t.air_contents.gas[GAS_CO2] && !t.air_contents.gas[GAS_NITROGEN])
									contents.Add(t.air_contents.gas[GAS_PHORON])
								else
									contents.Add(0)

					if(istype(tankcheck[i], /obj/item/organ/internal/vaurca/preserve))
						var/obj/item/organ/internal/vaurca/preserve/t = tankcheck[i]
						if (!isnull(t.manipulated_by) && t.manipulated_by != C.real_name && findtext(t.desc,breathes))
							contents.Add(t.air_contents.total_moles)	//Someone messed with the tank and put unknown gasses
							continue					//in it, so we're going to believe the tank is what it says it is
						switch(breathes)
															//These tanks we're sure of their contents
							if(GAS_NITROGEN) 							//So we're a bit more picky about them.

								if(t.air_contents.gas[GAS_NITROGEN] && !t.air_contents.gas[GAS_OXYGEN])
									contents.Add(t.air_contents.gas[GAS_NITROGEN])
								else
									contents.Add(0)

							if (GAS_OXYGEN)
								if(t.air_contents.gas[GAS_OXYGEN] && !t.air_contents.gas[GAS_PHORON])
									contents.Add(t.air_contents.gas[GAS_OXYGEN])
								else
									contents.Add(0)

							// No races breath this, but never know about downstream servers.
							if (GAS_CO2)
								if(t.air_contents.gas[GAS_CO2] && !t.air_contents.gas[GAS_PHORON])
									contents.Add(t.air_contents.gas[GAS_CO2])
								else
									contents.Add(0)

							if (GAS_PHORON)
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
					to_chat(C, "<span class='notice'>You are now running on internals from [tankcheck[best]] [from] your [nicename[best]].</span>")
					playsound(usr, 'sound/effects/internals.ogg', 100, 1)
					C.internal = tankcheck[best]


				if(C.internal)
					if(C.internals)
						C.internals.icon_state = "internal1"
				else
					to_chat(C, "<span class='notice'>You don't have a[breathes==GAS_OXYGEN ? "n oxygen" : addtext(" ",breathes)] tank.</span>")
