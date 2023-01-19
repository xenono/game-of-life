local function turnRectangleOn(x,y, grid)
    grid[x][y][3] = true
end

local function turnRectangleOff(x,y, grid)
    grid[x][y][3] = false
end

local function getCellStatus(x,y,grid)
    return grid[x][y][3]
end

local function cellOutOfGrid(cellX, cellY, gridSize) 
    if(cellX > gridSize or cellX < 0) then return true end
    if(cellY > gridSize or cellY < 0) then return true end
    return false
end



-- Find number of single cell neighbours
local function countCellNeighbours(cellX,cellY, grid, gridSize)
    local numOfNeighbours = 0 

    for x = cellX-1, cellX+1 do
        for y = cellY-1, cellY + 1 do
            if(x == cellX and y == cellY) then goto continue end

            if(cellOutOfGrid(x,y,gridSize)) then goto continue end

            if(getCellStatus(x,y,grid)) then
                numOfNeighbours = numOfNeighbours + 1
            end
            
            ::continue::
        end
    end

    return numOfNeighbours
end

local function processCell(cellX,cellY, grid, gridSize) 
    local n = countCellNeighbours(cellX,cellY, grid, gridSize)
    local isCellALive = grid[cellX][cellY][3]
    if (not isCellALive and n == 3) then
        return true
    end
    if(isCellALive and n < 2) then return false end
    if(isCellALive and n > 3) then return false end
    if(isCellALive and n == 2 or n == 3) then return true end
    
end

local function updateGrid(grid, nextStepUpdates) 
    for i,v in pairs(nextStepUpdates) do
        local x,y,newCellState = v[1],v[2],v[3]
        grid[x][y][3] = newCellState
    end
end

return {
    countCellNeighbours = countCellNeighbours, 
    cellOutOfGrid = cellOutOfGrid, 
    turnRectangleOff = turnRectangleOff, 
    turnRectangleOn = turnRectangleOn,
    processCell = processCell,
    updateGrid = updateGrid
}