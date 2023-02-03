Button = {x=nil, y=nil, text=nil}
Button.__index = Button

function Button:new(x,y, text, size, isActive)
    local btn = {}
    setmetatable(btn, Button)
    btn.x = x
    btn.y = y
    btn.width = size
    btn.height = 50
    local font = love.graphics.newFont(12,"normal",100)
    btn.text = love.graphics.newText(font, text)
    btn.content = text
    btn.isActive = isActive
    return btn
end

function Button:draw() 
    love.graphics.setColor(255,255,255,1)
    love.graphics.rectangle("fill", self.x,self.y, self.width, self.height)
    if not self.isActive then
        love.graphics.setColor(0,0,0,0.8)
        love.graphics.rectangle("fill", self.x + 1,self.y + 1, self.width - 2, self.height - 2)
        love.graphics.setColor(255,255,255,1)
    else 
        love.graphics.setColor(0,0,0,1)
    end

    love.graphics.draw(self.text, self.x + (self.width/2) - (self.text.getWidth(self.text)/2),self.y + (self.height/2)-(self.text.getHeight(self.text)/2))
    
end

function Button:isClicked(mouseX, mouseY)
    if not self.isActive then return end
    if mouseX >= self.x and mouseX <= self.x + self.width then
        if mouseY >= self.y and mouseY <= self.y + self.height then
            return true
        end
    end
    return false
end

function Button:activate()
    self.isActive = true
end

function Button:deactivate()
    self.isActive = false
end

return Button