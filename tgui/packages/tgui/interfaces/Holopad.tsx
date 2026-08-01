import { Button, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';
import { SearchBar } from './common/SearchBar';

export type HolopadData = {
  holopad_list: Pad[];
  command_auth: BooleanLike;
  forcing_call: BooleanLike;
  call_range: number;
};

type Pad = {
  id: string;
  busy: BooleanLike;
  ref: string;
};

export const Holopad = (props) => {
  const { act, data } = useBackend<HolopadData>();

  const [searchTerm, setSearchTerm] = useLocalState<string>(`searchTerm`, ``);

  return (
    <Window>
      <Window.Content scrollable>
        <Section
          title="Selection Disc"
          buttons={
            <Stack align="center">
              <Stack.Item>
                <Button
                  content="Summon AI"
                  icon="chevron-circle-down"
                  onClick={() => act('call_ai')}
                />
              </Stack.Item>
              {data.command_auth ? (
                <Stack.Item>
                  <Button
                    content="Force Call"
                    tooltip="This is only available due to your command authorisation."
                    selected={data.forcing_call}
                    icon="microphone"
                    onClick={() => act('toggle_command')}
                  />
                </Stack.Item>
              ) : (
                ''
              )}
              <Stack.Item>
                <SearchBar
                  autoFocus
                  placeholder="Search by holopad name"
                  query={searchTerm}
                  onSearch={(value) => {
                    setSearchTerm(value);
                  }}
                  style={{ width: '18rem' }}
                />
              </Stack.Item>
            </Stack>
          }
        >
          {data.holopad_list.length ? (
            <HolopadList />
          ) : (
            `No holopads found in your range of ${data.call_range} clicks.`
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

export const HolopadList = (props) => {
  const { act, data } = useBackend<HolopadData>();

  const [searchTerm, setSearchTerm] = useLocalState<string>(`searchTerm`, ``);

  return (
    <Section>
      {data.holopad_list
        .filter(
          (pad) => pad.id?.toLowerCase().indexOf(searchTerm.toLowerCase()) > -1,
        )
        .map((holopad) => (
          <Button
            key={holopad.id}
            content={holopad.id}
            disabled={holopad.busy}
            tooltip={holopad.busy && 'This holopad is busy.'}
            onClick={() => act('call_holopad', { call_holopad: holopad.ref })}
          />
        ))}
    </Section>
  );
};
