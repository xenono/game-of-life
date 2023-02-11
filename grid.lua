Grid = {
    size=nil,
    cells={},
    border=nil,
    cellSize=nil,
    startX=nil,
    startY=nil,
    endX=nil,
    endY=nil,
    width=nil,
    height=nil,
    patterns=nil
}
Grid.__index = Grid

function Grid:new(width,borderOffset,cellSize, patterns) 
    local grid = {}
    setmetatable(grid,Grid)
    grid.cellSize = cellSize
    grid.squareSize = grid.cellSize - 1
    grid.border = borderOffset
    grid.size = (width/grid.cellSize) - 1
    grid.width = width
    grid.height = width
    grid.startX = 0
    grid.startY = 0
    grid.endX = grid.startX + grid.width
    grid.endY = grid.startY + grid.height
    grid.cells = {}
    grid.patterns = patterns
    grid.gameVariation = "Life"
    return grid
end

function Grid:setup()
    for x = 0 , self.size do
        self.cells[x] = {}
        for y = 0, self.size do
            self.cells[x][y] = {(self.cellSize * x) + self.border,(self.cellSize * y) + self.border, false}
        end
    end
end

function Grid:setGameVariation(variation)
    self.gameVariation = variation
end

function Grid:draw()
    love.graphics.setColor(196,196,196,1)
    
    -- -- Draw grid
    love.graphics.setColor(255,255,255,0.1)
    love.graphics.setLineStyle("rough") 
    for i = 0, self.size do
        love.graphics.line(0,i * self.cellSize, self.width , i * self.cellSize)
        love.graphics.line(i * self.cellSize + 1, 0, i * self.cellSize, self.width)
    end
    love.graphics.line(0,802,802,802)

    love.graphics.setColor(255,0,0,1)

    for x = 0, self.size do
        for y = 0, self.size do
            if(self.cells[x][y][3]) then
                love.graphics.rectangle('fill', self.cells[x][y][1], self.cells[x][y][2], self.squareSize, self.squareSize)
            end
        end
    end
    love.graphics.setColor(255,255,255,1)
end

function Grid:turnCellOn(x,y)
    self.cells[x][y][3] = true
end

function Grid:turnCellOff(x,y)
    self.cells[x][y][3] = false
end

function Grid:getCellStatus(x,y)
    return self.cells[x][y][3]
end

function Grid:cellOutOfGrid(cellX, cellY) 
    if(cellX > self.size or cellX < 0) then return true end
    if(cellY > self.size or cellY < 0) then return true end
    return false
end

function Grid:countCellNeighbours(cellX,cellY)
        local numOfNeighbours = 0 
    
        for x = cellX-1, cellX+1 do
            for y = cellY-1, cellY + 1 do
                if(x == cellX and y == cellY) then goto continue end
    
                if(self:cellOutOfGrid(x,y)) then goto continue end
    
                if(self:getCellStatus(x,y)) then
                    numOfNeighbours = numOfNeighbours + 1
                end
                
                ::continue::
            end
        end
    
        return numOfNeighbours
    end

function Grid:getNextCellState(cellX,cellY) 
    local n = self:countCellNeighbours(cellX,cellY)
    local isCellALive = self.cells[cellX][cellY][3]

    if self.gameVariation == "HighLife" and (not isCellALive and n == 6) then
        return true
    end

    if (not isCellALive and n == 3) then
        return true
    end
    if(isCellALive and n < 2) then return false end
    if(isCellALive and n > 3) then return false end
    if(isCellALive and n == 2 or n == 3) then return true end
    
end

function Grid:update(nextStepUpdates)
    for x = 0, self.size do
        for y = 0, self.size do
            local currentCellState = self.cells[x][y][3]
            local nextCellState = self:getNextCellState(x,y)
            if(not (currentCellState == nextCellState)) then
                table.insert(nextStepUpdates, {x,y,nextCellState})
            end
        end
    end
end

function Grid:updateToNextStep(nextStepUpdates) 
    for i,v in pairs(nextStepUpdates) do
        local x,y,newCellState = v[1],v[2],v[3]
        self.cells[x][y][3] = newCellState
    end
end

function Grid:drawShape(startX, startY, shapeName)
    local shape = self.patterns[shapeName]

    for i,j in pairs(shape) do
        local x,y = j[1], j[2]
        self:turnCellOn(startX + x, startY + y)
    end
end

function Grid:isMouseInGrid(x,y) 
    if x >= 0 and x <= self.width then
        if y >= 0 and y <= self.height then
            return true
        end
    end
    return false
end


function Grid:reset(shape)
    for x = 0, self.size do
        for y = 0, self.size do
            self:turnCellOff(x,y)
        end
    end
    if shape then
        self:drawShape(23,20,shape)
    end
end

function Grid:activateCellOnClick(mouseX, mouseY)
    local cellX = math.floor(mouseX / self.cellSize)
    local cellY = math.floor(mouseY / self.cellSize)

    self:turnCellOn(cellX, cellY)
end




return Grid