😋 = {x=6,y=3}

function update(hw_dt)
    if tapped('r') then love.event.quit('restart') end

    if tapped('c') then love.update=talkselect; shout('Chat with whom?') end

    local moved=false
    if not moved and not solid(posstr(😋.x,😋.y-1)) and (tapped('up') or tapped('kp8') or tapped('u'))    then 😋.y=😋.y-1; moved=true end
    if not moved and not solid(posstr(😋.x,😋.y+1)) and (tapped('down') or tapped('kp2') or tapped('n'))  then 😋.y=😋.y+1; moved=true end
    if not moved and not solid(posstr(😋.x-1,😋.y)) and (tapped('left') or tapped('kp4') or tapped('h'))  then 😋.x=😋.x-1; moved=true end
    if not moved and not solid(posstr(😋.x+1,😋.y)) and (tapped('right') or tapped('kp6') or tapped('k')) then 😋.x=😋.x+1; moved=true end
    if not moved and not solid(posstr(😋.x-1,😋.y-1)) and (tapped('kp7') or tapped('y')) then 😋.x=😋.x-1; 😋.y=😋.y-1; moved=true end
    if not moved and not solid(posstr(😋.x-1,😋.y+1)) and (tapped('kp1') or tapped('b')) then 😋.x=😋.x-1; 😋.y=😋.y+1; moved=true end
    if not moved and not solid(posstr(😋.x+1,😋.y-1)) and (tapped('kp9') or tapped('i')) then 😋.x=😋.x+1; 😋.y=😋.y-1; moved=true end
    if not moved and not solid(posstr(😋.x+1,😋.y+1)) and (tapped('kp3') or tapped('m')) then 😋.x=😋.x+1; 😋.y=😋.y+1; moved=true end

    if map[posstr(😋.x,😋.y)] and map[posstr(😋.x,😋.y)][1]=='🔽' and (love.keyboard.isDown('lshift') or love.keyboard.isDown('rshift')) and tapped('<') then
        cam.y=cam.y-12
        if map_empty() then
            cavegen()
        else 
            local sx,sy=strpos(map[posstr(😋.x,😋.y)].entry)
            😋.x=sx; 😋.y=sy
        end
        raycast()
    end
    if map[posstr(😋.x,😋.y)] and map[posstr(😋.x,😋.y)][1]=='🔼' and tapped('<') then
        cam.y=cam.y+12
        local sx,sy=strpos(map[posstr(😋.x,😋.y)].entry)
        😋.x=sx; 😋.y=sy
        raycast()
    end

    if moved then
        header.msg='Hello world!'

        if 😋.y>=cam.y+12 then cam.y=cam.y+12 end
        if 😋.x>=cam.x+24 then cam.x=cam.x+24 end
        if 😋.y<cam.y then cam.y=cam.y-12 end
        if 😋.x<cam.x then cam.x=cam.x-24 end

        if in_dungeon() then raycast() end

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

    t=t+1
end

function talkselect()
    for i,v in ipairs({{'up',0,-1},{'down',0,1},{'left',-1,0},{'right',1,0}}) do
    if tapped(v[1]) then
        local pos=posstr(😋.x+v[2],😋.y+v[3])
        if map[pos] then
            if map[pos].t then
                map[pos].t(map[pos]); header.msg='Hello world!'
            else shout(fmt('You can\'t chat with a %s!',map[pos][1])); love.update=update end
        else shout('Nobody there to talk to.'); love.update=update end
    end
    end
    t=t+1
end

function start_dialogue(d)
    cur_diag=diag_db[d]
    cur_diag.i=1
    cur_diag[cur_diag.i].j=cur_diag[cur_diag.i].j or 1
    love.update=dialogue
end

