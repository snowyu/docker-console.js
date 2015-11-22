Shell       = require 'shell'
cmdConnect  = require './commands/connect'
docker      = require './docker'

conn = (host, tlsVerify, certPath)->
  docker.connect(host, tlsVerify, certPath)
  app.set('prompt', docker.host+'>')

app = new Shell
  chdir: __dirname
  prompt: docker.host+'>'

app.configure ->
  app.set 'title', 'the docker console'

  app.use Shell.history
    shell: app
  app.use Shell.router
    shell: app
  app.use Shell.completer
    shell: app
  app.use Shell.error
    shell: app
  app.use Shell.help
    shell: app
    introduction: true

app.on 'quit', -> process.exit()

app.cmd 'echo :data', 'echo the params', (req, res, done)->
  console.log(req.params)
  res.prompt()

app.cmd 'prompt :prompt', 'change the prompt', (req, res, done)->
  app.set('prompt', req.params.prompt)
  res.prompt()

app.cmd 'lm', 'list all machines', (req, res, done)->
  docker.lm null, (result, err)->
    throw new err if err
    res.print(result).ln()
    done()

app.cmd 'connect :host', 'connect to the docker host', (req, res, done)->
  console.log('connect to:', req.params.host)
  conn(req.params.host)

app.cmd 'connect :host, :certPath', 'connect to the docker host with certPath', (req, res, done)->
  console.log('connect to:', req.params)
  conn(req.params.host, true, req.params.certPath)
  res.prompt()
