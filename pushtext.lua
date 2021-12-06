-- ----------------------------------------------------------------------------------------
-- Created by Amy Law
-- ----------------------------------------------------------------------------------------

local pushText = {}
local pushText_mt = {__index = pushText}

-- ----------------------------------------------------------------------------------------
-- Functions
-- ----------------------------------------------------------------------------------------

function pushText.new(theText,positionX,positionY,theFont,theFontSize,theGroup)
	  local theTextField = display.newText(theText,positionX,positionY,theFont,theFontSize)
	  
local newPushText = {
    theTextField = theTextField}
    theGroup:insert(theTextField)                                             
	return setmetatable(newPushText,pushText_mt)
end

function pushText:setColor(r,b,g)
  self.theTextField:setFillColor(r,g,b)
end

function pushText:Pushtext()
	transition.to(self.theTextField, {xScale=2.0, yScale=2.0, time=4000, iterations = 1})
end

return pushText

-- ----------------------------------------------------------------------------------------
-- Created by Amy Law
-- ----------------------------------------------------------------------------------------
