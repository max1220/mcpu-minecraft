-- load config from file
config = dofile(assert(arg[1]))

-- data backing for memory(memory is sparse)
local mem = {}

-- state for the memory redstone contraption
local cur_addr = 0
local cur_in_val = 0
local cur_out_val = 0

-- load an image in hex format to offset
function load_hex_image(path, offset)
	local file = assert(io.open(path, "rb"))
	local content = file:read("*a")
	file:close()
	local cindex = offset
	for match in (content.." "):gmatch("(%x+)%s*") do
		mem[cindex] = tonumber(match, 16)
		cindex = cindex + 1
	end
end

-- load an image if specified in config
if config.image then
	load_hex_image(config.image, 0)
end

-- redraw the debug display
function redraw()
	term.clear()
	term.setCursorPos(1,1)
	print("Memory configuration")
	print(" addr bits: ",config.addr_bits)
	print(" data bits: ",config.data_bits)
	print("State")
	print((" addr:  %."..(config.addr_bits/4).."x"):format(cur_addr))
	print((" out:   %."..(config.data_bits/4).."x"):format(cur_out_val))
	if config.enable_write then
		print((" in:    %."..(config.data_bits/4).."x"):format(cur_in_val))
		print((" write: %s"):format(redstone.getInput(config.write_ena_side) and "yes" or "no"))
	end
	if not config.enable_hex_dump then return; end
	-- hex dump the memory around cur_addr
	print("Memory")
	local stride = 16
	local sub_i = cur_addr % stride
	local start_i = cur_addr-sub_i
	local nl_every = 4
	for i=0,stride-1 do
		if i == sub_i then io.write(("<%.2x>"):format(mem[start_i+i] or 0))
		else io.write((" %.2x "):format(mem[start_i+i] or 0))
		end
		if (i%nl_every == nl_every - 1) and (i ~= stride-1) then io.write("\n") end
	end
end

-- write a redstone tower by creating/removing redstone blocks
function write_redstone_tower(dx,dy,dz, value, bit_count, rel)
	local cx,cy,cz = dx,dy,dz
	if rel then
		cx,cy,cz = commands.getBlockPosition()
		cx,cy,cz = cx+dx,cy+dy,cz+dz
	end
	for i=1, bit_count do
		local bit = bit.band(value, 2^(i-1)) ~= 0
		local block = bit and "redstone_block" or "air"
		commands.async.setblock(cx, cy+(i-1)*2, cz, block)
		--print("s", cx, cy+(i-1)*2, cz, block)
	end
	--error()
end

-- read redstone dust in a redstone tower as a binary number
function read_redstone_tower(dx,dy,dz, bit_count, rel)
	local cx,cy,cz = dx,dy,dz
	if rel then
		cx,cy,cz = commands.getBlockPosition()
		cx,cy,cz = cx+dx,cy+dy,cz+dz
	end
	local infos = commands.getBlockInfos(cx,cy,cz, cx,cy+(bit_count*2-1),cz)
	local addr = 0
	for i=1, #infos, 2 do
		local info = infos[i]
		if info and info.state and info.state.power and info.state.power > 0 then
			addr = addr + 2^((i-1)/2)
		end
	end
	return addr
end

-- handle a redstone clock signal(handle inputs, update outputs)
function handle_redstone(enable_write)
	-- read address tower
	cur_addr = read_redstone_tower(config.addr_x,config.addr_y,config.addr_z, config.addr_bits, true)
	-- read the current input value
	if enable_write then
		cur_in_val = read_redstone_tower(config.in_x,config.in_y, config.in_z, config.data_bits, true)
		-- if write signal is enabled, write the input value to memory
		if redstone.getInput(config.write_ena_side) then
			mem[cur_addr] = cur_in_val
		end
	end
	-- update the output
	cur_out_val = mem[cur_addr] or 0
	os.sleep(0.05)
	write_redstone_tower(config.out_x,config.out_y,config.out_z, cur_out_val, config.data_bits, true)
	redraw()
end

-- read initial location(but don't write)
handle_redstone(false)

-- monitor the redstone clock input and loop forever
while true do
	local ev = { os.pullEvent() }
	local evt = ev[1]
	-- update redstone state on clock signal
	if (evt == "redstone") and redstone.getInput(config.clock_side) then
		handle_redstone(config.enable_write)
	end
end
