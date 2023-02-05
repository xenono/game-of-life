-- Import dkjson library
local json = require("dkjson")
local utils = require("utils")
local button = require("button")
local dropdown = require("dropdown")
local grid = require("grid")

Patterns = love.filesystem.read("patterns.json")
Patterns = json.decode(Patterns)

Grid = grid:new(800,1,16, Patterns)

Timer = love.timer.getTime()    
IsGameRunning = false

NextStepUpdates = {}

CurrentShape = "blank"

-- Setup buttons
StartBtn = button:new(0,802,"Start",100, true)
StopBtn = button:new(101,802,"Stop",100, false)
ResetBtn = button:new(202,802,"Reset",100, false)
ShapeBtn = button:new(303,802,"Choose Animation",150, true)
VariationBtn = button:new(454,802,"Choose Game Variation",200, true)
ExitBtn = button:new(655,802,"Exit",148, true)


-- Setup Dropdowns
ShapeDropdown = dropdown:new(303,802,Patterns["shapes"],150,50)


function love.draw()
    Grid:draw()

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
        Grid:update(NextStepUpdates)
        Grid:updateToNextStep(NextStepUpdates)
        NextStepUpdates = {}
        Timer = love.timer.getTime()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then

        -- Grid click handler
        if utils.isInGrid(802,802,x,y) then
            print("In grid")
        end
            
        -- Buttons click handler
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
            Grid:reset(nil)
            Grid:drawShape(23,20,shapeName)
            CurrentShape = shapeName
        end
        -- if utils.isInGrid(Grid.width, Grid.height,x,y) then
        --     print("List clicked")
        -- end
        


    end
end

function Reset()
    NextStepUpdates = {}
    Grid:reset(CurrentShape)
end

function Setup()
    Grid:setup()
    love.window.setTitle("Game of life")
    love.window.setMode(802,852)
end

Setup()