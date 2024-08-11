import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, NumberInput, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export type CapacitorData = {
  anchored: BooleanLike;
  locked: BooleanLike;
  active: BooleanLike;
  time_since_fail: number;
  charge_rate: number;
  stored_charge: number;
  max_charge: number;
  max_charge_rate: number;
};

export const ShieldCapacitor = (props, context) => {
  const { act, data } = useBackend<CapacitorData>(context);

  return (
    <Window resizable theme="hephaestus">
      <Window.Content scrollable>
        <Section>
          {data.locked ? (
            <NoticeBox>Swipe ID to unlock.</NoticeBox>
          ) : (
            <CapacitorWindow />
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

export const CapacitorWindow = (props, context) => {
  const { act, data } = useBackend<CapacitorData>(context);

  return (
    <Section
      title="Shield Capacitor"
      buttons={
        <Button
          content={data.active ? 'Online' : 'Offline'}
          color={data.active ? 'good' : 'bad'}
          icon={data.active ? 'power-off' : 'times'}
          disabled={!data.anchored && !data.active}
          onClick={() => act('toggle')}
        />
      }>
      <Box fontSize={1.5}>
        Capacitor status:{' '}
        <Box as="span" bold color={data.time_since_fail > 2 ? 'good' : 'bad'}>
          {data.time_since_fail > 2 ? 'OK' : 'Discharging'}.
        </Box>
      </Box>
      <LabeledList>
        <LabeledList.Item label="Stored Charge">
          <ProgressBar
            ranges={{
              good: [data.max_charge * 0.75, data.max_charge],
              average: [data.max_charge * 0.3, data.max_charge * 0.75],
              bad: [0, data.max_charge * 0.3],
            }}
            value={data.stored_charge}
            minValue={0}
            maxValue={data.max_charge}>
            {data.stored_charge} / {data.max_charge} W
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="Charge Rate">
          <NumberInput
            value={data.charge_rate}
            minValue={0}
            maxValue={data.max_charge_rate}
            step={10000}
            stepPixelSize={3}
            onDrag={(e, v) => act('charge_rate', { charge_rate: v })}
            unit="W"
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
