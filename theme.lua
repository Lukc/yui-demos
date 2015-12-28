
local yui = require "yui.init"

local sdl = require "SDL"
local image = require "SDL.image"

local backgroundSurface = image.load("data/bg.png")
local background

return {
	drawWindow = function(self, renderer)
		if not background then
			background = renderer:createTextureFromSurface(backgroundSurface)
		end

		renderer:copy(background, nil, nil)
	end,
	drawButton = function(self, renderer)
		renderer:setDrawColor(0x000000)

		local rectangle = yui.growRectangle(self:rectangle(), 2)

		renderer:setDrawBlendMode(sdl.blendMode.Blend)
		renderer:setDrawColor {r = 127, g = 196, b = 255, a = 61}
		renderer:fillRect(rectangle)
		renderer:setDrawBlendMode(sdl.blendMode.None)

		if self.hovered or self.focused then
			renderer:setDrawColor(0x88BBFF)
		else
			renderer:setDrawColor(0x444444)
		end

		renderer:drawRect(rectangle)
	end,
	drawFrame = function(self, renderer)
		local rectangle = yui.growRectangle(self:rectangle(), 2)

		renderer:setDrawBlendMode(sdl.blendMode.Blend)
		renderer:setDrawColor {r = 127, g = 196, b = 255, a = 31}
		renderer:fillRect(rectangle)
		renderer:setDrawBlendMode(sdl.blendMode.None)

		if self.hovered or self.focused then
			renderer:setDrawColor(0x88BBFF)
		else
			renderer:setDrawColor(0x444444)
		end

		renderer:drawRect(rectangle)
	end,
	drawRow = function(self, renderer)
	end
}

