//#define IS_VALID_ASSOC_KEY(V) (istext(V) || ispath(V) || isdatum(V) || islist(V))
#define IS_VALID_ASSOC_KEY(V) (!isnum(V)) //hhmmm..

// vv_do_basic() keys
#define VV_HK_BASIC_EDIT "datumedit"
#define VV_HK_BASIC_CHANGE "datumchange"
//This differs from TG
#define VV_HK_BASIC_MASSEDIT "datummass"

// /datum
#define VV_HK_CALLPROC "proc_call"
#define VV_HK_MARK "mark"

// /mob/living
#define VV_HK_ADMIN_RENAME "admin_rename"

//Helpers for vv_get_dropdown() - yes this is different from the tg one, cope
#define VV_DROPDOWN_OPTION(href_key, name) . += "<option value='?_src_=vars;[href_key]=[REF(src)]'>[name]</option>"
