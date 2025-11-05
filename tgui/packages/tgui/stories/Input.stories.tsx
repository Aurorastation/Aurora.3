/**
 * @file
 * @copyright 2021 Aleksej Komarov
 * @license MIT
 */

import { useState } from 'react';
import {
  Box,
  DraggableControl,
  Icon,
  Input,
  Knob,
  LabeledList,
  NumberInput,
  Section,
  Slider,
} from 'tgui-core/components';

export const meta = {
  title: 'Input',
  render: () => <Story />,
};

function Story() {
  const [number, setNumber] = useState(0);
  const [text, setText] = useState('Sample text');

  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Input (onChange)">
          <Input value={text} onChange={setText} />
        </LabeledList.Item>
        <LabeledList.Item label="Input (onInput)">
          <Input value={text} onChange={setText} />
        </LabeledList.Item>
        <LabeledList.Item label="NumberInput (onChange)">
          <NumberInput
            animated
            width="40px"
            step={1}
            stepPixelSize={5}
            value={number}
            minValue={-100}
            maxValue={100}
            onChange={(value) => setNumber(value)}
          />
        </LabeledList.Item>
        <LabeledList.Item label="NumberInput (onDrag)">
          <NumberInput
            animated
            width="40px"
            step={1}
            stepPixelSize={5}
            value={number}
            minValue={-100}
            maxValue={100}
            onChange={(value) => setNumber(value)}
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
}
