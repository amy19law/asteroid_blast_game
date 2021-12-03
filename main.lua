-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Background Image
background = display.newImageRect( "Images/background.png", 960, 1710)
background.x = display.contentCenterX
background.y = display.contentCenterY

local composer = require("composer")

-- Seed the Random Number Generator
math.randomseed(os.time())

-- Reserve channel for Background Music
audio.reserveChannels(1)
-- Reduce the Channel Volume
audio.setVolume(0.5, {channel=1})

-- Go to the Menu Screen
composer.gotoScene("menu")