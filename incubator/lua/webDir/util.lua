function breakHeaders(raw)
    headers = {}
    for k, v in string.gmatch(raw, "([%w_-]+):%s([%w_/]+)") do
        headers[k] = v
    end

    return headers
end
