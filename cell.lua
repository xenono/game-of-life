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
  cell.color = color

  return cell
end

function Cell:turnOn()
  self.isActive = true;
end

function Cell:turnOff()
  self.isActive = false;
end

function Cell:getStatus()
  return self.isActive
end

function Cell:setStatus(newStatus)
  self.isActive = newStatus
end


return Cell


