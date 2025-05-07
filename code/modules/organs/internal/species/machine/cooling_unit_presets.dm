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
	/// The maximum health the cooling unit's plating will have.
	var/plating_max_health = 20

/singleton/synthetic_organ_preset/cooling_unit/apply_preset(obj/item/organ/internal/machine/organ)
	. = ..()
	var/obj/item/organ/internal/machine/cooling_unit/cooling_unit = organ
	cooling_unit.passive_temp_change = passive_temp_change
	cooling_unit.plating.replace_health(plating_max_health)

/singleton/synthetic_organ_preset/cooling_unit/air
	name = "air cooling unit"
	desc = "One of the most complex and vital components of a synthetic. It regulates its internal temperature through the use of chassis-mounted fans and prevents the frame from overheating."

	passive_temp_change = 2
	plating_max_health = 50

/singleton/synthetic_organ_preset/cooling_unit/liquid
	name = "liquid-cooling pump and radiator array"
	desc = "An extremely complex set of cooling pipes that transport coolant throughout a synthetic's body. The most efficient type of cooling, but also the most vulnerable."

	passive_temp_change = 3
	plating_max_health = 20

/singleton/synthetic_organ_preset/cooling_unit/passive
	name = "passive radiator cooling block"
	desc = "A simplistic, but efficient block of large cooling fins, which cool down a synthetic's body enough to make it work. Quite cheap, but durable."

	passive_temp_change = 1
	plating_max_health = 120

// Xion cooling units.
/singleton/synthetic_organ_preset/cooling_unit/air_xion
	name = "xion manufacturing advanced air cooling unit"
	desc = "A very complex air cooling setup, with high-grade laminar plasteel fans and integrated space-proof heatsinks to allow the frame to still be cooled in space."

	passive_temp_change = 10
	plating_max_health = 25

/singleton/synthetic_organ_preset/cooling_unit/liquid_xion
	name = "xion manufacturing advanced cryo-cooling pump and radiator array"
	desc = "An extremely complex cryo-cooling setup. It uses advanced coolant to allow the frame to still function in space - but its laminar super-flow piping is extremely fragile."

	passive_temp_change = 20
	plating_max_health = 25

/singleton/synthetic_organ_preset/cooling_unit/passive_xion
	name = "xion manufacturing passive mega-fin array"
	desc = "The simplicity of this cooling design betrays its efficiency: an extremely durable array of laminar plasteel fins, supplemented with a coating of coolant that allows the synthetic to be cooled even in space."

	passive_temp_change = 5
	plating_max_health = 200

// Zenghu cooling units.
/singleton/synthetic_organ_preset/cooling_unit/air_zenghu
	name = "zeng-hu penta-fan air cooling system"
	desc = "A sleek and luxurious air cooling system invented by Zeng-Hu for their house-made synthetic frames. It uses a patented and exclusive type of penta-fin fan. More efficient than standard air cooling solutions, but it will not allow cooling in space."

	passive_temp_change = 3
	plating_max_health = 40

/singleton/synthetic_organ_preset/cooling_unit/liquid_zenghu
	name = "zeng-hu lamellar liquid cooling system"
	desc = "A sleek set of superimposed lamellar pipes with a custom cooling solution. In black market and enthusiast repair forums, this is known as 'the enthusiast's nightmare' due to its practical impossibility to repair in anything less than a Zeng-Hu facility; \
			the lamellar pipes are impossible to reproduce or find through a third-party solution due to their extremely complex and exclusive Zeng-Hu make."

	passive_temp_change = 4
	plating_max_health = 15

/singleton/synthetic_organ_preset/cooling_unit/passive_zenghu
	name = "suprafin cooling fins"
	desc = "A sleek set of engraved, plasteel fins patented by Zeng-Hu as 'suprafins'. The engravings help increase thermal area to the maximum possible, and a specialized cooling solution is imprinted onto the fins to improve their cooling ability."

	passive_temp_change = 2
	plating_max_health = 130
