-- Import dkjson library
local json = require("dkjson")

SquareSize = 15
CellSize = 16
GridSize = (800/CellSize) - 1
GridBorderOffset = 1
Grid = {}
Timer = love.timer.getTime()

Patterns = json.decode(love.filesystem.read("patterns.json"))

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

    for y = 0, GridSize do
        for x = 0, GridSize do
            if(Grid[y][x][3]) then
                love.graphics.rectangle('fill', Grid[y][x][1], Grid[y][x][2],SquareSize,SquareSize)
            end
        end
    end
end

function love.update(dt) 
    if(love.timer.getTime() - Timer >= 1) then
        local x = love.math.random(1,GridSize)
        local y = love.math.random(1,GridSize)
        TurnRectangleOn(x,y)
        Timer = love.timer.getTime()
    end
end

function TurnRectangleOn(x,y)
    Grid[y][x][3] = true
end

function TurnRectangleOff(x,y)
    Grid[y][x][3] = false
end

function Setup()
    for x = 0 , GridSize do
        Grid[x] = {}
        for y = 0, GridSize do
            -- love.graphics.rectangle("fill",(CellSize*x)+GridBorderOffset,(CellSize*y)+1,SquareSize, SquareSize)
            Grid[x][y] = {(CellSize*x)+GridBorderOffset,(CellSize*y)+GridBorderOffset, false}
        end
    end
    love.window.setTitle("Game of life")
    love.window.setMode(802,802)
end

Setup()

Grid[10][10][3] = false
TurnRectangleOn(10,10)




