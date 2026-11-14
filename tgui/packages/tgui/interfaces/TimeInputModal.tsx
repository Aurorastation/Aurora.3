import { useEffect, useRef, useState } from 'react';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import { isEscape, KEY } from 'tgui-core/keys';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { InputButtons } from './common/InputButtons';
import { Loader } from './common/Loader';

type TimeInputData = {
  default_time: string;
  large_buttons: boolean;
  message: string;
  timeout: number;
  title: string;
};

const HoldButton = ({ icon, onStep }: { icon: string; onStep: () => void }) => {
  const delay = useRef<ReturnType<typeof setTimeout> | null>(null);
  const repeat = useRef<ReturnType<typeof setInterval> | null>(null);

  const stop = () => {
    if (delay.current) {
      clearTimeout(delay.current);
      delay.current = null;
    }
    if (repeat.current) {
      clearInterval(repeat.current);
      repeat.current = null;
    }
  };

  useEffect(() => stop, []);

  return (
    <div
      onPointerCancel={stop}
      onPointerDown={(event) => {
        if (event.button !== 0) {
          return;
        }
        stop();
        onStep();
        delay.current = setTimeout(() => {
          repeat.current = setInterval(onStep, 100);
        }, 350);
      }}
      onPointerLeave={stop}
      onPointerUp={stop}
    >
      <Button
        fluid
        icon={icon}
        onClick={(event) => {
          if (event.type === 'keydown') {
            onStep();
          }
        }}
      />
    </div>
  );
};

export const TimeInputModal = (props) => {
  const { act, data } = useBackend<TimeInputData>();
  const { default_time = '00:00', large_buttons, message = '', timeout, title } = data;
  const [hours, setHours] = useState(default_time.slice(0, 2));
  const [minutes, setMinutes] = useState(default_time.slice(3, 5));
  const minuteInput = useRef<HTMLInputElement>(null);
  const isValid = hours.length > 0 && minutes.length > 0;
  const time = `${hours.padStart(2, '0')}:${minutes.padStart(2, '0')}`;

  const windowHeight = 245 + (message.length > 30 ? Math.ceil(message.length / 4) : 0) + (large_buttons ? 5 : 0);

  const stepHours = (amount: number) => {
    setHours((value) => String(((Number(value) + amount + 24) % 24)).padStart(2, '0'));
  };

  const stepMinutes = (amount: number) => {
    setMinutes((value) => String(((Number(value) + amount + 60) % 60)).padStart(2, '0'));
  };

  const clampInput = (value: string, max: number) => {
    const digits = value.replace(/\D/g, '').slice(0, 2);
    return digits ? String(Math.min(Number(digits), max)).padStart(digits.length, '0') : '';
  };

  const replaceFilledValue = (event: React.KeyboardEvent<HTMLInputElement>, setValue: (value: string) => void) => {
    const input = event.currentTarget;
    if (/^\d$/.test(event.key) && input.value.length === 2 && input.selectionStart === input.selectionEnd) {
      event.preventDefault();
      setValue(event.key);
    }
  };

  function handleKeyDown(event: React.KeyboardEvent<HTMLDivElement>) {
    if (event.key === KEY.Enter && isValid) {
      act('submit', { entry: time });
    }
    if (isEscape(event.key)) {
      act('cancel');
    }
  }

  return (
    <Window title={title} width={320} height={windowHeight}>
      {timeout && <Loader value={timeout} />}
      <Window.Content onKeyDown={handleKeyDown}>
        <Section fill>
          <Stack fill vertical>
            <Stack.Item>
              <Box color="label">{message}</Box>
            </Stack.Item>
            <Stack.Item grow>
              <Stack align="center" justify="center" fill>
                <Stack.Item width="5rem">
                  <Stack vertical align="center">
                    <Stack.Item><Box color="label">HOUR</Box></Stack.Item>
                    <Stack.Item>
                      <HoldButton icon="chevron-up" onStep={() => stepHours(1)} />
                    </Stack.Item>
                    <Stack.Item>
                      <input
                        autoFocus
                        className="Input Input--fluid"
                        inputMode="numeric"
                        maxLength={2}
                        onClick={(event) => event.currentTarget.select()}
                        onFocus={(event) => event.currentTarget.select()}
                        onKeyDown={(event) => replaceFilledValue(event, setHours)}
                        onBlur={() => setHours((value) => value.padStart(2, '0'))}
                        onChange={(event) => {
                          const value = clampInput(event.currentTarget.value, 23);
                          setHours(value);
                          if (value.length === 2) {
                            minuteInput.current?.focus();
                            minuteInput.current?.select();
                          }
                        }}
                        style={{ fontSize: '2rem', textAlign: 'center' }}
                        type="text"
                        value={hours}
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <HoldButton icon="chevron-down" onStep={() => stepHours(-1)} />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item><Box fontSize={2} mt={1}>:</Box></Stack.Item>
                <Stack.Item width="5rem">
                  <Stack vertical align="center">
                    <Stack.Item><Box color="label">MINUTE</Box></Stack.Item>
                    <Stack.Item>
                      <HoldButton icon="chevron-up" onStep={() => stepMinutes(1)} />
                    </Stack.Item>
                    <Stack.Item>
                      <input
                        className="Input Input--fluid"
                        inputMode="numeric"
                        maxLength={2}
                        onClick={(event) => event.currentTarget.select()}
                        onFocus={(event) => event.currentTarget.select()}
                        onKeyDown={(event) => replaceFilledValue(event, setMinutes)}
                        onBlur={() => setMinutes((value) => value.padStart(2, '0'))}
                        onChange={(event) => setMinutes(clampInput(event.currentTarget.value, 59))}
                        ref={minuteInput}
                        style={{ fontSize: '2rem', textAlign: 'center' }}
                        type="text"
                        value={minutes}
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <HoldButton icon="chevron-down" onStep={() => stepMinutes(-1)} />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <InputButtons input={time} disabled={!isValid} />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
