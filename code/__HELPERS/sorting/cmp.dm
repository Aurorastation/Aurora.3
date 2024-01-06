/proc/cmp_numeric_dsc(a,b)
	return b - a

/proc/cmp_numeric_asc(a,b)
	return a - b

/proc/cmp_text_asc(a,b)
	return sorttext(b,a)

/proc/cmp_text_dsc(a,b)
	return sorttext(a,b)

/proc/cmp_name_asc(atom/a, atom/b)
	return sorttext(b.name, a.name)

/proc/cmp_name_dsc(atom/a, atom/b)
	return sorttext(a.name, b.name)

/proc/cmp_records_asc(datum/record/a, datum/record/b)
	return sorttext(b.vars[b.cmp_field], a.vars[a.cmp_field])

/proc/cmp_records_dsc(datum/record/a, datum/record/b)
	return sorttext(a.vars[a.cmp_field], b.vars[b.cmp_field])

/proc/cmp_ckey_asc(client/a, client/b)
	return sorttext(b.ckey, a.ckey)

/proc/cmp_ckey_dsc(client/a, client/b)
	return sorttext(a.ckey, b.ckey)

/proc/cmp_subsystem_init(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return initial(b.init_order) - initial(a.init_order) //uses initial() so it can be used on types

/proc/cmp_subsystem_display(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return sorttext(b.name, a.name)

/proc/cmp_subsystem_priority(datum/controller/subsystem/a, datum/controller/subsystem/b)
	return a.priority - b.priority

/proc/cmp_timer(datum/timedevent/a, datum/timedevent/b)
	return a.timeToRun - b.timeToRun

/proc/cmp_camera(obj/machinery/camera/a, obj/machinery/camera/b)
	if (a.c_tag_order != b.c_tag_order)
		return b.c_tag_order - a.c_tag_order
	return sorttext(b.c_tag, a.c_tag)

/proc/cmp_alarm(datum/alarm/a, datum/alarm/b)
	return sorttext(b.last_name, a.last_name)

/proc/cmp_uplink_item(datum/uplink_item/a, datum/uplink_item/b)
	var/total_crystal_cost_a = a.telecrystal_cost(INFINITY) + a.bluecrystal_cost(INFINITY)
	var/total_crystal_cost_b = b.telecrystal_cost(INFINITY) + b.bluecrystal_cost(INFINITY)
	return total_crystal_cost_b - total_crystal_cost_a

/proc/cmp_access(datum/access/a, datum/access/b)
	return sorttext("[b.access_type][b.desc]", "[a.access_type][a.desc]")

/proc/cmp_player_setup_group(datum/category_group/player_setup_category/a, datum/category_group/player_setup_category/b)
	return a.sort_order - b.sort_order

/proc/cmp_cardstate(datum/card_state/a, datum/card_state/b)
	return sorttext(b.name, a.name)

/proc/cmp_uplink_category(datum/uplink_category/a, datum/uplink_category/b)
	return sorttext(b.name, a.name)

/proc/cmp_admin_secret(datum/admin_secret_item/a, datum/admin_secret_item/b)
	return sorttext(b.name, a.name)

/proc/cmp_supply_drop(datum/supply_drop_loot/a, datum/supply_drop_loot/b)
	return sorttext(b.name, a.name)

/proc/cmp_rcon_smes(obj/machinery/power/smes/buildable/S1, obj/machinery/power/smes/buildable/S2)
	return sorttext(S2.RCon_tag, S1.RCon_tag)

/proc/cmp_rcon_bbox(obj/machinery/power/breakerbox/BR1, obj/machinery/power/breakerbox/BR2)
	return sorttext(BR2.RCon_tag, BR1.RCon_tag)

/proc/cmp_recipe_complexity_dsc(singleton/recipe/A, singleton/recipe/B)
	var/a_score = LAZYLEN(A.items) + LAZYLEN(A.reagents) + LAZYLEN(A.fruit)
	var/b_score = LAZYLEN(B.items) + LAZYLEN(B.reagents) + LAZYLEN(B.fruit)
	return b_score - a_score

/proc/cmp_planelayer(atom/A, atom/B)
	return (B.plane - A.plane) || (B.layer - A.layer)

/proc/cmp_clientcolor_priority(datum/client_color/A, datum/client_color/B)
	return B.priority - A.priority

/proc/cmp_ruincost_priority(datum/map_template/ruin/A, datum/map_template/ruin/B)
	return initial(A.spawn_cost) - initial(B.spawn_cost)

/proc/cmp_fusion_reaction_asc(singleton/fusion_reaction/A, singleton/fusion_reaction/B)
	return A.priority - B.priority

/proc/cmp_fusion_reaction_des(singleton/fusion_reaction/A, singleton/fusion_reaction/B)
	return B.priority - A.priority
