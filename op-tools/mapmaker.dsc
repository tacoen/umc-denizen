mapmaker_command:

    type: command
    name: umc-mapmaker
    description: umc Map maker
    usage: /mapmaker start|stop x z step radius wait y
    permission: umcmap.can

    tab completions:
        1: start|stop
		2: <player.location.x.round_down>
		3: <player.location.z.round_down>
		4: 10|5|3
		5: 200|100
		6: 90|60|30|15
		7: <player.location.y.round_down>
	
    script:
	
    - define x <context.args.get[2].if_null[<player.location.x.round_down>]>
    - define z <context.args.get[3].if_null[<player.location.z.round_down>]>
    - define s <context.args.get[4].if_null[9]>
    - define r <context.args.get[5].if_null[200]>
    - define y <context.args.get[7].if_null[140]>
    - define w <context.args.get[6].if_null[90]>
	
    - choose <context.args.first>:

		- case start:

			- flag server mapmaker_run:true

			- run locally mapmaker-tp def.x:<[x]> def.y:<[y]> def.z:<[z]>
			- wait <[w]>s

			
			# First one, using first x
			
            - repeat <[s]> as:zstep:

				- if !<server.has_flag[mapmaker_run]>:
					- repeat stop
					- stop

				- define zn <[z].add_int[<[r].mul_int[<[zstep]>]>]>
				- run locally path:mapmaker-tp def.x:<[x]> def.z:<[zn]> def.y:<[y]>
				- wait <[w]>s

            - repeat <[s]> as:xstep:

				- if !<server.has_flag[mapmaker_run]>:
					- repeat stop
					- stop

				- define xn <[x].add_int[<[r].mul_int[<[xstep]>]>]>
				- run locally path:mapmaker-tp def.x:<[xn]> def.z:<[z]> def.y:<[y]>
				- wait <[w]>s
				
				- repeat <[s]> as:zstep:

					- if !<server.has_flag[mapmaker_run]>:
						- repeat stop
						- stop

					- define zn <[z].add_int[<[r].mul_int[<[zstep]>]>]>
					- run locally path:mapmaker-tp def.x:<[xn]> def.z:<[zn]> def.y:<[y]>
					- wait <[w]>s

				
            - flag server mapmaker_run:!
            - narrate "<&e>[!]<reset> umc-mapmaker - Routine Finish"

        - case stop:
            - flag server mapmaker_run:!
            - narrate "<&e>[!]<reset> umc-mapmaker Set to Stop"

	mapmaker-tp:
		- narrate "<&e>[*]<reset> umc-mapmaker: <[x]>, <[y]>, <[z]>"
		- teleport <player> location:<[x]>,<[y]>,<[z]>,world
	
