-- ----------------------------------------------------------------------------------------
-- Created by Amy Law
-- ----------------------------------------------------------------------------------------

local backgroundEffects = {}
local backgroundEffects_mt = {__index = backgroundEffects}

-- ----------------------------------------------------------------------------------------
-- Functions
-- ----------------------------------------------------------------------------------------

-- Function to Create Background Effect
function backgroundEffects.new(numberOfElements,theView,effectSpeed)
	local effectGroup = display.newGroup()
    local allEffects = {} 

    for i=0, numberOfElements do
		local element = display.newCircle(math.random(display.contentWidth), math.random(display.contentHeight), math.random(1,3))
		element:setFillColor(1,1,1)
		effectGroup:insert(element)
		table.insert(allEffects,element)
    end
    theView:insert(effectGroup)

	    local newBackgroundEffects = {
            allEffects = allEffects,
            effectSpeed = effectSpeed 
		}	

return setmetatable(newBackgroundEffects,backgroundEffects_mt)
end

function backgroundEffects:enterFrame()
	self:moveElements()
	self:checkElementsOutOfBounds()
end
-- Function to move elements of effect to look like stars
function backgroundEffects:moveElements()
        for i=1, #self.allEffects do
            self.allEffects[i].y = self.allEffects[i].y+self.effectSpeed
        end
end

-- Function to check if element of the effect are out of bounds
function  backgroundEffects:checkElementsOutOfBounds()
	for i=1, #self.allEffects do
		if(self.allEffects[i].y-100 > display.contentHeight) then
			self.allEffects[i].x  = math.random(display.contentWidth)
			self.allEffects[i].y = 0
		end
	end
end

return backgroundEffects

-- ----------------------------------------------------------------------------------------
-- Created by Amy Law
-- ----------------------------------------------------------------------------------------
