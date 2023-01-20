/* Utility Closets
 * Contains:
 *		Emergency Closet
 *		Fire Closet
 *		Tool Closet
 *		Radiation Closet
 *		Bombsuit Closet
 *		Hydrant
 *		First Aid
 */

/*
 * Emergency Closet
 */
/obj/structure/closet/emcloset
	name = "emergency closet"
	desc = "It's a storage unit for emergency breathmasks and o2 tanks."
	icon_state = "emergency"
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED

/obj/structure/closet/emcloset/fill()
	switch (pickweight(list("small" = 50, "aid" = 20, "tank" = 10, "seal" = 10, "all" = 10)))
		if ("small")
			new /obj/item/tank/emergency_oxygen(src)
			new /obj/item/tank/emergency_oxygen(src)
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/clothing/suit/space/emergency(src)
			new /obj/item/clothing/head/helmet/space/emergency(src)
			new /obj/item/device/oxycandle(src)
			new /obj/item/airbubble(src)
		if ("aid")
			new /obj/item/tank/emergency_oxygen(src)
			new /obj/item/storage/toolbox/emergency(src)
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/storage/firstaid/o2(src)
			new /obj/item/clothing/suit/space/emergency(src)
			new /obj/item/clothing/head/helmet/space/emergency(src)
			new /obj/item/device/oxycandle(src)
			new /obj/item/airbubble(src)
		if ("tank")
			new /obj/item/tank/emergency_oxygen/engi(src)
			new /obj/item/clothing/mask/gas/alt(src)
			new /obj/item/tank/emergency_oxygen/engi(src)
			new /obj/item/clothing/mask/gas/alt(src)
			new /obj/item/clothing/mask/gas/half(src)
			new /obj/item/device/oxycandle(src)
			new /obj/item/device/oxycandle(src)
			new /obj/item/airbubble(src)
		if ("seal")
			new /obj/item/tank/emergency_oxygen(src)
			new /obj/item/storage/toolbox/emergency(src)
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/clothing/suit/space/emergency(src)
			new /obj/item/clothing/head/helmet/space/emergency(src)
			new /obj/item/device/oxycandle(src)
			new /obj/item/storage/bag/inflatable/emergency(src)
		if ("all")
			new /obj/item/storage/toolbox/emergency(src)
			new /obj/item/tank/emergency_oxygen/engi(src)
			new /obj/item/clothing/mask/breath(src)
			new /obj/item/clothing/mask/gas/alt(src)
			new /obj/item/clothing/mask/gas/half(src)
			new /obj/item/storage/firstaid/o2(src)
			new /obj/item/clothing/suit/space/emergency(src)
			new /obj/item/clothing/suit/space/emergency(src)
			new /obj/item/clothing/head/helmet/space/emergency(src)
			new /obj/item/clothing/head/helmet/space/emergency(src)
			new /obj/item/device/oxycandle(src)
			new /obj/item/device/oxycandle(src)
			new /obj/item/device/oxycandle(src)
			new /obj/item/airbubble(src)
			new /obj/item/airbubble(src)
			new /obj/item/storage/bag/inflatable/emergency(src)

/obj/structure/closet/emcloset/legacy/fill()
	..()
	new /obj/item/tank/oxygen(src)
	new /obj/item/clothing/mask/gas(src)

/obj/structure/closet/emcloset/offworlder
	name = "offworlder supplies"
	desc = "It's a storage unit for offworlder breathing apparatus."

/obj/structure/closet/emcloset/offworlder/fill()
	new /obj/item/rig/light/offworlder
	new /obj/item/rig/light/offworlder
	new /obj/item/rig/light/offworlder
	new /obj/item/clothing/accessory/offworlder/bracer
	new /obj/item/clothing/accessory/offworlder/bracer
	new /obj/item/clothing/accessory/offworlder/bracer
	new /obj/item/storage/pill_bottle/rmt
	new /obj/item/storage/pill_bottle/rmt
	new /obj/item/storage/pill_bottle/rmt
	new /obj/item/clothing/mask/offworlder

