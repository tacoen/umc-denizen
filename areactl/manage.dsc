umc-tab-comp:

	# <proc[umc-tab-comp].context[<[command]>|<context.args.get[1]>|<context.args.get[3]>]>

	type: procedure
	definitions: command|param1
	script:

	  - choose <[command]>:

			- default:
				- determine

			- case "get":

				- choose <[param1]>:
					- case area-name:
						- determine <server.flag[umc.area].keys.if_null[<[param2]>]>

			- case "cmdlist":

				- choose <[param1]>:
					- default:
						- determine <list[]>
					- case calc:
						- determine <list[population|spawn_location|price]>
					- case spawn:
						- determine <list[max|entities|prof|color|location]>
					- case prop:
						- determine <list[title|owner|gamemode|price|midi]>
					- case tp:
						- determine <list[set|go]>						
					- case task:
						- determine <list[in|out]>	

			- case "vars":
			
				- choose <[param1]>:
					- default:
						- determine
						
					- case tp-set:
						- determine <list[cursor|player]>						

					- case prop-title:
						- determine "<player.location.direction>"

					- case prop-owner:
						- define players <list[]>
						- foreach <server.players> as:p:
							- define players <[players].include[<[p].name>]>
						- determine <[players]>

					- case prop-gamemode:
						- determine <list[adventure|survival|creative]>

					- case prop-midi:
						- determine <server.list_files[midi/]>

					- case spawn-location:
						- determine <list[cursor|player]>
					- case spawn-max:
						- determine <list[2|5|9]>
					- case spawn-reserve:
						- determine <list[1|2]>

					- case spawn-prof:
						- determine <list[#random].include[<script[umc_config].data_key[villager.prof].as_list.alphabetical>]>

					- case spawn-entities:
						- determine <list[villager|disguise|mmobs]>

					- case spawn-entities-villager:
						- determine <list[#random].include[<script[umc_config].data_key[villager.color].as_list.alphabetical>]>

					- case spawn-entities-mmobs:
						- determine <list[].include[<server.flag[umc.mmob.color]>]>

					- case spawn-entities-disguise:
						- determine <list[#random].include[<script[umc_config].data_key[disguise.color].as_list.alphabetical>]>

umc-area-manage:
	type: command
	name: umc-area
    permission: umc.op
    usage: /umc-area cmd parameter
    tab completions:
		1: task|test|active|deactive|prop|calc|reset|info|create-area|remove-area|yaml-load|yaml-save|adjustheight|spawn|note|tp
		2: <proc[umc-tab-comp].context[get|area-name]>
		3: <proc[umc-tab-comp].context[cmdlist|<context.args.get[1]>]>
		4: <proc[umc-tab-comp].context[vars|<context.args.get[1]>-<context.args.get[3]>]>
		5: <proc[umc-tab-comp].context[vars|<context.args.get[1]>-<context.args.get[3]>-<context.args.get[4]>]>
#		6: <proc[umc-tab-comp].context[vars|<context.args.get[1]>-<context.args.get[3]>-<context.args.get[4]>-prof]>

	script:

	- define name <context.args.get[2].if_null[null]>
	- define param1 <context.args.get[3].if_null[1]>
	- define param2 <context.args.get[4].if_null[#random]>
	- define param3 <context.args.get[5].if_null[1]>
	- define param4 <context.args.get[6].if_null[1]>

	- if <context.args.first> == "create-area":

		- if !<player.has_flag[seltool_selection]>:
			- narrate "<red>You don't have any area selected."
			- stop
		- if <[name]> == null:
			- narrate format:umc "<red>Require name."
			- stop

		- note <player.flag[seltool_selection]> as:<[name]>
		- narrate "umc: Area <[name]> Noted."
		- flag server umc.area.<[name]>.area:<player.flag[seltool_selection]>
		- narrate "umc: Area <[name]> Created."
		- inject selector_tool_status_task path:<player.flag[seltool_type]>
		- stop

	- if <context.args.first> == "yaml-save":

		- yaml create id:umc-area
		- yaml id:umc-area load:data/umc/areas.yml
		- yaml id:umc-area set areas:<server.flag[umc.area]>
		- yaml id:umc-area savefile:data/umc/areas.yml
		- narrate "savefile: data/umc/areas.yml"

	- if <context.args.first> == "yaml-load":

		- yaml create id:umc-area
		- yaml id:umc-area load:data/umc/areas.yml
		- define areas <yaml[umc-area].read[areas]>
		- flag server umc.area:<[areas]>
		- narrate "loadfile: data/umc/areas.yml"

	- if <[name]> == null:
		- stop

	- choose <context.args.first>:

		- case remove-area:
			- flag server umc.area.<[name]>:!
			- narrate format:umc "Area "<[name]> removed"

		- case adjustheight:

			- if <[param1].equals[max]>:
				- define y-max 321
				- define y-min -65
			- else:
				- define y-cent <player.flag[seltool_selection].bounding_box.center.y>
				- define y-max <player.flag[seltool_selection].bounding_box.max.y.add_int[<[param1]>]>
				- define y-min <player.flag[seltool_selection].bounding_box.min.y.sub_int[<[param1]>]>

			- define new_max <player.flag[seltool_selection].bounding_box.center.with_y[<[y-max]>]>
			- define new_min <player.flag[seltool_selection].bounding_box.center.with_y[<[y-min]>]>
			- narrate format:umc "<[y-min]> <[y-max]> <[new_max]> <[new_min]>"
			- flag player seltool_selection:<player.flag[seltool_selection].include[<[new_min]>]>
			- flag player seltool_selection:<player.flag[seltool_selection].include[<[new_max]>]>

			- flag server umc.area.<[name]>.area:<player.flag[seltool_selection]>
			- note <player.flag[seltool_selection]> as:<[name]>

			- inject selector_tool_status_task path:<player.flag[seltool_type]>

		- case prop:

			- choose <[param1]>:
				- case title:
					- define n <context.args.get[3].if_null[-1]>
					- define param2 <context.raw_args.after[<[n]>].trim>
					- flag server umc.area.<[name]>.prop.title:<[param2]>

				- case owner:
					- flag server umc.area.<[name]>.prop.owner:<[param2]>

				- case gamemode:
					- flag server umc.area.<[name]>.prop.gamemode:<[param2]>

				- case price:
					- flag server umc.area.<[name]>.prop.price:<[param2]>

				- case midi:
					- flag server umc.area.<[name]>.prop.midi:<[param2]>

		- case tp:
		
			- choose <[param1]>:
			
				- case set:
					- if <[param2]> == "cursor":
						- define loc <player.location.cursor_on>
					- else:
						- define loc <player.location>

					- flag server umc.area.<[name]>.tphere:<[loc]>
				
					- narrate "tp location: <[loc]>"
					- showfake glass <[loc].add[0,1,1]> duration:1s		
		
				- case go:
		
					- teleport <player> <server.flag[umc.area.<[name]>.tphere]>

		- case spawn:

			- choose <[param1]>:

				- case location:

					- if <[param2]> == "cursor":
						- define loc <player.location.cursor_on>
					- else:
						- define loc <player.location>

					- flag server umc.area.<[name]>.spawn.location:<[loc]>
					- narrate "spawn location: <[loc]>"
					- showfake glass <[loc].add[0,1,1]> duration:1s

				- case color:
					- flag server umc.area.<[name]>.spawn.color:<[param2]>

				- case prof:
					- flag server umc.area.<[name]>.spawn.prof:<[param2]>

				- case entities:
					- flag server umc.area.<[name]>.spawn.entities:<[param2]>
					- flag server umc.area.<[name]>.spawn.color:<[param3]>
					- flag server umc.area.<[name]>.spawn.prof:<[param4]>

				- case max:
					- flag server umc.area.<[name]>.spawn.max:<[param2]>
					- flag server umc.area.<[name]>.spawn.reverse:<[param3]>

		- case active:
			- flag server umc.area.<[name]>.active:true

		- case deactive:
			- flag server umc.area.<[name]>.active:!

		- case reset:
			- flag server umc.area.<[name]>.spawn:!
			- flag server umc.area.<[name]>.prop:!

		- case calc:

			- choose <[param1]>:

				- case spawn_location:
					- define areatarget <server.flag[umc.area.<[name]>.area]>
					- define loc <[areatarget].center.with_y[<player.location.y>]>
					- flag server umc.area.<[name]>.spawn.location:<[loc]>
					- narrate "Spawn location: <[loc]>"
					- showfake glass <[loc]> duration:1s

				- case price:
					- define y-max <script[umc_config].data_key[world_max_y]>
					- define y-min <script[umc_config].data_key[world_min_y]>
					- define new_max <player.flag[seltool_selection].bounding_box.center.with_y[<[y-max]>]>
					- define new_min <player.flag[seltool_selection].bounding_box.center.with_y[<[y-min]>]>
					- define sel_sale <player.flag[seltool_selection].include[<[new_min]>]>
					- define sel_sale <[sel_sale].include[<[new_max]>]>
					- define price <[sel_sale].volume.div_int[32].round_to_precision[2]>
					- narrate "Price: <[price]>"
					- flag server umc.area.<[name]>.prop.price:<[price]>
					- inject selector_tool_status_task path:<[sel_sale]>
					- note <[sel_sale> as:<[name]>
					- flag server umc.area.<[name]>.area:<[sel_sale]>
					- narrate "Area: maxed!"

				- case population:

#					- define lv <[areatarget].living_entities.count_matches[*]>
#					- define lv_v <[areatarget].entities[villager].count_matches[*].if_null[0]>
					- define mat *_bed
					- define rsv <server.flag[umc.area.<[name]>.spawn_reserve].if_null[0]>
					- if <[mat].contains_text[bed]>:
						- define spm <[areatarget].blocks[<[mat]>].count_matches[*].div_int[2].if_null[1]>
					- else:
						- define spm <[areatarget].blocks[<[mat]>].count_matches[*].if_null[1]>
					- define max <[spm].sub_int[<[rsv]>]>
					- flag server umc.area.<[name]>.spawn.max:<[max]>
					- flag server umc.area.<[name]>.spawn.reserve:<[rsv]>

		- case info:

			- define inf <server.flag[umc.area.<[name]>]>

			- if <[inf.active]>:
				- define isactive "- <&e>Active<&7>"
			- else:
				- define isactive  ""

			- if <[inf.spawn].if_null[null]> != null:
				- foreach <[inf.spawn].keys.alphabetical> as:ke:
				
					- if <[ke]> == "location":
						- narrate format:umn "spawn.<[ke]> = <[inf.spawn.<[ke]>].xyz>"
					- else:
						- narrate format:umn "spawn.<[ke]> = <[inf.spawn.<[ke]>]>"

			- if <[inf.prop].if_null[null]> != null:
				- foreach <[inf.prop].keys.alphabetical> as:ke:
					- narrate format:umn "prop.<[ke]> = <[inf.prop.<[ke]>]>"

			- narrate format:umn "<&f><[name]><&7> <[isactive]>"

		- case test:

#			- define areatarget <server.flag[umc.area.<[name]>.area]>
#			- define loc <[areatarget].center.with_y[<player.location.y>]>
#			- showfake glass <[loc].add[0,1,1]> duration:1s

			- inject umc-title
			- inject umc-area-midi

		- case note:

			- if <server.notes[cuboids].contains_any_text[<[name]>]>.not:
				- flag player seltool_selection:<server.flag[umc.area.<[name]>.area]>
				- note <player.flag[seltool_selection]> as:<[name]>
				- inject selector_tool_status_task path:<player.flag[seltool_type]>
			- else:
				- narrate "umc: <[name]> note existed."
				- narrate <server.notes[cuboids]>

# untested

		- case task:
			- define n <context.args.get[4].if_null[-1]>
			- define param2 <context.raw_args.after[<[n]>].trim>
			- flag server umc.area.<[name]>.task.<[param1]>:<[param2]>
			- narrate "task.<[param1]>: <[param2]>"