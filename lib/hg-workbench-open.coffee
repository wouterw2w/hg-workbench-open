{CompositeDisposable} = require 'atom'
exec = require('child_process').exec
path = require('path')

module.exports =
  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'hg-workbench-open:toggle': => @opener()

  deactivate: ->
    @subscriptions.dispose()

  opener: ->
    editor = atom.workspace.getActivePaneItem()
    file = editor?.buffer?.file
    pathName = path.dirname(file?.path)
    if editor = atom.workspace.getActiveTextEditor()
      console.log("Opening " + pathName + " in TortoiseHg")
      exec("thgw.exe -R \"" + pathName + "\"")