-- ----------------------------------------------------------------------------------------
-- Created by Amy Law
-- ----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local physics = require( "physics" )
physics.start()
physics.setGravity(0, 0)

-- ----------------------------------------------------------------------------------------
-- Initialise Variables
-- ----------------------------------------------------------------------------------------

local lives = 3
local score = 0
local playerDeath = false
local asteroidsTable = {}
local planetTables = {}
local planet
local player
local gameTimer
local livesText
local scoreText
local objectGroup
local uiGroup
local backgroundMusic

-- ----------------------------------------------------------------------------------------
-- Functions
-- ----------------------------------------------------------------------------------------

-- Function to Create Asteroids
local function spawnAsteroid()
	local createAsteroid = display.newImage(objectGroup, "images/asteroid.png", 110, 90)
	table.insert(asteroidsTable, createAsteroid)
	physics.addBody(createAsteroid, "dynamic", {radius=45, bounce=1})
	createAsteroid.myName = "asteroid"

	local location = math.random(2)

	if (location == 1) then
		-- Create from the left
		createAsteroid.x = -50
		createAsteroid.y = math.random(450)
		createAsteroid:setLinearVelocity(math.random(35, 125), math.random(10,50))
	elseif (location == 2) then
		-- Create from the right
		createAsteroid.x = display.contentWidth + 50
		createAsteroid.y = math.random(450)
		createAsteroid:setLinearVelocity(math.random(-125,-35), math.random(10,50))
	end
	createAsteroid:applyTorque(math.random(-1,2))
end

-- Functions to Create Planets
local function spawnPlanetA()
	local newPlanetA = display.newImageRect(objectGroup, "images/planet1.png", 100, 100)
	newPlanetA.myName = "planet A"
	physics.addBody(newPlanetA, "dynamic", {radius=40, bounce=0.8})
	newPlanetA.x = math.random(display.contentWidth)
	newPlanetA.y = -60
    newPlanetA:setLinearVelocity(math.random(-35,35), math.random(35,35))
end

local function spawnPlanetB()
	local newPlanetB = display.newImageRect(objectGroup, "images/planet2.png", 100, 100)
	newPlanetB.myName = "planet B"
	physics.addBody(newPlanetB, "dynamic", {radius=40, bounce=0.8})
	newPlanetB.x = math.random(display.contentWidth)
	newPlanetB.y = -60
    newPlanetB:setLinearVelocity(math.random(-35,35), math.random(35,35))
end

-- Function to Create and Allow Player to Fire Laser
local function shootLaser()
	local newLaser = display.newImageRect(objectGroup, "images/laser.png", 15, 42)
	physics.addBody(newLaser, "dynamic", {isSensor=true})
	newLaser.isBullet = true
	newLaser.myName = "laser"
	audio.play(laserSound) -- Play Laser Sound
    
    -- Position of where the laser will shoot from (the players position)
	newLaser.x = player.x
	newLaser.y = player.y
	newLaser:toBack()
    
    -- Laser movement/transtion 
	transition.to(newLaser, {y=-25, time=750, onComplete = function() display.remove(newLaser) 
	end
	} )
end

-- ----------------------------------------------------------------------------------------
-- Created by Amy Law
-- ----------------------------------------------------------------------------------------

-- Function to run spawnAsteroid & spawnPlanet functions & remove off screen asteriods in order to form game loop 
local function gameLoop()
	-- Create new asteroid
	spawnAsteroid()

	-- Remove Asteroids which have gone off screen
	for i = #asteroidsTable, 1, -1 do
		local asteroid = asteroidsTable[i]

		if (asteroid.x < -100 or
			asteroid.x > display.contentWidth + 100 or
			asteroid.y < -100 or
			asteroid.y > display.contentHeight + 100)
		then
			display.remove(asteroid)
			table.remove(asteroidsTable, i)
		end
	end

	-- Create Planet when score reaches set amount and ensure that small amount of planets is create at a time
	if (score >= 1000) then
		i = math.random(1, 25)    
		    if (i == 15) then
		       spawnPlanetA()
		    elseif (i == 20) then
		       spawnPlanetB()
	        end
        end
	end

-- Function to move player, by dragging the player left and right
local function movePlayer(event)

	local player = event.target
	local phase = event.phase

	if ("began" == phase) then
		-- Set touch focus on the player
		display.currentStage:setFocus(player)
		-- Store initial offset position
		player.touchOffsetX = event.x - player.x
	elseif ("moved" == phase) then
		-- Move the player to the new touch position
		player.x = event.x - player.touchOffsetX
	elseif ("ended" == phase or "cancelled" == phase) then
		-- Release touch focus on the player
		display.currentStage:setFocus(nil)
	end
	return true  -- Prevents touch propagation to underlying objects
