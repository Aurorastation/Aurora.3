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
				var/breathes = "oxygen"    //default, we'll check later
				var/list/contents = list()
				var/from = "on"

				if(ishuman(C))
					var/mob/living/carbon/human/H = C
					breathes = H.species.breath_type
					nicename = list ("suit", "back", "belt", "right hand", "left hand", "left pocket", "right pocket")
					tankcheck = list (H.s_store, C.back, H.belt, C.r_hand, C.l_hand, H.l_store, H.r_store)
					if(H.species.has_organ["phoron reserve tank"])
						var/obj/item/organ/vaurca/preserve/preserve = H.internal_organs_by_name["phoron reserve tank"]
						if(preserve && preserve.air_contents)
							from = "in"
							nicename |= "sternum"
							tankcheck |= preserve

				else
					nicename = list("right hand", "left hand", "back")
					tankcheck = list(C.r_hand, C.l_hand, C.back)

				// Rigs are a fucking pain since they keep an air tank in nullspace.
				if(istype(C.back,/obj/item/weapon/rig))
					var/obj/item/weapon/rig/rig = C.back
					if(rig.air_supply)
						from = "in"
						nicename |= "hardsuit"
						tankcheck |= rig.air_supply

				for(var/i in 1 to tankcheck.len)
					if(istype(tankcheck[i], /obj/item/weapon/tank))
						var/obj/item/weapon/tank/t = tankcheck[i]
						if (!isnull(t.manipulated_by) && t.manipulated_by != C.real_name && findtext(t.desc,breathes))
							contents.Add(t.air_contents.total_moles)	//Someone messed with the tank and put unknown gasses
							continue					//in it, so we're going to believe the tank is what it says it is
						switch(breathes)
															//These tanks we're sure of their contents
							if("nitrogen") 							//So we're a bit more picky about them.

								if(t.air_contents.gas["nitrogen"] && !t.air_contents.gas["oxygen"])
									contents.Add(t.air_contents.gas["nitrogen"])
								else
									contents.Add(0)

							if ("oxygen")
								if(t.air_contents.gas["oxygen"] && !t.air_contents.gas["phoron"])
									contents.Add(t.air_contents.gas["oxygen"])
								else
									contents.Add(0)

							// No races breath this, but never know about downstream servers.
							if ("carbon dioxide")
								if(t.air_contents.gas["carbon_dioxide"] && !t.air_contents.gas["phoron"])
									contents.Add(t.air_contents.gas["carbon_dioxide"])
								else
									contents.Add(0)

							if ("phoron")
								if(t.air_contents.gas["carbon_dioxide"] && !t.air_contents.gas["nitrogen"])
									contents.Add(t.air_contents.gas["phoron"])
								else
									contents.Add(0)

					if(istype(tankcheck[i], /obj/item/organ/vaurca/preserve))
						var/obj/item/organ/vaurca/preserve/t = tankcheck[i]
						if (!isnull(t.manipulated_by) && t.manipulated_by != C.real_name && findtext(t.desc,breathes))
							contents.Add(t.air_contents.total_moles)	//Someone messed with the tank and put unknown gasses
							continue					//in it, so we're going to believe the tank is what it says it is
						switch(breathes)
															//These tanks we're sure of their contents
							if("nitrogen") 							//So we're a bit more picky about them.

								if(t.air_contents.gas["nitrogen"] && !t.air_contents.gas["oxygen"])
									contents.Add(t.air_contents.gas["nitrogen"])
								else
									contents.Add(0)

							if ("oxygen")
								if(t.air_contents.gas["oxygen"] && !t.air_contents.gas["phoron"])
									contents.Add(t.air_contents.gas["oxygen"])
								else
									contents.Add(0)

							// No races breath this, but never know about downstream servers.
							if ("carbon dioxide")
								if(t.air_contents.gas["carbon_dioxide"] && !t.air_contents.gas["phoron"])
									contents.Add(t.air_contents.gas["carbon_dioxide"])
								else
									contents.Add(0)

							if ("phoron")
								if(t.air_contents.gas["phoron"] && !t.air_contents.gas["nitrogen"])
									contents.Add(t.air_contents.gas["phoron"])
								else
									contents.Add(0)

					if(!(istype(tankcheck[i], /obj/item/organ/vaurca/preserve)) & !(istype(tankcheck[i], /obj/item/weapon/tank)))
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
					to_chat(C, "<span class='notice'>You don't have a[breathes=="oxygen" ? "n oxygen" : addtext(" ",breathes)] tank.</span>")
