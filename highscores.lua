-- ----------------------------------------------------------------------------------------
-- Created by Amy Law
-- ----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local backgroundEffects = require("backgroundeffects") -- A module that will generate Background Effects
local effectsGenerator -- Single instance of the Background Effects
local pushText = require("pushtext") -- Pushes text on the start screen, very dramatic

-- ----------------------------------------------------------------------------------------
-- Initialise Variables
-- ----------------------------------------------------------------------------------------

local json = require("json")
local scoresTable = {}
local filePath = system.pathForFile("scores.json", system.DocumentsDirectory)

-- ----------------------------------------------------------------------------------------
-- Functions
-- ----------------------------------------------------------------------------------------

-- Function to Load Scores
local function loadScores()

	local file = io.open(filePath, "r")

	if file then
		local contents = file:read("*a")
		io.close( file )
		scoresTable = json.decode(contents)
	end

	if (scoresTable == nil or #scoresTable == 0) then
		scoresTable = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	end
end

-- Function to Save Scores
local function saveScores()

	for i = #scoresTable, 11, -1 do
		table.remove(scoresTable, i)
	end

	local file = io.open(filePath, "w")

	if file then
		file:write(json.encode(scoresTable))
		io.close(file)
	end
end

-- Function to load up Menu 
function backHome()
    composer.gotoScene("menu")
end

-- ----------------------------------------------------------------------------------------
-- Scene Event Functions
-- ----------------------------------------------------------------------------------------

-- Function which runs when the scene is first created but not yet displayed on screen
function scene:create(event)
	local group = self.view

	effectsGenerator = backgroundEffects.new(10, group, 20)

    -- Load the previous scores
	loadScores()
	
	local leaderboardHeader = pushText.new("LEADERBOARD", display.contentCenterX, 100,"AstroSpace.ttf", 44, group)
		leaderboardHeader:setColor(1, 1, 1)
		leaderboardHeader:Pushtext()
	
	-- Insert the saved score from game into the table
	table.insert(scoresTable, composer.getVariable("finalScore"))
	composer.setVariable("finalScore", 0)

	-- Sort the table entries from highest to lowest
	local function compare(a, b)
		return a > b
	end
	table.sort(scoresTable, compare)

    -- Save the scores
	saveScores()

	for i = 1, 10 do
		if ( scoresTable[i] ) then
			local posY = 150 + (i * 56)

			local rankNum = display.newText(group, i .. ")", display.contentCenterX-50, posY, "AstroSpace.ttf", 36)
			rankNum:setFillColor(1, 1, 1)
			rankNum.anchorX = 1

			local thisScore = display.newText(group, scoresTable[i], display.contentCenterX-30, posY, "AstroSpace.ttf", 36)
			thisScore.anchorX = 0
		end
	end
	
	backButton = display.newImage("images/backbutton.png",display.contentCenterX,display.contentCenterY+400)
	group:insert(backButton)

end

-- ----------------------------------------------------------------------------------------
-- Created by Amy Law
-- ----------------------------------------------------------------------------------------

-- Function which runs when the scene is fully on screen
function scene:show( event )
	local phase = event.phase
    -- Code which runs when the scene is fully on screen
	    if (phase == "did") then
	    	backButton:addEventListener("tap",backHome)
            Runtime:addEventListener("enterFrame", effectsGenerator)
	    end
end

-- Function which runs when the scene is about to and when fully off screen
function scene:hide(event)
	local phase = event.phase
	    if (phase == "will") then
        	backButton:removeEventListener("tap",backHome)
	    	Runtime:removeEventListener("enterFrame", effectsGenerator)
	    end
end

-- Scene event function listeners
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene

-- ----------------------------------------------------------------------------------------
-- Created by Amy Law
-- ----------------------------------------------------------------------------------------
