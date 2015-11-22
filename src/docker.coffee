module.exports = docker = require './commands'

docker.connect = require './commands/connect'
docker.lm      = require './commands/list-machine'