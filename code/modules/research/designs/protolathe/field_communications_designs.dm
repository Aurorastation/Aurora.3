/datum/design/item/field_equipment
	p_category = "Field Equipment Designs"
	req_tech = list(TECH_ENGINEERING = 2, TECH_MAGNET = 2)
	materials = list(MATERIAL_STEEL = 500, MATERIAL_GLASS = 250)

/datum/design/item/field_equipment/flashlight
	name = "Flashlight"
	build_path = /obj/item/flashlight

/datum/design/item/field_equipment/flashlight_heavy
	name = "Heavy Flashlight"
	build_path = /obj/item/flashlight/heavy

/datum/design/item/field_equipment/flashlight_lantern
	name = "Lantern"
	build_path = /obj/item/flashlight/lantern

/datum/design/item/field_equipment/flashlight_maglight
	name = "Maglight"
	build_path = /obj/item/flashlight/maglight

/datum/design/item/field_equipment/flashlight_pen
	name = "Penlight"
	materials = list(MATERIAL_STEEL = 200, MATERIAL_GLASS = 100)
	build_path = /obj/item/flashlight/pen

/datum/design/item/field_equipment/marshalling_wand
	name = "Marshalling Wand"
	build_path = /obj/item/flashlight/marshallingwand

/datum/design/item/field_equipment/gps
	name = "Global Positioning System"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 3)
	build_path = /obj/item/gps

/datum/design/item/field_equipment/gps/science
	name = "Science GPS"
	build_path = /obj/item/gps/science

/datum/design/item/field_equipment/gps/engineering
	name = "Engineering GPS"
	build_path = /obj/item/gps/engineering

/datum/design/item/field_equipment/gps/mining
	name = "Mining GPS"
	build_path = /obj/item/gps/mining

/datum/design/item/field_equipment/gps/janitor
	name = "Custodial GPS"
	build_path = /obj/item/gps/janitor

/datum/design/item/field_equipment/gps/medical
	name = "Medical GPS"
	build_path = /obj/item/gps/medical

/datum/design/item/field_equipment/hailer
	name = "Hailer"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2)
	build_path = /obj/item/hailer

/datum/design/item/field_equipment/holowarrant
	name = "Holowarrant Projector"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2)
	build_path = /obj/item/holowarrant

/datum/design/item/field_equipment/roller_bed
	name = "Roller Bed"
	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)
	materials = list(MATERIAL_STEEL = 2000, MATERIAL_PLASTIC = 1000)
	build_path = /obj/item/roller

/datum/design/item/communications
	p_category = "Communications Equipment Designs"
	req_tech = list(TECH_DATA = 3, TECH_MAGNET = 2)
	materials = list(MATERIAL_STEEL = 300, MATERIAL_GLASS = 200)

/datum/design/item/communications/tv_camera
	name = "Television Camera"
	build_path = /obj/item/tvcamera

/datum/design/item/communications/encryption_key
	name = "Standard Encryption Key"
	build_path = /obj/item/encryptionkey

/datum/design/item/communications/headset
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	materials = list(MATERIAL_STEEL = 400, MATERIAL_GLASS = 100)

/datum/design/item/communications/headset/Fabricate(newloc, fabricator)
	var/obj/item/radio/headset/headset = new build_path(newloc)
	QDEL_NULL(headset.keyslot1)
	QDEL_NULL(headset.keyslot2)
	headset.recalculateChannels(TRUE)
	return headset

/datum/design/item/communications/headset/generic
	name = "Radio Headset Chassis"
	build_path = /obj/item/radio/headset

/datum/design/item/communications/headset/generic/alt
	name = "Bowman Headset Chassis"
	build_path = /obj/item/radio/headset/alt

/datum/design/item/communications/headset/service
	name = "Service Headset Chassis"
	build_path = /obj/item/radio/headset/headset_service

/datum/design/item/communications/headset/service/alt
	name = "Service Bowman Headset Chassis"
	build_path = /obj/item/radio/headset/headset_service/alt

/datum/design/item/communications/headset/service/wrist
	name = "Service Wrist Radio Chassis"
	build_path = /obj/item/radio/headset/wrist/service

/datum/design/item/communications/headset/service/clip
	name = "Service Clip-on Radio Chassis"
	build_path = /obj/item/radio/headset/wrist/clip/service

/datum/design/item/communications/headset/engineering
	name = "Engineering Headset Chassis"
	build_path = /obj/item/radio/headset/headset_eng

