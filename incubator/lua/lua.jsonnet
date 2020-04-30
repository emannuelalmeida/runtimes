{
    ID: 'lua',
    versions:
    [{ name: 'luaJiT',
        version: '2.1',
        images: [{
            phase: "runtime",
            image: "emannuelalmeida/lua@sha256:8a0cd9942c98072724f02881bd401718da9bda55d4bb6bcc6419e2124dfacd07",
            env: {
            },
        }],
    },],
    depName: '.rockspec',
    fileNameSuffix: '.lua',
}