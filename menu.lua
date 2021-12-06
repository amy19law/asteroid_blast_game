-- ----------------------------------------------------------------------------------------
-- Created by Amy Law
-- ----------------------------------------------------------------------------------------

local composer = require( "composer" ) --This is a composer file so need to require composer module
local scene = composer.newScene()
local infoButton
local startButton -- Self explanatory
local pushText = require("pushtext") -- Pushes text on the start screen, very dramatic
local backgroundEffects = require("backgroundeffects") -- A module that will generate Background Effects
local effectsGenerator -- Single instance of the Background Effects

-- ----------------------------------------------------------------------------------------
-- Functions
-- ----------------------------------------------------------------------------------------

function startGame()
    composer.gotoScene("game", {time=800, effect="crossFade"})
end

function startInfo()
    composer.gotoScene("info", {time=800, effect="crossFade"})
end

function startOptions()
    composer.gotoScene("options", {time=800, effect="crossFade"})
end

function startHighscores()
    composer.gotoScene("highscores", {time=800, effect="crossFade"})
end

function quitGame()
    os.exit()
end    

-- ----------------------------------------------------------------------------------------
-- Scene Event Functions
-- ----------------------------------------------------------------------------------------

function scene:create(event)
	local group = self.view

	effectsGenerator =  backgroundEffects.new(10,group,20)
	
	logo = display.newImage("images/logo.png",display.contentCenterX,display.contentCenterY-350)
    group:insert(logo)

	startButton = display.newImage("images/play.png",display.contentCenterX,display.contentCenterY-20)
    group:insert(startButton)
	
	infoButton = display.newImage("images/instructionsButton.png",display.contentCenterX,display.contentCenterY+150)
    group:insert(infoButton)
	
	optionsButton = display.newImage("images/options.png",display.contentCenterX,display.contentCenterY+320)
    group:insert(optionsButton)

	highscoresButton = display.newImage("images/highscores.png",display.contentCenterX,display.contentCenterY+490)
    group:insert(highscoresButton)

    exitButton = display.newText(group, "EXIT GAME", display.contentCenterX-315,display.contentCenterY+665, "AstroSpace.ttf", 20)
    group:insert(exitButton)
	
	local invadersText =  pushText.new("AMY LAW - MOBILE DEVELOPMENT PROJECT 2021",display.contentCenterX,display.contentCenterY+615,"AstroSpace.ttf", 12.5,group)
       invadersText:Pushtext()
end

-- ----------------------------------------------------------------------------------------
-- Created by Amy Law
-- ----------------------------------------------------------------------------------------

function scene:show(event)
	local phase = event.phase
    	if (phase == "did") then
    	    startButton:addEventListener("tap",startGame)
    	    infoButton:addEventListener("tap",startInfo)
    	    optionsButton:addEventListener("tap",startOptions)
     	    highscoresButton:addEventListener("tap",startHighscores)
    	    Runtime:addEventListener("enterFrame", effectsGenerator)
            exitButton:addEventListener("tap", quitGame)

    	end
end

function scene:hide( event )
	local phase = event.phase
    	if (phase == "will") then
        	startButton:removeEventListener("tap",startGame)
	    	infoButton:removeEventListener("tap",startInfo)
	    	optionsButton:removeEventListener("tap",startOptions)
	    	highscoresButton:removeEventListener("tap",startHighscores)
	    	Runtime:removeEventListener("enterFrame", effectsGenerator)
            exitButton:addEventListener("tap", quitGame)
    	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
return scene

-- ----------------------------------------------------------------------------------------
-- Created by Amy Law
-- ----------------------------------------------------------------------------------------
