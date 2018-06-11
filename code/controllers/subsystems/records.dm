/var/datum/controller/subsystem/records/SSrecords

/datum/controller/subsystem/records
    name = "Records"
    flags = SS_NO_FIRE

    var/list/records

/datum/controller/subsystem/records/New()
    LAZYINITLIST(records)
    NEW_SS_GLOBAL(SSrecords)

/datum/controller/subsystem/records/proc/generate_record(var/mob/living/carbon/human/H)
    if(H.mind && !player_is_antag(H.mind, only_offstation_roles = 1) && SSjobs.ShouldCreateRecords(H.mind.assigned_role))
        var/assignment = GetAssignment(H)
        var/id = generate_record_id()
        var/list/r = create_empty_record(H, id)
        //General Data
        r["name"] = H.real_name
        r["real_rank"] = H.mind.assigned_role
        r["rank"] = assignment
        r["age"] = H.age
        r["fingerprint"] = md5(H.dna.uni_identity)
        r["sex"] = H.gender
        r["species"] = H.get_species()
        r["home_system"] = H.home_system
        r["citizenship"] = H.citizenship
        r["faction"] = H.personal_faction
        r["religion"] = H.religion
        r["ccia_record"] = H.ccia_record
        r["ccia_actions"] = H.ccia_actions
        if(H.gen_record && !jobban_isbanned(H, "Records"))
            r["notes"] = H.gen_record

        //Medical Data
        r["medical"]["blood_type"] = H.b_type
        r["medical"]["blood_dna"] = H.dna.unique_enzymes
        if(H.med_record && !jobban_isbanned(H, "Records"))
            r["medical"]["notes"] = H.med_record

        //Security Data
        r["security"]["incidents"] = H.incidents
        if(H.sec_record && !jobban_isbanned(H, "Records"))
            r["security"]["notes"] = H.sec_record

        //Locked Data
        r["locked"] = r.Copy()
        r["locked"]["nid"] = md5("[H.real_name][H.mind.assigned_role]")
        r["locked"]["enzymes"] = H.dna.SE // Used in respawning
        r["locked"]["identity"] = H.dna.UI
        if(H.exploit_record && !jobban_isbanned(H, "Records"))
            r["locked"]["exploit_record"] = H.exploit_record
        else
            r["locked"]["exploit_record"] = "No additional information acquired."

        add_record(r)

/datum/controller/subsystem/records/proc/add_record(var/list/record)
    records[record["id"]] = record
        
/datum/controller/subsystem/records/proc/create_empty_record(var/mob/living/carbon/human/H, var/id)
    var/icon/front
    var/icon/side
    if(H)
        front = getFlatIcon(H, SOUTH, always_use_defdir = TRUE)
        side = getFlatIcon(H, WEST, always_use_defdir = TRUE)
    else
        var/mob/living/carbon/human/dummy = new()
        front = getFlatIcon(dummy, SOUTH, always_use_defdir = TRUE)
        side = getFlatIcon(dummy, SOUTH, always_use_defdir = TRUE)
        qdel(dummy)
    
    if(!id) id = generate_record_id()
    var/list/r = list()
    //General Data
    r["name"] = "New Record"
    r["id"] = id
    r["rank"] = "Unassigned"
    r["real_rank"] = "Unassigned"
    r["sex"] = "Male"
    r["age"] = "Unknown"
    r["fingerprint"] = "Unknown"
    r["phisical_status"] = "Active"
    r["medical_status"] = "Stable"
    r["species"] = "Human"
    r["home_system"] = "Unknown"
    r["citizenship"] = "Unknown"
    r["faction"] = "Unknown"
    r["religion"] = "Unknown"
    r["photo_front"] = front
    r["photo_side"] = side
    r["notes"] = "No notes found."
    r["ccia_record"] = "No CCIA records found"
    r["ccia_actions"] = "No CCIA actions found"

    //Medical Data
    var/list/m = list()
    r["medical"] = m
    m["blood_type"] = "AB+"
    m["blood_dna"] = md5("New Record")
    m["disabilities"] = "No disabilities have been declared."
    m["allergies"] = "No allergies have been detected in this patient."
    m["diseases"] = "No diseases have been diagnosed at the moment."
    m["notes"] = "No notes found."

    //Security Data
    var/list/s = list()
    r["security"] = s
    s["criminal"] = "None"
    s["crimes"] = "There is no crime convictions."
    s["notes"] = "No notes found."
    s["incidents"] = ""

    return r

/datum/controller/subsystem/records/proc/find_record(var/field, var/value)
    for(var/list/r in records)
        if(r[field] == value)
            return r

/datum/controller/subsystem/records/proc/build_records()
    set waitfor = FALSE
    for(var/mob/living/carbon/human/H in player_list)
        generate_record(H)

/proc/GetAssignment(var/mob/living/carbon/human/H)
    if(H.mind.role_alt_title)
        return H.mind.role_alt_title
    else if(H.mind.assigned_role)
        return H.mind.assigned_role
    else if(H.job)
        return H.job
    else
        return "Unassigned"

/proc/generate_record_id()
    return add_zero(num2hex(rand(1, 65535)), 4)