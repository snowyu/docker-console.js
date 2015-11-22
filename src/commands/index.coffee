# get or set the global docker instance.
Docker = require('dockerode')
defaultHost     = '/var/run/docker.sock'
defaultUrl      = 'unix://' + defaultHost

dockerInstance = new Docker

module.exports = docker = ->
  dockerInstance

docker.host = defaultUrl
docker.set = (aDocker)->
  if aDocker instanceof Docker
    dockerInstance = aDocker
  dockerInstance