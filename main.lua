-- file linking.
    -- in-engine stuff
        utf8= require 'utf-8'
        require 'load'
        require 'alias'
        require 'utility'
    -- world
        require 'dex'
        require 'space'
        require 'perlin'
    -- game data
        require 'update'
        require 'draw'

t = 0
-- runtime.
    print(fmt('made by verysoftwares with LOVE %d.%d', love.getVersion()))