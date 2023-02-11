Dropdown = {x=nil,y=nil,items={}}
Dropdown.__index = Dropdown

function Dropdown:new(x,y,items,width,parentHeight) 
    local dropdown = {}
    setmetatable(dropdown, Dropdown)
    dropdown.x = x
    dropdown.y = y
    
    dropdown.isActive = false
    dropdown.width = width
    
    dropdown.itemHeight = 50 -- Leave 2 pixels for borders
    dropdown.parentHeight = parentHeight
    dropdown.font = love.graphics.newFont(12,"normal",100)
    dropdown.items = {}
    dropdown.itemsNum = #items

    dropdown:setupList(items)

    return dropdown
end

function Dropdown:setupList(items)
    for i, v in pairs(items) do
        local itemObject = {}
        itemObject.text = love.graphics.newText(self.font, v)
        itemObject.x = self.x + 1
        itemObject.y = self.y - ((i-1) * self.itemHeight)  - self.parentHeight - 1 
        itemObject.width = self.width - 2
        itemObject.height = self.itemHeight - 2
        itemObject.content = v
        table.insert(self.items, itemObject)
    end
end


function Dropdown:draw()
    if not self.isActive then return end
    -- Draw wrapper
    love.graphics.setColor(255,255,255,1)
    love.graphics.rectangle("fill", self.x, self.y - (self.itemsNum * 50) - 2, self.width, self.itemHeight * self.itemsNum + 1)
    -- Draw list items
    for item = self.itemsNum, 1, -1 do
        love.graphics.setColor(0,0,0,1)
        love.graphics.rectangle("fill", self.items[item].x, self.items[item].y, self.items[item].width, self.items[item].height)
        love.graphics.setColor(255,255,255,1)
        love.graphics.draw(self.items[item].text, self.items[item].x + (self.items[item].width/2) - (self.items[item].text.getWidth(self.items[item].text)/2),self.items[item].y + (self.items[item].height/2)-(self.items[item].text.getHeight(self.items[item].text)/2))
    end
end

function Dropdown:isItemListClicked(mouseX,mouseY)
    if not self.isActive then return false end
    
    for item = 1, self.itemsNum do
        if mouseX >= self.items[item].x and mouseX <= self.items[item].x + self.items[item].width then
            if mouseY >= self.items[item].y and mouseY <= self.items[item].y + self.items[item].height then
                self:toggle()
                return true, self.items[item].content
            end
        end
    end
    return false, nil
end

function Dropdown:toggle()
    self.isActive = not self.isActive
end

function Dropdown:deactivate()
    self.isActive = false
end


return Dropdown