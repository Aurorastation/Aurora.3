import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Tabs,
} from '../components';
import { round } from 'common/math';
import { BooleanLike } from '../../common/react';

type EngineInfo = {
  eng_type: string;
  eng_on: BooleanLike;
  eng_thrust: number;
  eng_thrust_limiter: number; // percentage
  eng_status: StatusLine[];
  eng_reference: string;
};

type StatusLine = {
  text: string;
  severity?: 'good' | 'average' | 'bad';
};

type Data = {
  state: 'status' | 'engines' | string;
  global_state: BooleanLike;
  global_limit: number; // percentage
  total_thrust: number;
  engines_info: EngineInfo[];
};

export const EnginesControl = (_props, context) => {
  const { act, data } = useBackend<Data>(context);

  const engines = data.engines_info || [];
  const globalOn = !!data.global_state;

  const severityToColor = (sev?: StatusLine['severity']) => {
    switch (sev) {
      case 'bad':
        return 'bad';
      case 'average':
        return 'average';
      case 'good':
        return 'good';
      default:
        return undefined;
    }
  };

  return (
    <Window width={390} height={530}>
      <Window.Content scrollable>
        <Section>
          <Tabs>
            <Tabs.Tab
              selected={data.state === 'status'}
              onClick={() => act('set_state', { state: 'status' })}
            >
              Overall info
            </Tabs.Tab>
            <Tabs.Tab
              selected={data.state === 'engines'}
              onClick={() => act('set_state', { state: 'engines' })}
            >
              Details
            </Tabs.Tab>
          </Tabs>
        </Section>

        <Section>
          <LabeledList>
            <LabeledList.Item label="Global controls">
              <Button
                icon="power-off"
                selected={globalOn}
                onClick={() => act('global_toggle')}
              >
                {globalOn ? 'Shut all down' : 'Power all up'}
              </Button>
            </LabeledList.Item>

            <LabeledList.Item label="Thrust limit">
              <Button
                icon="minus-circle"
                onClick={() => act('global_limit_delta', { delta: -0.1 })}
              />
              <Button onClick={() => act('set_global_limit')}>
                {round(data.global_limit, 1)}%
              </Button>
              <Button
                icon="plus-circle"
                onClick={() => act('global_limit_delta', { delta: 0.1 })}
              />
            </LabeledList.Item>

            <LabeledList.Item label="Total thrust">
              {round(data.total_thrust * 10, 0.1) / 10}
            </LabeledList.Item>
          </LabeledList>
        </Section>

        {!engines.length && <NoticeBox>No engines detected.</NoticeBox>}

        {data.state === 'status' &&
          engines.map((E, i) => (
            <Section key={E.eng_reference} title={`Engine #${i + 1}`}>
              <LabeledList>
                <LabeledList.Item label="Power">
                  <Button
                    icon="power-off"
                    selected={!!E.eng_on}
                    onClick={() =>
                      act('engine_toggle', { engine: E.eng_reference })
                    }
                  >
                    {E.eng_on ? 'Shutdown' : 'Power up'}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Thrust">
                  {round(E.eng_thrust * 10, 0.1) / 10}
                </LabeledList.Item>
                <LabeledList.Item label="Thrust limit">
                  {round(E.eng_thrust_limiter, 1)}%
                </LabeledList.Item>
              </LabeledList>
            </Section>
          ))}

        {data.state === 'engines' &&
          engines.map((E, i) => (
            <Section key={E.eng_reference} title={`Engine #${i + 1}`}>
              <LabeledList>
                <LabeledList.Item label="Power">
                  <Button
                    icon="power-off"
                    selected={!!E.eng_on}
                    onClick={() =>
                      act('engine_toggle', { engine: E.eng_reference })
                    }
                  >
                    {E.eng_on ? 'Shutdown' : 'Power up'}
                  </Button>
                </LabeledList.Item>

                <LabeledList.Item label="Type">{E.eng_type}</LabeledList.Item>

                <LabeledList.Item label="Status">
                  <Box color={E.eng_on ? 'good' : 'average'}>
                    {E.eng_on ? 'Online' : 'Offline'}
                  </Box>
                  <Box>
                    {E.eng_status?.length ? (
                      E.eng_status.map((line, idx) => (
                        <Box key={idx} color={severityToColor(line.severity)}>
                          {line.text}
                        </Box>
                      ))
                    ) : (
                      <Box>-</Box>
                    )}
                  </Box>
                </LabeledList.Item>

                <LabeledList.Item label="Current thrust">
                  {round(E.eng_thrust * 10, 0.1) / 10}
                </LabeledList.Item>

                <LabeledList.Item label="Thrust limit">
                  <Stack align="center">
                    <Stack.Item>
                      <Button
                        icon="minus-circle"
                        onClick={() =>
                          act('engine_limit_delta', {
                            engine: E.eng_reference,
                            delta: -0.1,
                          })
                        }
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        onClick={() =>
                          act('engine_set_limit', { engine: E.eng_reference })
                        }
                      >
                        {round(E.eng_thrust_limiter, 1)}%
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="plus-circle"
                        onClick={() =>
                          act('engine_limit_delta', {
                            engine: E.eng_reference,
                            delta: 0.1,
                          })
                        }
                      />
                    </Stack.Item>
                  </Stack>
                </LabeledList.Item>
              </LabeledList>
            </Section>
          ))}
      </Window.Content>
    </Window>
  );
};

export default EnginesControl;
