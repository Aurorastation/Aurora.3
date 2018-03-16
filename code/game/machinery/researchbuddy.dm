#define ASTRONOMY 1
#define MEDICINE 2
#define ENGINEERING 3
#define MATHEMATICS 4
#define DATATHEORY 5
#define PHILOSOPHY 6

#define BLUESPACE 1
#define XENOARCH 2
#define COMBATMED 3
#define ANATOMY 4
#define CHEMISTRY 5
#define PHORONMED 6
#define BIOLOGICAL 7
#define COMBATENGIE 8
#define POWERE 9
#define PHORONENGIE 10
#define MATERIALS 11
#define EQUATIONS 12
#define BLUESPACEMATH 13
#define TELESCIENCE 14
#define AI2 15
#define ELECTROMAG 16
#define LAW 17
#define DIPLO 18
#define ECOPOLICY 19

/obj/machinery/researchbuddy
	name = "Research Buddy"
	desc = ""
	icon = 'icons/obj/biogenerator.dmi' // sprites...
	icon_state = "biogen-stand"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 40
	var/active = 0
	var/field = 0
	var/support1 = 0
	var/support2 = 0
	var/pointworth = 0
	var/progress = 0
	var/paper

/obj/machinery/researchbuddy/Initialize()
	. = ..()

/obj/machinery/researchbuddy/update_icon()
	if(!active)
		icon_state = "biogen-stand"
	else
		icon_state = "biogen-work"
	return

/obj/machinery/researchbuddy/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = outside_state)
	var/data[0]

	data["power"] = stat & (NOPOWER|BROKEN) ? 0 : 1
	data["field"] = field
	data["support1"] = support1
	data["support2"] = support2
	data["processing"] = active
	data["progress"] = progress
	data["paper"] = paper

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "researchbuddy.tmpl", "NT Research Buddy", 600, 600, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/researchbuddy/attack_hand(mob/user as mob)
	if(..())
		return 1

	ui_interact(user)

/obj/machinery/researchbuddy/Topic(href, href_list)
	if(stat & BROKEN) return
	if(usr.stat || usr.restrained()) return
	if(!in_range(src, usr)) return

	usr.set_machine(src)
	var/numv
	if(href_list["field"])
		numv = round(text2num(href_list["field"]), 1)
		if(numv <= 6 && numv > 0)
			field = numv
	if(href_list["supportone"])
		numv = round(text2num(href_list["supportone"]), 1)
		if(numv <= 19 && numv > 0)
			if(support1)
				if(numv == support1)
					return
				support2 = numv
			else
				support1 = numv
	if(href_list["confirm"])
		numv = round(text2num(href_list["confirm"]), 1)
		switch(numv)
			if(1)
				active = 1
			if(2)
				field = 0
				support1 = 0
				support2 = 0
				paper = 0
	
	if(href_list["paper"])
		numv = round(text2num(href_list["paper"]), 1)
		switch(numv)
			if(1)
				Write_Paper(usr)
			if(2)
				paper = 2
	updateUsrDialog()

/obj/machinery/researchbuddy/machinery_process()
	set waitfor = FALSE
	if(active == 0)
		return
	if(active < 100)
		sleep(rand(200,1200))
		active += rand(2,5)
	if(active > 100)a
		FinishPaper()
		active = 0

/obj/machinery/researchbuddy/proc/Write_Paper(var/mob)
	if(field && support1 && support2)
		paper = input(mob, "Please enter a message to include in your report.", "Report", "") as message|null
		if(!paper)
			paper = 2

/obj/machinery/researchbuddy/proc/FinishPaper()
	ping()
	var/value = 2//GetValue()
	var/money = 2//tbd
	if(paper)
		message_admins("A researchbuddy paper with additional information has been completed. The paper has been printed on the CentCom fax machine.")
	var/obj/item/weapon/paper/pp = new(src.loc)
	pp.name = "Research report No. [rand(1,2000)]"
	pp.info = "Research on [field] was completed at [world.time]. The principles applied to [field] was [support1] and [support2]. [paper !=2 ? "Additional information was filed with the report, stating [paper]." : "No additional information was filed with the report."]. A Senior Official has reviewed the analysis formed and has assigned its value at [value]. [money ? "No money will be given for this paper." : "[money] has been deposited into the research account for this success."]"
	field = 0
	support1 = 0
	support2 = 0
	paper = 0
	