require("util")
local cjson = require("cjson")

local mod_name = os.getenv("MOD_NAME") ~= nil and os.getenv("MOD_NAME") or ""
local func_handler = os.getenv("FUNC_HANDLER") ~= nil and os.getenv("FUNC_HANDLER") or ""
local runtime = os.getenv("RUNTIME") ~= nil and os.getenv("RUNTIME") or ""
local memory_limit = os.getenv("MEMORY_LIMIT") ~= nil and os.getenv("MEMORY_LIMIT") or ""
local mod_root_path = os.getenv("MOD_ROOT_PATH") ~= nil and os.getenv("MOD_ROOT_PATH") or "/kubeless/"
local mod_path = mod_root_path .. "/" .. mod_name .. ".lua"
local func_timeout = os.getenv("FUNC_TIMEOUT") ~= nil and os.getenv("FUNC_TIMEOUT") or "180"
local ftimeout = tonumber(func_timeout)

-- For now that's how we read the headers, cause of the underscore issue
headers = breakHeaders(ngx.req.raw_header())

--Here it reads the body from the request
ngx.req.read_body()

if headers["Content-Type"] == 'application/json' then
    data = cjson.decode(ngx.req.get_body_data())
else
    data = ngx.req.get_post_args()
end

event = {
    ["event-id"]=headers["HTTP_EVENT_ID"],
    ["event-type"]=headers["HTTP_EVENT_TYPE"],
    ["event-time"]=headers["HTTP_EVENT_TIME"],
    ["event-namespace"]=headers["HTTP_EVENT_NAMESPACE"],
    data= data,
    extensions= {
        request=ngx.req
    }
}

context = {
    ["function-name"] = func_handler,
    ["timeout"] = func_timeout,
    ["runtime"] = runtime,
    ["memory-limit"] = memory_limit
}

if pcall(function()
    mod = require(mod_name)
    output = _G[func_handler](event, context)
end) then 
    ngx.say(output)
else
    ngx.say("Error while trying to execute: " .. mod_name .. "." .. func_handler .. ".")
    ngx.exit(ngx.HTTP_BAD_REQUEST)
end

