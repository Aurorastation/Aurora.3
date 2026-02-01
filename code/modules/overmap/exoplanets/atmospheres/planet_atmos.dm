/singleton/atmosphere
	/// Assoc list of [GAS] => % of atmosphere
	var/list/gases = list()
	/// Expected # of atmospheres generated (earthlike = 1 atm); can be a range as list(min, max)
	var/expected_atms = list(0.8, 1.2)
	/// Temperature of atmosphere. Can be a single value or a range as list(min, max)
	var/temperature = T20C
	/// XGM_GAS flags that are rejected from generation.
	var/ban_flags = 0
	/// % chance that other gas types can appear in gases. Gases not listed default to a value of 1
	var/list/gas_potential = list(
		GAS_PHORON = 0,
		GAS_WATERVAPOR = 0,
		GAS_ALIEN = 0.5
	)

/singleton/atmosphere/void
	expected_atms = 0

/singleton/atmosphere/breathable
	gases = list(
		GAS_OXYGEN = O2STANDARD
	)
	ban_flags = XGM_GAS_FUEL|XGM_GAS_CONTAMINANT

/singleton/atmosphere/breathable/nitrogen
	gases = list(
		GAS_NITROGEN = N2STANDARD
	)

/singleton/atmosphere/breathable/earthlike
	gases = list(
		GAS_OXYGEN = O2STANDARD,
		GAS_NITROGEN = N2STANDARD
	)
	expected_atms = 1

/singleton/atmosphere/sulfur
	gases = list(
		GAS_SULFUR = O2STANDARD
	)
	expected_atms = O2STANDARD

/singleton/atmosphere/nitrogen
	gases = list(
		GAS_NITROGEN = O2STANDARD
	)
	expected_atms = O2STANDARD

/singleton/atmosphere/nitrogen/luthien
	temperature = list(T20C + 20, 355)

/singleton/atmosphere/nitrogen/caprice
	temperature = T0C + 400

/singleton/atmosphere/nitrogen/new_gibson
	temperature = T0C - 200

/singleton/atmosphere/chlorine
	gases = list(
		GAS_CHLORINE = O2STANDARD
	)
	expected_atms = O2STANDARD

/singleton/atmosphere/chlorine/azmar
	temperature = T0C + 500

/singleton/atmosphere/sulfur/lava
	temperature = list(T20C + 220, T20C + 800)

/singleton/atmosphere/sulfur/lava/huozhu
	temperature = list(T20C + 600, T20C + 1000)

/singleton/atmosphere/breathable/earthlike/burszia
	temperature = T0C - 113

/singleton/atmosphere/breathable/earthlike/burszia/brightside
	temperature = T0C + 546

/singleton/atmosphere/breathable/earthlike/moghes
	temperature = list(T20C + 10, T20C + 20)

/singleton/atmosphere/breathable/earthlike/moghes/wasteland
	temperature = list(T20C + 20, T20C + 30)

/singleton/atmosphere/breathable/earthlike/ouerea
	temperature = list(T20C + 5, T20C + 10)

/singleton/atmosphere/breathable/earthlike/xanu
	temperature = list(T0C - 1, T0C - 5)

/singleton/atmosphere/breathable/earthlike/xanu/mountains
	temperature = list(T0C + 25, T0C + 30)

/singleton/atmosphere/breathable/jungle
	temperature = list(T20C + 10, T20C + 30)

/singleton/atmosphere/breathable/earthlike/jungle
	temperature = list(T20C + 10, T20C + 30)

/singleton/atmosphere/hot
	temperature = list(T20C + 20, 355)

/singleton/atmosphere/breathable/hot
	temperature = list(T20C + 20, 355)

/singleton/atmosphere/breathable/earthlike/hot
	temperature = list(T20C + 20, 355)

/singleton/atmosphere/cold
	temperature = list(265, T20C - 10)

/singleton/atmosphere/breathable/cold
	temperature = list(265, T20C - 10)

/singleton/atmosphere/breathable/earthlike/cold
	temperature = list(265, T20C - 10)

/singleton/atmosphere/breathable/earthlike/adhomai
	temperature = T0C - 5

/singleton/atmosphere/breathable/earthlike/adhomai/northpole
	temperature = T0C - 40

/singleton/atmosphere/thin
	expected_atms = 0.1
