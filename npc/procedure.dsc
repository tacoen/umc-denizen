umc-npc-textproc:
	type: procedure
	definitions: topic|what
	script:

   # <npc.location.distance[<npc.anchor[<[nloc]>]>].round_down_to_precision[0]>

	
	- choose <[topic]>:

		- case location-pin:
			- define what <[what].if_null[_random]>
			- if <[what]> == "_random":
				- define lokasi <server.flag[umc.location.pin].keys.random[1].get[1]>
			- else:
				- define lokasi <[what]>
	
			- define distant <npc.location.distance[<server.flag[umc.location.pin.<[lokasi]>]>].round_down_to_precision[2]>
			- define arah <server.flag[umc.location.pin.<[lokasi]>].as_location.direction[<npc.location>]>
			- determine  "<[lokasi]> is <[distant]> block <[arah]> from here"
			
		- case enchant:
			- define what <[what].if_null[_random]>
			- if <[what]> == "_random":
				- define what <script[umc_npc].data_key[enchant].keys.random[1].get[1]>
		
			- determine "<[what].replace[_].with[ ]> will <script[umc_npc].data_key[enchant.<[what]>]>"