umc_npc:
    type: data

	# https://meta.denizenscript.com/Docs/Search/night#worldtag.time.period

	text:
		day: Hello! I hope is a pleasant day for us.
		night: Good Evening.
		dawn: Have a nice day.
		dusk: Oh, Hi!
		midnight: Really?
        bye: Bye!
		mumble: Oh, Well...
		intro:	Greeting my friend, I'am <npc.name.to_titlecase>. and you are?
		feed: Nice to meet you. I'am <player.name.to_titlecase>.

	anchor:
		dawn: lantern
		day: crafting_table
		dusk: crafting_table
		night: lantern
		midnight: *_bed

	flags:
		- mumble
		
	enchant:
		Aqua_Affinity: Speeds up how fast you can mine blocks underwater
		Bane_of_Arthropods: Increases attack damage against arthropods
		Blast_Protection: Reduces blast and explosion damage
		Channeling: Summons a lightning bolt at a targeted mob when enchanted item is thrown targeted mob must be standing in raining
		Curse_of_Binding: Cursed item can not be removed from player
		Curse_of_Vanishing: Cursed item will disappear after player dies
		Depth_Strider: Speeds up how fast you can move underwater
		Efficiency: Increases how fast you can mine
		Feather_Falling: Reduces fall and teleportation damage
		Fire_Aspect: Sets target on fire
		Fire_Protection: Reduces damage caused by fire and lava
		Flame: Turns arrows into flaming arrows
		Fortune: Increases block drops from mining
		Frost_Walker: Freezes water into ice so that you can walk on it and also allows you to walk on magma blocks without taking damage
		Impaling: Increases attack damage against sea creatures
		Infinity: Shoots an infinite amount of arrows
		Knockback: Increases knockback dealt and enemies repel backwards
		Looting: Increases amount of loot dropped when mob is killed
		Loyalty: Returns your weapon when it is thrown like a spear
		Luck_of_the_Sea: Increases chances of catching valuable items
		Lure: Increases the rate of fish biting your hook
		Mending: Uses xp to mend your tools, weapons and armor
		Multishot: Shoots 3 arrows at once but only costs 1 arrow from your inventory
		Piercing: Arrow can pierce through multiple entities
		Power: Increases damage dealt by bow
		Projectile_Protection: Reduces projectile damage from arrows, fireballs, fire charges
		Protection: General protection against attacks, fire, lava, and falling
		Punch: Increases knockback dealt and enemies repel backwards
		Quick_Charge: Reduces the amount of time to reload a crossbow
		Respiration: Extends underwater breathing see better underwater
		Riptide: Propels the player forward when enchanted item is thrown while in water or rain
		Sharpness: Increases attack damage dealt to mobs
		Silk_Touch: Mines blocks themselves, It's fragile items
		Smite: Increases attack damage against undead mobs
		Soul_Speed: Speeds up how fast you can move across soul sand and soul soil
		Sweeping_Edge: Increases damage of sweep attack
		Swift_Sneak: Increases movement speed while sneaking
		Thorns: Causes damage to attackers
		Unbreaking: Increases durability of item, in effect, by decreasing the chance of the tool, weapon, or armor taking durability damage when used
		