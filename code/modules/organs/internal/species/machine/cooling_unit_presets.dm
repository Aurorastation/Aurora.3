/*
* These are presets for the cooling unit data. Essentially, each type of cooling unit can have its own presets (depending on pref setting)
* that change the name, description, and functioning of the cooling unit.
*/

/singleton/synthetic_organ_preset/cooling_unit
	/// The name the cooling unit organ will have.
	name = "epic cooling unit"
	/// The description the cooling unit organ will get.
	desc = "It cools epically."
	/// The passive temperature change the cooling unit will have.
	var/passive_temp_change = 3
	/// The power used when cooling down.
	var/base_power_consumption = 10
	/// The maximum health the cooling unit's plating will have.
	var/plating_max_health = 20

/singleton/synthetic_organ_preset/cooling_unit/apply_preset(obj/item/organ/internal/machine/organ)
	. = ..()
	var/obj/item/organ/internal/machine/cooling_unit/cooling_unit = organ
	cooling_unit.passive_temp_change = passive_temp_change
	cooling_unit.base_power_consumption = base_power_consumption
	cooling_unit.plating.replace_health(plating_max_health)

/singleton/synthetic_organ_preset/cooling_unit/air
	name = "air cooling unit"
	desc = "One of the most complex and vital components of a synthetic. It regulates its internal temperature through the use of chassis-mounted fans and prevents the frame from overheating."

	passive_temp_change = 20
	plating_max_health = 50

/obj/item/organ/internal/machine/cooling_unit/air
	forced_preset = /singleton/synthetic_organ_preset/cooling_unit/air

/singleton/synthetic_organ_preset/cooling_unit/liquid
	name = "liquid-cooling pump and radiator array"
	desc = "An extremely complex set of cooling pipes that transport coolant throughout a synthetic's body. The most efficient type of cooling, but also the most vulnerable."
	icon_state = "ipc_liquid_cooler"

	passive_temp_change = 3
	base_power_consumption = 2
	plating_max_health = 20

/obj/item/organ/internal/machine/cooling_unit/liquid
	forced_preset = /singleton/synthetic_organ_preset/cooling_unit/liquid

/singleton/synthetic_organ_preset/cooling_unit/passive
	name = "passive radiator cooling block"
	desc = "A simplistic, but efficient block of large cooling fins, which cool down a synthetic's body enough to make it work. Quite cheap, but durable."
	icon_state = "ipc_liquid_cooler"

	passive_temp_change = 1
	base_power_consumption = 5
	plating_max_health = 120



/obj/item/organ/internal/machine/cooling_unit/passive
	forced_preset = /singleton/synthetic_organ_preset/cooling_unit/passive

// Xion cooling units.
/singleton/synthetic_organ_preset/cooling_unit/air_xion
	name = "xion manufacturing advanced air cooling unit"
	desc = "A very complex air cooling setup, with high-grade laminar plasteel fans and integrated space-proof heatsinks to allow the frame to still be cooled in space."
	icon_state = "ipc_xion_fans"

	passive_temp_change = 10
	plating_max_health = 25

/obj/item/organ/internal/machine/cooling_unit/air/xion
	forced_preset = /singleton/synthetic_organ_preset/cooling_unit/air_xion

/singleton/synthetic_organ_preset/cooling_unit/liquid_xion
	name = "xion manufacturing advanced cryo-cooling pump and radiator array"
	desc = "An extremely complex cryo-cooling setup. It uses advanced coolant to allow the frame to still function in space - but its laminar super-flow piping is extremely fragile."
	icon_state = "ipc_xion_liquid_cooler"

	passive_temp_change = 20
	plating_max_health = 25

/obj/item/organ/internal/machine/cooling_unit/liquid/xion
	forced_preset = /singleton/synthetic_organ_preset/cooling_unit/liquid_xion

/singleton/synthetic_organ_preset/cooling_unit/passive_xion
	name = "xion manufacturing passive intra-fin array"
	desc = "The simplicity of this cooling design betrays its efficiency: an extremely durable array of laminar plasteel fins, supplemented with an expensive coating that allows the synthetic to be cooled even in space."
	icon_state = "ipc_heatsink"

	passive_temp_change = 5
	plating_max_health = 200

/obj/item/organ/internal/machine/cooling_unit/passive/xion
	forced_preset = /singleton/synthetic_organ_preset/cooling_unit/passive_xion

// Zenghu cooling units.
/singleton/synthetic_organ_preset/cooling_unit/air_zenghu
	name = "zeng-hu penta-fan air cooling system"
	desc = "A sleek and luxurious air cooling system invented by Zeng-Hu for their house-made synthetic frames. It uses a patented and exclusive type of penta-fin fan. More efficient than standard air cooling solutions, but it will not allow cooling in space."
	icon_state = "ipc_zeng_fans"

	passive_temp_change = 3
	plating_max_health = 40

/obj/item/organ/internal/machine/cooling_unit/air/zenghu
	forced_preset = /singleton/synthetic_organ_preset/cooling_unit/air_zenghu

/singleton/synthetic_organ_preset/cooling_unit/liquid_zenghu
	name = "zeng-hu lamellar liquid cooling system"
	desc = "A sleek set of superimposed lamellar pipes with a custom cooling solution. In black market and enthusiast repair forums, this is known as 'the enthusiast's nightmare' due to its practical impossibility to repair in anything less than a Zeng-Hu facility; \
			the lamellar pipes are impossible to reproduce or find through a third-party solution due to their extremely complex and exclusive Zeng-Hu make."
	icon_state = "ipc_zeng_cooling"

	passive_temp_change = 4
	plating_max_health = 15

/obj/item/organ/internal/machine/cooling_unit/liquid/zenghu
	forced_preset = /singleton/synthetic_organ_preset/cooling_unit/liquid_zenghu

/singleton/synthetic_organ_preset/cooling_unit/passive_zenghu
	name = "suprafin cooling fins"
	desc = "A sleek set of engraved, plasteel fins patented by Zeng-Hu as 'suprafins'. The engravings help increase thermal area to the maximum possible, and a specialized cooling solution is imprinted onto the fins to improve their cooling ability."
	icon_state = "ipc_zeng_cooling_passive"

	passive_temp_change = 2
	plating_max_health = 130

/obj/item/organ/internal/machine/cooling_unit/passive/zenghu
	forced_preset = /singleton/synthetic_organ_preset/cooling_unit/passive_zenghu

