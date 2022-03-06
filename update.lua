elf = {x=6,y=3}

function update(hw_dt)
if tapped('r') then love.event.quit('restart') end

    if tapped('up')    then elf.y=elf.y-1 end
    if tapped('down')  then elf.y=elf.y+1 end
    if tapped('left')  then elf.x=elf.x-1 end
    if tapped('right') then elf.x=elf.x+1 end

t = t+1
end

love.update= update