-- Import dkjson library
local json = require("dkjson")
local utils = require("utils")

SquareSize = 15
CellSize = 16
GridSize = (800/CellSize) - 1
GridBorderOffset = 1
Grid = {}
Timer = love.timer.getTime()

Patterns = love.filesystem.read("patterns.json")
Patterns = json.decode(Patterns)

NextStepUpdates = {}

function love.draw()
    love.graphics.setColor(196,196,196,1)
    
    -- -- Draw grid
    love.graphics.setColor(255,255,255,0.1)
    love.graphics.setLineStyle("rough") 
    for i = 0, GridSize do
        love.graphics.line(0,i*CellSize,800,i*CellSize)
        love.graphics.line(i*CellSize+1,0,i*CellSize,800)
    end
    love.graphics.setColor(255,0,0,1)

    for x = 0, GridSize do
        for y = 0, GridSize do
            if(Grid[x][y][3]) then
                love.graphics.rectangle('fill', Grid[x][y][1], Grid[x][y][2],SquareSize,SquareSize)
            end
        end
    end
end

function love.update(dt) 
    if(love.timer.getTime() - Timer >= 1) then
        local x = love.math.random(1,GridSize)
        local y = love.math.random(1,GridSize)
        for x = 0, GridSize do
            for y = 0, GridSize do
                local currentCellState = Grid[x][y][3]
                local nextCellState = utils.processCell(x,y,Grid,GridSize)
                if(not (currentCellState == nextCellState)) then
                    table.insert(NextStepUpdates, {x,y,nextCellState})
                end
            end
        end
        utils.updateGrid(Grid, NextStepUpdates)
        NextStepUpdates = {}
        Timer = love.timer.getTime()
    end
end


function DrawShape(startX,startY,shapeName)
    
    local shape = Patterns[shapeName]
    for i,j in pairs(shape) do
        local x,y = j[1], j[2]
        utils.turnRectangleOn(startX + x, startY + y,Grid)
    end
end

function Setup()
    for x = 0 , GridSize do
        Grid[x] = {}
        for y = 0, GridSize do
            Grid[x][y] = {(CellSize*x)+GridBorderOffset,(CellSize*y)+GridBorderOffset, false}
        end
    end
    love.window.setTitle("Game of life")
    love.window.setMode(802,802)
end

Setup()

DrawShape(10,10,"blinker")
DrawShape(40,10,"beacon")
-- print(utils.processCell(11,9,Grid,GridSize))
-- print(Grid[11][9][3])