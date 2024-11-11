local label = os.getComputerLabel()
if label == "irom" then
    shell.run("start_irom.lua")
elseif label == "dram" then
    shell.run("start_dram.lua")
end
