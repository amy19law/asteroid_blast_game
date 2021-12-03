local composer = require( "composer" ) --This is a composer file so need to require composer module
local scene = composer.newScene()
local backgroundEffects = require("backgroundeffects") -- A module that will generate Background Effects
local effectsGenerator -- Single instance of the Background Effects
local pushText = require("pushtext") -- Pushes text on the start screen, very dramatic

local physics = require( "physics" )
physics.start()

-- ----------------------------------------------------------------------------------------
-- Functions
-- ----------------------------------------------------------------------------------------

-- Function for Laser
local function showLaser()
    local laser = display.newImageRect("images/laser.png", 14, 40)
	physics.addBody(laser, "dynamic", {isSensor=true})
    laser.x = display.contentCenterX
	laser.y = display.contentCenterY+190
	audio.play(laserSound)

	transition.to(laser, {y=-25, time=750, onComplete = function() display.remove(laser) 
	end
	} )
end

-- Function to load up Menu
function backHome()
    composer.gotoScene("menu")
end

-- ----------------------------------------------------------------------------------------
-- Scene Event Functions
-- ----------------------------------------------------------------------------------------

function scene:create(event)
	local group = self.view

	effectsGenerator =  backgroundEffects.new(10,group,20)

	local invadersText =  pushText.new("INSTRUCTIONS",display.contentCenterX,display.contentCenterY-550,"AstroSpace.ttf", 40,group)
    invadersText:setColor( 1, 1, 1 )
    invadersText:Pushtext()

	instructions = display.newImage("images/instructions.png",display.contentCenterX,display.contentCenterY)
    group:insert(instructions)
    
    -- Displaying objects with transitions 
    planetA = display.newImage(group, "images/planet1.png", display.contentCenterX-290, display.contentCenterY-330)
	group:insert(planetA)
	transition.to(planetA, {time = 10000, rotation = 100, iterations = 0, transition = easing.continuousLoop})

	planetB = display.newImage(group, "images/planet2.png", display.contentCenterX+270, display.contentCenterY-290)
	group:insert(planetB)
	transition.to(planetB, {time = 10000, rotation = -100, iterations = 0, transition = easing.continuousLoop})

    asteroid1 = display.newImage(group, "images/asteroid.png", display.contentCenterX-290, display.contentCenterY-150)
	group:insert(asteroid1)
	transition.to(asteroid1, {time = 10000, rotation = 360, iterations = 0, transition = easing.continuousLoop})

	asteroid2 = display.newImage(group, "images/asteroid.png", display.contentCenterX-250, display.contentCenterY)
	group:insert(asteroid2)
	transition.to(asteroid2, {time = 10000, rotation = -360, iterations = 0, transition = easing.continuousLoop})

	asteroid3 = display.newImage(group, "images/asteroid.png", display.contentCenterX+270, display.contentCenterY-90)
	group:insert(asteroid3)
	transition.to(asteroid3, {time = 10000, rotation = -360, iterations = 0, transition = easing.continuousLoop})

    player = display.newImage(group, "images/player.png", display.contentCenterX+100, display.contentCenterY+250, 120, 140)
    group:insert(player)
        transition.moveTo(player, { x=display.contentCenterX-100, y=display.contentCenterY+250, time=3000, onComplete= function() 
        	transition.moveTo(player, { x=display.contentCenterX, y=display.contentCenterY+250, time=3000})
    end } )
    
    laserButton = display.newImage(group, "images/laserbutton.png",display.contentCenterX+254,display.contentCenterY+350)
    group:insert(laserButton)

    laserSound = audio.loadSound("sounds/lasers.wav")

	backButton = display.newImage("Images/backbutton.png",display.contentCenterX,display.contentCenterY+550)
	group:insert(backButton)
end


function scene:show(event)
	local phase = event.phase
        if (phase == "did") then
            backButton:addEventListener("tap",backHome)
            Runtime:addEventListener("enterFrame", effectsGenerator)
            laserButton:addEventListener("tap", showLaser)
            player:addEventListener("tap", showLaser)
        end
end

function scene:hide(event)
	local phase = event.phase
	    if (phase == "will") then
        	backButton:removeEventListener("tap",backHome)
	    	Runtime:removeEventListener("enterFrame", effectsGenerator)
	    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)

return scene