/obj/structure/closet/secure_closet/captains
	name = "captain's locker"
	req_access = list(access_captain)
	icon_state = "cap"

/obj/structure/closet/secure_closet/captains/fill()
	// Backpack
	if(prob(50))
		new /obj/item/storage/backpack/captain(src)
	else
		new /obj/item/storage/backpack/satchel/cap(src)
	new /obj/item/storage/backpack/duffel/cap(src)
	// Armor
	new /obj/item/clothing/head/helmet(src)
	new /obj/item/clothing/suit/armor/carrier/officer(src)
	//Tools
	new /obj/item/device/radio/headset/heads/captain(src)
	new /obj/item/device/radio/headset/heads/captain/alt(src)
	new /obj/item/device/megaphone/command(src)
	new /obj/item/gun/energy/disruptorpistol(src)
	new /obj/item/device/flash(src)
	new /obj/item/melee/telebaton(src)
	// uniform briefcases
	new /obj/item/storage/briefcase/nt/captain(src)
	new /obj/item/storage/briefcase/nt/captain_white(src)
	new /obj/item/storage/briefcase/nt/captain_formal(src)
	new /obj/item/storage/briefcase/nt/acap(src)

/obj/structure/closet/secure_closet/captains2
	name = "captain's attire"
	req_access = list(access_captain)
	icon_state = "cap"

