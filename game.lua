local ui = require("ui")

Game = {variation=nil, grid=nil, status=nil, currentShape=nil, nextStepUpdates=nil, ui=nil}
Game.__index = Game

function Game:new(variation, grid, data)
    local game = {}
    setmetatable(game, Game)
    game.variation = variation
    game.grid = grid
    game.status = 0
    game.currentShape = "blank"
    game.nextStepUpdates = {}
    game.ui = ui:new(variation,data)
    return game
end

function Game:setup()
    self.grid:setup()
end


function Game:draw()
    self.grid:draw()
    self.ui:draw()
end

function Game:update(nextStepUpdates)
    self.grid:update(self.nextStepUpdates)
    self.grid:updateToNextStep(self.nextStepUpdates)
    self.nextStepUpdates = {}
end

function Game:setVariation(variation)
    self.variation = variation
    self.grid:setGameVariation(variation)
    self.ui:setVariation(variation)
    self.grid:reset()
    self.grid:drawShape(20,20,self.currentShape)
end

function Game:getStatus()
    return self.status
end


function Game:getVariation()
    return self.variation
end

function Game:start()
    self.status = 1
end

function Game:stop()
    self.status = 0
end

function Game:setShape(newShape)
    self.grid:reset()
    self.grid:drawShape(20,20,newShape)
    self.currentShape = newShape
end

function Game:reset()
    self.nextStepUpdates = {}
    self.grid:reset(self.currentShape)
end

function Game:handleGridClick(x,y, isRpmClick)
    if self.grid:isMouseInGrid(x,y) then
        self.grid:activateCellOnClick(x,y, isRpmClick)
    end
end

return Game