import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export type SupermatterData = {
  integrity_percentage: number;
  ambient_temp: number;
  ambient_pressure: number;
  detonating: BooleanLike;
};

export const Supermatter = (props, context) => {
  const { act, data } = useBackend<SupermatterData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        {data.detonating ? <DetonateWindow /> : <SupermatterWindow />}
      </Window.Content>
    </Window>
  );
};

export const DetonateWindow = (props, context) => {
  const { act, data } = useBackend<SupermatterData>(context);

  return (
    <Section title="CRYSTAL DELAMINATION IMMINENT">
      <Box color="bad">Evacuate immediately!</Box>
    </Section>
  );
};

export const SupermatterWindow = (props, context) => {
  const { act, data } = useBackend<SupermatterData>(context);

  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Crystal Integrity">
          <ProgressBar
            ranges={{
              good: [80, 100],
              average: [40, 80],
              bad: [0, 40],
            }}
            value={data.integrity_percentage}
            minValue={0}
            maxValue={100}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Temperature">
          <ProgressBar
            ranges={{
              good: [0, 4500],
              average: [4500, 6000],
              bad: [6000, Infinity],
            }}
            value={data.ambient_temp}
            minValue={0}
            maxValue={10000}>
            {data.ambient_temp} K
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="Pressure">
          {data.ambient_pressure} kPa
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
