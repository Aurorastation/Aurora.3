/**
 * Browser-agnostic abstraction of key-value web storage.
 *
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

export const IMPL_MEMORY = 0;
export const IMPL_HUB_STORAGE = 1;
export const IMPL_INDEXED_DB = 2;
export const IMPL_IFRAME_INDEXED_DB = 3;

const INDEXED_DB_VERSION = 1;
const INDEXED_DB_NAME = 'tgui';
const INDEXED_DB_STORE_NAME = 'storage-v1';

const READ_ONLY = 'readonly';
const READ_WRITE = 'readwrite';

const testGeneric = (testFn) => () => {
  try {
    return Boolean(testFn());
  } catch {
    return false;
  }
};

const testHubStorage = testGeneric(
  () => window.hubStorage && window.hubStorage.getItem
);

// TODO: Remove with 516
// prettier-ignore
const testIndexedDb = testGeneric(() => (
  (window.indexedDB || window.msIndexedDB)
  && (window.IDBTransaction || window.msIDBTransaction)
));

class MemoryBackend {
  constructor() {
    this.impl = IMPL_MEMORY;
    this.store = {};
  }

  async get(key) {
    return this.store[key];
  }

  async set(key, value) {
    this.store[key] = value;
  }

  async remove(key) {
    this.store[key] = undefined;
  }

  async clear() {
    this.store = {};
  }
}

class HubStorageBackend {
  constructor() {
    this.impl = IMPL_HUB_STORAGE;
  }

  async get(key) {
    const value = await window.hubStorage.getItem('aurora-' + key);
    if (typeof value === 'string') {
      return JSON.parse(value);
    }
  }

  async set(key, value) {
    window.hubStorage.setItem('aurora-' + key, JSON.stringify(value));
  }

  async remove(key) {
    window.hubStorage.removeItem('aurora-' + key);
  }

  async clear() {
    window.hubStorage.clear();
  }
}

class IFrameIndexedDbBackend {
  constructor() {
    this.impl = IMPL_IFRAME_INDEXED_DB;
  }

  async ready() {
    const iframe = document.createElement('iframe');
    iframe.style.display = 'none';
    iframe.src = Byond.storageCdn;

    const completePromise = new Promise((resolve) => {
      iframe.onload = () => resolve(this);
    });

    this.documentElement = document.body.appendChild(iframe);
    this.iframeWindow = this.documentElement.contentWindow;

    return completePromise;
  }

  async get(key) {
    const promise = new Promise((resolve) => {
      window.addEventListener('message', (message) => {
        if (message.data.key && message.data.key === key) {
          resolve(message.data.value);
        }
      });
    });

    this.iframeWindow.postMessage({ type: 'get', key: key }, '*');
    return promise;
  }

  async set(key, value) {
    this.iframeWindow.postMessage({ type: 'set', key: key, value: value }, '*');
  }

  async remove(key) {
    this.iframeWindow.postMessage({ type: 'remove', key: key }, '*');
  }

  async clear() {
    this.iframeWindow.postMessage({ type: 'clear' }, '*');
  }

  async ping() {
    const promise = new Promise((resolve) => {
      window.addEventListener('message', (message) => {
        if (message.data === true) {
          resolve(true);
        }
      });

      setTimeout(() => resolve(false), 100);
    });

    this.iframeWindow.postMessage({ type: 'ping' }, '*');
    return promise;
  }

  async processChatMessages(messages) {
    this.iframeWindow.postMessage(
      { type: 'processChatMessages', messages: messages },
      '*'
    );
  }

  async getChatMessages() {
    const promise = new Promise((resolve) => {
      window.addEventListener('message', (message) => {
        if (message.data.messages) {
          resolve(message.data.messages);
        }
      });
    });

    this.iframeWindow.postMessage({ type: 'getChatMessages' }, '*');
    return promise;
  }

  async setNumberStored(number) {
    this.iframeWindow.postMessage(
      { type: 'setNumberStored', newMax: number },
      '*'
    );
  }

  async destroy() {
    document.body.removeChild(this.documentElement);
    this.documentElement = null;
    this.iframeWindow = null;
  }
}

class IndexedDbBackend {
  // TODO: Remove with 516
  constructor() {
    this.impl = IMPL_INDEXED_DB;
    /** @type {Promise<IDBDatabase>} */
    this.dbPromise = new Promise((resolve, reject) => {
      const indexedDB = window.indexedDB || window.msIndexedDB;
      const req = indexedDB.open(INDEXED_DB_NAME, INDEXED_DB_VERSION);
      req.onupgradeneeded = () => {
        try {
          req.result.createObjectStore(INDEXED_DB_STORE_NAME);
        } catch (err) {
          reject(new Error('Failed to upgrade IDB: ' + req.error));
        }
      };
      req.onsuccess = () => resolve(req.result);
      req.onerror = () => {
        reject(new Error('Failed to open IDB: ' + req.error));
      };
    });
  }

  async getStore(mode) {
    // prettier-ignore
    return this.dbPromise.then((db) => db
      .transaction(INDEXED_DB_STORE_NAME, mode)
      .objectStore(INDEXED_DB_STORE_NAME));
  }

  async get(key) {
    const store = await this.getStore(READ_ONLY);
    return new Promise((resolve, reject) => {
      const req = store.get(key);
      req.onsuccess = () => resolve(req.result);
      req.onerror = () => reject(req.error);
    });
  }

  async set(key, value) {
    // NOTE: We deliberately make this operation transactionless
    const store = await this.getStore(READ_WRITE);
    store.put(value, key);
  }

  async remove(key) {
    // NOTE: We deliberately make this operation transactionless
    const store = await this.getStore(READ_WRITE);
    store.delete(key);
  }

  async clear() {
    // NOTE: We deliberately make this operation transactionless
    const store = await this.getStore(READ_WRITE);
    store.clear();
  }
}

/**
 * Web Storage Proxy object, which selects the best backend available
 * depending on the environment.
 */
export class StorageProxy {
  constructor() {
    this.backendPromise = (async () => {
      if (!Byond.TRIDENT) {
        if (Byond.storageCdn) {
          const iframe = new IFrameIndexedDbBackend();
          await iframe.ready();

          if ((await iframe.ping()) === true) {
            return iframe;
          }

          iframe.destroy();
        }

        if (!testHubStorage()) {
          Byond.winset(null, 'browser-options', '+byondstorage');

          return new Promise((resolve) => {
            const listener = () => {
              document.removeEventListener('byondstorageupdated', listener);
              resolve(new HubStorageBackend());
            };

            document.addEventListener('byondstorageupdated', listener);
          });
        }
        return new HubStorageBackend();
      }
      // TODO: Remove with 516
      if (testIndexedDb()) {
        try {
          const backend = new IndexedDbBackend();
          await backend.dbPromise;
          return backend;
        } catch {}
      }
      console.warn(
        'No supported storage backend found. Using in-memory storage.'
      );
      return new MemoryBackend();
    })();
  }

  async get(key) {
    const backend = await this.backendPromise;
    return backend.get(key);
  }

  async set(key, value) {
    const backend = await this.backendPromise;
    return backend.set(key, value);
  }

  async remove(key) {
    const backend = await this.backendPromise;
    return backend.remove(key);
  }

  async clear() {
    const backend = await this.backendPromise;
    return backend.clear();
  }
}

export const storage = new StorageProxy();
