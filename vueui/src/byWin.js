import Utils from './utils'
import Vector from './vector'

const state = {
  windowKey: '',
  dragging: false,
  resizing: false,
  screenOffset: [0, 0],
  dragPointOffset: null,
  resizeMatrix: null,
  initialSize: null,
  size: null,
}

export function isBYOND() {
  return (
    window.location.hostname === '127.0.0.1' && location.pathname.indexOf('/tmp') === 0 && location.search !== '?ext'
  )
}

export function winget(id, propName, callback) {
  if (!isBYOND()) return
  var isArray = propName instanceof Array
  var isSpecific = propName && propName !== '*' && !isArray
  var _callback = callback
  if (isSpecific) {
    _callback = props => {
      return callback(props[propName])
    }
  }
  Utils.sendRawWithCallback(
    'byond://winget',
    {
      id: id,
      property: (isArray && propName.join(',')) || propName || '*',
    },
    _callback
  )
}

export function winset(id, propName, propValue) {
  if (!isBYOND()) return
  if (typeof id === 'object' && id !== null) {
    return Utils.sendRaw('winset', id)
  }
  let props = {}
  if (typeof propName === 'string') {
    props[propName] = propValue
  } else {
    Object.assign(props, propName)
  }
  props.id = id
  return Utils.sendRaw('byond://winset', props)
}

export const setWindowKey = key => (state.windowKey = key)

export const getWindowPosition = () => [window.screenLeft, window.screenTop]

export const getWindowSize = () => [window.innerWidth, window.innerHeight]

export function setWindowPosition(pos = [0, 0]) {
  const byondPos = Vector.add(pos, state.screenOffset)
  winset(state.windowKey, {
    pos: byondPos[0] + ',' + byondPos[1],
  })
}

export function setWindowSize(size = [300, 300]) {
  winset(state.windowKey, {
    size: size[0] + 'x' + size[1],
  })
}

export const getScreenPosition = () => Vector.scale(state.screenOffset, -1)

export const getScreenSize = () => [window.screen.availWidth, window.screen.availHeight]

export function setupDrag() {
  winget(state.windowKey, 'pos', pos => {
    state.screenOffset = [pos.x - window.screenLeft, pos.y - window.screenTop]
  })
}

export function dragStartHandler(event) {
  state.dragging = true
  state.dragPointOffset = [window.screenLeft - event.screenX, window.screenTop - event.screenY]

  event.target?.setCapture()
  event.target?.focus()
  dragMoveHandler(event)
  event.target.addEventListener('mousemove', dragMoveHandler)
}

export function dragEndHandler(event) {
  event.target.removeEventListener('mousemove', dragMoveHandler)
  event.target.releaseCapture()
  document.getElementById('content').focus()
  state.dragging = false
}

export function dragMoveHandler(event) {
  if (!state.dragging) {
    return
  }
  event.preventDefault()
  setWindowPosition(Vector.add([event.screenX, event.screenY], state.dragPointOffset))
}

export function resizeStartHandler(x, y, event) {
  state.resizeMatrix = [x, y]
  state.resizing = true
  state.dragPointOffset = [window.screenLeft - event.screenX, window.screenTop - event.screenY]
  state.initialSize = [window.innerWidth, window.innerHeight]
  // Focus click target
  //event.target?.focus()
  document.addEventListener('mousemove', resizeMoveHandler)
  document.addEventListener('mouseup', resizeEndHandler)
  resizeMoveHandler(event)
}

export function resizeEndHandler(event) {
  resizeMoveHandler(event)
  document.removeEventListener('mousemove', resizeMoveHandler)
  document.removeEventListener('mouseup', resizeEndHandler)
  document.getElementById('content').focus()
  state.resizing = false
}

export function resizeMoveHandler(event) {
  if (!state.resizing) {
    return
  }
  event.preventDefault()
  let mul = Vector.multiply(
    state.resizeMatrix,
    Vector.add(
      [event.screenX, event.screenY],
      Vector.scale([window.screenLeft, window.screenTop], -1),
      state.dragPointOffset,
      [1, 1]
    )
  )
  state.size = Vector.add(state.initialSize, mul)
  // Sane window size values
  state.size[0] = Math.max(state.size[0], 100)
  state.size[1] = Math.max(state.size[1], 50)
  setWindowSize(state.size)
}

export function setVisibility(visible = 1) {
  winset(state.windowKey, {
    'is-visible': visible,
  })
}

export default {
  isBYOND,
  winget,
  winset,
  setWindowKey,
  getWindowPosition,
  getWindowSize,
  setWindowPosition,
  setWindowSize,
  getScreenPosition,
  getScreenSize,
  setupDrag,
  dragStartHandler,
  dragEndHandler,
  dragMoveHandler,
  resizeStartHandler,
  resizeEndHandler,
  resizeMoveHandler,
  setVisibility,
}
