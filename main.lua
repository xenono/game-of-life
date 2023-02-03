-- Import dkjson library
local json = require("dkjson")
local utils = require("utils")
local button = require("button")
local dropwdown = require("dropdown")

SquareSize = 15
CellSize = 16
GridSize = (800/CellSize) - 1
GridBorderOffset = 1
Grid = {}
Timer = love.timer.getTime()    
IsGameRunning = false
Patterns = love.filesystem.read("patterns.json")
Patterns = json.decode(Patterns)

NextStepUpdates = {}

-- Setup buttons
StartBtn = button:new(0,802,"Start",100, true)
StopBtn = button:new(101,802,"Stop",100, false)
ResetBtn = button:new(202,802,"Reset",100, false)
ShapeBtn = button:new(303,802,"Choose Animation",150, true)
VariationBtn = button:new(454,802,"Choose Game Variation",200, true)
ExitBtn = button:new(655,802,"Exit",148, true)


-- Setup Dropdowns
ShapeDropdown = dropwdown:new(303,802,{"shape1","shape2"},150,50)


function love.draw()
    love.graphics.setColor(196,196,196,1)
    
    -- -- Draw grid
    love.graphics.setColor(255,255,255,0.1)
    love.graphics.setLineStyle("rough") 
    for i = 0, GridSize do
        love.graphics.line(0,i*CellSize,800,i*CellSize)
        love.graphics.line(i*CellSize+1,0,i*CellSize,800)
    end
    love.graphics.line(0,802,802,802)

    love.graphics.setColor(255,0,0,1)

    for x = 0, GridSize do
        for y = 0, GridSize do
            if(Grid[x][y][3]) then
                love.graphics.rectangle('fill', Grid[x][y][1], Grid[x][y][2],SquareSize,SquareSize)
            end
        end
    end
    love.graphics.setColor(255,255,255,1)
    
    -- Draw buttons
    StartBtn:draw()
    StopBtn:draw() 
    ResetBtn:draw()
    ShapeBtn:draw()
    VariationBtn:draw()
    ExitBtn:draw()

    -- Draw dropwdowns
    ShapeDropdown:draw()
end

function love.update(dt) 
    if not IsGameRunning then return end
    if(love.timer.getTime() - Timer >= 0.5) then
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

function love.mousepressed(x, y, button)
    if button == 1 then
        if StartBtn:isClicked(x,y) then
            IsGameRunning = true
            StartBtn:deactivate()
            StopBtn:activate()
            ResetBtn:activate()
            VariationBtn:deactivate()
            ShapeBtn:deactivate()
            ShapeDropdown:deactivate()
            IsGameRunning = true
        elseif StopBtn:isClicked(x,y) then
            StopBtn:deactivate()
            StartBtn:activate()
            ResetBtn:deactivate()
            VariationBtn:activate()
            ShapeBtn:activate()
            IsGameRunning = false
        elseif  ResetBtn:isClicked(x,y) then
            Reset()
        elseif  VariationBtn:isClicked(x,y) then 
            print("Variation")
        elseif ShapeBtn:isClicked(x,y) then 
            ShapeDropdown:toggle()
        elseif ExitBtn:isClicked(x,y) then
            love.event.quit()
        end

        local isShapeDropDownClicked, shapeName = ShapeDropdown:isItemListClicked(x,y)
        if isShapeDropDownClicked and shapeName then
            print(shapeName)
        end
        -- if is then
        -- print("List clicked")
        


    end
end



function DrawShape(startX,startY,shapeName)
    
    local shape = Patterns[shapeName]
    for i,j in pairs(shape) do
        local x,y = j[1], j[2]
        utils.turnRectangleOn(startX + x, startY + y,Grid)
    end
end

function Reset()
    NextStepUpdates = {}
    utils.resetGrid(Grid,GridSize,"lightShip")
end

function Setup()
    for x = 0 , GridSize do
        Grid[x] = {}
        for y = 0, GridSize do
            Grid[x][y] = {(CellSize*x)+GridBorderOffset,(CellSize*y)+GridBorderOffset, false}
        end
    end
    
    love.window.setTitle("Game of life")
    love.window.setMode(802,852)
end

Setup()

DrawShape(10,10,"blinker")
DrawShape(40,10,"beacon")
DrawShape(30,30,"lightShip")

Reset()
-- print(utils.processCell(11,9,Grid,GridSize))
-- print(Grid[11][9][3])