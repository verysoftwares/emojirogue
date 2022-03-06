-- file linking.
    -- in-engine stuff
        utf8= require 'utf-8'
        require 'load'
        require 'alias'
        require 'utility'
    -- world
        require 'space'
        require 'perlin'
    -- game data
        require 'dex'
        require 'update'
        require 'draw'

t = 0
-- runtime.
    print(fmt('made by emuurom collective with Löve %d.%d', love.getVersion()))