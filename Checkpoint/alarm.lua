s = peripheral.wrap("front")

function alarm()
	redstone.setOutput("top", true)
	s.playNote("harp", 3, 2)
	sleep(0.2)
	s.playNote("harp", 3, 2)
	sleep(0.2)
	redstone.setOutput("top", false)
	s.playNote("harp", 3, 2)
	sleep(0.2)
	s.playNote("harp", 3, 2)
	sleep(0.2)
	alarm()
end

alarm()