end

-- Function to Update Score
local function updateScore()
	scoreText.text = "Score: " .. score
end

-- Function to Draw Lives 
function drawLives()
	life1 = display.newImage("images/heart.png", display.contentCenterX-225, display.contentCenterY+610)
	life1.name = "life1"
    scene.view:insert(life1)
	
	life2 = display.newImage("images/heart.png", display.contentCenterX-175, display.contentCenterY+610)
	life2.name = "life2"
    scene.view:insert(life2)
	
	life3 = display.newImage("images/heart.png", display.contentCenterX-125, display.contentCenterY+610)
	life3.name = "life3"
    scene.view:insert(life3)
end

-- ----------------------------------------------------------------------------------------
-- Created by Amy Law
-- ----------------------------------------------------------------------------------------

-- Function to Update Lives
function updateLives()
	if (lives == 2) then
		life3:removeSelf()
    end
    if (lives == 1) then
		life2:removeSelf()
    end
    if (lives == 0) then
		life1:removeSelf()
    end
end

-- Function to reload player after death 
local function respawnPlayer()

    audio.play(playerRespawnSound)
	player.isBodyActive = false
	player.x = display.contentCenterX
	player.y = display.contentHeight

	-- Fade in the player back into game
	transition.to(player, {alpha=1, time=3500, onComplete = function()
			player.isBodyActive = true
			playerDeath = false
		end
	} )
end

-- Function to redirect to Highscores when game ends
local function endGame()
	composer.setVariable("finalScore", score)
	composer.gotoScene("highscores", {time=1000, effect="crossFade"})
end

-- Function to detect collison between laser & asteroid and player & asteroid
local function collision(event)
	if (event.phase == "began") then
		local object1 = event.object1
		local object2 = event.object2

		if ((object1.myName == "laser" and object2.myName == "asteroid") or
			 (object1.myName == "asteroid" and object2.myName == "laser"))
		then
			-- Remove both the laser and asteroid
			display.remove(object1)
			display.remove(object2)

			audio.play(collisionSound)

			for i = #asteroidsTable, 1, -1 do
				if (asteroidsTable[i] == object1 or asteroidsTable[i] == object2) then
					table.remove(asteroidsTable, i)
					break
				end
			end

			-- Increase score when laser hits an asteroid 
			score = score + 100
			updateScore()

		elseif ((object1.myName == "player" and object2.myName == "asteroid") or
				 (object1.myName == "asteroid" and object2.myName == "player"))
		then
			if (playerDeath == false) then
				playerDeath = true

				audio.play(playerHitSound)

				-- Update amount of lives when asteroid hits player
				lives = lives - 1
				updateLives()

				if (lives == 0) then
					display.remove(player)
					timer.performWithDelay(2000, endGame)
				else
					player.alpha = 0
					timer.performWithDelay(1000, respawnPlayer)
				end
			end

		elseif ((object1.myName == "laser" and object2.myName == "planet A") or
			 (object1.myName == "planet A" and object2.myName == "laser"))
		then
			-- Remove both the laser and planet
			display.remove(object1)
			display.remove(object2)

			audio.play(planetExplosionSound)

			for i = #planetTables, 1, -1 do
				if (planetTables[i] == object1 or planetTables[i] == object2) then
					table.remove(planetTables, i)
					break
				end
			end

			-- Increase score when laser hits an asteroid 
			score = score - 500
			updateScore()

		elseif ((object1.myName == "player" and object2.myName == "planet A") or
				 (object1.myName == "planet A" and object2.myName == "player"))
		then
			if (playerDeath == false) then
				playerDeath = true

				audio.play(playerHitSound)

				-- Update amount of lives when planet hits player
				lives = lives - 1
				playerKilled()

				if (lives == 0) then
					display.remove(player)
					timer.performWithDelay(2000, endGame)
				else
					player.alpha = 0
					timer.performWithDelay(1000, respawnPlayer)
				end
			end

			elseif ((object1.myName == "laser" and object2.myName == "planet B") or
			 (object1.myName == "planet B" and object2.myName == "laser"))
		then
			-- Remove both the laser and planet
			display.remove(object1)
			display.remove(object2)

			audio.play(planetExplosionSound)

			for i = #planetTables, 1, -1 do
				if (planetTables[i] == object1 or planetTables[i] == object2) then
					table.remove(planetTables, i)
					break
				end
			end

			-- Decrease score when laser hits an planet 
			score = score - 500
			updateScore()

		elseif ((object1.myName == "player" and object2.myName == "planet B") or
				 (object1.myName == "planet B" and object2.myName == "player"))
		then
			if (playerDeath == false) then
				playerDeath = true

				audio.play(playerHitSound) -- Play collision sound

				-- Update amount of lives when planet hits player
				lives = lives - 1
				updateLives()

				if (lives == 0) then
					display.remove(player)
					timer.performWithDelay(2000, endGame)
				else
					player.alpha = 0
					timer.performWithDelay(1000, respawnPlayer)
				end
			end

		end
	end
