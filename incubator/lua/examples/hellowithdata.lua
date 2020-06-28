function handler(event, context)
    for key, value in pairs(event) do
        print(key, value)
    end
    return event["data"]["status"]
end