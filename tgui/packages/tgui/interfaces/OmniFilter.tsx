import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import {
  Button,
  LabeledList,
  ProgressBar,
  Section,
  Table,
} from '../components';
import { Window } from '../layouts';

type OmniFilterData = {
  power: BooleanLike;
  config: BooleanLike;
  last_power_draw: number;
  max_power_draw: number;
  set_flow_rate: number;
  max_flow_rate: number;
  last_flow_rate: number;
  ports: PortEntry[];
  filter_types: string[];
};

type PortEntry = {
  dir: string;
  input: BooleanLike;
  output: BooleanLike;
  filter: BooleanLike;
  f_type: string | null;
};

export const OmniFilter = (props, context) => {
  const { act, data } = useBackend<OmniFilterData>(context);

  return (
    <Window
      title="Omni Filter Control"
      width={430}
      height={360}
      theme="hephaestus"
    >
      <Window.Content>
        <Section title="Controls">
          <LabeledList>
            <LabeledList.Item label="Power">
              <Button
                icon="power-off"
                content={data.power ? 'On' : 'Off'}
                selected={!!data.power}
                disabled={!!data.config}
                onClick={() => act('power')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Configure">
              <Button
                icon="cog"
                content="Configure"
                selected={!!data.config}
                onClick={() => act('configure')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Flow Rate">
              {data.config ? (
                <Button
                  content={`${data.set_flow_rate} L/s`}
                  onClick={() => act('set_flow_rate')}
                />
              ) : (
                `${data.set_flow_rate} L/s`
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Current Flow Rate">
              {data.last_flow_rate} L/s
            </LabeledList.Item>
            <LabeledList.Item label="Load">
              <ProgressBar
                value={data.last_power_draw}
                minValue={0}
                maxValue={data.max_power_draw}
                color={
                  data.last_power_draw < data.max_power_draw - 5
                    ? 'good'
                    : 'average'
                }
              >
                {data.last_power_draw} W
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {data.ports?.length > 0 && (
          <Section title="Ports">
            <Table>
              <Table.Row header>
                <Table.Cell>Port</Table.Cell>
                <Table.Cell textAlign="center">Input</Table.Cell>
                <Table.Cell textAlign="center">Output</Table.Cell>
                <Table.Cell textAlign="center">Filter</Table.Cell>
              </Table.Row>
              {data.ports.map((port) => (
                <Table.Row key={port.dir}>
                  <Table.Cell color="average">{port.dir} Port</Table.Cell>
                  <Table.Cell textAlign="center">
                    {data.config ? (
                      <Button
                        icon={port.input ? 'dot-circle' : 'circle'}
                        selected={!!port.input}
                        onClick={() =>
                          act('switch_mode', {
                            dir: port.dir,
                            mode: port.input ? 'none' : 'in',
                          })
                        }
                      />
                    ) : port.input ? (
                      'Input'
                    ) : (
                      ''
                    )}
                  </Table.Cell>
                  <Table.Cell textAlign="center">
                    {data.config ? (
                      <Button
                        icon={port.output ? 'dot-circle' : 'circle'}
                        selected={!!port.output}
                        onClick={() =>
                          act('switch_mode', {
                            dir: port.dir,
                            mode: 'out',
                          })
                        }
                      />
                    ) : port.output ? (
                      'Output'
                    ) : (
                      ''
                    )}
                  </Table.Cell>
                  <Table.Cell textAlign="center">
                    {data.config ? (
                      <Button
                        content={port.filter ? (port.f_type ?? 'None') : '-'}
                        disabled={!port.filter}
                        onClick={() => act('switch_filter', { dir: port.dir })}
                      />
                    ) : port.filter ? (
                      (port.f_type ?? 'None')
                    ) : (
                      ''
                    )}
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
