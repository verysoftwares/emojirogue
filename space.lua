--[[ handling positions of the game space. ]]--


-- you give this the numbers 0 and 1, it will return a string '0,1'.
-- table keys use this format consistently. 
    function posstr(x,y)
        return fmt('%d,%d',x,y)
    end

-- you give this the string '0,1', it will return 0 and 1. 
    function strpos(pos)
        local delim=string.find(pos,',')
        local x=sub(pos,1,delim-1)
        local y=sub(pos,delim+1)
        --important tonumber calls
        --Lua will handle a string+number addition until it doesn't
        return tonumber(x),tonumber(y)
    end
