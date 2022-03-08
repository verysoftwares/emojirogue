😋 = {x=6,y=3}

function update(hw_dt)
    if tapped('r') then love.event.quit('restart') end

    if tapped('t') then love.update=talkselect; shout('Talk to whom?') end

    local moved=false
    if not moved and not solid(posstr(😋.x,😋.y-1)) and tapped('up')    then 😋.y=😋.y-1; moved=true end
    if not moved and not solid(posstr(😋.x,😋.y+1)) and tapped('down')  then 😋.y=😋.y+1; moved=true end
    if not moved and not solid(posstr(😋.x-1,😋.y)) and tapped('left')  then 😋.x=😋.x-1; moved=true end
    if not moved and not solid(posstr(😋.x+1,😋.y)) and tapped('right') then 😋.x=😋.x+1; moved=true end

    if moved then
        header.msg='Hello world!'

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

    t=t+1
end

function talkselect()
    for i,v in ipairs({{'up',0,-1},{'down',0,1},{'left',-1,0},{'right',1,0}}) do
    if tapped(v[1]) then
        local pos=posstr(😋.x+v[2],😋.y+v[3])
        if map[pos] then
            if map[pos].t then
                map[pos].t(map[pos]); header.msg='Hello world!'
            else shout(fmt('You can\'t talk to a %s!',map[pos][1])); love.update=update end
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

love.update= update