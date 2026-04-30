import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section, Stack, Table } from '../components';
import { Window } from '../layouts';
import { BooleanLike } from '../../common/react';

type Data = {
  hacking: number;
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

export const NuclearBomb = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  const authed = !!data.auth;
  const unlocked = authed && !!data.yescode;

  const keypadDisabled = !authed;

  return (
    <Window width={300} height={510} title="Nuke Control Panel">
      <Window.Content scrollable>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Authorization Disk">
              <Button
                icon={authed ? 'eject' : 'circle'}
                onClick={() => act('auth')}
              >
                {authed ? '++++++++++' : '----------'}
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>

        <Section>
          <LabeledList>
            <LabeledList.Item label="Status">
              {data.authstatus} - {data.safe}
            </LabeledList.Item>
            <LabeledList.Item label="Timer">{data.time}</LabeledList.Item>
          </LabeledList>
        </Section>

        <Section title="Controls">
          <Stack vertical>
            <Stack.Item>
              <LabeledList>
                <LabeledList.Item label="Timer">
                  <Button
                    icon="play"
                    color={data.timer ? 'red' : undefined}
                    disabled={!unlocked}
                    onClick={() => act('timer', { timer: 1 })}
                  >
                    On
                  </Button>
                  <Button
                    icon="stop"
                    selected={!data.timer}
                    disabled={!unlocked}
                    onClick={() => act('timer', { timer: 0 })}
                  >
                    Off
                  </Button>
                </LabeledList.Item>

                <LabeledList.Item label="Time">
                  <Button
                    disabled={!unlocked || data.time <= 120}
                    onClick={() => act('time', { time: -10 })}
                  >
                    --
                  </Button>
                  <Button
                    disabled={!unlocked || data.time <= 120}
                    onClick={() => act('time', { time: -1 })}
                  >
                    -
                  </Button>

                  <Box inline mx={1} fontFamily="monospace">
                    {data.time}
                  </Box>

                  <Button
                    disabled={!unlocked}
                    onClick={() => act('time', { time: 1 })}
                  >
                    +
                  </Button>
                  <Button
                    disabled={!unlocked}
                    onClick={() => act('time', { time: 10 })}
                  >
                    ++
                  </Button>
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>

            <Stack.Item>
              <LabeledList>
                <LabeledList.Item label="Safety">
                  <Button
                    icon="info"
                    selected={!!data.safety}
                    disabled={!unlocked}
                    onClick={() => act('safety')}
                  >
                    Engaged
                  </Button>
                  <Button
                    icon="exclamation-triangle"
                    color={!data.safety ? 'red' : undefined}
                    disabled={!unlocked}
                    onClick={() => act('safety')}
                  >
                    Disengaged
                  </Button>
                </LabeledList.Item>

                <LabeledList.Item label="Anchor">
                  <Button
                    icon="lock"
                    selected={!!data.anchored}
                    disabled={!unlocked}
                    onClick={() => act('anchor')}
                  >
                    Engaged
                  </Button>
                  <Button
                    icon="unlock"
                    selected={!data.anchored}
                    disabled={!unlocked}
                    onClick={() => act('anchor')}
                  >
                    Disengaged
                  </Button>
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
          </Stack>
        </Section>

        <Section title="Keypad">
          <Box mb={1} fontFamily="monospace">
            &gt; {data.message || ''}
          </Box>

          <Table>
            <Table.Row>
              {['1', '2', '3'].map((k) => (
                <Table.Cell key={k}>
                  <Button
                    fluid
                    disabled={keypadDisabled}
                    onClick={() => act('type', { type: k })}
                  >
                    {k}
                  </Button>
                </Table.Cell>
              ))}
            </Table.Row>

            <Table.Row>
              {['4', '5', '6'].map((k) => (
                <Table.Cell key={k}>
                  <Button
                    fluid
                    disabled={keypadDisabled}
                    onClick={() => act('type', { type: k })}
                  >
                    {k}
                  </Button>
                </Table.Cell>
              ))}
            </Table.Row>

            <Table.Row>
              {['7', '8', '9'].map((k) => (
                <Table.Cell key={k}>
                  <Button
                    fluid
                    disabled={keypadDisabled}
                    onClick={() => act('type', { type: k })}
                  >
                    {k}
                  </Button>
                </Table.Cell>
              ))}
            </Table.Row>

            <Table.Row>
              {['R', '0', 'E'].map((k) => (
                <Table.Cell key={k}>
                  <Button
                    fluid
                    disabled={keypadDisabled}
                    onClick={() => act('type', { type: k })}
                  >
                    {k}
                  </Button>
                </Table.Cell>
              ))}
            </Table.Row>
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
