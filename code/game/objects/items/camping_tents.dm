// Various tents, shapes, so on
// Look in camping.dm for the code itself


/obj/item/tent/medium
	name = "camp tent"
	color = "#2e3763"
	footprint = list(
		"#^#",
		"###",
		"#v#"
	)
	roof_layout = list(
		"LMR",
		"LMR",
		"LMR"
	)

/obj/item/tent/big
	name = "base camp tent"
	color = "#2e3763"
	footprint = list(
		"#^^#",
		"####",
		"####",
		"####",
		"#vv#"
	)
	roof_layout = list(
		"LLRR",
		"LLRR",
		"LLRR",
		"LLRR",
		"LLRR"
	)

/obj/item/tent/turn
	name = "corner connector tent"
	color = "#2e3763"
	footprint = list(
		"..^^",
		"..##",
		"<###",
		"<###"
	)
	roof_layout = list(
		"..LR",
		"..LR",
		"LLLR",
		"LLLR"
	)

/obj/item/tent/t_junction
	name = "T-junction connector tent"
	color = "#2e3763"
	footprint = list(
		".^^.",
		".##.",
		"<##>",
		"<##>"
	)
	roof_layout = list(
		".LR.",
		".LR.",
		"LLRR",
		"LLRR"
	)

/obj/item/tent/medical
	name = "medical tent"
	color = HOLOMAP_AREACOLOR_MEDICAL
	footprint = list(
		".^^..",
		".##..",
		"#####",
		"#####",
		"####>",
		"#####"
	)
	roof_layout = list(
		".LM..",
		".LM..",
		"LLMRR",
		"LLMRR",
		"LLMRR",
		"LLMRR"
	)

/obj/item/tent/security
	name = "security tent"
	color = HOLOMAP_AREACOLOR_SECURITY
	footprint = list(
		".#^^#.",
		".####.",
		"#####.",
		"######",
		"######",
		"#####."
	)
	roof_layout = list(
		".LLRR.",
		".LLRR.",
		"LLLRR.",
		"LLLRRR",
		"LLLRRR",
		"LLLRR."
	)

/obj/item/tent/engineering
	name = "engineering tent"
	color = HOLOMAP_AREACOLOR_ENGINEERING
	footprint = list(
		"#^^#..",
		"#####>",
		"#####>",
		"#####>",
		"####.."
	)
	roof_layout = list(
		"LLRR..",
		"LLRRRR",
		"LLRRRR",
		"LLRRRR",
		"LLRR.."
	)

/obj/item/tent/science
	name = "science tent"
	color = HOLOMAP_AREACOLOR_SCIENCE
	footprint = list(
		".##^^#",
		".#####",
		".#####",
		".###..",
		"####..",
		"####.."
	)
	roof_layout = list(
		".LLMRR",
		".LLMRR",
		".LLMRR",
		".LLM..",
		"LLLM..",
		"LLLM.."
	)

/obj/item/tent/command
	name = "command tent"
	color = HOLOMAP_AREACOLOR_COMMAND
	footprint = list(
		".#^^#.",
		"######",
		"<####>",
		"<####>",
		"######",
		".#vv#.",
	)
	roof_layout = list(
		"..LR..",
		".LLRR.",
		"LLLRRR",
		"LLLRRR",
		".LLRR.",
		"..LR..",
	)

/obj/item/tent/mess_hall
	name = "mess hall tent"
	color = HOLOMAP_AREACOLOR_CIVILIAN
	footprint = list(
		"..^^..",
		"######",
		"######",
		"<#####",
		"<#####"
	)
	roof_layout = list(
		"..LR..",
		"LLLRRR",
		"LLLRRR",
		"LLLRRR",
		"LLLRRR"
	)

/obj/item/tent/command_comms
	name = "command and communications tent"
	color = HOLOMAP_AREACOLOR_COMMAND
	footprint = list(
		".#^^#",
		".####",
		"#####",
		"#####",
		".####",
		".#vv#"
	)
	roof_layout = list(
		".LLRR",
		".LLRR",
		"LLLRR",
		"LLLRR",
		".LLRR",
		".LLRR"
	)

/obj/item/tent/field_kitchen
	name = "field kitchen tent"
	color = HOLOMAP_AREACOLOR_CIVILIAN
	footprint = list(
		"#^^#",
		"####",
		"####",
		"####"
	)
	roof_layout = list(
		"LLRR",
		"LLRR",
		"LLRR",
		"LLRR"
	)

/obj/item/tent/quarantine
	name = "quarantine tent"
	color = HOLOMAP_AREACOLOR_MEDICAL
	footprint = list(
		".^^.",
		"####",
		"####",
		".##.",
		"####",
		"####",
		".vv."
	)
	roof_layout = list(
		".LR.",
		"LLRR",
		"LLRR",
		".LR.",
		"LLRR",
		"LLRR",
		".LR."
	)

/obj/item/tent/decontamination
	name = "decontamination tent"
	color = HOLOMAP_AREACOLOR_MEDICAL
	footprint = list(
		"#^^#",
		"####",
		"####",
		"####",
		"#vv#"
	)
	roof_layout = list(
		"LLRR",
		"LLRR",
		"LLRR",
		"LLRR",
		"LLRR",
	)

/obj/item/tent/machinist
	name = "machinist tent"
	color = HOLOMAP_AREACOLOR_OPERATIONS
	footprint = list(
		"#^^#",
		"####",
		"####",
		"####",
		".##."
	)
	roof_layout = list(
		"LLRR",
		"LLRR",
		"LLRR",
		"LLRR",
		".LR."
	)

/obj/item/tent/vehicle_workshop
	name = "vehicle workshop tent"
	color = HOLOMAP_AREACOLOR_OPERATIONS
	footprint = list(
		".#^^#.",
		"######",
		"######",
		"######",
		".####.",
		".vvvv."
	)
	roof_layout = list(
		".LLRR.",
		"LLLRRR",
		"LLLRRR",
		"LLLRRR",
		".LLRR.",
		".LLRR."
	)

/obj/item/tent/cargo
	name = "cargo tent"
	color = HOLOMAP_AREACOLOR_OPERATIONS
	footprint = list(
		"#^^##..",
		"#####..",
		"#######",
		"#######",
		"#######",
		"#######"
	)
	roof_layout = list(
		"LLMRR..",
		"LLMRR..",
		"LLMRRRR",
		"LLMRRRR",
		"LLMRRRR",
		"LLMRRRR"
	)

/obj/item/tent/mining
	name = "miners' tent"
	color = "#8b7242"
	assembly_time_per_stage = 5 SECONDS
	disassembly_time_per_stage = 5 SECONDS
	footprint = list(
		".#^#.",
		".###.",
		".####",
		".####",
		".###."
	)
	roof_layout = list(
		".LMR.",
		".LMR.",
		".LMRR",
		".LMRR",
		".LMR."
	)
