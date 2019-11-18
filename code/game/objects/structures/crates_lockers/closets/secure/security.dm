/obj/structure/closet/secure_closet/captains
	name = "captain's locker"
	req_access = list(access_captain)
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"

	fill()
		//Appearance
		if(prob(50))
			new /obj/item/storage/backpack/captain(src)
		else
			new /obj/item/storage/backpack/satchel_cap(src)
		new /obj/item/clothing/suit/captunic(src)
		new /obj/item/clothing/suit/captunic/capjacket(src)
		new /obj/item/clothing/head/caphat/cap(src)
		new /obj/item/clothing/under/rank/captain(src)
		new /obj/item/clothing/suit/storage/vest(src)
		new /obj/item/clothing/gloves/captain(src)
		new /obj/item/clothing/head/helmet(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/clothing/under/dress/dress_cap(src)
		new /obj/item/clothing/head/caphat/formal(src)
		new /obj/item/clothing/under/captainformal(src)
		//Tools
		new /obj/item/device/radio/headset/heads/captain(src)
		new /obj/item/cartridge/captain(src)
		new /obj/item/gun/energy/pistol(src)
		new /obj/item/device/flash(src)
		new /obj/item/melee/telebaton(src)

/obj/structure/closet/secure_closet/captains2
	name = "captain's attire"
	req_access = list(access_captain)
	icon_state = "capsecure1"
	icon_closed = "capsecure"
	icon_locked = "capsecure1"
	icon_opened = "capsecureopen"
	icon_broken = "capsecurebroken"
	icon_off = "capsecureoff"

	fill()
		new /obj/item/storage/backpack/captain(src)
		new /obj/item/storage/backpack/satchel_cap(src)
		new /obj/item/clothing/suit/captunic(src)
		new /obj/item/clothing/suit/captunic/capjacket(src)
		new /obj/item/clothing/head/caphat(src)
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

	fill()
		..()
		//Supply
		new /obj/item/storage/box/ids(src)
		new /obj/item/storage/box/ids( src )
		//Appearance
		new /obj/item/clothing/glasses/sunglasses(src)
		new /obj/item/clothing/suit/storage/vest(src)
		new /obj/item/clothing/head/helmet(src)
		//Tools
		new /obj/item/cartridge/hop(src)
		new /obj/item/device/radio/headset/heads/hop(src)
		new /obj/item/gun/energy/pistol(src)
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

	fill()
		..()
		new /obj/item/clothing/under/rank/head_of_personnel(src)
		new /obj/item/clothing/under/dress/dress_hop(src)
		new /obj/item/clothing/under/dress/dress_hr(src)
		new /obj/item/clothing/under/lawyer/female(src)
		new /obj/item/clothing/under/lawyer/black(src)
		new /obj/item/clothing/under/lawyer/red(src)
		new /obj/item/clothing/under/lawyer/oldman(src)
		new /obj/item/clothing/under/rank/head_of_personnel_whimsy(src)
		new /obj/item/clothing/shoes/brown(src)
		new /obj/item/clothing/shoes/black(src)
		new /obj/item/clothing/shoes/leather(src)
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

	fill()
		..()
		//Supply
		new /obj/item/storage/box/flashbangs(src)
		//Appearance
		new /obj/item/storage/backpack/security(src)
		new /obj/item/storage/backpack/satchel_sec(src)
		new /obj/item/clothing/under/rank/head_of_security(src)
		new /obj/item/clothing/under/rank/head_of_security/corp(src)
		new /obj/item/clothing/suit/storage/toggle/armor/hos/jensen(src)
		new /obj/item/clothing/suit/armor/hos(src)
		new /obj/item/clothing/suit/storage/vest/hos(src)
		new /obj/item/clothing/head/helmet/hos/cap(src)
		new /obj/item/clothing/head/helmet/hos(src)
		new /obj/item/clothing/head/beret/sec/hos(src)
		new /obj/item/clothing/accessory/badge/hos(src)
		new /obj/item/clothing/shoes/black_boots(src)
		new /obj/item/clothing/gloves/black_leather(src)
		//Tools
		new /obj/item/cartridge/hos(src)
		new /obj/item/device/radio/headset/heads/hos(src)
		new /obj/item/storage/box/tranquilizer(src)
		new /obj/item/clothing/glasses/sunglasses/sechud(src)
		new /obj/item/clothing/glasses/sunglasses/sechud/head(src)
		new /obj/item/shield/riot/tact(src)
		new /obj/item/melee/baton/loaded(src)
		new /obj/item/melee/telebaton(src)
		new /obj/item/gun/energy/pistol(src)
		new /obj/item/taperoll/police(src)
		new /obj/item/device/flash(src)
		new /obj/item/device/holowarrant(src)
		new /obj/item/device/breath_analyzer(src)
		//Belts
		new /obj/item/clothing/accessory/holster/waist(src)
		new /obj/item/clothing/accessory/holster/armpit(src)
		new /obj/item/clothing/accessory/holster/hip(src)
		new /obj/item/clothing/accessory/holster/thigh(src)
		new /obj/item/storage/belt/security(src)



/obj/structure/closet/secure_closet/hos2
	name = "head of security's attire"
	req_access = list(access_hos)
	icon_state = "hossecure1"
	icon_closed = "hossecure"
	icon_locked = "hossecure1"
	icon_opened = "hossecureopen"
	icon_broken = "hossecurebroken"
	icon_off = "hossecureoff"

	fill()
		//Appearance
		new /obj/item/storage/backpack/security(src)
		new /obj/item/storage/backpack/satchel_sec(src)
		new /obj/item/clothing/under/rank/head_of_security(src)
		new /obj/item/clothing/under/rank/head_of_security/corp(src)
		new /obj/item/clothing/suit/storage/vest/hos(src)
		new /obj/item/clothing/head/beret/sec/hos(src)
		new /obj/item/clothing/head/helmet/hos/cap(src)
		new /obj/item/clothing/head/helmet/hos(src)
		//Tools
		new /obj/item/clothing/glasses/sunglasses/sechud/aviator(src)
		new /obj/item/device/radio/headset/heads/hos(src)
		//Belts
		new /obj/item/storage/belt/security(src)

		new /obj/item/clothing/accessory/holster/armpit(src)
		new /obj/item/clothing/accessory/holster/waist(src)
		new /obj/item/clothing/accessory/holster/hip(src)
		new /obj/item/clothing/accessory/holster/thigh(src)

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


	fill()
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
		new /obj/item/clothing/suit/storage/vest/warden(src)
		new /obj/item/clothing/under/rank/warden(src)
		new /obj/item/clothing/under/rank/warden/corp(src)
		new /obj/item/clothing/suit/armor/vest/warden(src)
		new /obj/item/clothing/suit/armor/vest/warden/commissar(src)
		new /obj/item/clothing/head/beret/sec/warden(src)
		new /obj/item/clothing/head/helmet/warden(src)
		new /obj/item/clothing/head/helmet/warden/commissar(src)
		new /obj/item/clothing/head/helmet(src)
		new /obj/item/clothing/accessory/badge/warden(src)
		new /obj/item/clothing/shoes/black_boots(src)
		new /obj/item/clothing/gloves/black_leather(src)
		//Tools
		new /obj/item/cartridge/security(src)
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/clothing/glasses/sunglasses/sechud/aviator(src)
		new /obj/item/clothing/glasses/sunglasses/sechud(src)
		new /obj/item/taperoll/police(src)
		new /obj/item/reagent_containers/spray/pepper(src)
		new /obj/item/melee/baton/loaded(src)
		new /obj/item/gun/energy/pistol(src)
		//Belts
		if (prob(50))
			new /obj/item/clothing/accessory/storage/black_vest(src)
		else
			new /obj/item/clothing/accessory/storage/pouches/black(src)
		new /obj/item/storage/belt/security(src)


/obj/structure/closet/secure_closet/security_cadet
	name = "security cadet's locker"
	req_access = list(access_security)
	icon_state = "seccadet1"
	icon_closed = "seccadet"
	icon_locked = "seccadet1"
	icon_opened = "seccadetopen"
	icon_broken = "seccadetbroken"
	icon_off = "seccadetoff"

	fill()
		//Appearance
		if(prob(50))
			new /obj/item/storage/backpack/security(src)
		else
			new /obj/item/storage/backpack/satchel_sec(src)
		new /obj/item/clothing/head/beret/sec/cadet(src)
		new /obj/item/clothing/suit/storage/hazardvest/cadet(src)
		new /obj/item/clothing/under/rank/cadet(src)
		//Tools
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/device/flash(src)
		new /obj/item/reagent_containers/spray/pepper(src)
		new /obj/item/taperoll/police(src)
		new /obj/item/device/hailer(src)
		new /obj/item/device/holowarrant(src)
		new /obj/item/device/flashlight/flare(src)
		//Belts
		if (prob(50))
			new /obj/item/clothing/accessory/storage/black_vest(src)
		else
			new /obj/item/clothing/accessory/storage/pouches/black(src)
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

	fill()
		//Appearance
		if(prob(50))
			new /obj/item/storage/backpack/security(src)
		else
			new /obj/item/storage/backpack/satchel_sec(src)
		new /obj/item/clothing/head/soft/sec/corp(src)
		new /obj/item/clothing/under/rank/security/corp(src)
		new /obj/item/clothing/suit/storage/vest/officer(src)
		new /obj/item/clothing/head/helmet(src)
		//Tools
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/clothing/glasses/sunglasses/sechud/aviator(src)
		new /obj/item/clothing/glasses/sunglasses/sechud(src)
		new /obj/item/ammo_magazine/c45m/rubber(src)
		new /obj/random/handgun(src)
		new /obj/item/gun/energy/taser(src)
		new /obj/item/device/flash(src)
		new /obj/item/reagent_containers/spray/pepper(src)
		new /obj/item/melee/baton/loaded(src)
		new /obj/item/taperoll/police(src)
		new /obj/item/device/hailer(src)
		new /obj/item/device/holowarrant(src)
		new /obj/item/device/flashlight/flare(src)
		new /obj/item/handcuffs(src)
		//Belts
		if (prob(50))
			new /obj/item/clothing/accessory/storage/black_vest(src)
		else
			new /obj/item/clothing/accessory/storage/pouches/black(src)
		new /obj/item/clothing/accessory/holster/hip(src)
		new /obj/item/storage/belt/security(src)

/obj/structure/closet/secure_closet/security/cargo

	fill()
		..()
		new /obj/item/clothing/accessory/armband/cargo(src)
		new /obj/item/device/encryptionkey/headset_cargo(src)

/obj/structure/closet/secure_closet/security/engine

	fill()
		..()
		new /obj/item/clothing/accessory/armband/engine(src)
		new /obj/item/device/encryptionkey/headset_eng(src)

/obj/structure/closet/secure_closet/security/science

	fill()
		..()
		new /obj/item/clothing/accessory/armband/science(src)
		new /obj/item/device/encryptionkey/headset_sci(src)

/obj/structure/closet/secure_closet/security/med

	fill()
		..()
		new /obj/item/clothing/accessory/armband/medgreen(src)
		new /obj/item/device/encryptionkey/headset_med(src)


/obj/structure/closet/secure_closet/detective
	name = "detective's locker"
	req_access = list(access_detective)
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"

	fill()
		//Appearance
		new /obj/item/clothing/suit/storage/toggle/det_jacket(src)
		new /obj/item/clothing/under/det(src)
		new /obj/item/clothing/under/det/black(src)
		new /obj/item/clothing/under/det/classic(src)
		new /obj/item/clothing/gloves/black(src)
		new /obj/item/clothing/shoes/brown(src)
		//Tools
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/clothing/suit/storage/vest/detective(src)
		new /obj/item/ammo_magazine/c38(src)
		new /obj/item/ammo_magazine/c38(src)
		new /obj/item/gun/projectile/revolver/detective(src)
		new /obj/item/taperoll/police(src)
		//Belts
		new /obj/item/clothing/accessory/holster/armpit(src)
		new /obj/item/clothing/accessory/holster/waist(src)
		new /obj/item/clothing/accessory/holster/hip(src)
		new /obj/item/clothing/accessory/holster/thigh(src)

/obj/structure/closet/secure_closet/detective/attackby(obj/item/W as obj, mob/user as mob)
	if(opened)
		if(istype(W, /obj/item/grab))
			var/obj/item/grab/G = W
			if(large)
				MouseDrop_T(G.affecting, user)	//act like they were dragged onto the closet
			else
				to_chat(user, "<span class='notice'>The locker is too small to stuff [G.affecting] into!</span>")
		else if(isrobot(user))
			return
		else if(W.loc != user) // This should stop mounted modules ending up outside the module.
			return
		user.drop_from_inventory(W,loc)
	else if(!opened)
		if(istype(W, /obj/item/melee/energy/blade))//Attempt to cut open locker if locked
			if(emag_act(INFINITY, user, "<span class='danger'>The locker has been sliced open by [user] with \an [W]</span>!", "<span class='danger'>You hear metal being sliced and sparks flying.</span>"))
				spark(src, 5)
				playsound(loc, 'sound/weapons/blade.ogg', 50, 1)
				playsound(loc, "sparks", 50, 1)
		else
			togglelock(user)//Attempt to lock locker if closed


/obj/structure/closet/secure_closet/csi
	name = "forensic technician's locker"
	req_access = list(access_forensics_lockers)
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_broken = "secbroken"
	icon_off = "secoff"

	fill()
		//Appearance
		new /obj/item/clothing/gloves/black(src)
		new /obj/item/clothing/suit/storage/forensics/blue(src)
		new /obj/item/clothing/suit/storage/forensics/red(src)
		new /obj/item/clothing/suit/storage/vest/csi(src)
		new /obj/item/clothing/under/det/forensics(src)
		new /obj/item/clothing/under/det/black(src)
		new /obj/item/clothing/under/det/classic(src)
		new /obj/item/clothing/shoes/laceup(src)
		//Tools
		new /obj/item/device/radio/headset/headset_sec(src)
		new /obj/item/storage/box/evidence(src)
		new /obj/item/device/flash(src)
		new /obj/item/taperoll/police(src)

/obj/structure/closet/secure_closet/injection
	name = "lethal injections locker"
	req_access = list(access_captain)

	fill()
		new /obj/item/reagent_containers/syringe/ld50_syringe/chloral(src)
		new /obj/item/reagent_containers/syringe/ld50_syringe/chloral(src)


// These are special snowflakes that need to be in a global list.
/obj/structure/closet/secure_closet/brig
	name = "brig locker"
	req_access = list(access_brig)
	anchored = 1
	var/id = null

	Initialize()
		. = ..()
		brig_closets += src

	Destroy()
		brig_closets -= src
		return ..()

	fill()
		new /obj/item/clothing/under/color/orange( src )
		new /obj/item/clothing/shoes/orange( src )

/obj/structure/closet/secure_closet/courtroom
	name = "courtroom locker"
	req_access = list(access_lawyer)

	fill()
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
