-- ----------------------------------------------------------------------------------------
-- Created by Amy Law
-- ----------------------------------------------------------------------------------------

local composer = require( "composer" ) --This is a composer file so need to require composer module
local scene = composer.newScene()
local backgroundEffects = require("backgroundeffects") -- A module that will generate Background Effects
local effectsGenerator -- Single instance of the Background Effects
local pushText = require("pushtext") -- Pushes text on the start screen, very dramatic
soundOn = false

-- ----------------------------------------------------------------------------------------
-- Functions
-- ----------------------------------------------------------------------------------------

-- Function to load up Menu
function backHome()
    composer.gotoScene("menu")
end

-- Function to Play Music
function playMusic()
	backgroundMusic = audio.loadSound("sounds/backgroundmusic.wav")
	backgroundChannel = audio.play( backgroundMusic, {loops=-1} )
	soundOn = true
end

-- Function to Stop Music
function stopMusic()
	backgroundMusic = audio.loadSound("sounds/backgroundmusic.wav")
	backgroundChannel = audio.pause( backgroundMusic, {loops=-1} )
	soundOn = false
end

--Function to select Background Colour (Tinting the current background)
function redTintBackground()
    background:setFillColor( 0.7, 0.4, 0.4)
end

function blueTintBackground()
    background:setFillColor( 0.4, 0.6, 0.7)
end

function yellowTintBackground()
    background:setFillColor( 1, 1, 0)
end

function greenTintBackground()
    background:setFillColor( 0.4, 0.7, 0.4)
end

function purpleTintBackground()
    background:setFillColor( 1, 1, 1)
end

-- ----------------------------------------------------------------------------------------
-- Scene Event Functions
-- ----------------------------------------------------------------------------------------

function scene:create(event)
	local group = self.view
	
	effectsGenerator =  backgroundEffects.new(10,group,20)
	
	local invadersText =  pushText.new("OPTIONS",display.contentCenterX,display.contentCenterY-300,"AstroSpace.ttf", 70,group)
		invadersText:setColor( 1, 1, 1 )
		invadersText:Pushtext()	
	
	local musicText = pushText.new ("MUSIC",display.contentCenterX,display.contentCenterY-160,"AstroSpace.ttf",50,group)
    
    local musicOnText = pushText.new ("ON",display.contentCenterX-60,display.contentCenterY,"AstroSpace.ttf", 30,group)
    musicButton = display.newImage("Images/musicon.png",display.contentCenterX-60,display.contentCenterY-70)
	group:insert(musicButton)

    local musicOffText = pushText.new ("OFF",display.contentCenterX+60,display.contentCenterY,"AstroSpace.ttf", 30,group)
	stopMusicButton = display.newImage("Images/musicoff.png",display.contentCenterX+60,display.contentCenterY-70)
	group:insert(stopMusicButton)

    -- Background Colour Options (Tinting the current background)
	local colourText =  pushText.new ("SELECT BACKGROUND",display.contentCenterX,display.contentCenterY+100,"AstroSpace.ttf", 50,group)
	
	redTintButton = display.newImage("images/redbutton.png",display.contentCenterX-200,display.contentCenterY+175)
	group:insert(redTintButton)

	blueTintButton = display.newImage("images/bluebutton.png",display.contentCenterX-100,display.contentCenterY+175)
	group:insert(blueTintButton)
	
	yellowTintButton = display.newImage("images/yellowbutton.png",display.contentCenterX,display.contentCenterY+175)
	group:insert(yellowTintButton)

	greenTintButton = display.newImage("images/greenbutton.png",display.contentCenterX+100,display.contentCenterY+175)
	group:insert(greenTintButton)
	
	purpleTintButton = display.newImage("images/purplebutton.png",display.contentCenterX+200,display.contentCenterY+175)
	group:insert(purpleTintButton)

	backButton = display.newImage("images/backbutton.png",display.contentCenterX,display.contentCenterY+400)
	group:insert(backButton)
end

-- ----------------------------------------------------------------------------------------
-- Created by Amy Law
-- ----------------------------------------------------------------------------------------

function scene:show(event)
	local phase = event.phase
        if ( phase == "did" ) then
            redTintButton:addEventListener("tap",redTintBackground)
            blueTintButton:addEventListener("tap",blueTintBackground)
            yellowTintButton:addEventListener("tap",yellowTintBackground)
            greenTintButton:addEventListener("tap",greenTintBackground)
            purpleTintButton:addEventListener("tap",purpleTintBackground)
            musicButton:addEventListener("tap",playMusic)
            stopMusicButton:addEventListener("tap",stopMusic)
            backButton:addEventListener("tap",backHome)
            Runtime:addEventListener("enterFrame", effectsGenerator)
        end
end

function scene:hide( event )
	local phase = event.phase
		if ( phase == "will" ) then
			redTintButton:removeEventListener("tap",redTintBackground)
			blueTintButton:removeEventListener("tap",blueTintBackground)
			yellowTintButton:removeEventListener("tap",yellowTintBackground)
			greenTintButton:removeEventListener("tap",greenTintBackground)
			purpleTintButton:removeEventListener("tap",purpleTintBackground)
			musicButton:removeEventListener("tap",playMusic)
			stopMusicButton:removeEventListener("tap",stopMusic)
    		backButton:removeEventListener("tap",backHome)
			Runtime:removeEventListener("enterFrame", effectsGenerator)
		end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
return scene

-- ----------------------------------------------------------------------------------------
-- Created by Amy Law
-- ----------------------------------------------------------------------------------------
