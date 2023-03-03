UI = {bigFont=nil, mediumFont=nil, normalFont=nil, title=nil, data=nil, rules=nil, ruleTitle=nil, extraInfo=nil}
UI.__index = UI

function UI:new(variation, data)
  local ui = {}
  setmetatable(ui, UI)
  ui.bigFont = love.graphics.newFont(20,"normal",200)
  ui.mediumFont = love.graphics.newFont(16,"normal",200)
  ui.normalFont = love.graphics.newFont(13,"normal",200)
  ui.title = love.graphics.newText(ui.bigFont, "Game Of Life")
  ui.ruleTitle = love.graphics.newText(ui.bigFont, "Rules")
  ui.data = data
  ui.rules = {}
  ui:setVariation(variation);
  return ui
end

function UI:draw() 
  love.graphics.setColor(255,255,255)
  love.graphics.draw(self.title, 1000 - (self.title.getWidth(self.title)/2),20 + (self.title.getHeight(self.title)/2))
  love.graphics.draw(self.variationName, 1000 - (self.variationName.getWidth(self.variationName)/2),70 + (self.variationName.getHeight(self.variationName)/2))
  love.graphics.draw(self.ruleTitle, 1000 - (self.ruleTitle.getWidth(self.ruleTitle)/2),120 + (self.ruleTitle.getHeight(self.ruleTitle)/2))

  for i, rule in pairs(self.rules) do
    love.graphics.draw(rule, 820,170 + (i-1)*50 + (rule.getHeight(rule)/2))
  end

  love.graphics.draw(self.extraInfo, 1000 - (self.extraInfo.getWidth(self.extraInfo)/2),170 + 30 +(#self.rules * 50)+ (self.extraInfo.getHeight(self.extraInfo)/2))

end

function UI:setVariation(variation)
  self.rules = {}
  self.variationName = love.graphics.newText(self.mediumFont, "Variation: " .. variation)
  local extraInfoText = "Press LPM on the grid to activate the cell."
  if(variation == "The Rainbow Game") then
    extraInfoText = "Press LPM on the grid to activate the cell with Red Color\n\nPress RPM to activate it with Blue Color\n\nAvaiable shapes are drawn with random colors."
  end

  self.extraInfo = love.graphics.newText(self.normalFont, extraInfoText)

  for i, rule in pairs(self.data["rules"][variation]) do
    local ruleText = love.graphics.newText(self.normalFont, i .. ". " .. rule)
    table.insert(self.rules, ruleText)
  end

end

return UI
