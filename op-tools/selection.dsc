umc-opsel:
	type: command
	name: umc-op-selection
	alias: uos
    description: umc op tools, whats else?
    permission: umc.op
    permission message: You dont have permission to use this command
    usage: /umc-op cmd parameter parameter
    tab completions:
		1: grass|no
		2: <list[<script[umc_config].data_key[flowers]>]>.include[#random]>
		3: 5|10|20|50
		default: StopTyping
		
	script:

	- narrate <player.flag[seltool_selection]>
	
