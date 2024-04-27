import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section, Table } from '../components';
import { Window } from '../layouts';

export type RoundData = {
  gamemode: string;
  round_duration: string;
  evacuation_is_idle: BooleanLike;
  time_left: number;
  waiting_to_leave: BooleanLike;
  round_delayed: BooleanLike;

  antagonist_types: string[];
  antagonists: Antagonist[];
  nuke_disks: NukeDisk[];
};

type Antagonist = {
  role: string;
  name: string;
  stat: number;
  ref: string;
};

type NukeDisk = {
  location_name: string;
  x: number;
  y: number;
  z: number;
};

export const RoundStatus = (props, context) => {
  const { act, data } = useBackend<RoundData>(context);

  return (
    <Window resizable theme="admin">
      <Window.Content scrollable>
        <Section title="Round Status">
          <LabeledList>
            <LabeledList.Item label="Current Game Mode">
              {data.gamemode}
            </LabeledList.Item>
            <LabeledList.Item label="Round Duration">
              {data.round_duration}
            </LabeledList.Item>
            <LabeledList.Item label="Evacuation">
              {data.evacuation_is_idle ? (
                <Button
                  content="Call"
                  icon="exclamation-triangle"
                  color="red"
                  onClick={() => act('call_shuttle', { call_shuttle: '1' })}
                />
              ) : (
                <Button
                  content="Recall"
                  icon="exclamation-triangle"
                  color="red"
                  onClick={() => act('call_shuttle', { call_shuttle: '2' })}
                />
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {data.antagonists && data.antagonists.length ? <Antagonists /> : ''}
        {data.nuke_disks && data.nuke_disks.length ? <NukeDisks /> : ''}
      </Window.Content>
    </Window>
  );
};

export const Antagonists = (props, context) => {
  const { act, data } = useBackend<RoundData>(context);

  return (
    <Section title="Antagonists">
      {data.antagonist_types.map((antag_type) => (
        <Section title={antag_type} key={antag_type}>
          <Table>
            {data.antagonists
              .filter((antag) => antag.role === antag_type)
              .map((antag) => (
                <Table.Row key={antag.ref}>
                  <Table.Cell>
                    {antag.name}{' '}
                    {antag.stat === 1 ? (
                      <Box as="span" color="average">
                        (UNCONSCIOUS)
                      </Box>
                    ) : antag.stat === 2 ? (
                      <Box as="span" bold color="red">
                        (DEAD)
                      </Box>
                    ) : (
                      ''
                    )}
                  </Table.Cell>
                  <Table.Cell>
                    <Button
                      content="PM"
                      onClick={() =>
                        act('private_message', {
                          private_message: antag.ref,
                        })
                      }
                    />
                    |{' '}
                    <Button
                      content="PP"
                      onClick={() =>
                        act('show_player_panel', {
                          show_player_panel: antag.ref,
                        })
                      }
                    />
                  </Table.Cell>
                </Table.Row>
              ))}
          </Table>
        </Section>
      ))}
    </Section>
  );
};

export const NukeDisks = (props, context) => {
  const { act, data } = useBackend<RoundData>(context);

  return (
    <Section title="Nuclear Disks">
      <Table>
        {data.nuke_disks.map((disk) => (
          <Table.Row key={disk.location_name}>
            <Table.Cell>Nuclear Disk</Table.Cell>
            <Table.Cell>
              {disk.location_name} ({disk.x}, {disk.y}, {disk.z})
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
