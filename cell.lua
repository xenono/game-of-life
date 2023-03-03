Cell = {
  x = nil,
  y = nil,
  isActive = false,
  color = nil

}
Cell.__index = Cell

-- Cell x and y attributes are not x and y coordinates in pixels but indexes in Grid Matrix
function Cell:new(x, y, isActive, color)
  local cell = {}
  setmetatable(cell, Cell)
  cell.x = x
  cell.y = y
  cell.isActive = isActive
  cell.color = color or {255,0,0}

  return cell
end

function Cell:turnOn(color)
  self.isActive = true;
  self:setColor(color)
end

function Cell:turnOff()
  self.isActive = false;
  self:setColor({0,0,0})
end

function Cell:getStatus()
  return self.isActive
end

function Cell:setStatus(newStatus)
  self.isActive = newStatus
end

function Cell:setColor(color)
  self.color = color
end

function Cell:getColor()
  return self.color[1], self.color[2], self.color[3]
end

return Cell


