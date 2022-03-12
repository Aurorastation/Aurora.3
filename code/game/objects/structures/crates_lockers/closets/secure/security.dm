/obj/structure/closet/secure_closet/captains
	name = "captain's locker"
	req_access = list(access_captain)
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"

/obj/structure/closet/secure_closet/captains/fill()
	// Backpack
	if(prob(50))
		new /obj/item/storage/backpack/captain(src)
	else
		new /obj/item/storage/backpack/satchel_cap(src)
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
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"

/obj/structure/closet/secure_closet/captains2/fill()
	new /obj/item/storage/backpack/captain(src)
	new /obj/item/storage/backpack/satchel_cap(src)
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

/obj/structure/closet/secure_closet/hop
	name = "head of personnel's locker"
	req_access = list(access_hop)
	icon_state = "hopsecure1"
	icon_closed = "hopsecure"
	icon_locked = "hopsecure1"
	icon_opened = "hopsecureopen"
	icon_broken = "hopsecurebroken"
	icon_off = "hopsecureoff"

/obj/structure/closet/secure_closet/hop/fill()
	..()
	//Supply
	new /obj/item/storage/box/ids(src)
	new /obj/item/storage/box/ids(src)
	new /obj/item/storage/box/fancy/keypouch/cargo(src)
	new /obj/item/storage/box/fancy/keypouch/service(src)
	//Appearance
	new /obj/item/clothing/glasses/sunglasses(src)
	new /obj/item/clothing/suit/armor/carrier/officer(src)
	new /obj/item/clothing/head/helmet(src)
	new /obj/item/clothing/accessory/holster/waist(src)
	//Tools
	new /obj/item/device/radio/headset/heads/hop(src)
	new /obj/item/device/radio/headset/heads/hop/alt(src)
	new /obj/item/device/megaphone/command(src)
	new /obj/item/storage/box/goldstar(src)
	new /obj/item/gun/energy/disruptorpistol(src)
	new /obj/item/gun/projectile/sec/flash(src)
	new /obj/item/device/flash(src)

/obj/structure/closet/secure_closet/hop2
	name = "head of personnel's attire"
	req_access = list(access_hop)
	icon_state = "hopsecure1"
	icon_closed = "hopsecure"
	icon_locked = "hopsecure1"
	icon_opened = "hopsecureopen"
	icon_broken = "hopsecurebroken"
	icon_off = "hopsecureoff"

