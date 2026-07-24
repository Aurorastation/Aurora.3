import {
  Box,
  Button,
  LabeledList,
  NumberInput,
  Section,
  Table,
} from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';

import { useBackend } from '../backend';
import { NtosWindow } from '../layouts';

type SignalerChannel = {
  index: number;
  label: string;
  frequency: number;
  code: number;
  receiving: boolean;
  receiving_enabled: boolean;
  last_received_code: number | null;
  last_received_time: string | null;
};

type Data = {
  hardware_ready: boolean;
  hardware_status: string;
  min_frequency: number;
  max_frequency: number;
  receive_channels: number;
  silent: boolean;
  channels: SignalerChannel[];
};

export const NTOSSignaler = () => {
  const { act, data } = useBackend<Data>();
  const { channels = [] } = data;
  const rows: SignalerChannel[][] = [];

  for (let i = 0; i < channels.length; i += 2) {
    rows.push(channels.slice(i, i + 2));
  }

  return (
    <NtosWindow width={820} height={720} theme="ntos">
      <NtosWindow.Content scrollable>
        <Section
          title="Signal Manager"
          buttons={
            <Button
              icon={data.silent ? 'volume-mute' : 'volume-up'}
              content={data.silent ? 'Sound Off' : 'Sound On'}
              selected={!data.silent}
              onClick={() => act('toggle_silent')}
            />
          }
        >
          <Box color={data.hardware_ready ? 'good' : 'bad'}>
            {data.hardware_status}
          </Box>
        </Section>
        <Table>
          {rows.map((row) => (
            <Table.Row key={row[0]?.index}>
              {row.map((channel) => (
                <Table.Cell key={channel.index} width="50%" verticalAlign="top">
                  <SignalSlot channel={channel} data={data} />
                </Table.Cell>
              ))}
            </Table.Row>
          ))}
        </Table>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const SignalSlot = (props: { channel: SignalerChannel; data: Data }) => {
  const { act } = useBackend<Data>();
  const { channel, data } = props;
  const channelNumber = channel.receiving
    ? channel.index
    : channel.index - data.receive_channels;

  return (
    <Section
      title={channel.label}
      buttons={
        <>
          <Button
            icon="pen"
            tooltip={`Rename ${channel.receiving ? 'receiver' : 'signaler'} ${channelNumber}`}
            onClick={() => act('rename', { index: channel.index })}
          />
          <Button
            icon="sync"
            tooltip="Reset"
            color="yellow"
            onClick={() => act('reset', { index: channel.index })}
          />
        </>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Frequency">
          <NumberInput
            animated
            tickWhileDragging
            unit="kHz"
            minValue={data.min_frequency / 10}
            maxValue={data.max_frequency / 10}
            value={channel.frequency / 10}
            step={0.1}
            stepPixelSize={6}
            format={(value) => toFixed(value, 1)}
            width="80px"
            onChange={(value) =>
              act('frequency', {
                index: channel.index,
                frequency: value * 10,
              })
            }
          />
        </LabeledList.Item>
        {channel.receiving ? (
          <>
            <LabeledList.Item label="Receiver">
              <Button
                fluid
                icon={channel.receiving_enabled ? 'toggle-on' : 'toggle-off'}
                selected={channel.receiving_enabled}
                color={channel.receiving_enabled ? 'good' : 'default'}
                content={channel.receiving_enabled ? 'Enabled' : 'Disabled'}
                onClick={() =>
                  act('toggle_receive', {
                    index: channel.index,
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="Last Code">
              {channel.receiving_enabled
                ? (channel.last_received_code ?? 'None')
                : 'Disabled'}
            </LabeledList.Item>
            <LabeledList.Item label="Last Signal">
              {channel.receiving_enabled
                ? channel.last_received_time || 'None'
                : 'Disabled'}
            </LabeledList.Item>
          </>
        ) : (
          <>
            <LabeledList.Item label="Code">
              <NumberInput
                animated
                tickWhileDragging
                minValue={1}
                maxValue={100}
                value={channel.code}
                step={1}
                stepPixelSize={6}
                width="80px"
                onChange={(value) =>
                  act('code', {
                    index: channel.index,
                    code: value,
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="Send">
              <Button
                fluid
                icon="wifi"
                disabled={!data.hardware_ready}
                color="good"
                content="Send Signal"
                onClick={() => act('send', { index: channel.index })}
              />
            </LabeledList.Item>
          </>
        )}
      </LabeledList>
    </Section>
  );
};
