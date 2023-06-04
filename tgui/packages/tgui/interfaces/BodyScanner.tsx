import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { BlockQuote, LabeledList, Section, Stack } from '../components';
import { Window } from '../layouts';

export type ScannerData = {
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
  rads: number;

  cloneLoss: string;
  oxyLoss: string;
  bruteLoss: string;
  fireLoss: string;
  toxLoss: string;

  paralysis: number;
  bodytemp: number;
  inaprovaline_amount: number;
  soporific_amount: number;
  bicaridine_amount: number;
  dexalin_amount: number;
  dermaline_amount: number;
  thetamycin_amount: number;
  other_amount: number;

  organs: Organ[];
  has_internal_injuries: BooleanLike;
  has_external_injuries: BooleanLike;
  missing_organs: string;
};

type Organ = {
  name: string;
  burn_damage: string;
  brute_damage: string;
  wounds: string;
};

export const BodyScanner = (props, context) => {
  const { act, data } = useBackend<ScannerData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        {data.invalid ? <InvalidWindow /> : <ScannerWindow />}
      </Window.Content>
    </Window>
  );
};

export const InvalidWindow = (props, context) => {
  const { act, data } = useBackend<ScannerData>(context);

  return (
    <BlockQuote color="red">
      {data.nocons
        ? 'No scanner bed detected.'
        : !data.occupied
          ? 'No occupant detected.'
          : data.ipc
            ? 'An object in the scanner bed is interfering with the sensor array.'
            : data.noscan
              ? 'No diagnostics profile installed for this species.'
              : 'Unknown error.'}
    </BlockQuote>
  );
};

export const ScannerWindow = (props, context) => {
  const { act, data } = useBackend<ScannerData>(context);

  return (
    <Stack fill>
      <Stack.Item>
        <Section fill title="Patient Status">
          <LabeledList>
            <LabeledList.Item label="Name">{data.name}</LabeledList.Item>
            <LabeledList.Item
              label="Status"
              color={consciousnessLabel(data.stat)}>
              {consciousnessText(data.stat)}
            </LabeledList.Item>
            <LabeledList.Item label="Species">{data.species}</LabeledList.Item>
            <LabeledList.Item
              label="Brain Activity"
              color={progressClass(data.brain_activity)}>
              {brainText(data.brain_activity)}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const consciousnessLabel = (value) => {
  switch (value) {
    case 0:
      return 'good';
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
    return 'good';
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

const damageLabel = (value) => {
  if (value === 'Fatal' || value < 10) {
    return 'bad';
  }
  if (value === 'Critical' || value < 20) {
    return 'bad';
  } else if (value === 'Severe' || value < 40) {
    return 'average';
  } else if (value === 'Significant' || value < 60) {
    return 'orange';
  } else if (value === 'Moderate' || value < 80) {
    return 'yellow';
  } else if (value === 'Minor' || value < 100) {
    return 'good';
  } else {
    return 'green';
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
