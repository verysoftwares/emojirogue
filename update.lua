😋 = {x=6,y=3}

function update(hw_dt)
if tapped('r') then love.event.quit('restart') end

    if tapped('up')    then 😋.y=😋.y-1 end
    if tapped('down')  then 😋.y=😋.y+1 end
    if tapped('left')  then 😋.x=😋.x-1 end
    if tapped('right') then 😋.x=😋.x+1 end

    if 😋.y>=cam.y+12 then cam.y=cam.y+12 end
    if 😋.x>=cam.x+24 then cam.x=cam.x+24 end
    if 😋.y<cam.y then cam.y=cam.y-12 end
    if 😋.x<cam.x then cam.x=cam.x-24 end

t = t+1
end

love.update= update