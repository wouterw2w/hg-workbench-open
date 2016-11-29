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
    listTree = document.querySelector('.tree-view')
    selected = listTree.querySelectorAll('.selected > .header > span, .selected > span')
    if selected.length == 1
      pieces = selected[0].dataset.path.split(path.sep)
      name = pieces[pieces.length - 1].replace(".", "-")
      pieces.splice(pieces.length, 1)
      pathName = pieces.join(path.sep)
      extname = path.extname(pathName).trim()
      if extname == ''
        console.log("Opening " + pathName + " in TortoiseHg")
        exec("thgw.exe -R \"" + pathName + "\"")
      else
        pieces.splice(pieces.length - 1, 1)
        pathName = pieces.join(path.sep)
        console.log("Opening " + pathName + " in TortoiseHg")
        exec("thgw.exe -R \"" + pathName + "\"")
    else
      console.log("Error, no/too many folders selected.")