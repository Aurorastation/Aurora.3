import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Section, Box, LabeledList } from '../components';
import { Window } from '../layouts';

export type VitalsData = {
  has_occupant: BooleanLike;
  stat: number;
  brain_activity: number;
  blood_pressure: number;
  blood_pressure_level: number;
  blood_volume: number;
  blood_o2: number;
};

export const VitalsMonitor = (props, context) => {
  const { act, data } = useBackend<VitalsData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Patient Vitals">
          {data.has_occupant ? (
            <PatientVitals />
          ) : (
            <Box bold>No patient detected.</Box>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

const PatientVitals = (props, context) => {
  const { act, data } = useBackend<VitalsData>(context);
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Status" color={ConsciousnessLabel(data.stat)}>
          {ConsciousnessText(data.stat)}
        </LabeledList.Item>
        <LabeledList.Item
          label="Brain Activity"
          color={ProgressClass(data.brain_activity)}>
          {data.brain_activity}%
        </LabeledList.Item>
        <LabeledList.Item
          label="BP"
          color={PressureClass(data.blood_pressure_level)}>
          {data.blood_pressure}
        </LabeledList.Item>
        <LabeledList.Item
          label="Blood Oxygenation"
          color={ProgressClass(Math.round(data.blood_o2))}>
          {Math.round(data.blood_o2)}%
        </LabeledList.Item>
        <LabeledList.Item
          label="Blood Volume"
          color={ProgressClass(Math.round(data.blood_volume))}>
          {Math.round(data.blood_volume)}%
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const ConsciousnessLabel = (value) => {
  switch (value) {
    case 0:
      return 'good';
    case 1:
      return 'average';
    case 2:
      return 'bad';
  }
};

const ConsciousnessText = (value) => {
  switch (value) {
    case 0:
      return 'Conscious';
    case 1:
      return 'Unconscious';
    case 2:
      return 'DEAD';
  }
};

const ProgressClass = (value) => {
  if (value <= 50) {
    return 'bad';
  } else if (value <= 90) {
    return 'average';
  } else {
    return 'good';
  }
};

const PressureClass = (value) => {
  switch (value) {
    case 1:
      return 'bad';
    case 2:
      return 'green';
    case 3:
      return 'good';
    case 4:
      return 'bad';
    default:
      return 'teal';
  }
};
