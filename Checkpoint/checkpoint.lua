--Fuel Instructions                                                         --
-- First Place Coal or Coal Block into the first Slot                       --
-- (1 Coal == 80 Fuel Levels, 1 Coal Block == 800 Fuel Levels)              --
-- Second Open the lua console, by typing the lua command                   -- 
-- Run the Refuel Command, turtle.refuel()                                  --
-- Third Check Fuel Level, turtle.getFuelLevel()                            --
-- (1 Movement == 1 FuelLevel)                                              --
-- Current Program Moves 12 Blocks per Complete Run                         --
-- Fourth Close the console, exit()                                         --

--Settings
price = 10 --In Diamonds
doorTime = 10 --Seconds to leave door open
controlComputer = {46} --Computer ID's with Admin Access

--Startup
m = peripheral.wrap("back")
m.setTextColor(colors.red)
m.setTextScale(1)

local alarmpid = 0
function signalProcessor()
	local id, msg, ptcl = rednet.receive("FleecaNet")
	print(id)
	for i=1,#controlComputer,1 do
		if id == controlComputer[i] then
			if msg == "reset" then
				rednet.broadcast("reset", "FleecaNet")
				os.reboot()
			elseif msg == "disable" then
				multishell.setFocus(alarmpid)
				os.queueEvent("terminate")
				redstone.setOutput("top", false)
			end
			signalProcessor()
		end
	end
	signalProcessor()
end

function getEvent()
	local eventdata = {os.pullEvent()}
	local event = eventdata[1]
	if event == "monitor_touch" then
		m.clear()
		m.setCursorPos(1,2)
		m.write("              Hacking...")
	
		for i=1,5,1 do
			turtle.down()
		end
		turtle.back()
		turtle.turnRight()
		
		turtle.suck()
		if not (turtle.getItemCount(1) == 0) and turtle.getItemDetail(1).name == "minecraft:diamond" and turtle.getItemDetail(1).count >= price then
			turtle.dropDown()
			turtle.turnLeft()
			
			turtle.forward()
			for i=1,5,1 do
				turtle.up()
			end
			
			m.clear()
			m.setCursorPos(1,2)
			m.setTextColor(colors.green)
			m.write("           System Overriden")
			m.setTextColor(colors.red)
			
			redstone.setOutput("left", true)
			alarmpid = multishell.launch({}, "alarm.lua")
			
			rednet.broadcast("Lvl_1", "FleecaNet")
			
			signalProcessor()
		else
			turtle.turnRight()
			turtle.turnRight()
			turtle.drop()
			turtle.turnRight()
			
			turtle.forward()
			for i=1,5,1 do
				turtle.up()
			end
			
			m.clear()
			m.setCursorPos(1,2)
			m.write("          Hack Unsuccessful")
			
			sleep(2)
			
			m.clear()
			m.setCursorPos(1,2)
			m.write("   Toss " .. price .. " Diamonds on to the carpet")
			m.setCursorPos(1,3)
			m.write("     and Click screen to begin Hack")
		end
	else
		--Timer maybe?
	end
end

m.clear()
m.setCursorPos(1,2)
m.write("   Toss " .. price .. " Diamonds on to the carpet")
m.setCursorPos(1,3)
m.write("     and Click screen to begin Hack")

while true do
   getEvent()
end
