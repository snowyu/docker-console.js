_       = require 'lodash'
Table   = require 'cli-table'
nodedm  = require 'nodedm'
dm      = nodedm.dm

toTable = (aMachines, aNameOnly, style)->
  style ?=
    head:['blue']
    border: ['grey']

  if aNameOnly
    vHead = ['Number', 'NAME']
  else
    vHead = ['Number', 'NAME', 'ACTIVE', 'DRIVER', 'STATE', 'URL', 'SWARM']

  result = new Table
    head: vHead
    style: style

  for m, id in aMachines
    if _.isObject m
      result.push [id, m.name, m.active, m.driver, m.state, m.url, m.swarm]
    else
      result.push [id, m]
  result

module.exports = (aNameOnly, done)->
  dm.ls(aNameOnly).then (machines)->
    result = toTable(machines, aNameOnly)
    done(result.toString())
