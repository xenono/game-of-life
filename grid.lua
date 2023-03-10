Cell = require("cell")
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
    patterns=nil,
    baseColor=nil,
    secondaryColor=nil
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
    grid.baseColor = {255,0,0}
    grid.secondaryColor = {0,0,255}
    return grid
end

function Grid:setup()
    for x = 0 , self.size do
        self.cells[x] = {}
        for y = 0, self.size do
            self.cells[x][y] = Cell:new(x, y, false, {0,0,0})
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


    for x = 0, self.size do
        for y = 0, self.size do
            if(self.cells[x][y]:getStatus()) then
                local r,g,b = self.cells[x][y]:getColor()
                love.graphics.setColor(love.math.colorFromBytes(r,g,b))
                love.graphics.rectangle('fill', self.cellSize * self.cells[x][y].x + self.border , self.cellSize * self.cells[x][y].y + self.border, self.squareSize, self.squareSize)
            end
        end
    end
end

function Grid:turnCellOn(x,y,color)
    self.cells[x][y]:turnOn(color)
end

function Grid:turnCellOff(x,y)
    self.cells[x][y]:turnOff()
end

function Grid:getCellStatus(x,y)
    return self.cells[x][y]:getStatus()
end

function Grid:cellOutOfGrid(cellX, cellY) 
    if(cellX >= self.size or cellX <= 0) then return true end
    if(cellY >= self.size or cellY <= 0) then return true end
    return false
end

function Grid:countCellNeighbours(cellX,cellY)
        local numOfNeighbours = 0 
        local neighboursColors = {}
        for x = cellX-1, cellX+1 do
            for y = cellY-1, cellY + 1 do
                if(x == cellX and y == cellY) then goto continue end
    
                if(self:cellOutOfGrid(x,y)) then goto continue end
    
                if(self:getCellStatus(x,y)) then
                    numOfNeighbours = numOfNeighbours + 1
                    table.insert(neighboursColors, {self.cells[x][y]:getColor()})
                end
                
                ::continue::
            end
        end
    
        return numOfNeighbours, neighboursColors
    end

function Grid:getNextColorCell(neighboursColors)
    local r,g,b = 0,0,0
    for i = 1, 3 do
        r = r +neighboursColors[i][1]
        g = g + neighboursColors[i][2]
        b = b + neighboursColors[i][3]
    end

    return {r/3,g/3,b/3}
end
function Grid:getNextCellState(cellX,cellY) 
    local n, neighboursColors = self:countCellNeighbours(cellX,cellY)
    local isCellALive = self.cells[cellX][cellY]:getStatus()
    if self.gameVariation == "HighLife" and (not isCellALive and n == 6) then
        return true
    end

    if (not isCellALive and n == 3) then
        if(self.gameVariation == "The Rainbow Game") then
            local color = self:getNextColorCell(neighboursColors)
            return true, color
        end
        return true, self.baseColor;
    end
    if(isCellALive and n < 2) then return false, self.baseColor; end
    if(isCellALive and n > 3) then return false, self.baseColor; end
    if(isCellALive and n == 2 or n == 3) then return true, self.baseColor; end
    return false, self.baseColor;
end

function Grid:update(nextStepUpdates)
    for x = 0, self.size do
        for y = 0, self.size do
            local currentCellState = self.cells[x][y]:getStatus()
            local nextCellState, nextColor = self:getNextCellState(x,y)
            if(not (currentCellState == nextCellState)) then
                table.insert(nextStepUpdates, Cell:new(x, y, nextCellState, nextColor))
            end
        end
    end
end

function Grid:updateToNextStep(nextStepUpdates) 
    for _, newCell in pairs(nextStepUpdates) do
        self.cells[newCell.x][newCell.y] = newCell
    end
end

function Grid:drawShape(startX, startY, shapeName)
    local shape = self.patterns[shapeName]

    for i,j in pairs(shape) do
        local x,y = j[1], j[2]
        if(self.gameVariation == "The Rainbow Game") then
            local r = math.random(0,255)
            local g = math.random(0,255)
            local b = math.random(0,255)
            self:turnCellOn(startX + x, startY + y, {r,g,b})
            ::continue::
        else
            self:turnCellOn(startX + x, startY + y, self.baseColor)
        end
    end
end

function Grid:isMouseInGrid(x,y) 
    if x > 0 and x < self.width then
        if y > 0 and y < self.height then
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
        self:drawShape(20,20,shape)
    end
end

function Grid:activateCellOnClick(mouseX, mouseY, isRpmClicked)
    local cellX = math.floor(mouseX / self.cellSize)
    local cellY = math.floor(mouseY / self.cellSize)

    if(isRpmClicked) then
        self:turnCellOn(cellX, cellY, self.secondaryColor)
    else
        self:turnCellOn(cellX, cellY, self.baseColor)
    end
end




return Grid