/obj/structure/closet/secure_closet/captains2/fill()
	new /obj/item/storage/backpack/captain(src)
	new /obj/item/storage/backpack/satchel/cap(src)
	new /obj/item/clothing/suit/captunic(src)
	new /obj/item/clothing/suit/captunic/capjacket(src)
	new /obj/item/clothing/head/caphat(src)
	new /obj/item/clothing/head/bandana/captain(src)
	new /obj/item/clothing/under/rank/captain(src)
	new /obj/item/clothing/suit/storage/vest(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/gloves/captain(src)
	new /obj/item/clothing/under/dress/dress_cap(src)
	new /obj/item/clothing/head/helmet/formalcaptain(src)
	new /obj/item/clothing/under/captainformal(src)

/obj/structure/closet/secure_closet/xo
	name = "executive officer's locker"
	req_access = list(access_hop)
	icon_state = "sec"
	icon_door = "hop"

/obj/structure/closet/secure_closet/xo/fill()
	..()
	//Supply
	new /obj/item/storage/box/ids(src)
	new /obj/item/storage/box/ids(src)
	new /obj/item/storage/box/fancy/keypouch/sec(src)
	new /obj/item/storage/box/fancy/keypouch/service(src)
	//Appearance
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/suit/armor/carrier/officer(src)
	new /obj/item/clothing/head/helmet(src)
	new /obj/item/clothing/accessory/holster/waist(src)
	//Tools
	new /obj/item/device/radio/headset/heads/xo(src)
	new /obj/item/device/radio/headset/heads/xo/alt(src)
	new /obj/item/device/megaphone/command(src)
	new /obj/item/storage/box/goldstar(src)
	new /obj/item/gun/energy/disruptorpistol(src)
	new /obj/item/gun/projectile/sec/flash(src)
	new /obj/item/device/flash(src)

/obj/structure/closet/secure_closet/xo2
	name = "executive officer's attire"
	req_access = list(access_hop)
	icon_state = "sec"
	icon_door = "hop"

/obj/structure/closet/secure_closet/xo2/fill()
	..()
	new /obj/item/clothing/under/rank/xo(src)
	new /obj/item/clothing/head/caphat/xo(src)
	new /obj/random/suit(src)
	new /obj/random/suit(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/laceup/brown(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/head/caphat/cap/beret/xo(src)
	new /obj/item/clothing/gloves/captain/white/xo(src)

/obj/structure/closet/secure_closet/hos
	name = "head of security's locker"
	req_access = list(access_hos)
	icon_state = "hos"

/obj/structure/closet/secure_closet/hos/fill()
	..()
	//Supply
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/box/ids(src)
	//Appearance
	if(prob(50))
		new /obj/item/storage/backpack/security(src)
	else
		new /obj/item/storage/backpack/satchel/sec(src)
	new /obj/item/storage/backpack/duffel/sec(src)
	new /obj/item/clothing/suit/armor/carrier/hos(src)
	new /obj/item/clothing/accessory/leg_guard(src)
	new /obj/item/clothing/accessory/arm_guard(src)
	new /obj/item/clothing/head/helmet/hos(src)
	new /obj/item/clothing/accessory/badge/hos(src)
	new /obj/item/clothing/suit/storage/security/hos(src)
	new /obj/item/clothing/mask/gas/alt(src)
	new /obj/item/clothing/mask/gas/half(src)
	//Tools
	new /obj/item/device/radio/headset/heads/hos(src)
	new /obj/item/device/radio/headset/heads/hos/alt(src)
	new /obj/item/device/megaphone/sec(src)
	new /obj/item/storage/box/tranquilizer(src)
	new /obj/item/clothing/glasses/sunglasses/sechud(src)
	new /obj/item/clothing/glasses/sunglasses/sechud/head(src)
	new /obj/item/shield/riot/tact(src)
	new /obj/item/melee/telebaton(src)
	new /obj/item/gun/energy/disruptorpistol(src)
	new /obj/item/taperoll/police(src)
	new /obj/item/device/breath_analyzer(src)
	new /obj/item/crowbar/red(src)
	new /obj/item/ipc_tag_scanner(src)
	//Belts
	new /obj/item/clothing/accessory/holster/waist(src)
	new /obj/item/storage/belt/security/full(src)
	new /obj/item/storage/box/fancy/keypouch/sec(src)

/obj/structure/closet/secure_closet/hos2
	name = "head of security's attire"
	req_access = list(access_hos)
	icon_state = "hos"

/obj/structure/closet/secure_closet/hos2/fill()
	//Appearance
	if(prob(50))
		new /obj/item/storage/backpack/security(src)
	else
		new /obj/item/storage/backpack/satchel/sec(src)
	new /obj/item/storage/backpack/duffel/sec(src)
	new /obj/item/clothing/suit/armor/carrier/hos(src)
	new /obj/item/clothing/accessory/leg_guard(src)
	new /obj/item/clothing/accessory/arm_guard(src)
	new /obj/item/clothing/head/helmet/hos(src)
	//Tools
	new /obj/item/clothing/glasses/sunglasses/sechud/aviator(src)
	new /obj/item/device/radio/headset/heads/hos(src)
	new /obj/item/device/radio/headset/heads/hos/alt(src)
	//Belts
	new /obj/item/storage/belt/security(src)
	new /obj/item/clothing/accessory/holster/waist(src)
	new /obj/item/device/breath_analyzer(src)

/obj/structure/closet/secure_closet/warden
	name = "warden's locker"
	req_access = list(access_armory)
	icon_state = "warden"

/obj/structure/closet/secure_closet/warden/fill()
	//Supply
	new /obj/item/storage/box/ids(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/box/teargas(src)
	//Appearance
	if(prob(50))
		new /obj/item/storage/backpack/security(src)
	else
		new /obj/item/storage/backpack/satchel/sec(src)
	new /obj/item/storage/backpack/duffel/sec(src)
	new /obj/item/clothing/suit/armor/carrier/officer(src)
	new /obj/item/clothing/accessory/arm_guard(src)
	new /obj/item/clothing/accessory/leg_guard(src)
	new /obj/item/clothing/head/helmet/security(src)
	new /obj/item/clothing/accessory/badge/warden(src)
	new /obj/item/clothing/mask/gas/alt(src)
	new /obj/item/clothing/mask/gas/half(src)
	//Tools
	new /obj/item/device/radio/headset/headset_warden(src)
	new /obj/item/device/radio/headset/headset_warden/alt(src)
	new /obj/item/clothing/glasses/sunglasses/sechud/aviator(src)
	new /obj/item/clothing/glasses/sunglasses/sechud(src)
	new /obj/item/taperoll/police(src)
	new /obj/item/gun/energy/disruptorpistol(src)
	//Belts
	new /obj/item/clothing/accessory/storage/black_vest(src)
	new /obj/item/clothing/accessory/holster/hip(src)
	new /obj/item/storage/belt/security/full(src)
	// Utility
	new /obj/item/device/radio/sec(src)
	new /obj/item/crowbar(src)
	new /obj/item/device/flashlight/maglight(src)
	new /obj/item/wrench(src)
	new /obj/item/device/multitool(src)


/obj/structure/closet/secure_closet/security_cadet
	name = "security cadet's locker"
	req_access = list(access_security)
	icon_state = "sec"
	icon_door = "seccadet"

/obj/structure/closet/secure_closet/security_cadet/fill()
	//Appearance
	if(prob(50))
		new /obj/item/storage/backpack/security(src)
	else
		new /obj/item/storage/backpack/satchel/sec(src)
	new /obj/item/storage/backpack/duffel/sec(src)
	new /obj/item/clothing/head/beret/security(src)
	new /obj/item/clothing/head/softcap/security(src)
	new /obj/item/clothing/suit/storage/hazardvest/security(src)
	new /obj/item/clothing/under/rank/cadet(src)
	//Tools
	new /obj/item/device/radio/headset/headset_sec(src)
	new /obj/item/device/radio/headset/headset_sec/alt(src)
	new /obj/item/device/flash(src)
	new /obj/item/reagent_containers/spray/pepper(src)
	new /obj/item/taperoll/police(src)
	new /obj/item/device/hailer(src)
	new /obj/item/device/holowarrant(src)
	new /obj/item/device/flashlight/flare/glowstick/red(src)
	//Belts
	new /obj/item/clothing/accessory/storage/black_vest(src)
	new /obj/item/storage/belt/security(src)

/obj/structure/closet/secure_closet/security
	name = "security officer's locker"
	req_access = list(access_brig)
	icon_state = "sec"

/obj/structure/closet/secure_closet/security/fill()
	//Appearance
	if(prob(50))
		new /obj/item/storage/backpack/security(src)
	else
		new /obj/item/storage/backpack/satchel/sec(src)
	new /obj/item/storage/backpack/duffel/sec(src)
	new /obj/item/clothing/suit/armor/carrier/officer(src)
	new /obj/item/clothing/accessory/arm_guard(src)
	new /obj/item/clothing/accessory/leg_guard(src)
	new /obj/item/clothing/head/helmet/security(src)
	new /obj/item/clothing/accessory/badge/officer(src)
	new /obj/item/clothing/mask/gas/alt(src)
	new /obj/item/clothing/mask/gas/half(src)
	//Tools
	new /obj/item/device/radio/headset/headset_sec(src)
	new /obj/item/device/radio/headset/headset_sec/alt(src)
	new /obj/item/clothing/glasses/sunglasses/sechud/aviator(src)
	new /obj/item/clothing/glasses/sunglasses/sechud(src)
	new /obj/item/gun/energy/disruptorpistol/security(src)
	new /obj/item/taperoll/police(src)
	new /obj/item/device/hailer(src)
	new /obj/item/device/flashlight/flare/glowstick/red(src)
	//Belts
	new /obj/item/clothing/accessory/storage/black_vest(src)
	new /obj/item/clothing/accessory/holster/hip(src)
	new /obj/item/storage/belt/security/full(src)
	new /obj/item/clothing/suit/storage/hazardvest/security/officer(src)

/obj/structure/closet/secure_closet/investigator
	name = "investigator's locker"
	req_access = list(access_forensics_lockers)
	icon_state = "sec"

/obj/structure/closet/secure_closet/investigator/fill()
	//Appearance
	new /obj/item/storage/backpack/satchel/leather/recolorable(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat(src)
	new /obj/item/clothing/under/det(src)
	new /obj/item/clothing/under/det/idris(src)
	new /obj/item/clothing/under/det/pmc(src)
	new /obj/item/clothing/under/det/zavod(src)
	new /obj/item/clothing/accessory/badge/investigator(src)
	new /obj/item/clothing/shoes/laceup/all_species(src)
	new /obj/item/clothing/shoes/laceup/all_species(src)
	//Tools
	new /obj/item/device/radio/headset/headset_sec(src)
	new /obj/item/device/radio/headset/headset_sec/alt(src)
	new /obj/item/clothing/suit/armor/carrier/officer(src)
	new /obj/item/gun/energy/disruptorpistol/miniature/security(src)
	new /obj/item/taperoll/police(src)
	new /obj/item/device/flash(src)
	new /obj/item/device/laser_pointer/blue(src)
	new /obj/item/device/camera/detective(src)
	new /obj/item/device/camera_film(src)
	new /obj/item/stamp/investigations(src)
	//Belts
	new /obj/item/clothing/accessory/holster/waist(src)
	new /obj/item/clothing/accessory/storage/pouches/black(src)

/obj/structure/closet/secure_closet/injection
	name = "lethal injections locker"
	req_access = list(access_captain)

/obj/structure/closet/secure_closet/injection/fill()
	new /obj/item/reagent_containers/syringe/large/ld50_syringe/chloral(src)
	new /obj/item/reagent_containers/syringe/large/ld50_syringe/chloral(src)


// These are special snowflakes that need to be in a global list.
/obj/structure/closet/secure_closet/brig
	name = "brig locker"
	req_access = list(access_brig)
	anchored = TRUE
	canbemoved = TRUE
	var/id = null

/obj/structure/closet/secure_closet/brig/Initialize()
	. = ..()
	brig_closets += src

/obj/structure/closet/secure_closet/brig/Destroy()
	brig_closets -= src
	return ..()

/obj/structure/closet/secure_closet/brig/fill()
	new /obj/item/clothing/under/color/orange( src )
	new /obj/item/clothing/shoes/orange( src )

/obj/structure/closet/secure_closet/courtroom
	name = "courtroom locker"
	req_access = list(access_lawyer)

/obj/structure/closet/secure_closet/courtroom/fill()
	..()
	//Appearance
	new /obj/item/clothing/head/powdered_wig (src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/suit/judgerobe (src)
	//Tools
	new /obj/item/paper/Court (src)
	new /obj/item/paper/Court (src)
	new /obj/item/paper/Court (src)
	new /obj/item/pen (src)
	new /obj/item/storage/briefcase(src)

/obj/structure/closet/secure_closet/bridge_crew
	name = "bridge crew's locker"
	req_access = list(access_bridge_crew)
	icon_state = "sec"
	icon_door = "hop"

/obj/structure/closet/secure_closet/bridge_crew/fill()
	..()
	new /obj/item/clothing/under/rank/bridge_crew(src)
	new /obj/item/clothing/head/caphat/bridge_crew(src)
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/accessory/holster/waist(src)
	new /obj/item/gun/energy/disruptorpistol/miniature(src)
	new /obj/item/device/radio/headset/headset_com(src)
	new /obj/item/device/radio/headset/headset_com/alt(src)
	new /obj/item/device/radio/off(src)
	new /obj/item/device/gps(src)

// Evidence Storage Locker
/obj/structure/closet/secure_closet/evidence
	name = "evidence storage locker"
	anchored = TRUE
	canbemoved = TRUE
	req_one_access = list(access_brig, access_armory, access_forensics_lockers)

// Contraband Storage Locker
/obj/structure/closet/secure_closet/contraband
	name = "contraband weapons and ammunition storage locker"
	anchored = TRUE
	canbemoved = TRUE
	req_access = list(access_armory)
