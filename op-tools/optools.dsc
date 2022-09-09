umc-op-tools-proc:
	type: procedure
	definitions: command
	script:

	- choose <[command]>:

		- default:
			- determine ""

		- case sub-fx:
			- determine <list[nv|cp]>

		- case sub-wesel:
			- determine <list[show|max|min|flat|up|down]>

		- case sub-no:
			- determine <list[grass|trees|flora]>

		- case sub-kill:
			- determine <server.entity_types.include[_monsters|_villagers|_all]>

		- case sub-spawner:
			- determine <server.entity_types>

		- case param1-wesel:
			- determine <list[5|10|20|30|50]>

		- case param1-no:
			- determine <list[5|10|20|30|50]>

		- case param1-spawner:
			- determine <list[1|2|3|4|5|6]>

		- case param 2-spawner:
			- determine <list[1|2|3|4|5|6]>

		- case param1-vprof:
			- determine <list[3|5|10]>

		- case sub-vprof:
			- determine <list[NONE].include[<script[umc_config].data_key[villager.prof]>]>

		- case param2-vprof:
			- determine <list[1|2|3|4|5]>
			

umc-optools-command:
	type: command
	name: umc-op
    description: umc op tools, whats else?
    permission: umc.op
    permission message: You dont have permission to use this command
    usage: /umc-op cmd parameter parameter
    tab completions:
        1: fx|no|kill|spawner|wesel|vprof
		2: <proc[umc-op-tools-proc].context[sub-<context.args.get[1]>]>
		3: <proc[umc-op-tools-proc].context[param1-<context.args.get[1]>]>
		4: <proc[umc-op-tools-proc].context[param2-<context.args.get[1]>]>
		default: StopTyping

    script:

	- define cmd <context.args.get[1].if_null[help]>
	- define sub <context.args.get[2].if_null[null]>
	- define param1 <context.args.get[3].if_null[10]>
	- define param2 <context.args.get[4].if_null[10]>

    - choose <context.args.first>:

		- default:
			- narrate format:umc "optools:"

		- case wesel:

			- define cuboid <player.we_selection>

			- if <player.we_selection.if_null[null]> == null:
				- narrate format:umc-err "Worldedit Selection is empty!"
				- stop

			- choose <[sub]>:
			
				- case max:
					- define ymax <[cuboid].max.with_y[<script[umc_config].data_key[world_max_y]>]>
					- define ymin <[cuboid].min>
					- inject locally wesel_pos

				- case min:
					- define ymin <[cuboid].max>
					- define ymin <[cuboid].min.with_y[<script[umc_config].data_key[world_min_y]>]>
					- inject locally wesel_pos
					
				- case flat:
					- define ymin <[cuboid].min>
					- define ymax <[cuboid].max.with_y[<[ymin].y>]>
					- inject locally wesel_pos
					
				- case up:
					- define ny <[cuboid].max.y.add_int[<[param1]>]>
					- narrate <[param1]>
					- narrate <[ny]>
					- define ymax <[cuboid].max.with_y[<[ny]>]>
					- define ymin <[cuboid].min>
					- inject locally wesel_pos
				
				- case down:
					- define ymax <[cuboid].max>
					- define ny <[cuboid].min.y.sub_int[<[param1]>]>
					- define ymin <[cuboid].min.with_y[<[ny]>]>
					- inject locally wesel_pos
					
					
			- inject locally wesel_show

		- case fx:

			- choose <[sub]>:
				- case nv:
					- if !<player.list_effects.contains_text[NIGHT_VISION]>:
						- cast NIGHT_VISION d:3600s amplifier:4 <player> no_icon hide_particles
					- else:
						- cast cancel NIGHT_VISION <player>
				- case cp:
					- if !<player.list_effects.contains_text[CONDUIT_POWER]>:
						- cast CONDUIT_POWER d:3600s amplifier:4 <player> no_icon hide_particles
					- else:
						- cast cancel CONDUIT_POWER <player>

		- case no:

			- choose <[sub]>:

				- case grass:
					- modifyblock <player.location.find_blocks[*grass].within[<[param1]>]> air
				
				- case flora:
					- foreach <list[*grass].include[<script[umc_config].data_key[flowers]>]> as:item:
						- modifyblock <player.location.find_blocks[<[item]>].within[<[param1]>]> air

				- case trees:
					- modifyblock <player.location.find_blocks[*LEAVES].within[<[param1]>]> air
					- modifyblock <player.location.find_blocks[*LOG].within[<[param1]>]> air

		- case kill:

			- if <[sub]> == "_all":
				- foreach <player.location.chunk.living_entities> as:entry:
					- if <[entry].is_player>:
						- next
					- else:
						- kill <[entry]>
					
			- if <[sub]> == "_monsters":
				- kill <player.location.find_entities[monster].within[<[param1]>]>
				- kill <player.location.find_entities[bat].within[<[param1]>]>
			
			- else if <[sub]> == "_villagers":
				- kill <player.location.find_entities[villager].within[<[param1]>]>			
			- else:
				- kill <player.location.find_entities[<[sub]>].within[<[param1]>]>

		- case spawner:
			- define uspawner <item[spawner]>
            - adjust def:uspawner spawner_type:<[sub]>
            - adjust def:uspawner spawner_player_range:<[param1]>
            - adjust def:uspawner spawner_count:<[param2]>
            - adjust def:uspawner spawner_max_nearby_entities:<context.location.spawner_max_nearby_entities>
            - adjust def:uspawner spawner_delay_data:-1|200|800
#            - adjust def:uspawner "display:<&d><context.location.spawner_type.as_entity.translated_name> Spawner"


#			- give <player> SPAWNER[spawner_count=<[param2]>;spawner_type=<[sub]>;spawner_player_range=<[param1]>;spawner_range=<[param1].div_int[2]>]

			- give <player> <[uspawner]>
			- narrate <[uspawner]>
			


    wesel_show:

		- define cuboid <player.we_selection>
		- define center <[cuboid].center>
		- playeffect effect:block_marker special_data:glass at:<[cuboid].with_min[<[cuboid].min.with_x[<[center].x>]>].with_max[<[cuboid].max.with_x[<[center].x>]>].outline.parse[center]> offset:0 targets:<player> visibility:64
		- playeffect effect:block_marker special_data:glass at:<[cuboid].with_min[<[cuboid].min.with_z[<[center].z>]>].with_max[<[cuboid].max.with_z[<[center].z>]>].outline.parse[center]> offset:0 targets:<player> visibility:64
		- playeffect effect:block_marker special_data:glass at:<[cuboid].with_min[<[cuboid].min.with_y[<[center].y>]>].with_max[<[cuboid].max.with_y[<[center].y>]>].outline.parse[center]> offset:0 targets:<player> visibility:64
		- playeffect effect:block_marker special_data:barrier at:<[cuboid].outline.parse[center]> offset:0 targets:<player> visibility:50
		- narrate format:umc "Worldedit selection: <&f><player.we_selection.min.xyz> <&7>to <&f><player.we_selection.max.xyz>"

	wesel_pos:
		- narrate "masuk!"
		- narrate <[ymin]>
		- narrate <[ymax]>
		- execute as_op "/pos1 <[ymax].x>,<[ymax].y>,<[ymax].z>"
		- execute as_op "/pos2 <[ymin].x>,<[ymin].y>,<[ymin].z>"
