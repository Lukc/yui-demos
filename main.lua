
local sdl = require "SDL"

local yui = require "yui.init"

local theme = require "theme"

yui:init()

yui:loadFont("default", "DejaVuSans.ttf", 14)
yui:loadFont("big", "DejaVuSans.ttf", 28)
yui:loadFont("x-big", "DejaVuSans.ttf", 34)

local selectedButton = "button0"
local buttonId = 0
local selectionButtonWidth = 75
local selectionButtonWidthLarge = 355
local selectionButtonWidthSpeed = 200
local SelectionButton = function(name, image)
	local arg = {}

	if buttonId == 0 then
		arg.width = selectionButtonWidthLarge
	else
		arg.width = selectionButtonWidth
	end

	if name then
		arg[1] = yui.Label {
			x = 5,
			y = 2,

			text = name,

			font = "big"
		}
	end

	if image then
		arg[2] = yui.Image {
			file = image,

			x = 1,
			y = 50
		}
	end

	local self = yui.Frame(arg)

	if not arg.id then
		self.id = "button" .. buttonId
		buttonId = buttonId + 1
	end

	self.eventListeners.click = function(self, button)
		if self.id ~= selectedButton and button == sdl.mouseButton.Left then
			self.targetWidth = selectionButtonWidthLarge

			local previouslySelected =
				self:getRoot():getElementById(selectedButton)

			previouslySelected.targetWidth = selectionButtonWidth

			-- Forcing children placement update.
			previouslySelected.parent:update(0)

			selectedButton = self.id
		end
	end

	self.eventListeners.update = function(self, dt)
		local tw = self.targetWidth or self.width

		if self.width > tw then
			self.width =
				math.max(self.width - selectionButtonWidthSpeed * dt / 1000, tw)
		elseif self.width < tw then
			self.width =
				math.min(self.width + selectionButtonWidthSpeed * dt / 1000, tw)
		end

		if self.width ~= tw then
			print(self, self.width, self.realWidth)
		end
	end

	return self
end

local w = yui.Window {
	flags = { sdl.window.Resizable },

	width = 1024,
	height = 800,

	theme = theme,

	yui.Frame {
		width = 800,
		height = 600,

		titleHeight = 40,

		events = {
			-- Automated centering, uh…
			update = function(self, dt)
				self.x = (self.parent.realWidth - self.realWidth) / 2
				self.y = (self.parent.realHeight - self.realHeight) / 2
			end
		},

		yui.Label {
			text = "Choose your ship!",
			font = "x-big"
		},

		yui.Row {
			x = 10,
			y = 50,

			spacing = 10,

			width = 780,
			height = 480,

			SelectionButton("Foo Cruiser"),
			SelectionButton("Bar Frigate"),
			SelectionButton("Bleh Carrier"),
			SelectionButton("locked"),
			SelectionButton("locked"),
			SelectionButton("locked"),
		},

		yui.Button {
			yui.Label {
				text = "Let’s go!",
				align = "center",
				vAlign = "middle"
			},

			x = 10,
			y = 540,

			width = 780,

			height = 40,
		}
	}
}

while yui:run {w} do end

