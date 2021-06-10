--Adjust These Variables:
local scale = 6 --Resolution of the puzzle, options: 5,6,7,8
local screeninput = true -- true == Click screen to start, false == Click button to start
local network = "FleecaNet" --Name of the Game Network
local computernum = "1" --For chaining games together

local randoms = {}
--Adjust the amount to squares to click
randoms["5x"] = 10
randoms["6x"] = 3 --14
randoms["7x"] = 18
randoms["8x"] = 24

local viewtimes = {}
--Adjust the amound of seconds the player can view the solution
viewtimes["5x"] = 3
viewtimes["6x"] = 4
viewtimes["7x"] = 5
viewtimes["8x"] = 5

local puzzletimes = {}
--Adjust the amound of seconds till the timer runs out
puzzletimes["5x"] = 7
puzzletimes["6x"] = 8
puzzletimes["7x"] = 9
puzzletimes["8x"] = 10

local scales = {}
--Adjust the size of the buttons themselves
--Adjust in pairs, must be 2 apart for x and y axis respectfully
--All require 3x3 displays except 8 which requires 3x4
scales["5x1"] = 9
scales["5x2"] = 11
scales["5y1"] = 5
scales["5y2"] = 7

scales["6x1"] = 7
scales["6x2"] = 9
scales["6y1"] = 4
scales["6y2"] = 6

scales["7x1"] = 6
scales["7x2"] = 8
scales["7y1"] = 3
scales["7y2"] = 5

scales["8x1"] = 5
scales["8x2"] = 7
scales["8y1"] = 3
scales["8y2"] = 5
--=======================--


os.loadAPI("button")
m = peripheral.wrap("top")
m.clear()

local timerid = 0
local issuccess = false
local totalnum = 1

local numbersize = scale*scale
local numbers = {}

function generatePuzzle() --Create Random Pool
	local possibilities = {} --Pool of tiles
	for possibility=1,scale*scale,1 do --Fill the pool of tiles
		possibilities[possibility] = possibility
	end
	
	for ranpos=1,randoms[scale.."x"],1 do --Add point per random scale
		selected = math.random(1,numbersize)
		if #numbers == 0 then
			numbers[1] = possibilities[selected]
		else
			local newarray = {}
			local domove = false
			for randomitem=1,#numbers+1,1 do
				if domove and randomitem == #numbers+1 then --Move End State
					newarray[randomitem] = numbers[randomitem-1]
					domove = false
				elseif domove then --Move State
					newarray[randomitem] = numbers[randomitem-1]
				elseif randomitem == #numbers+1 then --End State
					newarray[randomitem] = possibilities[selected]
				elseif not domove and possibilities[selected] < numbers[randomitem] then --Insert State
					newarray[randomitem] = possibilities[selected]
					domove = true
				else --Normal State
					newarray[randomitem] = numbers[randomitem]
				end
			end
			numbers = newarray
		end
		
		for possibility=selected,numbersize,1 do
			possibilities[possibility] = possibilities[possibility+1]
		end
		numbersize = numbersize - 1
	end
	
	firstPass()
end

function firstPass()
	for row=1,scale,1 do
      for col=1,scale,1 do
		 button.setTable("T" .. col+((row-1)*scale), (2*col)+(scales[scale.."x1"]*(col-1)),scales[scale.."x2"]+(scales[scale.."x2"]*(col-1)),(2*row)+(scales[scale.."y1"]*(row-1)),scales[scale.."y2"]+(scales[scale.."y2"]*(row-1)))
		 if numbers[totalnum] == col+((row-1)*scale) then
		    numbers[totalnum] = "T" .. col+((row-1)*scale)
			button.toggleCorrect("T" .. col+((row-1)*scale))
			totalnum = totalnum + 1
		 end
	  end
   end
   button.screen()
   button.addnumbers(numbers)
   button.winlose(fail, success)
   sleep(viewtimes[scale.."x"])
   button.clearTable()
   secondPass()
end

function secondPass()
   for row=1,scale,1 do
      for col=1,scale,1 do
	     button.setTable("T" .. col+((row-1)*scale), (2*col)+(scales[scale.."x1"]*(col-1)),scales[scale.."x2"]+(scales[scale.."x2"]*(col-1)),(2*row)+(scales[scale.."y1"]*(row-1)),scales[scale.."y2"]+(scales[scale.."y2"]*(row-1)))
      end
   end
   
   timerid = os.startTimer(puzzletimes[scale.."x"])
   button.screen()
end

function getEvent()
	local eventdata = {os.pullEvent()}
	local event = eventdata[1]
	if event == "monitor_touch" and not issuccess then
		x = eventdata[3]
		y = eventdata[4]
		button.checkxy(x,y)
	elseif event == "timer" and eventdata[2] == timerid and not issuccess then
		redstone.setOutput("left",true)
		m.clear()
		sleep(2)
		os.reboot()
	end
end

function fail()
	redstone.setOutput("left", true)
	m.clear()
	sleep(2)
	os.reboot()
end

function success()
	print("Success")
	issuccess = true
	redstone.setOutput("right", true)
	m.clear()
	rednet.broadcast("Lvl_"..computernum+1, network)
end

print("Program Started!")
local isOff = true
while isOff do
	if not screeninput and redstone.getInput("front") or screeninput and os.pullEvent("monitor_touch") then
		redstone.setOutput("right", false)
		redstone.setOutput("left", false)
		generatePuzzle()
		isOff = false
	end
	sleep(1)
end

while true do
   getEvent()
end
