local function breakHeaders(raw)
    ngx.say(raw)
    headers = {}
    for k, v in string.gmatch(raw, "([%w_]+):%s([%w_/]+)") do
        print (k)
        print (v)
        headers[k] = v
    end

    return headers
end

--local mod_name = os.getenv("MOD_NAME")
-- func_handler = os.getenv("FUNC_HANDLER")
--local runtime = os.getenv("RUNTIME")
--local memory_limit = os.getenv("MEMORY_LIMIT")
local mod_root_path = os.getenv("MOD_ROOT_PATH") ~= nil and os.getenv("MOD_ROOT_PATH") or "/kubeless/"
--local mod_path = mod_root_path .. "/" .. mod_name .. ".lua"
local func_timeout = os.getenv("FUNC_TIMEOUT") ~= nil and os.getenv("FUNC_TIMEOUT") or "180"
local ftimeout = tonumber(func_timeout)
--print(mod_path)
--print (os.getenv("MOD_ROOT_PATH"))


headers = breakHeaders(ngx.req.raw_header())
ngx.say()

event = {
    ["event-id"]=headers["HTTP_EVENT_ID"],
    ["event-type"]=headers["HTTP_EVENT_TYPE"],
    ["event-time"]=headers["HTTP_EVENT_TIME"],
    ["event-namespace"]=headers["HTTP_EVENT_NAMESPACE"],
    --data= data,
    --extensions= {
    --    request=req
    -- }
}


context = {
    ["function-name"] = func_handler,
    ["timeout"] = func_timeout,
    ["runtime"] = runtime,
    ["memory-limit"] = memory_limit
}



--local mod = loadfile(mod_path)

--mod(event, context)
print "Let's see what's going on here..."

ngx.say("OK")
--local headers = { ["Content-type"] = "text/html" }