/datum/design/item/communications/headset/engineering/alt
	name = "Engineering Bowman Headset Chassis"
	build_path = /obj/item/radio/headset/headset_eng/alt

/datum/design/item/communications/headset/chief_engineer
	name = "Chief Engineer Headset Chassis"
	build_path = /obj/item/radio/headset/heads/ce

/datum/design/item/communications/headset/chief_engineer/alt
	name = "Chief Engineer Bowman Headset Chassis"
	build_path = /obj/item/radio/headset/heads/ce/alt

/datum/design/item/communications/headset/cargo
	name = "Operations Headset Chassis"
	build_path = /obj/item/radio/headset/headset_cargo

/datum/design/item/communications/headset/cargo/alt
	name = "Operations Bowman Headset Chassis"
	build_path = /obj/item/radio/headset/headset_cargo/alt

/datum/design/item/communications/headset/cargo/clip
	name = "Operations Clip-on Radio Chassis"
	build_path = /obj/item/radio/headset/wrist/clip/cargo

/datum/design/item/communications/headset/operations_manager
	name = "Operations Manager Headset Chassis"
	build_path = /obj/item/radio/headset/operations_manager

/datum/design/item/communications/headset/operations_manager/alt
	name = "Operations Manager Bowman Headset Chassis"
	build_path = /obj/item/radio/headset/operations_manager/alt

/datum/design/item/communications/headset/medical
	name = "Medical Headset Chassis"
	build_path = /obj/item/radio/headset/headset_med

/datum/design/item/communications/headset/medical/alt
	name = "Medical Bowman Headset Chassis"
	build_path = /obj/item/radio/headset/headset_med/alt

/datum/design/item/communications/headset/chief_medical_officer
	name = "Chief Medical Officer Headset Chassis"
	build_path = /obj/item/radio/headset/heads/cmo

/datum/design/item/communications/headset/chief_medical_officer/alt
	name = "Chief Medical Officer Bowman Headset Chassis"
	build_path = /obj/item/radio/headset/heads/cmo/alt

/datum/design/item/communications/headset/science
	name = "Science Headset Chassis"
	build_path = /obj/item/radio/headset/headset_sci

/datum/design/item/communications/headset/science/alt
	name = "Science Bowman Headset Chassis"
	build_path = /obj/item/radio/headset/headset_sci/alt

/datum/design/item/communications/headset/research_director
	name = "Research Director Headset Chassis"
	build_path = /obj/item/radio/headset/heads/rd

/datum/design/item/communications/headset/research_director/alt
	name = "Research Director Bowman Headset Chassis"
	build_path = /obj/item/radio/headset/heads/rd/alt

/datum/design/item/communications/headset/security
	name = "Security Headset Chassis"
	build_path = /obj/item/radio/headset/headset_sec

/datum/design/item/communications/headset/security/alt
	name = "Security Bowman Headset Chassis"
	build_path = /obj/item/radio/headset/headset_sec/alt

/datum/design/item/communications/headset/warden
	name = "Warden Headset Chassis"
	build_path = /obj/item/radio/headset/headset_warden

/datum/design/item/communications/headset/warden/alt
	name = "Warden Bowman Headset Chassis"
	build_path = /obj/item/radio/headset/headset_warden/alt

/datum/design/item/communications/headset/head_of_security
	name = "Head of Security Headset Chassis"
	build_path = /obj/item/radio/headset/heads/hos

/datum/design/item/communications/headset/head_of_security/alt
	name = "Head of Security Bowman Headset Chassis"
	build_path = /obj/item/radio/headset/heads/hos/alt

/datum/design/item/communications/headset/command
	name = "Command Headset Chassis"
	build_path = /obj/item/radio/headset/headset_com

/datum/design/item/communications/headset/command/alt
	name = "Command Bowman Headset Chassis"
	build_path = /obj/item/radio/headset/headset_com/alt

/datum/design/item/communications/headset/executive_officer
	name = "Executive Officer Headset Chassis"
	build_path = /obj/item/radio/headset/heads/xo

/datum/design/item/communications/headset/executive_officer/alt
	name = "Executive Officer Bowman Headset Chassis"
	build_path = /obj/item/radio/headset/heads/xo/alt

/datum/design/item/communications/headset/captain
	name = "Captain Headset Chassis"
	build_path = /obj/item/radio/headset/heads/captain

/datum/design/item/communications/headset/captain/alt
	name = "Captain Bowman Headset Chassis"
	build_path = /obj/item/radio/headset/heads/captain/alt
