/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { vecAdd, vecInverse, vecMultiply, vecScale } from './vector.js';
import { storage } from './storage.js';

window.Byond = (function () {
    var Byond = {};
    // Utility functions
    var hasOwn = Object.prototype.hasOwnProperty;
    var assign = function (target) {
      for (var i = 1; i < arguments.length; i++) {
        var source = arguments[i];
        for (var key in source) {
          if (hasOwn.call(source, key)) {
            target[key] = source[key];
          }
        }
      }
      return target;
    };
    // Trident engine version
    var tridentVersion = (function () {
      var groups = navigator.userAgent.match(/Trident\/(\d+).+?;/i);
      var majorVersion = groups && groups[1];
      return majorVersion
        ? parseInt(majorVersion, 10)
        : null;
    })();
    // Basic checks to detect whether this page runs in BYOND
    var isByond = tridentVersion !== null
      && location.hostname === '127.0.0.1'
      && location.pathname.indexOf('/tmp') === 0
      && location.search !== '?external';
  
    // Version constants
    Byond.IS_BYOND = isByond;
    Byond.IS_LTE_IE8 = tridentVersion !== null && tridentVersion <= 4;
    Byond.IS_LTE_IE9 = tridentVersion !== null && tridentVersion <= 5;
    Byond.IS_LTE_IE10 = tridentVersion !== null && tridentVersion <= 6;
    Byond.IS_LTE_IE11 = tridentVersion !== null && tridentVersion <= 7;
  
    // Callbacks for asynchronous calls
    Byond.__callbacks__ = [];

    // Makes a BYOND call.
    // See: https://secure.byond.com/docs/ref/skinparams.html
    Byond.call = function (path, params) {
      // Not running in BYOND, abort.
      if (!isByond) {
        return;
      }
      // Build the URL
      var url = (path || '') + '?';
      var i = 0;
      if (params) {
        for (var key in params) {
          if (hasOwn.call(params, key)) {
            if (i++ > 0) {
              url += '&';
            }
            var value = params[key];
            if (value === null || value === undefined) {
              value = '';
            }
            url += encodeURIComponent(key)
              + '=' + encodeURIComponent(value)
          }
        }
      }
      // Perform a standard call via location.href
      if (url.length < 2048) {
        location.href = 'byond://' + url;
        return;
      }
      // Send an HTTP request to DreamSeeker's HTTP server.
      // Allows sending much bigger payloads.
      var xhr = new XMLHttpRequest();
      xhr.open('GET', url);
      xhr.send();
    };
  
    Byond.callAsync = function (path, params) {
      if (!window.Promise) {
        throw new Error('Async calls require API level of ES2015 or later.');
      }
      var index = Byond.__callbacks__.length;
      var promise = new window.Promise(function (resolve) {
        Byond.__callbacks__.push(resolve);
      });
      Byond.call(path, assign({}, params, {
        callback: 'Byond.__callbacks__[' + index + ']',
      }));
      return promise;
    };
  
    Byond.topic = function (params) {
      return Byond.call('', params);
    };
  
    Byond.command = function (command) {
      return Byond.call('winset', {
        command: command,
      });
    };
  
    Byond.winget = function (id, propName) {
      var isArray = propName instanceof Array;
      var isSpecific = propName && propName !== '*' && !isArray;
      var promise = Byond.callAsync('winget', {
        id: id,
        property: isArray && propName.join(',') || propName || '*',
      });
      if (isSpecific) {
        promise = promise.then(function (props) {
          return props[propName];
        });
      }
      return promise;
    };

    Byond.winset = function (id, propName, propValue) {
      if (typeof id === 'object' && id !== null) {
        return Byond.call('winset', id);
      }
      var props = {};
      if (typeof propName === 'string') {
        props[propName] = propValue;
      }
      else {
        assign(props, propName);
      }
      props.id = id;
      return Byond.call('winset', props);
    };
  
    return Byond;
  })();
  
  let windowKey = window.__windowId__;
  let dragging = false;
  let resizing = false;
  let screenOffset = [0, 0];
  let screenOffsetPromise;
  let dragPointOffset;
  let resizeMatrix;
  let initialSize;
  let size;

  export const setWindowKey = key => {
    windowKey = key;
  };
  
  export const getWindowPosition = () => [
    window.screenLeft,
    window.screenTop,
  ];
  
  export const getWindowSize = () => [
    window.innerWidth,
    window.innerHeight,
  ];
  
  export const setWindowPosition = vec => {
    const byondPos = vecAdd(vec, screenOffset);
    return window.Byond.winset(window.__windowId__, {
      pos: byondPos[0] + ',' + byondPos[1],
    });
  };
  
  export const setWindowSize = vec => {
    return window.Byond.winset(window.__windowId__, {
      size: vec[0] + 'x' + vec[1],
    });
  };
  
  export const getScreenPosition = () => [
    0 - screenOffset[0],
    0 - screenOffset[1],
  ];
  
  export const getScreenSize = () => [
    window.screen.availWidth,
    window.screen.availHeight,
  ];
  
  /**
   * Moves an item to the top of the recents array, and keeps its length
   * limited to the number in `limit` argument.
   *
   * Uses a strict equality check for comparisons.
   *
   * Returns new recents and an item which was trimmed.
   */
  const touchRecents = (recents, touchedItem, limit = 50) => {
    const nextRecents = [touchedItem];
    let trimmedItem;
    for (let i = 0; i < recents.length; i++) {
      const item = recents[i];
      if (item === touchedItem) {
        continue;
      }
      if (nextRecents.length < limit) {
        nextRecents.push(item);
      }
      else {
        trimmedItem = item;
      }
    }
    return [nextRecents, trimmedItem];
  };
  
  export const storeWindowGeometry = async () => {
    const geometry = {
      pos: getWindowPosition(),
      size: getWindowSize(),
    };
    storage.set(windowKey, geometry);
    // Update the list of stored geometries
    const [geometries, trimmedKey] = touchRecents(
      await storage.get('geometries') || [],
      windowKey);
    if (trimmedKey) {
      storage.remove(trimmedKey);
    }
    storage.set('geometries', geometries);
  };
  
  export const recallWindowGeometry = async (options = {}) => {
    const geometry = await storage.get(windowKey);
    // let pos = geometry?.pos || options.pos;
    let pos = geometry?.pos;
    const size = options.size;
    // Set window size
    if (size) {
      setWindowSize(size);
    }
    // Set window position
    if (pos) {
      await screenOffsetPromise;
      setWindowPosition(pos);
    }
    // Set window position at the center of the screen.
    else if (size) {
      await screenOffsetPromise;
      const areaAvailable = [
        window.screen.availWidth - Math.abs(screenOffset[0]),
        window.screen.availHeight - Math.abs(screenOffset[1]),
      ];
      const pos = vecAdd(
        vecScale(areaAvailable, 0.5),
        vecScale(size, -0.5),
        vecScale(screenOffset, -1.0));
      setWindowPosition(pos);
    }
  };
  
  export const setupDrag = async () => {
    // Calculate screen offset caused by the windows taskbar
    screenOffsetPromise = window.Byond.winget(window.__windowId__, 'pos')
      .then(pos => [
        pos.x - window.screenLeft,
        pos.y - window.screenTop,
      ]);
    screenOffset = await screenOffsetPromise;
  };
  
  export const dragStartHandler = event => {
    dragging = true;
    dragPointOffset = [
      window.screenLeft - event.screenX,
      window.screenTop - event.screenY,
    ];
    // Focus click target
    event.target?.setCapture();
    event.target?.focus();
    dragMoveHandler(event);
    event.target.addEventListener('mousemove', dragMoveHandler);
  };
  
  export const dragEndHandler = event => {
    event.target.removeEventListener('mousemove', dragMoveHandler);
    event.target.releaseCapture();
    document.getElementById('content').focus();
    dragging = false;
    storeWindowGeometry();
  };
  
  const dragMoveHandler = event => {
    if (!dragging) {
      return;
    }
    event.preventDefault();
    setWindowPosition(vecAdd(
      [event.screenX, event.screenY],
      dragPointOffset));
  };
  
  export const resizeStartHandler = (x, y, event) => {
    resizeMatrix = [x, y];
    resizing = true;
    dragPointOffset = [
      window.screenLeft - event.screenX,
      window.screenTop - event.screenY,
    ];
    initialSize = [
      window.innerWidth,
      window.innerHeight,
    ];
    // Focus click target
    event.target?.focus();
    document.addEventListener('mousemove', resizeMoveHandler);
    document.addEventListener('mouseup', resizeEndHandler);
    resizeMoveHandler(event);
  };
  
  const resizeEndHandler = event => {
    resizeMoveHandler(event);
    document.removeEventListener('mousemove', resizeMoveHandler);
    document.removeEventListener('mouseup', resizeEndHandler);
    document.getElementById('content').focus();
    resizing = false;
    storeWindowGeometry();
  };
  
  const resizeMoveHandler = event => {
    if (!resizing) {
      return;
    }
    event.preventDefault();
    size = vecAdd(initialSize, vecMultiply(resizeMatrix, vecAdd(
      [event.screenX, event.screenY],
      vecInverse([window.screenLeft, window.screenTop]),
      dragPointOffset,
      [1, 1])));
    // Sane window size values
    size[0] = Math.max(size[0], 150);
    size[1] = Math.max(size[1], 50);
    setWindowSize(size);
  };
