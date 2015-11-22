fs              = require 'fs'
path            = require 'path'
_               = require 'lodash'
Docker          = require 'dockerode'
docker          = require './'
defaultHost     = '/var/run/docker.sock'
defaultUrl      = 'unix://' + defaultHost

DOCKER_HOST       = process.env.DOCKER_HOST
DOCKER_TLS_VERIFY = process.env.DOCKER_TLS_VERIFY
DOCKER_CERT_PATH  = process.env.DOCKER_CERT_PATH

if DOCKER_TLS_VERIFY
  DOCKER_TLS_VERIFY = switch DOCKER_TLS_VERIFY[0]
    when '0', 'f', 'n' then false
    when '1', 't', 'y', 'o' then true


genOptions = (aHost, aIsTLSVerify, aCertPath)->
  result = {}
  aHost = DOCKER_HOST || defaultUrl unless aHost
  aIsTLSVerify = DOCKER_TLS_VERIFY unless aIsTLSVerify
  aCertPath = DOCKER_CERT_PATH unless aCertPath

  if aHost.indexOf('unix://') == 0
    result.socketPath = aHost.substring(7) || defaultHost
  else
    vSplit = /(?:tcp:\/\/)?(.*?):([0-9]+)/g.exec(aHost)
    if !vSplit or vSplit.length != 3
      throw new Error('the docker host should be something like tcp://localhost:1234')
    result.port = vSplit[2]
    result.protocol = 'http'
    if aIsTLSVerify or result.port == '2376'
      result.protocol += 's'
    result.host = vSplit[1]
    if aCertPath
      result.ca    = fs.readFileSync path.join(aCertPath, 'ca.pem')
      result.cert  = fs.readFileSync path.join(aCertPath, 'cert.pem')
      result.key   = fs.readFileSync path.join(aCertPath, 'key.pem')
  docker.host = aHost
  return result

module.exports  = (aHost, aIsTLSVerify, aCertPath)->
  docker.set new Docker genOptions(aHost, aIsTLSVerify, aCertPath)
