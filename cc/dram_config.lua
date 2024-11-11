return {
	image = "dram.hex",

	-- enable the hex-dump at the bottom of the info screen
	enable_hex_dump = true,

	-- if writing to the memory is enabled(memory is RAM) or disabled(memory is ROM)
	enable_write = true,

	-- side of the computer to check for clock signals
	clock_side = "back",

	-- side of the computer to check for write-enable signals
	write_ena_side = "right",

	-- address size and word size
	addr_bits = 32,
	data_bits = 32,

	-- if positions are relative to computer position or in absolute world coordinates
	position_relative = true,

	-- positions of redstone towers
	addr_x = -2,
	addr_y = 2,
	addr_z = 0,
	out_x = 0,
	out_y = 2,
	out_z = 0,
	in_x = 2,
	in_y = 2,
	in_z = 0,
}
