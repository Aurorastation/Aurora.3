//Contains: Engineering department jumpsuits
/obj/item/clothing/under/rank/chief_engineer
	name = "chief engineer's jumpsuit"
	desc = "It's a high visibility jumpsuit given to those engineers insane enough to achieve the rank of \"Chief Engineer\". It has minor radiation shielding."
	icon = 'icons/obj/item/clothing/department_uniforms/command.dmi'
	icon_state = "chief_engineer"
	item_state = "chief_engineer"
	contained_sprite = TRUE
	armor = list(
		rad = ARMOR_RAD_MINOR
	)
	siemens_coefficient = 0.75

/obj/item/clothing/under/rank/atmospheric_technician
	name = "atmospheric technician's jumpsuit"
	desc = "It's a jumpsuit worn by atmospheric technicians."
	icon = 'icons/obj/item/clothing/department_uniforms/engineering.dmi'
	icon_state = "nt_atmos"
	item_state = "nt_atmos"
	contained_sprite = TRUE
	siemens_coefficient = 0.75

/obj/item/clothing/under/rank/atmospheric_technician/heph
	icon_state = "heph_atmos"
	item_state = "heph_atmos"

/obj/item/clothing/under/rank/atmospheric_technician/zavod
	icon_state = "zav_atmos"
	item_state = "zav_atmos"

/obj/item/clothing/under/rank/engineer
	name = "engineer's jumpsuit"
	desc = "It's an orange high visibility jumpsuit worn by engineers. It has minor radiation shielding."
	icon = 'icons/obj/item/clothing/department_uniforms/engineering.dmi'
	icon_state = "nt_engineer"
	item_state = "nt_engineer"
	contained_sprite = TRUE
	armor = list(
		rad = ARMOR_RAD_MINOR
	)
	siemens_coefficient = 0.75

/obj/item/clothing/under/rank/engineer/heph
	icon_state = "heph_engineer"
	item_state = "heph_engineer"

/obj/item/clothing/under/rank/engineer/zavod
	icon_state = "zav_engineer"
	item_state = "zav_engineer"

/obj/item/clothing/under/rank/engineer/apprentice
	name = "engineering apprentice's jumpsuit"
	desc = "It's a noticeably cheaper high visibility jumpsuit worn by engineering apprentices. It has minor radiation shielding."
	icon_state = "nt_apprentice"
	item_state = "nt_apprentice"

/obj/item/clothing/under/rank/engineer/apprentice/heph
	icon_state = "heph_apprentice"
	item_state = "heph_apprentice"

/obj/item/clothing/under/rank/engineer/apprentice/zavod
	icon_state = "zav_apprentice"
	item_state = "zav_apprentice"
