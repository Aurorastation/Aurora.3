import { Box, Button, LabeledList, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type NuclearBombData = {
  auth: BooleanLike;
  authstatus: string;
  safe: string;
  time: number;
  timer: BooleanLike;
  safety: BooleanLike;
  anchored: BooleanLike;
  yescode: BooleanLike;
  message: string;
};

const KEYPAD_ROWS: string[][] = [
  ['1', '2', '3'],
  ['4', '5', '6'],
  ['7', '8', '9'],
  ['R', '0', 'E'],
];

export const NuclearBomb = (props, context) => {
  const { act, data } = useBackend<NuclearBombData>();
  const armed = !!data.auth && !!data.yescode;

  return (
    <Window width={340} height={560} theme="hephaestus">
      <Window.Content>
        <Section title="Authorization">
          <LabeledList>
            <LabeledList.Item label="Disk">
              <Button
                content={data.auth ? 'Eject Disk' : 'Insert Disk'}
                color={data.auth ? 'good' : undefined}
                onClick={() => act('auth')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Status">
              {data.authstatus} — {data.safe}
            </LabeledList.Item>
            <LabeledList.Item label="Timer">{data.time}s</LabeledList.Item>
          </LabeledList>
        </Section>

        <Section title="Display">
          <Box
            p={1}
            textAlign="center"
            style={{
              fontFamily: 'monospace',
              fontSize: '1.4em',
              backgroundColor: '#111',
              color: '#7f7',
              minHeight: '1.6em',
              border: '1px solid #333',
            }}
          >
            {data.message || ' '}
          </Box>
        </Section>

        <Section title="Controls">
          <LabeledList>
            <LabeledList.Item label="Timer">
              <Button
                content="On"
                color={data.timer ? 'bad' : undefined}
                disabled={!armed}
                onClick={() => act('timer', { value: 1 })}
              />
              <Button
                content="Off"
                selected={!data.timer}
                disabled={!armed}
                onClick={() => act('timer', { value: 0 })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Time">
              <Button
                content="--"
                disabled={!armed || data.time <= 120}
                onClick={() => act('time', { value: -10 })}
              />
              <Button
                content="-"
                disabled={!armed || data.time <= 120}
                onClick={() => act('time', { value: -1 })}
              />
              <Box inline mx={1} width="44px" textAlign="center">
                {data.time}
              </Box>
              <Button
                content="+"
                disabled={!armed}
                onClick={() => act('time', { value: 1 })}
              />
              <Button
                content="++"
                disabled={!armed}
                onClick={() => act('time', { value: 10 })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Safety">
              <Button
                content="Engaged"
                selected={!!data.safety}
                disabled={!armed}
                onClick={() => act('safety')}
              />
              <Button
                content="Disengaged"
                color={!data.safety ? 'bad' : undefined}
                disabled={!armed}
                onClick={() => act('safety')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Anchor">
              <Button
                content="Engaged"
                selected={!!data.anchored}
                disabled={!armed}
                onClick={() => act('anchor')}
              />
              <Button
                content="Disengaged"
                selected={!data.anchored}
                disabled={!armed}
                onClick={() => act('anchor')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>

        <Section title="Keypad">
          {KEYPAD_ROWS.map((row, ri) => (
            <Stack key={ri} mb={0.5}>
              {row.map((key) => (
                <Stack.Item key={key} grow={1}>
                  <Button
                    fluid
                    textAlign="center"
                    disabled={!data.auth}
                    content={key}
                    onClick={() => act('type', { value: key })}
                  />
                </Stack.Item>
              ))}
            </Stack>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
