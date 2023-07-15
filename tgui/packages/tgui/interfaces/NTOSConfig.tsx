import { toFixed } from 'common/math';
import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { BlockQuote, Box, Button, Divider, LabeledList, ProgressBar, Section, Slider, Stack } from '../components';
import { NtosWindow } from '../layouts';

type BatteryData = {
  rating: number;
  percent: number;
};

type Hardware = {
  name: string;
  desc: string;
  enabled: BooleanLike;
  critical: BooleanLike;
  power_usage: number;
};

type NTOSConfigData = {
  battery: BatteryData;
  hardware: Hardware[];
  power_usage: number;
  disk_size: number;
  disk_used: number;
  card_slot: BooleanLike;
  registered: string;
  brightness: number;
  message_range: number;
  max_message_range: number;
};

const BatteryStatus = (props, context) => {
  const { act, data } = useBackend<NTOSConfigData>(context);
  const { battery } = data;
  if (!battery) {
    return (
      <LabeledList>
        <LabeledList.Item label="Battery" color="label">
          Not Installed
        </LabeledList.Item>
      </LabeledList>
    );
  } else {
    return (
      <LabeledList>
        <LabeledList.Item label="Battery" color="good">
          Installed
        </LabeledList.Item>
        <LabeledList.Item label="Rating" color="label">
          {battery.rating} Wh
        </LabeledList.Item>
        <LabeledList.Item label="Charge">
          <ProgressBar
            ranges={{
              good: [0.5, Infinity],
              average: [0.25, 0.5],
              bad: [-Infinity, 0.25],
            }}
            value={toFixed(battery.percent / 100)}
          />
        </LabeledList.Item>
      </LabeledList>
    );
  }
};

const ResourceUsage = (props, context) => {
  const { act, data } = useBackend<NTOSConfigData>(context);
  const { power_usage, disk_used, disk_size } = data;
  const remainingSpace = disk_size - disk_used;
  return (
    <LabeledList>
      <LabeledList.Item label="Power Usage" color="label">
        {power_usage} W
      </LabeledList.Item>
      <LabeledList.Item label="Drive Space">
        <ProgressBar
          ranges={{
            good: [-Infinity, 0.5],
            average: [0.5, 0.75],
            bad: [0.75, Infinity],
          }}
          value={disk_used / disk_size}>
          {remainingSpace} GQ free of {disk_size} GQ (
          {toFixed((disk_used / disk_size) * 100)}%)
        </ProgressBar>
      </LabeledList.Item>
    </LabeledList>
  );
};

export const NTOSConfig = (props, context) => {
  const { act, data } = useBackend<NTOSConfigData>(context);
  const {
    hardware = [],
    card_slot,
    registered,
    brightness,
    message_range,
    max_message_range,
  } = data;
  return (
    <NtosWindow>
      <NtosWindow.Content scrollable>
        <Stack justify="space-between">
          <Stack.Item>
            <BatteryStatus />
          </Stack.Item>
          <Stack.Item>
            <ResourceUsage />
          </Stack.Item>
        </Stack>
        <Divider />
        <Stack.Item width="100%">
          <LabeledList>
            <LabeledList.Item label="Registered ID">
              <Button disabled={!card_slot} onClick={() => act('PC_register')}>
                {registered ? registered : 'Unregistered'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Aud. Message Output Range">
              <Slider
                minValue={0}
                maxValue={max_message_range}
                value={message_range}
                step={1}
                stepPixelSize={30}
                onChange={(_, value) =>
                  act('audmessage', { 'new_range': value })
                }
              />
            </LabeledList.Item>
            {!(typeof brightness === 'undefined') && (
              <LabeledList.Item label="Flashlight Brightness">
                <Slider
                  minValue={0}
                  maxValue={10}
                  step={1}
                  stepPixelSize={30}
                  value={brightness}
                  onChange={(_, value) =>
                    act('brightness', { 'new_brightness': value })
                  }
                />
              </LabeledList.Item>
            )}
          </LabeledList>
        </Stack.Item>
        <Divider />
        <Section title="Hardware Configuration">
          <Stack.Item width="100%">
            <Stack fill vertical>
              {hardware.map((part) => {
                const { name, desc, enabled, critical, power_usage } = part;
                return (
                  <Stack.Item key={name}>
                    <Section
                      title={name}
                      mx={10}
                      buttons={
                        <Button
                          disabled={critical}
                          color={!critical && enabled ? 'bad' : 'good'}
                          icon="power-off"
                          onClick={() =>
                            act('PC_toggle_component', { 'component': name })
                          }>
                          {critical
                            ? 'N/A'
                            : enabled
                              ? 'Power Off'
                              : 'Power On'}
                        </Button>
                      }>
                      <BlockQuote>{desc}</BlockQuote>
                      {power_usage > 0 && (
                        <Box as="span">Power Usage: {power_usage} W</Box>
                      )}
                    </Section>
                  </Stack.Item>
                );
              })}
            </Stack>
          </Stack.Item>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