/obj/structure/closet/secure_closet/hop2/fill()
	..()
	new /obj/item/clothing/under/rank/head_of_personnel(src)
	new /obj/item/clothing/under/dress/dress_hop(src)
	new /obj/item/clothing/under/lawyer/black(src)
	new /obj/item/clothing/under/lawyer/red(src)
	new /obj/item/clothing/under/rank/head_of_personnel_whimsy(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/shoes/black(src)
	new /obj/item/clothing/shoes/laceup/brown(src)
	new /obj/item/clothing/shoes/white(src)
	new /obj/item/clothing/head/caphat/hop(src)

/obj/structure/closet/secure_closet/hos
	name = "head of security's locker"
	req_access = list(access_hos)
	icon_state = "hossecure1"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_opened = "hossecureopen"
	icon_broken = "hossecurebroken"
	icon_off = "hossecureoff"

/obj/structure/closet/secure_closet/hos/fill()
	..()
	//Supply
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/box/ids(src)
	//Appearance
	if(prob(50))
		new /obj/item/storage/backpack/security(src)
	else
		new /obj/item/storage/backpack/satchel_sec(src)
	new /obj/item/clothing/suit/armor/carrier/hos(src)
	new /obj/item/clothing/accessory/leg_guard(src)
	new /obj/item/clothing/accessory/arm_guard(src)
	new /obj/item/clothing/under/rank/head_of_security/corp(src)
	new /obj/item/clothing/head/beret/security/hos/corp(src)
	new /obj/item/clothing/head/hos/corp(src)
	new /obj/item/clothing/head/helmet/hos(src)
	new /obj/item/clothing/suit/storage/security/hos(src)
	new /obj/item/clothing/accessory/badge/hos(src)
	new /obj/item/clothing/gloves/black_leather(src)
	new /obj/item/clothing/suit/storage/toggle/armor/hos(src)
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
	//Belts
	new /obj/item/clothing/accessory/holster/waist(src)
	new /obj/item/storage/belt/security/full(src)
	new /obj/item/storage/box/fancy/keypouch/sec(src)

/obj/structure/closet/secure_closet/hos2
	name = "head of security's attire"
	req_access = list(access_hos)
	icon_state = "hossecure1"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_opened = "hossecureopen"
	icon_broken = "hossecurebroken"
	icon_off = "hossecureoff"

/obj/structure/closet/secure_closet/hos2/fill()
	//Appearance
	if(prob(50))
		new /obj/item/storage/backpack/security(src)
	else
		new /obj/item/storage/backpack/satchel_sec(src)
	new /obj/item/clothing/suit/armor/carrier/hos(src)
	new /obj/item/clothing/accessory/leg_guard(src)
	new /obj/item/clothing/accessory/arm_guard(src)
	new /obj/item/clothing/under/rank/head_of_security/corp(src)
	new /obj/item/clothing/head/beret/security/corp(src)
	new /obj/item/clothing/head/hos/corp(src)
	new /obj/item/clothing/head/helmet/hos(src)
	new /obj/item/clothing/suit/storage/security/hos(src)
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
	icon_state = "wardensecure1"
	icon_closed = "wardensecure"
	icon_locked = "wardensecure1"
	icon_opened = "wardensecureopen"
	icon_broken = "wardensecurebroken"
	icon_off = "wardensecureoff"

/obj/structure/closet/secure_closet/warden/fill()
	//Supply
	new /obj/item/storage/box/holobadge(src)
	new /obj/item/storage/box/ids(src)
	new /obj/item/storage/box/flashbangs(src)
	new /obj/item/storage/box/teargas(src)
	//Appearance
	if(prob(50))
		new /obj/item/storage/backpack/security(src)
	else
		new /obj/item/storage/backpack/satchel_sec(src)
	new /obj/item/clothing/suit/armor/carrier/officer(src)
	new /obj/item/clothing/accessory/arm_guard(src)
	new /obj/item/clothing/accessory/leg_guard(src)
	new /obj/item/clothing/under/rank/warden/corp(src)
	new /obj/item/clothing/head/beret/security/corp(src)
	new /obj/item/clothing/head/warden/corp(src)
	new /obj/item/clothing/head/helmet/security(src)
	new	/obj/item/clothing/suit/storage/security/warden(src)
	new /obj/item/clothing/accessory/badge/warden(src)
	new /obj/item/clothing/gloves/black_leather(src)
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
	new /obj/item/clothing/accessory/holster/waist(src)
	new /obj/item/storage/belt/security/full(src)


/obj/structure/closet/secure_closet/security_cadet
	name = "security cadet's locker"
	req_access = list(access_security)
	icon_state = "seccadet1"
	icon_closed = "seccadet"
	icon_locked = "seccadet1"
	icon_opened = "seccadetopen"
	icon_broken = "seccadetbroken"
	icon_off = "seccadetoff"

/obj/structure/closet/secure_closet/security_cadet/fill()
	//Appearance
	if(prob(50))
		new /obj/item/storage/backpack/security(src)
	else
		new /obj/item/storage/backpack/satchel_sec(src)
	new /obj/item/clothing/head/beret/security(src)
	new /obj/item/clothing/head/softcap/security(src)
	new /obj/item/clothing/suit/storage/hazardvest/cadet(src)
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
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"

/obj/structure/closet/secure_closet/security/fill()
	//Appearance
	if(prob(50))
		new /obj/item/storage/backpack/security(src)
	else
		new /obj/item/storage/backpack/satchel_sec(src)
	new /obj/item/clothing/suit/armor/carrier/officer(src)
	new /obj/item/clothing/accessory/arm_guard(src)
	new /obj/item/clothing/accessory/leg_guard(src)
	new /obj/item/clothing/under/rank/security/corp(src)
	new /obj/item/clothing/head/beret/security/corp(src)
	new /obj/item/clothing/head/softcap/security/corp(src)
	new /obj/item/clothing/head/helmet/security(src)
	new /obj/item/clothing/suit/storage/security/officer(src)
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

/obj/structure/closet/secure_closet/security/cargo/fill()
	..()
	new /obj/item/clothing/accessory/armband/cargo(src)
	new /obj/item/device/encryptionkey/headset_cargo(src)

/obj/structure/closet/secure_closet/security/engine/fill()
	..()
	new /obj/item/clothing/accessory/armband/engine(src)
	new /obj/item/device/encryptionkey/headset_eng(src)

/obj/structure/closet/secure_closet/security/science/fill()
	..()
	new /obj/item/clothing/accessory/armband/science(src)
	new /obj/item/device/encryptionkey/headset_sci(src)

/obj/structure/closet/secure_closet/security/med/fill()
	..()
	new /obj/item/clothing/accessory/armband/medgreen(src)
	new /obj/item/device/encryptionkey/headset_med(src)


/obj/structure/closet/secure_closet/investigator
	name = "investigator's locker"
	req_access = list(access_forensics_lockers)
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"

/obj/structure/closet/secure_closet/investigator/fill()
	//Appearance
	new /obj/item/storage/backpack/satchel/leather(src)
	new /obj/item/clothing/suit/storage/det_jacket(src)
	new /obj/item/clothing/under/det(src)
	new /obj/item/clothing/suit/storage/toggle/labcoat/security(src)
	new /obj/item/clothing/under/det/black(src)
	new /obj/item/clothing/under/det/classic(src)
	new /obj/item/clothing/accessory/badge/investigator(src)
	new /obj/item/clothing/suit/storage/toggle/forensics(src)
	new /obj/item/clothing/gloves/black/forensic(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/shoes/laceup(src)
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
	anchored = 1
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

/obj/structure/closet/secure_closet/wall
	name = "wall locker"
	req_access = list(access_security)
	icon = 'icons/obj/walllocker.dmi'
	icon_state = "wall-locker1"
	density = 1
	icon_closed = "wall-locker"
	icon_locked = "wall-locker1"
	icon_opened = "wall-lockeropen"
	icon_broken = "wall-lockerbroken"
	icon_off = "wall-lockeroff"

	//too small to put a man in
	large = 0

/obj/structure/closet/secure_closet/wall/update_icon()
	if(broken)
		icon_state = icon_broken
	else
		if(!opened)
			if(locked)
				icon_state = icon_locked
			else
				icon_state = icon_closed
		else
			icon_state = icon_opened