function dialogue()
    if cur_diag[cur_diag.i].choice then
        if tapped('left')  then cur_diag[cur_diag.i].choice.i=cur_diag[cur_diag.i].choice.i-1 end
        if tapped('right') then cur_diag[cur_diag.i].choice.i=cur_diag[cur_diag.i].choice.i+1 end
        if cur_diag[cur_diag.i].choice.i<1 then cur_diag[cur_diag.i].choice.i=#cur_diag[cur_diag.i].choice end
        if cur_diag[cur_diag.i].choice.i>#cur_diag[cur_diag.i].choice then cur_diag[cur_diag.i].choice.i=1 end
    end
    if tapped('z') or tapped('return') then
        if cur_diag[cur_diag.i].j<utf8.len(cur_diag[cur_diag.i][1]) then
            cur_diag[cur_diag.i].j=utf8.len(cur_diag[cur_diag.i][1])
        else
            if not cur_diag[cur_diag.i].choice then
                cur_diag.i=cur_diag.i+1
                if not cur_diag[cur_diag.i] then love.update=update; return 
                else cur_diag[cur_diag.i].j=cur_diag[cur_diag.i].j or 1 end
            else
                cur_diag[cur_diag.i].choiceresult[cur_diag[cur_diag.i].choice[cur_diag[cur_diag.i].choice.i]]()
            end
        end
    end
    if t%3==0 then 
        if cur_diag[cur_diag.i].j<utf8.len(cur_diag[cur_diag.i][1]) then cur_diag[cur_diag.i].j=cur_diag[cur_diag.i].j+1 end
    end
    t=t+1
end

diag_db={
    ['baobab_craft']={
        {'🆎🅰🅾 🅱🅰🅾🅱🆎'},
        {'🅰🅾 🅱🅰🆎 🌱🅾🅱🅾🅱🅰',choice={i=1,'yes','no'},choiceresult={['yes']=function() love.update=craft end, ['no']=function() love.update=update end}},
    },
    ['baobab_boo']={{'🅱🅾🅾'}},
    ['baobab_oob']={{'🅾🅾🅱'}},
    ['baobab_abba']={{'🅰🅱🅱🅰'}},
    ['baobab_dungeon']={{'🅱🅾🅱🅾 🆎🅾⛰ 🅰🆎🅾🅱🅰🔽 🆎🅰 🅱🅰🅱🅱🅰🅾💰'}},
}

header={msg='Hello world!'}
function shout(msg)
    header.msg=msg
end

function craft()
    if tapped('escape') then love.update=update end

    if tapped('left')  then inventory.i=inventory.i-1 end
    if tapped('right') then inventory.i=inventory.i+1 end
    if inventory.i>#inventory then inventory.i=1 end
    if inventory.i<1 then inventory.i=#inventory end

    if tapped('z') and #inventory>0 and #craft_area<5 then 
        ins(craft_area,inventory[inventory.i])
        rem(inventory,inventory.i)
    end

    if tapped('return') then
        for k,r in pairs(dex_recipes) do
            queue=''
            for j,v in ipairs(craft_area) do
                queue=queue..v[1]
            end
            local rec=k
            while utf8.len(queue)>0 do
                local char=utf8.sub(queue,1,1)
                queue=utf8.sub(queue,2)
                local f=utf8.find(rec,char)
                if f then
                    rec=utf8.sub(rec,1,f-1)..utf8.sub(rec,f+1)
                    if utf8.len(rec)==0 then 
                        if utf8.len(queue)~=0 then goto failure
                        else
                        ins(inventory,deepcopy(r))
                        shout(fmt('Crafted %s!',r.name))
                        goto success
                        end
                    end
                else goto failure end
            end
            ::failure::
        end
        ins(inventory,deepcopy(dex_recipes['fail']))
        shout('Crafting failed!')

        ::success::
        craft_area={}
    end
    t=t+1
end

inventory={i=1,{'🌱'},{'🌱'},{'🌱'},{'🥀'},{'🌱'},{'🌱'}}
craft_area={}

function raycast()
    rays={}
    for i=0,530-1 do
        local a=pi*2/530*i
        local rx=😋.x*64+16+32
        local ry=😋.y*(64+11)+16+32
        while AABB(rx,ry,1,1,cam.x*64+16,cam.y*(64+11)+16,64*24,(64+11)*12) do
            rx=rx+cos(a)*0.8
            ry=ry+sin(a)*0.8
            local tx,ty=flr((rx-16-32)/64),flr((ry-16-32)/(64+11))
            if map[posstr(tx,ty)] then
                --print(tx,ty,😋.x,😋.y,cam.x,cam.y)
                if not find(rays,posstr(tx,ty)) then ins(rays,posstr(tx,ty)) end
                if not find(memo,posstr(tx,ty)) then ins(memo,posstr(tx,ty)) end
                if solid(posstr(tx,ty)) then break end
            end
        end
    end
end
memo={}

function in_dungeon()
    return cam.y<0
end

love.update= update