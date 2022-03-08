😋 = {x=6,y=3}

function update(hw_dt)
    if tapped('r') then love.event.quit('restart') end

    local moved=false
    if not moved and not solid(posstr(😋.x,😋.y-1)) and tapped('up')    then 😋.y=😋.y-1; moved=true end
    if not moved and not solid(posstr(😋.x,😋.y+1)) and tapped('down')  then 😋.y=😋.y+1; moved=true end
    if not moved and not solid(posstr(😋.x-1,😋.y)) and tapped('left')  then 😋.x=😋.x-1; moved=true end
    if not moved and not solid(posstr(😋.x+1,😋.y)) and tapped('right') then 😋.x=😋.x+1; moved=true end

    if moved then
        if 😋.y>=cam.y+12 then cam.y=cam.y+12 end
        if 😋.x>=cam.x+24 then cam.x=cam.x+24 end
        if 😋.y<cam.y then cam.y=cam.y-12 end
        if 😋.x<cam.x then cam.x=cam.x-24 end

        for y=0,12-1 do
        for x=0,24-1 do
            local pos=posstr(cam.x+x,cam.y+y)
            if map[pos] and map[pos].f then map[pos].updated=false end 
        end
        end
        for y=0,12-1 do
        for x=0,24-1 do
            local pos=posstr(cam.x+x,cam.y+y)
            if map[pos] and map[pos].f and not map[pos].updated then map[pos].updated=true; map[pos].f(pos) end 
        end
        end        
    end

t = t+1
end

love.update= update