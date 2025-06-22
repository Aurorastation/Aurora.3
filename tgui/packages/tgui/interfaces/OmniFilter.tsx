import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Box, Button, Flex, LabeledList, NumberInput, ProgressBar, Section, Stack } from '../components';
import { Window } from '../layouts';

export type OmniFilterData = {
  power: BooleanLike;
  isConfiguring: BooleanLike;
  power_draw_last: number;
  power_draw_max: number;
  flow_rate_last: number;
  flow_rate_set: number;
  flow_rate_max: number;
  portData: Port[];
};

type Port = {
  dir: string;
  input: BooleanLike;
  output: BooleanLike;
  filter: BooleanLike;
  filter_type: string;
};

export const OmniFilter = (props, context) => {
  const { act, data } = useBackend<OmniFilterData>(context);

  return (
    <Window resizable width={720} height={600}>
      <Window.Content>
        {
          // Top section contains power and configuration buttons.
        }
        <Section
          title="Omni Filter Management"
          buttons={
            <>
              {
                // Power button just toggles power, obviously
              }
              <Button
                content={data.power ? 'On' : 'Off'}
                icon={data.power ? 'power-off' : 'times'}
                color={!data.power ? 'red' : 'green'}
                onClick={() => act('powerToggle')}
              />
              <Button
                content={'Configure'}
                color={!data.isConfiguring ? 'red' : 'green'}
                onClick={() => act('configToggle')}
              />
            </>
          }>
          <Flex>
            <Flex.Item>
              <Box>
                <Section fill title="Flow Status Panel">
                  <LabeledList>
                    <LabeledList.Item label="Transfer Rate">
                      <NumberInput
                        animated
                        disabled={!data.isConfiguring}
                        value={data.flow_rate_set}
                        width="63px"
                        unit="L/s"
                        minValue={0}
                        maxValue={data.flow_rate_max}
                        onChange={(_, value) =>
                          act('flowRateSet', {
                            flow_rate_set: value,
                          })
                        }
                      />
                      <Button
                        ml={1}
                        icon="maximize"
                        content="Max"
                        disabled={data.flow_rate_set === data.flow_rate_max}
                        onClick={() =>
                          act('flowRateSet', {
                            flow_rate_set: 'flow_rate_max',
                          })
                        }
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="Current Flow Rate">
                      {data.flow_rate_last} L/s
                    </LabeledList.Item>
                    <LabeledList.Item label="Current Power Load">
                      <ProgressBar
                        ranges={{
                          good: [0, data.power_draw_max * 0.25],
                          average: [
                            data.power_draw_max * 0.25,
                            data.power_draw_max * 0.75,
                          ],
                          bad: [
                            data.power_draw_max * 0.75,
                            data.power_draw_max,
                          ],
                        }}
                        value={data.power_draw_last}
                        minValue={0}
                        maxValue={data.power_draw_max}
                      />
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              </Box>
            </Flex.Item>
            {/*
              In the future, add another Flex.Item here for configuration of
              sensor-based shutoff params (i.e. if temp > X, shutoff.) That will
              prob be its own .tsx that will get pulled into the new flex box.
            */}
          </Flex>
        </Section>
        <Section>
          <Box width="450px" inline={1}>
            <Section title="Port Management">
              {
                // here we go....
              }
              <Stack vertical fill>
                <Stack.Item>
                  <Flex grow={1} align="center">
                    <Flex.Item>
                      <Box width="150px" textAlign="center">
                        Empty Space
                      </Box>
                    </Flex.Item>
                    <Flex.Item>
                      <Box width="150px" textAlign="center">
                        {data.portData.map(({ dir }, index) => (
                          <Button
                            icon="chevron-circle-up"
                            key={index}
                            content={dir}
                            disabled={!data.isConfiguring}
                            onClick={() =>
                              act('portModeToggle', {
                                dir: dir,
                                mode: 'output',
                              })
                            }
                          />
                        ))}
                      </Box>
                      <Box width="150px" textAlign="center">
                        Filter Label
                      </Box>
                      <Box width="150px" textAlign="center">
                        {/*
                          <Button
                            icon="chevron-circle-down"
                            disabled={!data.isConfiguring}
                            onClick={() =>
                              act('portModeToggle', {
                                dir: Port.dir,
                                mode: 'input',
                              })
                            }
                          />
                          */}
                      </Box>
                    </Flex.Item>
                    <Flex.Item>
                      <Box width="150px" textAlign="center">
                        Box 1
                      </Box>
                    </Flex.Item>
                  </Flex>
                </Stack.Item>
              </Stack>
            </Section>
          </Box>
          <Box width="250px" inline={1}>
            <Section title="Filter Configuration">
              <Stack>
                <Stack.Item>North Port</Stack.Item>
                <Stack.Item>East Port</Stack.Item>
                <Stack.Item>South Port</Stack.Item>
                <Stack.Item>West Port</Stack.Item>
              </Stack>
            </Section>
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
