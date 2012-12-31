http = require 'http'
httpProxy = require 'http-proxy'
urlParser = require 'url'

allowedHosts = [
    "yahoo.co.jp",
    "google.co.jp",
]

proxyServer = httpProxy.createServer (req, res, proxy)->
    ua = req.headers['user-agent']
    url = urlParser.parse req.url

    isIe6 = (ua)->
        flag = false
        unless ua.indexOf('MSIE 6.0') == -1 then flag = true
        flag

    requestHost = (url)->
        hostname = url.hostname
        unless url.port?
            portnum = 80
        else
            portnum = url.port
        target =
            host: hostname
            port: portnum
        proxy.proxyRequest req, res, target

    if isIe6(ua)
        flag = false
        for allowed in allowedHosts
            unless url.hostname.indexOf(allowed) == -1
                flag = true
                break
        if flag
            requestHost url
        else
            res.writeHead 403, { 'Content-Type': 'text/plain' }
            res.end 'Forbidden'
    else
        requestHost url

proxyServer.listen 6666

