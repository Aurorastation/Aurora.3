/datum/design/item/deployable_kit
	design_order = 11

/datum/design/item/deployable_kit/AssembleDesignName()
	name = "Deployable Kit Design ([name])"

/datum/design/item/deployable_kit/mech_chair
	name = "Remote Mech Centre"
	desc = "A deployable kit of a remote mech chair, capable of listening in to standard remote mech networks."
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, MATERIAL_SILVER = 750, MATERIAL_URANIUM = 250)
	build_path = /obj/item/deployable_kit/remote_mech

/datum/design/item/deployable_kit/mech_chair/brig
	name = "Remote Penal Mech Centre"
	desc = "A deployable kit of a remote mech chair, capable of listening in to penal remote mech networks."
	build_path = /obj/item/deployable_kit/remote_mech/brig