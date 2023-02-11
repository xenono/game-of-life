Game = {variation=nil, grid=nil, status=nil, currentShape=nil, nextStepUpdates=nil}
Game.__index = Game

function Game:new(variation, grid)
    local game = {}
    setmetatable(game, Game)
    game.variation = variation
    game.grid = grid
    game.status = 0
    game.currentShape = "blank"
    game.nextStepUpdates = {}
    return game
end

function Game:setup()
    self.grid:setup()
end


function Game:draw()
    self.grid:draw()
end

function Game:update(nextStepUpdates)
    self.grid:update(self.nextStepUpdates)
    self.grid:updateToNextStep(self.nextStepUpdates)
    self.nextStepUpdates = {}
end

function Game:setVariation(variation)
    self.variation = variation
    Grid:setGameVariation(variation)
end

function Game:getStatus()
    return self.status
end

function Game:start()
    self.status = 1
end

function Game:stop()
    self.status = 0
end

function Game:setShape(newShape)
    self.grid:reset()
    self.grid:drawShape(23,20,newShape)
    self.currentShape = newShape
end

function Game:reset()
    self.nextStepUpdates = {}
    self.grid:reset(self.currentShape)
end

function Game:handleGridClick(x,y)
    if self.grid:isMouseInGrid(x,y) then
        self.grid:activateCellOnClick(x,y)
    end
end

return Game