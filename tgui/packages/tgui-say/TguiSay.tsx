import { Channel, ChannelIterator } from './ChannelIterator';
import { ChatHistory } from './ChatHistory';
import { LineLength, RADIO_PREFIXES, WindowSize } from './constants';
import { dragStartHandler } from 'tgui/drag';
import { isEscape, KEY } from 'common/keys';
import { BooleanLike, classes } from 'common/react';
import { useEffect, useRef, useState } from 'react';
import { getPrefix, windowClose, windowOpen, windowSet } from './helpers';
import { byondMessages } from './timers';

type ByondOpen = {
  channel: Channel;
  mapfocus: BooleanLike;
  lobbyfocus: BooleanLike;
};

type ByondProps = {
  maxLength: number;
  lightMode: BooleanLike;
  scale: BooleanLike;
  extraChannels: Array<Channel>;
  languages: Array<string>;
};

export function TguiSay() {
  const innerRef = useRef<HTMLTextAreaElement>(null);
  const channelIterator = useRef(new ChannelIterator());
  const chatHistory = useRef(new ChatHistory());
  const messages = useRef(byondMessages);
  const scale = useRef(true);

  // I initially wanted to make these an object or a reducer, but it's not really worth it.
  // You lose the granulatity and add a lot of boilerplate.
  const [buttonContent, setButtonContent] = useState('');
  const [currentPrefix, setCurrentPrefix] = useState<
    keyof typeof RADIO_PREFIXES | null
  >(null);
  const [maxLength, setMaxLength] = useState(1024);
  const [size, setSize] = useState(WindowSize.Small);
  const [lightMode, setLightMode] = useState(false);
  const [value, setValue] = useState('');
  const [extraChannels, setExtraChennels] = useState<Array<Channel>>([]);
  const [languages, setLanguages] = useState<Array<string>>([]);

  const position = useRef([window.screenX, window.screenY]);
  const isDragging = useRef(false);

  function handleArrowKeys(direction: KEY.Up | KEY.Down): void {
    const chat = chatHistory.current;
    const iterator = channelIterator.current;

    if (direction === KEY.Up) {
      if (chat.isAtLatest() && value) {
        // Save current message to temp history if at the most recent message
        chat.saveTemp(value);
      }
      // Try to get the previous message, fall back to the current value if none
      const prevMessage = chat.getOlderMessage();

      if (prevMessage) {
        setButtonContent(chat.getIndex().toString());
        setValue(prevMessage);
      }
    } else {
      const nextMessage = chat.getNewerMessage() || chat.getTemp() || '';

      const newContent = chat.isAtLatest()
        ? iterator.current()
        : chat.getIndex().toString();

      setButtonContent(newContent);
      setValue(nextMessage);
    }
  }

  function handleBackspaceDelete(): void {
    const chat = chatHistory.current;
    const iterator = channelIterator.current;

    // User is on a chat history message
    if (!chat.isAtLatest()) {
      chat.reset();
      setButtonContent(currentPrefix ?? iterator.current());

      // Empty input, resets the channel
    } else if (currentPrefix && iterator.isSay() && value?.length === 0) {
      setCurrentPrefix(null);
      setButtonContent(iterator.current());
    }
  }

  function handleButtonClick(event: React.MouseEvent<HTMLButtonElement>): void {
    isDragging.current = true;

    setTimeout(() => {
      // So the button doesn't jump around accidentally
      if (isDragging.current) {
        dragStartHandler(event.nativeEvent);
      }
    }, 50);
  }

  // Prevents the button from changing channels if it's dragged
  function handleButtonRelease(): void {
    isDragging.current = false;
    const currentPosition = [window.screenX, window.screenY];

    if (JSON.stringify(position.current) !== JSON.stringify(currentPosition)) {
      position.current = currentPosition;
      return;
    }

    handleIncrementChannel();
  }

  function handleClose(): void {
    innerRef.current?.blur();
    windowClose(scale.current);

    setTimeout(() => {
      chatHistory.current.reset();
      channelIterator.current.reset();
      unloadChat();
    }, 25);
  }

  function handleEnter(): void {
    const iterator = channelIterator.current;
    const prefix = currentPrefix ?? '';

    if (value?.length && value.length < maxLength) {
      chatHistory.current.add(value);
      Byond.sendMessage('entry', {
        channel: iterator.current(),
        entry: iterator.isSay() ? prefix + value : value,
      });
    }

    handleClose();
  }

  function handleForceSay(): void {
    const iterator = channelIterator.current;

    // Only force say if we're on a visible channel and have typed something
    if (!value || iterator.isVisible()) return;

    const prefix = currentPrefix ?? '';
    const grunt = iterator.isSay() ? prefix + value : value;

    messages.current.forceSayMsg(grunt);
    unloadChat();
  }

  function handleIncrementChannel(): void {
    const iterator = channelIterator.current;

    iterator.next();
    setButtonContent(iterator.current());
    setCurrentPrefix(null);
    messages.current.channelIncrementMsg(iterator.isVisible());
  }

  function handleInput(event: React.FormEvent<HTMLTextAreaElement>): void {
    const iterator = channelIterator.current;
    let newValue = event.currentTarget.value;

    const newPrefix = getPrefix(newValue) || currentPrefix;
    // Handles switching prefixes
    if (canChangePrefix(newPrefix)) {
      if (RADIO_PREFIXES[newPrefix!]) {
        setButtonContent(RADIO_PREFIXES[newPrefix!]);
      }
      setCurrentPrefix(newPrefix);
      newValue = newValue.slice(3);
      iterator.set('Say');

      if (newPrefix === ':b ') {
        Byond.sendMessage('thinking', { visible: false });
      }
    }

    // Handles typing indicators
    if (channelIterator.current.isVisible() && newPrefix !== ':b ') {
      messages.current.typingMsg();
    }

    setValue(newValue);
  }

  function canChangePrefix(newPrefix: string | null) {
    if (!newPrefix || newPrefix === currentPrefix) {
      return false;
    }

    if (RADIO_PREFIXES[newPrefix]) {
      return true;
    }
    return true;
  }

  function handleKeyDown(
    event: React.KeyboardEvent<HTMLTextAreaElement>
  ): void {
    if (event.getModifierState('AltGraph')) return;

    switch (event.key) {
      case KEY.Up:
      case KEY.Down:
        event.preventDefault();
        handleArrowKeys(event.key);
        break;

      case KEY.Delete:
      case KEY.Backspace:
        handleBackspaceDelete();
        break;

      case KEY.Enter:
        event.preventDefault();
        handleEnter();
        break;

      case KEY.Tab:
        event.preventDefault();
        handleIncrementChannel();
        break;

      default:
        if (isEscape(event.key)) {
          handleClose();
        }
    }
  }

  function handleOpen(data: ByondOpen): void {
    setTimeout(() => {
      innerRef.current?.focus();
    }, 1);

    const { mapfocus, lobbyfocus } = data;

    if (!mapfocus && !lobbyfocus) {
      return;
    }
    channelIterator.current.set(data.channel);

    setCurrentPrefix(null);
    setButtonContent(channelIterator.current.current());
    windowOpen(channelIterator.current.current(), scale.current);
    innerRef.current?.focus();
  }

  function handleProps(data: ByondProps): void {
    setMaxLength(data.maxLength);
    setLightMode(!!data.lightMode);
    setExtraChennels(data.extraChannels);
    setLanguages(data.languages);
    scale.current = !!data.scale;
  }

  function unloadChat(): void {
    setCurrentPrefix(null);
    setButtonContent(channelIterator.current.current());
    setValue('');
  }

  /** Subscribe to Byond messages */
  useEffect(() => {
    Byond.subscribeTo('props', handleProps);
    Byond.subscribeTo('force', handleForceSay);
    Byond.subscribeTo('open', handleOpen);
  }, []);

  /** Value has changed, we need to check if the size of the window is ok */
  useEffect(() => {
    const len = value?.length || 0;

    let newSize: WindowSize;
    if (len > LineLength.Medium) {
      newSize = WindowSize.Large;
    } else if (len <= LineLength.Medium && len > LineLength.Small) {
      newSize = WindowSize.Medium;
    } else {
      newSize = WindowSize.Small;
    }

    if (size !== newSize) {
      windowSet(newSize, scale.current);
      setSize(newSize);
    }
  }, [value]);

  const theme =
    (lightMode && 'lightMode') ||
    (currentPrefix && RADIO_PREFIXES[currentPrefix]) ||
    channelIterator.current.current().toLowerCase();

  return (
    <>
      <div
        className={`window window-${theme} window-${size}`}
        style={{
          zoom: scale.current ? '' : `${100 / window.devicePixelRatio}%`,
        }}
        onMouseDown={dragStartHandler}>
        {!lightMode && <div className={`shine shine-${theme}`} />}
      </div>
      <div
        className={classes(['content', lightMode && 'content-lightMode'])}
        style={{
          zoom: scale.current ? '' : `${100 / window.devicePixelRatio}%`,
        }}>
        <button
          className={`button button-${theme}`}
          onMouseDown={handleButtonClick}
          onMouseUp={handleButtonRelease}
          type="button">
          {buttonContent}
        </button>
        <textarea
          spellCheck
          autoCorrect="off"
          className={classes([
            'textarea',
            `textarea-${theme}`,
            value.length > LineLength.Large && 'textarea-large',
          ])}
          maxLength={maxLength}
          onInput={handleInput}
          onKeyDown={handleKeyDown}
          ref={innerRef}
          value={value}
        />
        <button
          key="escape"
          className={`button button-${theme}`}
          onClick={handleClose}
          type="submit">
          X
        </button>
      </div>
    </>
  );
}
