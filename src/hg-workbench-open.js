'use babel'

let CompositeDisposable
let exec
let path

CompositeDisposable = require('atom').CompositeDisposable

exec = require('child_process').exec

path = require('path')

export default {
  subscriptions: null,
  config: {
    notify: {
      title: 'Show notifications',
      description: 'Enables notifications for when a file has been opened in Hg Workbench.',
      type: 'boolean',
      'default': 'false'
    },
    executable: {
      title: "Tortoise HG workbench path",
      description: "The path of the executable",
      type: "string",
      default: "/usr/bin/thg"
    }
  },
  activate () {
    this.subscriptions = new CompositeDisposable()
    return this.subscriptions.add(atom.commands.add('atom-workspace', {
      'hg-workbench-open:toggle': ((_this => () => _this.opener()))(this)
    }))
  },
  deactivate () {
    return this.subscriptions.dispose()
  },
  opener () {
    let listTree
    let notify
    let pathName
    let pieces
    let selected = atom.config.get('hg-workbench-open.notify')
    let executable = atom.config.get("hg-workbench-open.executable")
    listTree = document.querySelector('.tree-view')
    selected = listTree.querySelectorAll(
      '.selected > .header > span, .selected > span')
    if (selected.length === 1) {
      pieces = selected[0].dataset.path.split(path.sep)
      pieces.splice(pieces.length, 1)
      pathName = pieces.join(path.sep)
      if (path.extname(pathName).trim() !== '') {
        pieces.splice(pieces.length - 1, 1)
        pathName = pieces.join(path.sep)
      }
      if (notify) {
        atom.notifications.addSuccess(`Opening ${pathName} in TortoiseHg`, {
          'dismissable': true
        })
      }
      return exec(executable + `-R "${pathName}"`)
    } else {
      if (notify) {
        return atom.notifications.addWarning(
          'Error, no/too many folders selected.', {
            'dismissable': true
          })
      }
    }
  }
}
