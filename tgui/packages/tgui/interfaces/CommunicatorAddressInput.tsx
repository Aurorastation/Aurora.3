import { useState } from 'react';
import { Box, Button, Input, Section, Stack } from 'tgui-core/components';
import { isEscape, KEY } from 'tgui-core/keys';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Loader } from './common/Loader';

type CommunicatorAddressInputData = {
  groups: string[];
  large_buttons: boolean;
  swapped_buttons: boolean;
  timeout: number;
  title: string;
};

const validAddressGroup = (value: string) => /^[a-z0-9]{4}$/i.test(value);
const addressCharacters = '0123456789abcdefghijklmnopqrstuvwxyz';

const randomAddressGroup = () =>
  Array.from(
    { length: 4 },
    () => addressCharacters[Math.floor(Math.random() * addressCharacters.length)],
  ).join('');

export const CommunicatorAddressInput = () => {
  const { act, data } = useBackend<CommunicatorAddressInputData>();
  const { groups = ['0000', '0000', '0000'], timeout, title } = data;
  const [addressGroups, setAddressGroups] = useState(groups);
  const addressIsValid = addressGroups.every(validAddressGroup);

  const setGroup = (index: number, value: string) => {
    const nextGroups = [...addressGroups];
    nextGroups[index] = value.replace(/[^a-z0-9]/gi, '').slice(0, 4);
    setAddressGroups(nextGroups);
  };

  const submit = () => act('submit', { groups: addressGroups });

  const randomize = () => {
    setAddressGroups([randomAddressGroup(), randomAddressGroup(), randomAddressGroup()]);
  };

  const handleKeyDown = (event: React.KeyboardEvent<HTMLDivElement>) => {
    if (event.key === KEY.Enter && addressIsValid) {
      submit();
    }
    if (isEscape(event.key)) {
      act('cancel');
    }
  };

  return (
    <Window title={title} width={430} height={170}>
      {timeout && <Loader value={timeout} />}
      <Window.Content onKeyDown={handleKeyDown}>
        <Section fill>
          <Stack vertical fill>
            <Stack.Item>
              <Box color="label" textAlign="center">
                Choose a communicator number. Each group must have four letters or numbers.
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Stack align="center" justify="center">
                <Stack.Item>
                  <Box fontFamily="monospace" fontSize="1.3rem">
                    fc00
                  </Box>
                </Stack.Item>
                {[0, 1, 2].map((index) => (
                  <Stack.Item key={index}>
                    <Stack align="center">
                      <Stack.Item>
                        <Box fontFamily="monospace" fontSize="1.3rem" mr={0.5}>
                          :
                        </Box>
                      </Stack.Item>
                      <Stack.Item>
                        <Input
                          autoFocus={index === 0}
                          maxLength={4}
                          monospace
                          onChange={(value) => setGroup(index, value)}
                          textAlign="center"
                          value={addressGroups[index] || ''}
                          width="4.5rem"
                        />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                ))}
              </Stack>
            </Stack.Item>
            <Stack.Item grow />
            <Stack.Item>
              <Stack justify="space-around">
                <Stack.Item>
                  <Button color="bad" onClick={() => act('cancel')}>
                    Cancel
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={randomize}>Randomize</Button>
                </Stack.Item>
                <Stack.Item>
                  <Button color="good" disabled={!addressIsValid} onClick={submit}>
                    OK
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
