local function isInGrid(widthPx,heightPx, mouseX, mouseY)
    if mouseX >= 0 and mouseX <= widthPx then
        if mouseY >= 0 and mouseY <= heightPx then
            return true
        end
    end
    return false
end

return {
    isInGrid = isInGrid
}