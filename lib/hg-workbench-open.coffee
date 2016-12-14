{CompositeDisposable} = require 'atom'
exec = require('child_process').exec
path = require('path')

module.exports =
  subscriptions: null
  config: {
    notify: {
      title: 'Show notifications',
      description: 'Enables notifications for when a file has been opened in Hg Workbench.',
      type: 'boolean',
      default: 'false'
    }
  }

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'hg-workbench-open:toggle': => @opener()

  deactivate: ->
    @subscriptions.dispose()

  opener: ->
    notify = atom.config.get('hg-workbench-open.notify')
    editor = atom.workspace.getActivePaneItem()
    listTree = document.querySelector('.tree-view')
    selected = listTree.querySelectorAll('.selected > .header > span, .selected > span')
    if selected.length == 1
      pieces = selected[0].dataset.path.split(path.sep)
      name = pieces[pieces.length - 1].replace(".", "-")
      pieces.splice(pieces.length, 1)
      pathName = pieces.join(path.sep)
      extname = path.extname(pathName).trim()
      if extname != ''
        pieces.splice(pieces.length - 1, 1)
        pathName = pieces.join(path.sep)
      if notify
        atom.notifications.addSuccess 'Opening ' + pathName + ' in TortoiseHg', { 'dismissable': true }
      exec("thgw.exe -R \"" + pathName + "\"")
    else
      if notify
        atom.notifications.addWarning 'Error, no/too many folders selected.', { 'dismissable': true }