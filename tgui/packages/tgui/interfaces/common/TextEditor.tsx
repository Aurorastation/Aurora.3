import { Box, Button, Stack, TextArea } from 'tgui-core/components';
import React, { useEffect, useRef, useState } from 'react';

import { sanitizePaperText } from '../../sanitize';

interface TextEditorProps {
  height?: number | string;
  placeholder?: string;
  initial_text?: string;
  limited?: boolean;
  maxLength?: number;
  onChange?: (value: string) => void;
  previewHtml?: string;
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
  previewHtml,
  value,
}: TextEditorProps) {
  const [localText, setLocalText] = useState<string>(value ?? initial_text);
  const [previewVisible, setPreviewVisible] = useState(true);
  const textareaRef = useRef<HTMLTextAreaElement | null>(null);
  const text = value ?? localText;

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

  const editor = (
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
              applyFormatting('[table][row][cell]', '[/cell][/row][/table]')
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
      <TextArea
        fluid
        height={height}
        maxLength={maxLength}
        ref={textareaRef}
        value={text}
        onChange={setText}
        placeholder={placeholder}
      />
    </Box>
  );

  if (previewHtml === undefined) {
    return editor;
  }

  return (
    <Box>
      <Box textAlign="right" mb={0.5}>
        <Button
          icon={previewVisible ? 'eye-slash' : 'eye'}
          onClick={() => setPreviewVisible(!previewVisible)}
        >
          {previewVisible ? 'Hide Preview' : 'Show Preview'}
        </Button>
      </Box>
      {previewVisible ? (
        <Stack fill>
          <Stack.Item grow basis={0}>
            {editor}
          </Stack.Item>
          <Stack.Item grow basis={0}>
            <Box bold mb={0.5}>
              Preview
            </Box>
            <Box
              backgroundColor="#ffffff"
              color="#000000"
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
      ) : (
        editor
      )}
    </Box>
  );
}
