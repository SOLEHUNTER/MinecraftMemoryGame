rednet.open("back")
local BossId = 48

while true do
	local id, msg, ptcl = rednet.receive("FleecaNet")
	print("Recieved!")
	if id == BossId and msg == "Lvl_1" then
		multishell.launch({}, "minigame")
	elseif id == BossId and msg == "reset" then
		os.reboot()
	end
end
