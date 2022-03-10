-- my lua implementation of Perlin noise
-- from August 2019.

function perlin(x,y,z)
  --Perlin noise by Ken Perlin,
  --inventor of Perlin noise
  --and winner of Academy Award for Perlin noise,
  --which is his invention.
  xi=math.floor(x)%256; --if xi>255 then xi=255 end
  yi=math.floor(y)%256; --if yi>255 then yi=255 end
  zi=math.floor(z)%256; --if zi>255 then zi=255 end
  xf=x-math.floor(x)
  yf=y-math.floor(y)
  zf=z-math.floor(z)
  u=fade(xf)
  v=fade(yf)
  w=fade(zf)
  
  local p=per_p
  aaa = p[p[p[    xi ]+    yi ]+    zi ]
  aba = p[p[p[    xi ]+  yi+1 ]+    zi ]
  aab = p[p[p[    xi ]+    yi ]+  zi+1 ]
  abb = p[p[p[    xi ]+  yi+1 ]+  zi+1 ]
  baa = p[p[p[  xi+1 ]+    yi ]+    zi ]
  bba = p[p[p[  xi+1 ]+  yi+1 ]+    zi ]
  bab = p[p[p[  xi+1 ]+    yi ]+  zi+1 ]
  bbb = p[p[p[  xi+1 ]+  yi+1 ]+  zi+1 ]

  x1=lerp(grad(aaa,xf,yf,zf),
          grad(baa,xf-1,yf,zf),
          u)
  x2=lerp(grad(aba,xf,yf-1,zf),
          grad(bba,xf-1,yf-1,zf),
          u)
  y1=lerp(x1,x2,v)

  x1=lerp(grad(aab,xf,yf,zf-1),
          grad(bab,xf-1,yf,zf-1),
          u)
  x2=lerp(grad(abb,xf,yf-1,zf-1),
          grad(bbb,xf-1,yf-1,zf-1),
          u)
  y2=lerp(x1,x2,v)


  return (lerp(y1,y2,w)+1)/2

end

function fade(tt)
  return tt*tt*tt*(tt*(tt*6-15)+10)
end

function grad(hash,x,y,z)
  hash=hash%16
  
  if hash==0 then return x+y end
  if hash==1 then return -x+y end
  if hash==2 then return x-y end
  if hash==3 then return -x-y end
  if hash==4 then return x+z end
  if hash==5 then return -x+z end
  if hash==6 then return x-z end
  if hash==7 then return -x-z end
  if hash==8 then return y+z end
  if hash==9 then return -y+z end
  if hash==10 then return y-z end
  if hash==11 then return -y-z end
  if hash==12 then return y+x end
  if hash==13 then return -y+z end
  if hash==14 then return y-x end
  if hash==15 then return -y-z end
end

function lerp(a,b,x)
  return a+x * (b-a)
end

--https://xkcd.com/221/
permutation = {151,160,137,91,90,15,
   131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
   190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
   88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
   77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
   102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
   135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
   5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
   223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
   129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
   251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
   49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
   138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180}
per_p = {}
for i=0,512-1 do
  per_p[i] = permutation[i%256+1]
end

