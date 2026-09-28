import { Box, Button, Stack, TextArea } from 'tgui-core/components';
import React, { useEffect, useRef, useState } from 'react';

import { type PaperCodeContext, renderPaperCode } from '../../papercode';
import { sanitizePaperText } from '../../sanitize';

interface TextEditorProps {
  height?: number | string;
  placeholder?: string;
  initial_text?: string;
  limited?: boolean;
  maxLength?: number;
  onChange?: (value: string) => void;
  previewContext?: PaperCodeContext;
  value?: string;
}

/**
 * Textarea and toolbar with integrated pencode markup.
 *
 * Expects placeholder text and initial text value.
 * Exports onChange, providing the new text as a string.
 *
 */
export default function TextEditor({
  height = 30,
  placeholder = 'Type something here...',
  initial_text = '',
  limited = false,
  maxLength,
  onChange,
  previewContext,
  value,
}: TextEditorProps) {
  const [localText, setLocalText] = useState<string>(value ?? initial_text);
  const [previewVisible, setPreviewVisible] = useState(true);
  const textareaRef = useRef<HTMLTextAreaElement | null>(null);
  const text = value ?? localText;
  const previewHtml = previewContext
    ? renderPaperCode(text, previewContext)
    : undefined;

  useEffect(() => {
    if (value === undefined) {
      setLocalText(initial_text);
    }
  }, [initial_text, value]);

  const setText = (newText: string) => {
    if (value === undefined) {
      setLocalText(newText);
    }
    onChange?.(newText);
  };

  const applyFormatting = (prefix: string, suffix: string) => {
    const textarea = textareaRef.current;
    if (!textarea) {
      return;
    }

    const start = textarea.selectionStart;
    const end = textarea.selectionEnd;

    const selectedText = text.substring(start, end);
    const replacement = `${prefix}${selectedText}${suffix}`;
    const newText = text.substring(0, start) + replacement + text.substring(end);

    setText(newText);

    setTimeout(() => {
      textarea.focus();
      textarea.setSelectionRange(start + prefix.length, end + prefix.length);
    }, 0);
  };

  const toolbar = (
    <Box>
      <Button
        onClick={() => applyFormatting('[b]', '[/b]')}
        tooltip="Bold"
        icon="bold"
      />
      <Button
        onClick={() => applyFormatting('[i]', '[/i]')}
        tooltip="Italic"
        icon="italic"
      />
      <Button
        onClick={() => applyFormatting('[u]', '[/u]')}
        tooltip="Underline"
        icon="underline"
      />
      {!limited && (
        <>
          <Button
            onClick={() => applyFormatting('[center]', '[/center]')}
            tooltip="Center"
            icon="align-center"
          />
          <Button
            onClick={() => applyFormatting('[list][*]', '[/list]')}
            icon="list"
            tooltip="List"
          />
          <Button
            onClick={() =>
              applyFormatting(
                '[table][row][cell]',
                '[/cell][/row][/table]',
              )
            }
            icon="table"
            tooltip="Table"
          />
          <Button
            onClick={() => applyFormatting('[time]', '')}
            icon="clock"
            tooltip="Time"
          />
          <Button
            onClick={() => applyFormatting('[date]', '')}
            icon="calendar-days"
            tooltip="Date"
          />
        </>
      )}
      <Button
        onClick={() => applyFormatting('[small]', '[/small]')}
        tooltip="Small"
        icon="arrow-down"
      />
      <Button
        onClick={() => applyFormatting('[large]', '[/large]')}
        tooltip="Large"
        icon="arrow-up"
      />
    </Box>
  );

  const textArea = (
    <TextArea
      fluid
      height={height}
      maxLength={maxLength}
      ref={textareaRef}
      value={text}
      onChange={setText}
      placeholder={placeholder}
    />
  );

  if (previewHtml === undefined) {
    return (
      <Box>
        {toolbar}
        {textArea}
      </Box>
    );
  }

  const previewToggle = (
    <Button
      icon={previewVisible ? 'eye-slash' : 'eye'}
      onClick={() => setPreviewVisible(!previewVisible)}
    >
      {previewVisible ? 'Hide Preview' : 'Show Preview'}
    </Button>
  );

  if (!previewVisible) {
    return (
      <Box>
        <Stack align="center">
          <Stack.Item grow>{toolbar}</Stack.Item>
          <Stack.Item>{previewToggle}</Stack.Item>
        </Stack>
        {textArea}
      </Box>
    );
  }

  return (
    <Box>
      <Stack align="center">
        <Stack.Item grow basis={0}>
          {toolbar}
        </Stack.Item>
        <Stack.Item grow basis={0}>
          <Stack align="center">
            <Stack.Item bold grow>
              Preview
            </Stack.Item>
            <Stack.Item>{previewToggle}</Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
      <Stack fill>
        <Stack.Item grow basis={0}>
          {textArea}
        </Stack.Item>
        <Stack.Item grow basis={0}>
          <Box
            backgroundColor="#111111"
            height={height}
            overflow="auto"
            p={1}
            style={{ overflowWrap: 'anywhere' }}
            dangerouslySetInnerHTML={{
              __html: sanitizePaperText(previewHtml),
            }}
          />
        </Stack.Item>
      </Stack>
    </Box>
  );
}
