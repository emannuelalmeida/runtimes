local hcgi = require "xavante.cgiluahandler"
local hredir = require "xavante.redirecthandler"
local xavante = require "xavante"

local webDir = XAVANTE_WEB
local simplerules = {

    { -- Healthz mapping
        match = "^/healthz$",
        with = hredir,
        params = {"healthz.lp"}
    },

    { -- Regular mapping to run a file
        match = "^[^%./]*/$",
        with = hredir,
        params = {"index.lp"}
    },

    {
        match = {"%.lp$", "%.lp/.*$", "%.lua$", "%.lua/.*$" },
        with = hcgi.makeHandler (webDir)
    },
}

xavante.HTTP{
    server = {host = "*", port = 9090},
    
    defaultHost = {
    	rules = simplerules
    },
}

xavante.start()