map={}
for y=0,12-1 do for x=0,24-1 do
  map[posstr(x,y)]= {dex[1][flr(perlin(y*.1,x*.1,2472472)*#dex[1])+1]}
end end

for my=0,4 do
for mx=0,4 do
map[posstr(26+1+mx,3+4-2+1)]={'🧱'}
if not (mx==2) then
map[posstr(26+1+mx,3+4+4-2+1)]={'🧱'}
end
map[posstr(26+1,3+4-2+my+1)]={'🧱'}
map[posstr(26+1+4,3+4-2+my+1)]={'🧱'}

map[posstr(24*2-12-2+mx,3+4-5+1)]={'🧱'}
if not (mx==2) then
map[posstr(24*2-12-2+mx,3+4-5+4+1)]={'🧱'}
end
map[posstr(24*2-12-2,3+4-5+my+1)]={'🧱'}
map[posstr(24*2-12-2+4,3+4-5+my+1)]={'🧱'}

map[posstr(24*2-7+mx,3+4-2+1)]={'🧱'}
map[posstr(24*2-7+4,3+4-2+my+1)]={'🧱'}
if not (mx==2) then
map[posstr(24*2-7+mx,3+4+4-2+1)]={'🧱'}
end
map[posstr(24*2-7,3+4-2+my+1)]={'🧱'}end
end

for i=0,24-1 do
    map[posstr(i+24,0)]={'⛰️'}
    map[posstr(i+24,1)]={'⛰️'}
    if (i>2 and i<11) or (i>16 and i<21) then map[posstr(i+24,2)]={'⛰️'} end
    if i==11 then map[posstr(i+24,2)]={'🔽'} end
end

function solid(pos)
    return map[pos] and (map[pos][1]=='🧱' or map[pos][1]=='🐴' or map[pos][1]=='⛰️')
end

function oob(pos)
    local px,py=strpos(pos)
    return px<cam.x or py<cam.y or px>=cam.x+24 or py>=cam.y+12
end

function 😋collide(pos)
    local px,py=strpos(pos)
    return px==😋.x and py==😋.y
end

function 😋adjacent(pos)
    local px,py=strpos(pos)
    for i,v in ipairs({{-1,-1},{0,-1},{1,-1},{1,0},{1,1},{0,1},{-1,1},{-1,0}}) do
        if px+v[1]==😋.x and py+v[2]==😋.y then return true end
    end
    return false
end

function 🐴_wander(pos)
    local mx,my=strpos(pos)
    local newpos=posstr(mx+random(-1,1),my+random(-1,1))
    if not map[newpos] and not 😋collide(newpos) and not oob(newpos) then
    local 🐴=map[pos]
    map[pos]=nil
    map[newpos]=🐴
    end
end

map[posstr(26+1+2,3+4-2+1+2)]={'🐴',f=🐴_wander,t=function(🐴) start_dialogue('baobab_craft') end}
map[posstr(24*2-12-2+2,3+4-5+1+2)]={'🐴',f=🐴_wander,t=function(🐴) 
if not 🐴.diag then 🐴.diag=1 end
local prog={'baobab_boo','baobab_oob','baobab_abba'}
start_dialogue(prog[🐴.diag])
🐴.diag=🐴.diag+1
if 🐴.diag>3 then 🐴.diag=1 end 
end}
map[posstr(24*2-7+2,3+4-2+2+1)]={'🐴',f=🐴_wander,t=function(🐴) start_dialogue('baobab_dungeon') end}

function map_empty()
    for my=cam.y,cam.y+12-1 do
    for mx=cam.x,cam.x+24-1 do
        if map[posstr(mx,my)] then return false end
    end
    end
    return true
end

function cavegen()
    for y=cam.y,cam.y+12-1 do for x=cam.x,cam.x+24-1 do
        if perlin(y*.35,x*.35,24724)<0.5 then
        map[posstr(x,y)]= {'⛰️'}
        end
    end end
    filled={}
    for y=cam.y,cam.y+12-1 do for x=cam.x,cam.x+24-1 do
        if not map[posstr(x,y)] and not findany(filled,posstr(x,y)) then
            floodfill(x,y)
        end
    end end
    for i,v in ipairs(filled) do
        print(fmt('section %d has %d open tiles',i,#v))
    end
    local s=random(#filled[1])
    local spawnpoint=filled[1][s]
    rem(filled[1],s)
    -- player is still standing upstairs
    map[spawnpoint]={'🔼',entry=posstr(😋.x,😋.y)}
    map[posstr(😋.x,😋.y)].entry=spawnpoint
    local sx,sy=strpos(spawnpoint)
    😋.x=sx; 😋.y=sy
    s=random(#filled[1])
    local downstairs=filled[1][s]
    rem(filled[1],s)
    map[downstairs]={'🔽'}
    for i=1,random(3) do
        s=random(#filled[1])
        local 🐍pos=filled[1][s]
        rem(filled[1],s)
        map[🐍pos]={'🐍',f=🐍_ai} 
    end
end

function 🐍_ai(pos)
    local 🐍=map[pos]
    print(fmt('snek @ %s',pos))
    if 🐍.state==nil then
    local mx,my=strpos(pos)
    local newpos=posstr(mx+random(-1,1),my+random(-1,1))
    if not map[newpos] and not 😋collide(newpos) and not oob(newpos) then
    map[pos]=nil
    map[newpos]=🐍
    enemy_raycast(newpos)
    else
    enemy_raycast(pos)
    end
    elseif 🐍.state=='located' then
        if #🐍.path>0 then
            local nextpos=🐍.path[1]
            if not map[nextpos] or map[nextpos].path then
                rem(🐍.path,1)
                map[pos]=nil
                map[nextpos]=🐍
                print(fmt('snek @ %s walks into %s',pos,nextpos))
                if 😋adjacent(nextpos) then
                    local dmg=random(2)
                    shout(fmt('The 🐍 bites you for %d damage!',dmg))
                    😋.hp=😋.hp-dmg
                    enemy_raycast(nextpos)
                end
            end
        else
            print(fmt('snek @ %s is bored.',pos))
            🐍.state=nil
            🐍.path=nil
            🐍_ai(pos)
            return
        end
    end
end

filled={}
function floodfill(cx,cy)
    local out={posstr(cx,cy)}
    for i,v in ipairs(out) do
        local px,py=strpos(v)
        if px-1>=cam.x and not map[posstr(px-1,py)] and not find(out,posstr(px-1,py)) then ins(out,posstr(px-1,py)) end
        if px-1>=cam.x and py-1>=cam.y and not map[posstr(px-1,py-1)] and not find(out,posstr(px-1,py-1)) then ins(out,posstr(px-1,py-1)) end
        if py-1>=cam.y and not map[posstr(px,py-1)] and not find(out,posstr(px,py-1)) then ins(out,posstr(px,py-1)) end
        if px+1<cam.x+24 and py-1>=cam.y and not map[posstr(px+1,py-1)] and not find(out,posstr(px+1,py-1)) then ins(out,posstr(px+1,py-1)) end
        if px+1<cam.x+24 and not map[posstr(px+1,py)] and not find(out,posstr(px+1,py)) then ins(out,posstr(px+1,py)) end
        if px+1<cam.x+24 and py+1<cam.y+12 and not map[posstr(px+1,py+1)] and not find(out,posstr(px+1,py+1)) then ins(out,posstr(px+1,py+1)) end
        if py+1<cam.y+12 and not map[posstr(px,py+1)] and not find(out,posstr(px,py+1)) then ins(out,posstr(px,py+1)) end
        if px-1>=cam.x and py+1<cam.y+12 and not map[posstr(px-1,py+1)] and not find(out,posstr(px-1,py+1)) then ins(out,posstr(px-1,py+1)) end
    end
    ins(filled,out)
    table.sort(filled,function(a,b) return #a>#b end)
end