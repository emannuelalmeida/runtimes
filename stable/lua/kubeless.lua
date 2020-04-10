local pegasus = require 'pegasus'

local server = pegasus:new({ port='9090' })

server:start(function (req, rep)

    if req.path() == '/healthz' then 
        rep:write("OK")
    end

    rep:write('Testing pegasus and kubeless')

end)