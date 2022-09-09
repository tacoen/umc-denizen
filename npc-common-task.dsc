umc-npc-task:
	type: task
    debug: false
	script:

	midnight:

		- ~walk <npc> <npc.anchor[midnight]> speed:1 auto_range
		
		- wait 7s

		- if <npc.flag[lookfor.bed].length.if_null[0]> == 0:
			- define mat <script[umc_npc].data_key[anchor.midnight].parsed>
		- else:
			- define mat <npc.flag[lookfor.bed]>

		- foreach <npc.location.find_blocks[<[mat]>].within[15]> as:bedloc:

			- if <[bedloc].material.half> == HEAD:
				- if <[bedloc].has_flag[umoccupied]>:
					- foreach next
				- else:
					- ~walk <npc> <[bedloc]> speed:1 auto_range
					- ~sleep <[bedloc]>
					- flag <[bedloc]> umoccupied:<npc.name> expire:30s
					- foreach stop

	dawn:
		- narrate format:ntk "Now, I do dawn task."
		- ~walk <npc> <npc.anchor[dawn].simple> speed:1 auto_range radius:50

	day:
		- narrate format:ntk "Now, I do day task."
		- ~walk <npc> <npc.anchor[day]> speed:1 auto_range
		- repeat 5:
			- ~run locally small_wander
			- wait 3s

	sit:
		- sit <npc.location.add[0,0.20,0]>
		
	small_wander:
		- define rloc <npc.location.random_offset[3].with_y[npc.location.y]> 
		- if <[rloc].material.name> == air:
			- ~walk <npc> <[rloc]> speed:0.7 auto_range
		- else:
			- ~look <npc> <[rloc]> duration:3s
				
	dusk:
		- narrate format:ntk "Now, I do dusk task."
		- walk <npc> <npc.anchor[dusk]> speed:1 auto_range

	night:
		- narrate format:ntk "Now, I do night task."
		- walk <npc> <npc.anchor[night]> speed:1 auto_range
	
	wakeup:
		- stand
		- wait 2t
		- lookclose state:true
		- follow speed:0.5 lead:2
		- stop

	say:
		- define slot <[slot].if_null[day]>
		- if <npc.flag[text.<[slot]>].length.if_null[0]> == 0:
			- narrate format:<[format].if_null[ntk]> <script[umc_npc].data_key[text.<[slot]>].parsed>
		- else:
			- narrate format:<[format].if_null[ntk]> <npc.flag[text.<[slot]>].random.parsed>
