/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import DOMPurify from 'dompurify';
import { storage } from 'common/storage';
import { addHighlightSetting, importSettings, loadSettings, removeHighlightSetting, updateHighlightSetting, updateSettings } from '../settings/actions';
import { selectSettings } from '../settings/selectors';
import { addChatPage, changeChatPage, changeScrollTracking, clearChat, loadChat, rebuildChat, removeChatPage, saveChatToDisk, toggleAcceptedType, updateMessageCount } from './actions';
import { MESSAGE_SAVE_INTERVAL } from './constants';
import { createMessage, serializeMessage } from './model';
import { chatRenderer } from './renderer';
import { selectChat, selectCurrentChatPage } from './selectors';

// List of blacklisted tags
const FORBID_TAGS = ['a', 'iframe', 'link', 'video'];

const saveChatToStorage = async (store) => {
  const settings = selectSettings(store.getState());
  const state = selectChat(store.getState());

  if (!window.Storage && !Byond.TRIDENT) {
    const indexedDbBackend = await storage.backendPromise;
    indexedDbBackend.processChatMessages(chatRenderer.storeQueue);
  } else {
    const fromIndex = Math.max(
      0,
      chatRenderer.messages.length - settings.maxMessages
    );
    const messages = chatRenderer.messages
      .slice(fromIndex)
      .map((message) => serializeMessage(message));

    storage.set('chat-messages', messages);
  }

  chatRenderer.storeQueue = [];
  storage.set('chat-state', state);
};

const loadChatFromStorage = async (store) => {
  const state = await storage.get('chat-state');

  let messages;
  if (!window.Storage && !Byond.TRIDENT) {
    messages = await (await storage.backendPromise).getChatMessages();
  } else {
    messages = await storage.get('chat-messages');
  }

  // Discard incompatible versions
  if (state && state.version <= 4) {
    store.dispatch(loadChat());
    return;
  }
  if (messages) {
    for (let message of messages) {
      if (message?.html) {
        message.html = DOMPurify.sanitize(message.html, {
          FORBID_TAGS,
        });
      }
    }
    const batch = [
      ...messages,
      createMessage({
        type: 'internal/reconnected',
      }),
    ];
    chatRenderer.processBatch(batch, {
      prepend: true,
    });
  }
  store.dispatch(loadChat(state));
};

export const chatMiddleware = (store) => {
  let initialized = false;
  let loaded = false;
  const sequences: number[] = [];
  const sequences_requested: number[] = [];
  chatRenderer.events.on('batchProcessed', (countByType) => {
    // Use this flag to workaround unread messages caused by
    // loading them from storage. Side effect of that, is that
    // message count can not be trusted, only unread count.
    if (loaded) {
      store.dispatch(updateMessageCount(countByType));
    }
  });
  chatRenderer.events.on('scrollTrackingChanged', (scrollTracking) => {
    store.dispatch(changeScrollTracking(scrollTracking));
  });
  return (next) => (action) => {
    const { type, payload } = action;
    const settings = selectSettings(store.getState());
    // Load the chat once settings are loaded
    if (!initialized && settings.initialized) {
      setInterval(() => {
        saveChatToStorage(store);
      }, MESSAGE_SAVE_INTERVAL);
      initialized = true;
      loadChatFromStorage(store);
    }
    if (type === 'chat/message') {
      let payload_obj;
      try {
        payload_obj = JSON.parse(payload);
      } catch (err) {
        return;
      }

      const sequence: number = payload_obj.sequence;
      if (sequences.includes(sequence)) {
        return;
      }

      const sequence_count = sequences.length;
      seq_check: if (sequence_count > 0) {
        if (sequences_requested.includes(sequence)) {
          sequences_requested.splice(sequences_requested.indexOf(sequence), 1);
          // if we are receiving a message we requested, we can stop reliability checks
          break seq_check;
        }

        // cannot do reliability if we don't have any messages
        const expected_sequence = sequences[sequence_count - 1] + 1;
        if (sequence !== expected_sequence) {
          for (
            let requesting = expected_sequence;
            requesting < sequence;
            requesting++
          ) {
            sequences_requested.push(requesting);
            Byond.sendMessage('chat/resend', requesting);
          }
        }
      }

      sequences.push(sequence);
      chatRenderer.processBatch([payload_obj.content]);
      return;
    }
    if (type === loadChat.type) {
      next(action);
      const page = selectCurrentChatPage(store.getState());
      chatRenderer.changePage(page);
      chatRenderer.onStateLoaded();
      loaded = true;
      return;
    }
    if (
      type === changeChatPage.type ||
      type === addChatPage.type ||
      type === removeChatPage.type ||
      type === toggleAcceptedType.type
    ) {
      next(action);
      const page = selectCurrentChatPage(store.getState());
      chatRenderer.changePage(page);
      return;
    }
    if (type === rebuildChat.type) {
      chatRenderer.rebuildChat();
      return next(action);
    }

    if (
      type === updateSettings.type ||
      type === loadSettings.type ||
      type === addHighlightSetting.type ||
      type === removeHighlightSetting.type ||
      type === updateHighlightSetting.type ||
      type === importSettings.type
    ) {
      next(action);
      const nextSettings = selectSettings(store.getState());
      chatRenderer.setHighlight(
        nextSettings.highlightSettings,
        nextSettings.highlightSettingById
      );

      return;
    }
    if (type === 'roundrestart') {
      // Save chat as soon as possible
      saveChatToStorage(store);
      return next(action);
    }
    if (type === saveChatToDisk.type) {
      chatRenderer.saveToDisk();
      return;
    }
    if (type === clearChat.type) {
      chatRenderer.clearChat();
      return;
    }
    return next(action);
  };
};
