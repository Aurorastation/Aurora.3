import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { BlockQuote, LabeledList, Section, Table } from '../components';
import { Window } from '../layouts';

export type OperatingData = {
  // Booleans for errors.
  noscan: BooleanLike;
  nocons: BooleanLike;
  occupied: BooleanLike;
  invalid: BooleanLike;
  ipc: BooleanLike;

  // Occupant data.
  stat: number;
  name: string;
  species: string;
  brain_activity: number;
  pulse: number;
  blood_pressure: number;
  blood_pressure_level: number;
  blood_volume: number;
  blood_o2: number;
  blood_type: string;
};

export const Operating = (props, context) => {
  const { act, data } = useBackend<OperatingData>(context);

  return (
    <Window resizable theme="zenghu">
      <Window.Content scrollable>
        {data.invalid ? <InvalidWindow /> : <OperatingWindow />}
      </Window.Content>
    </Window>
  );
};

export const InvalidWindow = (props, context) => {
  const { act, data } = useBackend<OperatingData>(context);

  return (
    <Section>
      <BlockQuote>
        {data.nocons
          ? 'No operating table detected.'
          : !data.occupied
            ? 'No occupant detected.'
            : data.ipc
              ? 'An object on the operating table is interfering with the sensor array.'
              : data.noscan
                ? 'No diagnostics profile installed for this species.'
                : 'Unknown error.'}
      </BlockQuote>
    </Section>
  );
};

export const OperatingWindow = (props, context) => {
  const { act, data } = useBackend<OperatingData>(context);

  return (
    <Table>
      <Table.Row>
        <Table.Cell>
          <Section title="Patient Status" fill={false}>
            <Section>
              <LabeledList>
                <LabeledList.Item label="Name">{data.name}</LabeledList.Item>
                <LabeledList.Item label="Species">
                  {data.species}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Status"
                  color={consciousnessLabel(data.stat)}>
                  {consciousnessText(data.stat)}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Brain Activity"
                  color={progressClass(data.brain_activity)}>
                  {brainText(data.brain_activity)}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Pulse"
                  color={progressClass(data.brain_activity)}>
                  {data.pulse}
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <Section title="Blood Status" fill:true>
              <LabeledList>
                <LabeledList.Item
                  label="Blood Pressure"
                  color={getPressureClass(data.blood_pressure_level)}>
                  {data.blood_pressure}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Blood Oxygenation"
                  color={progressClass(data.blood_o2)}>
                  {Math.round(data.blood_o2)}%
                </LabeledList.Item>
                <LabeledList.Item
                  label="Blood Volume"
                  color={progressClass(data.brain_activity)}>
                  {Math.round(data.blood_volume)}%
                </LabeledList.Item>
                <LabeledList.Item label="Blood Type">
                  {data.blood_type}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Section>
        </Table.Cell>
      </Table.Row>
    </Table>
  );
};

const consciousnessLabel = (value) => {
  switch (value) {
    case 0:
      return 'green';
    case 1:
      return 'average';
    case 2:
      return 'bad';
  }
};
const consciousnessText = (value) => {
  switch (value) {
    case 0:
      return 'Conscious';
    case 1:
      return 'Unconscious';
    case 2:
      return 'DEAD';
  }
};

const progressClass = (value) => {
  if (value <= 50) {
    return 'bad';
  } else if (value <= 90) {
    return 'average';
  } else {
    return 'green';
  }
};

const brainText = (value) => {
  switch (value) {
    case 0:
      return 'None, patient is braindead';
    case -1:
      return 'ERROR - Non-Standard Biology';
    default:
      return value.toString().concat('%');
  }
};

const getPressureClass = (tpressure) => {
  switch (tpressure) {
    case 1:
      return 'red';
    case 2:
      return 'green';
    case 3:
      return 'good';
    case 4:
      return 'red';
    default:
      return 'teal';
  }
};
