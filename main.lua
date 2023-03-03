-- Import dkjson library
local json = require("dkjson")
local button = require("button")
local dropdown = require("dropdown")
local grid = require("grid")
local game = require("game")

Data = love.filesystem.read("data.json")
Data = json.decode(Data)

Grid = grid:new(800,1,16, Data)

Timer = love.timer.getTime()    

Game = game:new("Life",Grid, Data)

-- Setup buttons
StartBtn = button:new(0,802,"Start",100, true)
StopBtn = button:new(101,802,"Stop",100, false)
ResetBtn = button:new(202,802,"Reset",100, true)
ShapeBtn = button:new(303,802,"Choose Animation",150, true)
VariationBtn = button:new(454,802,"Choose Game Variation",200, true)
ExitBtn = button:new(655,802,"Exit",148, true)


-- Setup Dropdowns
ShapeDropdown = dropdown:new(303,802,Data["shapes"],150,50)
VariationDropdown = dropdown:new(454,802,{"Life","HighLife","The Rainbow Game"},200,50)


function love.draw()
    Game:draw()
    -- Draw buttons
    StartBtn:draw()
    StopBtn:draw() 
    ResetBtn:draw()
    ShapeBtn:draw()
    VariationBtn:draw()
    ExitBtn:draw()

    -- Draw dropwdowns
    ShapeDropdown:draw()
    VariationDropdown:draw()
end

function love.update(dt) 
    if Game:getStatus() == 0 then return end 

    if(love.timer.getTime() - Timer >= 0.5) then
        Game:update()
        Timer = love.timer.getTime()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then

        -- Grid click handler
        Game:handleGridClick(x,y, false)

        -- Buttons click handler
        if StartBtn:isClicked(x,y) then
            Game:start()
            StartBtn:deactivate()
            StopBtn:activate()
            VariationBtn:deactivate()
            ShapeBtn:deactivate()
            ShapeDropdown:deactivate()
            VariationDropdown:deactivate()
        elseif StopBtn:isClicked(x,y) then
            StopBtn:deactivate()
            StartBtn:activate()
            VariationBtn:activate()
            ShapeBtn:activate()
            Game:stop()
        elseif ResetBtn:isClicked(x,y) then
            Game:reset()
        elseif  VariationBtn:isClicked(x,y) then 
            VariationDropdown:toggle()
        elseif ShapeBtn:isClicked(x,y) then 
            ShapeDropdown:toggle()
        elseif ExitBtn:isClicked(x,y) then
            love.event.quit()
        end

        local isShapeDropDownClicked, shapeName = ShapeDropdown:isItemListClicked(x,y)
        if isShapeDropDownClicked and shapeName then
            Game:setShape(shapeName)
        end

        local isVariationDropDownClicked, variationName = VariationDropdown:isItemListClicked(x,y)
        if isVariationDropDownClicked and variationName then
            Game:reset()
            Game:setVariation(variationName)
        end
        
    end

    if Game:getVariation() == "The Rainbow Game"  and button == 2 then
        Game:handleGridClick(x,y, true)
    end
end

function Setup()
    Game:setup()
    love.window.setTitle("Game of life")
    love.window.setMode(1202,852)
end

Setup()