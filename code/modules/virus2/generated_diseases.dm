/datum/disease2/disease/generated
	var/generated_name = "Generated Disease"
	var/dangerous = FALSE
	uniqueID = 10000
	var/list/effect_datums = list()

/datum/disease2/disease/generated/New()

	antigen = list(pick(ALL_ANTIGENS))
	antigen |= pick(ALL_ANTIGENS)
	affected_species = get_infectable_species()

	for(var/i=1,i<effect_datums.len,i++)//It's a basic loop because I need the "i" for the stage number.
		var/datum/disease2/effect/E = effect_datums[i]
		var/datum/disease2/effectholder/H = new /datum/disease2/effectholder
		H.stage = i
		H.effect = new E
		H.effect.generate()
		H.chance = rand(0,H.effect.chance_maxm)
		H.multiplier = rand(1,H.effect.maxm)
		effects += H
	..()

/datum/disease2/disease/generated/cold
	generated_name = "Spacecold"
	spreadtype = "Airborne"
	uniqueID = 10001
	speed = 5
	effect_datums = list(
		/datum/disease2/effect/gunck,
		/datum/disease2/effect/sneeze,
		/datum/disease2/effect/fridge,
		/datum/disease2/effect/drowsness
	)

/datum/disease2/disease/generated/cough
	generated_name = "Moghes Cough"
	spreadtype = "Airborne"
	uniqueID = 10002
	speed = 5
	effect_datums = list(
		/datum/disease2/effect/headache,
		/datum/disease2/effect/cough,
		/datum/disease2/effect/groan,
		/datum/disease2/effect/drool
	)

/datum/disease2/disease/generated/zombie
	generated_name = "Cannibal Fever"
	dangerous = TRUE
	uniqueID = 10003
	effect_datums = list(
		/datum/disease2/effect/drool,
		/datum/disease2/effect/hungry,
		/datum/disease2/effect/groan,
		/datum/disease2/effect/mind
	)

/datum/disease2/disease/generated/madness
	generated_name = "Sensory Madness Syndrome"
	dangerous = TRUE
	uniqueID = 10004
	effect_datums = list(
		/datum/disease2/effect/headache,
		/datum/disease2/effect/blind,
		/datum/disease2/effect/hallucinations,
		/datum/disease2/effect/deaf_major
	)

/datum/disease2/disease/generated/clone
	generated_name = "Cloning Tube Disorder"
	dangerous = TRUE
	uniqueID = 10005
	effect_datums = list(
		/datum/disease2/effect/twitch,
		/datum/disease2/effect/hair,
		/datum/disease2/effect/mutation,
		/datum/disease2/effect/radian
	)

/datum/disease2/disease/generated/hyper
	generated_name = "Hormonal Infectious Disease"
	dangerous = TRUE
	uniqueID = 10006
	effect_datums = list(
		/datum/disease2/effect/twitch,
		/datum/disease2/effect/stimulant,
		/datum/disease2/effect/chem_synthesis,
		/datum/disease2/effect/killertoxins
	)

/datum/disease2/disease/generated/telepathy
	generated_name = "Skrell Syndrome"
	dangerous = TRUE
	uniqueID = 10007
	effect_datums = list(
		/datum/disease2/effect/headache,
		/datum/disease2/effect/hair,
		/datum/disease2/effect/telepathic,
		/datum/disease2/effect/bones
	)


/datum/disease2/disease/generated/dna
	generated_name = "DNA Disease"
	dangerous = TRUE
	uniqueID = 10012
	effect_datums = list(
		/datum/disease2/effect/twitch,
		/datum/disease2/effect/hair,
		/datum/disease2/effect/mutation,
		/datum/disease2/effect/dna
	)

/datum/disease2/disease/generated/fever
	generated_name = "Worker's Fever"
	uniqueID = 10013
	speed = 5
	stageprob = 15
	effect_datums = list(
		/datum/disease2/effect/headache,
		/datum/disease2/effect/drowsness,
		/datum/disease2/effect/confusion,
		/datum/disease2/effect/shakey
	)

/datum/disease2/disease/generated/spaceflu
	generated_name = "Space Flu"
	spreadtype = "Airborne"
	dangerous = TRUE
	uniqueID = 10014
	effect_datums = list(
		/datum/disease2/effect/gunck,
		/datum/disease2/effect/sneeze,
		/datum/disease2/effect/fridge,
		/datum/disease2/effect/toxins
	)