/*
 * Fire Closet
 */
/obj/structure/closet/firecloset
	name = "firefighting closet"
	desc = "It's a storage unit for firefighting supplies."
	icon_state = "fire"

/obj/structure/closet/firecloset/fill()
	new /obj/item/clothing/head/hardhat/firefighter(src)
	new /obj/item/clothing/suit/fire(src)
	new /obj/item/clothing/mask/gas/alt(src)
	new /obj/item/crowbar/rescue_axe/red(src)
	new /obj/item/tank/oxygen/red(src)
	new /obj/item/extinguisher(src)
	new /obj/item/inflatable/door(src)
	new /obj/item/inflatable/wall(src)
	new /obj/item/inflatable/wall(src)

/obj/structure/closet/firecloset/full/fill()
	new /obj/item/clothing/head/hardhat/firefighter(src)
	new /obj/item/clothing/suit/fire(src)
	new /obj/item/clothing/mask/gas/alt(src)
	new /obj/item/crowbar/rescue_axe/red(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/tank/oxygen/red(src)
	new /obj/item/extinguisher(src)
	new /obj/item/storage/bag/inflatable/emergency(src)

/*
 * Tool Closet
 */
/obj/structure/closet/toolcloset
	name = "tool closet"
	desc = "It's a storage unit for tools."
	icon_state = "eng"
	icon_door = "eng_tool"

/obj/structure/closet/toolcloset/fill()
	if(prob(40))
		new /obj/item/clothing/suit/storage/hazardvest(src)
	if(prob(70))
		new /obj/item/device/flashlight(src)
	if(prob(70))
		new /obj/item/screwdriver(src)
	if(prob(70))
		new /obj/item/wrench(src)
	if(prob(70))
		new /obj/item/weldingtool(src)
	if(prob(70))
		new /obj/item/crowbar(src)
	if(prob(70))
		new /obj/item/wirecutters(src)
	if(prob(70))
		new /obj/item/device/t_scanner(src)
	if(prob(20))
		new /obj/item/storage/belt/utility(src)
	if(prob(20))
		new /obj/item/storage/belt/utility/alt(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
	if(prob(30))
		new /obj/item/stack/cable_coil/random(src)
	if(prob(20))
		new /obj/item/device/multitool(src)
	if(prob(5))
		new /obj/item/clothing/gloves/yellow(src)
	if(prob(40))
		new /obj/item/clothing/head/hardhat(src)

/obj/structure/closet/toolcloset/empty/fill()


/*
 * Radiation Closet
 */
/obj/structure/closet/radiation
	name = "radiation suit closet"
	desc = "It's a storage unit for rad-protective suits."
	icon_state = "eng"
	icon_door = "eng_rad"

/obj/structure/closet/radiation/fill()
	for(var/i = 1 to 2)
		new /obj/item/clothing/head/radiation(src)
		new /obj/item/clothing/suit/radiation(src)
		new /obj/item/clothing/glasses/safety/goggles(src)
	for(var/i = 1 to 2)
		new /obj/item/reagent_containers/hypospray/autoinjector/hyronalin(src)

/*
 * Bombsuit closet
 */
/obj/structure/closet/bombcloset
	name = "\improper EOD closet"
	desc = "It's a storage unit for explosive-defusal equipment."
	icon_state = "bomb"

/obj/structure/closet/bombcloset/fill()
	new /obj/item/clothing/suit/bomb_suit(src)
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/head/bomb_hood(src)
	new /obj/item/wirecutters/bomb(src)

/obj/structure/closet/bombclosetsecurity // Why the hell is this different? And this is like, only used ONCE! Madness, I tell you.
	name = "\improper EOD closet"
	desc = "It's a storage unit for the security department's explosive-defusal equipment."
	icon_state = "bombsec"

/obj/structure/closet/bombclosetsecurity/fill()
	new /obj/item/clothing/suit/bomb_suit/security(src)
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/head/bomb_hood/security(src)
	new /obj/item/wirecutters/bomb(src)
