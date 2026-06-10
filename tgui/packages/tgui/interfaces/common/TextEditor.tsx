import {
  Box,
  Button,
  TextArea
} from 'tgui-core/components';
import React, { useState, useRef } from 'react';

interface TextEditorProps {
  placeholder?: string;
  initial_text?: string;
  onChange?: (value: string) => void;
}

/**
 * Textarea and toolbar with integrated pencode markup.
 *
 * Expects placeholder text and initial text value.
 * Exports onChange, providing the new text as a string.
 *
 */
export default function TextEditor({
  placeholder = "Type something here...",
  initial_text = "",
  onChange
}: TextEditorProps) {
  const [text, setText] = useState<string>(initial_text);
  const textareaRef = useRef<HTMLTextAreaElement | null>(null);

  const applyFormatting = (prefix: string, suffix: string) => {
    const textarea = textareaRef.current;
    if (!textarea) return;

    const start = textarea.selectionStart;
    const end = textarea.selectionEnd;

    const selected_text = text.substring(start, end);
    const replacement = `${prefix}${selected_text}${suffix}`;
    const new_text = text.substring(0, start) + replacement + text.substring(end);

    setText(new_text);
    if (onChange) onChange(new_text);

    setTimeout(() => {
      textarea.focus();
    }, 0);
  };

  return (
    <Box>
            <Button
            onClick={() => applyFormatting('[b]', '[/b]')}
            tooltip="Bold (Ctrl+B)"
            icon = 'bold'
            />{''}
            <Button
              onClick={() => applyFormatting('[i]', '[/i]')}
              tooltip="Italic (Ctrl+I)"
              icon = 'italic'
            />{''}
            <Button
              onClick={() => applyFormatting('[u]', '[/u]')}
              tooltip="Underline (Ctrl+U)"
              icon = 'underline'
            />{''}
            <Button
              onClick={() => applyFormatting('[center]', '[/center]')}
              tooltip = 'Center'
              icon = 'align-center'
            />{''}
            <Button
              onClick={() => applyFormatting('[list][*]', '[/list]')}
              icon = 'list'
              tooltip = 'List'
            />{''}
            <Button
              onClick={() => applyFormatting('[table][row][cell]', '[/table]')}
              icon = 'table'
              tooltip = 'Table'
            />{''}
            <Button
              onClick={() => applyFormatting('[time]', '')}
              icon = 'clock'
              tooltip = 'time'
            />{''}
            <Button
              onClick={() => applyFormatting('[date]', '')}
              icon = 'calendar-days'
              tooltip = 'date'
            />{''}
            <Button
              onClick={() => applyFormatting('[small]','[/small]')}
              tooltip="Small (Ctrl+S)"
              icon = 'arrow-down'
            />{''}
            <Button
              onClick={() => applyFormatting('[large]','[/large]')}
              tooltip="Large (Ctrl+L)"
              icon = 'arrow-up'
            />{''}
            <TextArea
              fluid
              height = {40} //Generic height to fit most spaces
              ref={textareaRef}
              value={text}
              onChange={(e) => {
                setText(e);
                if (onChange) onChange(e);
              }}
              placeholder={placeholder}
            />
          </Box>
  );
}

