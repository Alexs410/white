
GLOBAL_LIST_INIT(ventcrawl_machinery, typecacheof(list(
	/obj/machinery/atmospherics/components/unary/vent_pump,
	/obj/machinery/atmospherics/components/unary/vent_scrubber)))

//VENTCRAWLING

/mob/living/proc/handle_ventcrawl(atom/A)
	if(!ventcrawler || !Adjacent(A))
		return
	if(stat)
		to_chat(src, span_warning("Нужно быть в сознании для этого!"))
		return
	if(HAS_TRAIT(src, TRAIT_IMMOBILIZED))
		to_chat(src, span_warning("Не могу сделать это в таком состоянии!"))
		return
	if(HAS_TRAIT(src, TRAIT_HANDS_BLOCKED))
		to_chat(src, span_warning("Не могу сделать это со связанными руками!"))
		return
	if(has_buckled_mobs())
		to_chat(src, span_warning("Не могу перемещаться по трубам с существами на мне!"))
		return
	if(buckled)
		to_chat(src, span_warning("Не могу перемещаться со стулом по трубам!"))
		return

	var/obj/machinery/atmospherics/components/unary/vent_found


	if(A)
		vent_found = A
		if(!istype(vent_found) || !vent_found.can_crawl_through())
			vent_found = null

	if(!vent_found)
		for(var/obj/machinery/atmospherics/machine in range(1,src))
			if(is_type_in_typecache(machine, GLOB.ventcrawl_machinery))
				vent_found = machine

			if(!vent_found.can_crawl_through())
				vent_found = null

			if(vent_found)
				break


	if(vent_found)
		var/datum/pipeline/vent_found_parent = vent_found.parents[1]
		if(vent_found_parent && (vent_found_parent.members.len || vent_found_parent.other_atmosmch))
			visible_message(span_notice("[capitalize(src.name)] начинает проникать в систему вентиляции...")  ,span_notice("Начинаю проникать в систему вентиляции..."))

			if(!do_after(src, 25, target = vent_found))
				return

			if(!client)
				return

			if(iscarbon(src) && ventcrawler == VENTCRAWLER_NUDE)
				if(length(get_equipped_items(include_pockets = TRUE)) || get_num_held_items())
					to_chat(src, span_warning("Не могу ползать по трубам с предметами в руках!"))
					return

			visible_message(span_notice("[capitalize(src.name)] влезает в вентиляционное отверстие!") ,span_notice("Влезаю в вентиляционное отверстие."))
			forceMove(vent_found)
	else
		to_chat(src, span_warning("Эта вентиляция не подключена к системе труб!"))

/mob/living/simple_animal/slime/handle_ventcrawl(atom/A)
	if(buckled)
		to_chat(src, "<i>КАК...</i>")
		return
	return ..()


/mob/living/proc/add_ventcrawl(obj/machinery/atmospherics/starting_machine)
	if(!istype(starting_machine) || !starting_machine.can_see_pipes())
		return
	var/list/totalMembers = list()

	for(var/datum/pipeline/P in starting_machine.returnPipenets())
		totalMembers += P.members
		totalMembers += P.other_atmosmch

	if(!totalMembers.len)
		return

	if(client)
		for(var/X in totalMembers)
			var/obj/machinery/atmospherics/A = X //all elements in totalMembers are necessarily of this type.
			if(in_view_range(client.mob, A))
				if(!A.pipe_vision_img)
					A.pipe_vision_img = image(A, A.loc, dir = A.dir)
					A.pipe_vision_img.plane = ABOVE_HUD_PLANE
				client.images += A.pipe_vision_img
				pipes_shown += A.pipe_vision_img
	ADD_TRAIT(src, TRAIT_MOVE_VENTCRAWLING, VENTCRAWLING_TRAIT)

/mob/living/proc/remove_ventcrawl()
	if(client)
		for(var/image/current_image in pipes_shown)
			client.images -= current_image
	pipes_shown.len = 0
	REMOVE_TRAIT(src, TRAIT_MOVE_VENTCRAWLING, VENTCRAWLING_TRAIT)




//OOP
/atom/proc/update_pipe_vision(atom/new_loc = null)
	return

/mob/living/update_pipe_vision(atom/new_loc = null)
	. = loc
	if(new_loc)
		. = new_loc
	remove_ventcrawl()
	add_ventcrawl(.)
