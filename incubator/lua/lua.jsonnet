{
    ID: 'lua',
    versions:
    [{ name: 'luaJiT',
        version: '2.1',
        images: [{
            phase: "runtime",
            image: "emannuelalmeida/lua@sha256:03f1c85e359045e1e246445fb6a1fc00b708e541d4c584fb6992acedb29bafe4",
            env: {
            },
        }],
    },],
    depName: '.rockspec',
    fileNameSuffix: '.lua',
}