end

-- ----------------------------------------------------------------------------------------
-- Created by Amy Law
-- ----------------------------------------------------------------------------------------

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

    -- Temporarily pause the physics engine
	physics.pause()

    -- The Display Group fo objects, e.g. the player, asteroid & laser and insert into the scene's view group
	objectGroup = display.newGroup()
	group:insert(objectGroup)
	
	-- Display Player Ship
	player = display.newImageRect(objectGroup, "images/player.png", 120, 140)
	player.x = display.contentCenterX
	player.y = display.contentHeight
	physics.addBody(player, {radius=40, isSensor=true})
	player.myName = "player"

	-- The Display Group for the UI objects and insert into the scene's view group
	uiGroup = display.newGroup()
	group:insert(uiGroup)

	-- Display lives and score
	scoreText = display.newText(uiGroup, "Score: " .. score, display.contentCenterX, display.contentCenterY-600, "AstroSpace.ttf", 36)
	livesText = display.newText(uiGroup, "Lives: ", display.contentCenterX-300, display.contentCenterY+610, "AstroSpace.ttf", 36)
    drawLives()

    -- Display Buttons
    backButton = display.newText(group, "QUIT GAME", display.contentCenterX-262,display.contentCenterY+650, "AstroSpace.ttf", 36)
	group:insert(backButton)

	laserButton = display.newImage("images/laserbutton.png",display.contentCenterX+300,display.contentCenterY+620)
    group:insert(laserButton)

    -- Load Music
    collisionSound = audio.loadSound("sounds/collision.wav")
	laserSound = audio.loadSound("sounds/lasers.wav")
	backgroundMusic = audio.loadStream("sounds/backgroundmusic.wav")
	playerRespawnSound = audio.loadStream("sounds/playerdeath.wav")
	planetExplosionSound = audio.loadStream("sounds/planetexplosion.wav")
	playerHitSound = audio.loadStream('sounds/playerhit.wav')

	player:addEventListener("tap", shootLaser)
	player:addEventListener("touch", movePlayer)
	laserButton:addEventListener("tap", shootLaser)
end

-- ----------------------------------------------------------------------------------------
-- Created by Amy Law
-- ----------------------------------------------------------------------------------------

-- Function which runs when the scene is fully on screen
function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase

    -- Code which runs when the scene is fully on screen
    if (phase == "did") then
		physics.start()
		backButton:addEventListener("tap",backHome)
		Runtime:addEventListener("collision", collision)
		gameTimer = timer.performWithDelay(500, gameLoop, 0)
		--audio.play(backgroundMusic, {channel=1, loops=-1})
	end
end


-- Function which runs when the scene is about to and when fully off screen
function scene:hide(event)
	local group = self.view
	local phase = event.phase

    -- Code which runs when the scene is on screen, but begin to go off screen
	if (phase == "will") then
		timer.cancel(gameTimer)
		
	-- Code which runs immediately after the scene goes fully off screen
	elseif (phase == "did") then
		Runtime:removeEventListener("collision", collision)
		backButton:removeEventListener("tap", backHome)
		physics.pause()
		audio.stop(1)
		composer.removeScene("game")
	end
end

-- Function which runs prior to the removal of scene's view
function scene:destroy(event)

	local group = self.view
	audio.dispose(collisionSound)
	audio.dispose(laserSound)
	audio.dispose(backgroundMusic)
	audio.dispose(planetExplosionSound)
	audio.dispose(playerHitSound)
	audio.dispose(playerRespawnSound)
end

-- Scene event function listeners
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene

-- ----------------------------------------------------------------------------------------
-- Created by Amy Law
-- ----------------------------------------------------------------------------------------
