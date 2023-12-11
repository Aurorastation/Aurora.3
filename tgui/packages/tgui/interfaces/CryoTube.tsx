import { Fragment } from 'inferno';
import { Window } from '../layouts';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, Flex, Icon, LabeledList, ProgressBar, Section } from '../components';
import { BooleanLike } from 'common/react';

export type CryoData = {
  isOperating: BooleanLike;
  hasOccupant: BooleanLike;
  cellTemperature: number;
  cellTemperatureStatus: string;
  occupant: Occupant;
  isBeakerLoaded: BooleanLike;
  currentStasisMult: number;
  fastStasisMult: number;
  slowStasisMult: number;
};

export type BeakerData = {
  isBeakerLoaded: BooleanLike;
  beakerLabel: string;
  beakerVolume: number;
};

type Occupant = {
  name: string;
  stat: number;
  bruteLoss: string;
  cloneLoss: string;
  bodyTemperature: number;
  brainActivity: number;
  pulse: number;
  cryostasis: number;
  bloodPressure: number;
  bloodPressureLevel: number;
  bloodOxygenation: number;
};

const damageTypes = [
  {
    label: 'Physical Damage',
    type: 'bruteLoss',
  },
  {
    label: 'Genetic Damage',
    type: 'cloneLoss',
  },
];

const statNames = [
  ['good', 'Conscious'],
  ['average', 'Unconscious'],
  ['bad', 'DEAD'],
];

const progressClass = (value) => {
  if (value <= 50) {
    return 'bad';
  } else if (value <= 90) {
    return 'average';
  } else {
    return 'green';
  }
};

export const CryoTube = (props, context) => {
  const { act, data } = useBackend<CryoData>(context);
  return (
    <Window resizable theme="zenghu">
      <Window.Content className="Layout__content--flexColumn">
        <CryoContent />
      </Window.Content>
    </Window>
  );
};

export const CryoContent = (props, context) => {
  const { act, data } = useBackend<CryoData>(context);
  return (
    <Fragment>
      <Section
        title="Occupant"
        flexGrow="1"
        buttons={
          <Button
            icon="user-slash"
            onClick={() => act('ejectOccupant')}
            disabled={!data.hasOccupant}>
            Eject
          </Button>
        }>
        {data.hasOccupant ? (
          <LabeledList>
            <LabeledList.Item label="Occupant">
              {data.occupant.name || 'Unknown'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Status"
              color={statNames[data.occupant.stat][0]}>
              {statNames[data.occupant.stat][1]}
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item
              label="Brain Activity"
              color={progressClass(data.occupant.brainActivity)}>
              {brainText(data.occupant.brainActivity)}
            </LabeledList.Item>
            <LabeledList.Item
              label="Pulse Rate"
              color={progressClass(data.occupant.brainActivity)}>
              {data.occupant.pulse} BPM
            </LabeledList.Item>
            <LabeledList.Item
              label="Blood Pressure"
              color={getPressureClass(data.occupant.bloodPressureLevel)}>
              {data.occupant.bloodPressure}
            </LabeledList.Item>
            <LabeledList.Item label="Blood Oxygenation">
              <ProgressBar
                value={data.occupant.bloodOxygenation}
                ranges={{
                  bad: [0.01, 50],
                  average: [50.01, 90],
                  good: [90.01, Infinity],
                }}>
                <AnimatedNumber
                  value={Math.round(data.occupant.bloodOxygenation)}
                />
                {'%'}
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Temperature">
              <AnimatedNumber
                value={Math.round(data.occupant.bodyTemperature)}
              />
              {' K'}
            </LabeledList.Item>
            <LabeledList.Item label="Cryostasis Multiplier">
              <AnimatedNumber value={Math.round(data.occupant.cryostasis)} />
              {'x'}
            </LabeledList.Item>
            <LabeledList.Divider />
            {damageTypes.map((damageType) => (
              <LabeledList.Item key={damageType.label} label={damageType.label}>
                <ProgressBar
                  value={data.occupant[damageType.type] / 100}
                  ranges={{ bad: [0.01, Infinity] }}>
                  <AnimatedNumber
                    value={Math.round(data.occupant[damageType.type])}
                  />
                </ProgressBar>
              </LabeledList.Item>
            ))}
          </LabeledList>
        ) : (
          <Flex height="100%" textAlign="center">
            <Flex.Item grow="1" align="center" color="label">
              <Icon name="user-slash" mb="0.5rem" size="5" />
              <br />
              No occupant detected.
            </Flex.Item>
          </Flex>
        )}
      </Section>
      <Section
        title="Cell"
        buttons={
          <Button
            icon="eject"
            onClick={() => act('ejectBeaker')}
            disabled={!data.isBeakerLoaded}>
            Eject Beaker
          </Button>
        }>
        <LabeledList>
          <LabeledList.Item label="Power">
            <Button
              icon="power-off"
              onClick={() => act(data.isOperating ? 'switchOff' : 'switchOn')}
              selected={data.isOperating}>
              {data.isOperating ? 'On' : 'Off'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item
            label="Temperature"
            color={data.cellTemperatureStatus}>
            <AnimatedNumber value={data.cellTemperature} /> K
          </LabeledList.Item>
          <LabeledList.Item label="Beaker">
            <CryoBeaker />
          </LabeledList.Item>
        </LabeledList>
        <LabeledList>
          <LabeledList.Item label="Cryostasis Mode">
            <Button
              icon="play"
              onClick={() => act('goSlow')}
              selected={data.currentStasisMult === data.slowStasisMult}>
              Prioritize Stasis
            </Button>
            <Button
              icon="forward"
              onClick={() => act('goRegular')}
              selected={data.currentStasisMult === 1}>
              Balanced
            </Button>
            <Button
              icon="forward-fast"
              onClick={() => act('goFast')}
              selected={data.currentStasisMult === data.fastStasisMult}>
              Prioritize Metabolism
            </Button>
          </LabeledList.Item>
        </LabeledList>
      </Section>
    </Fragment>
  );
};

const CryoBeaker = (props, context) => {
  const { act, data } = useBackend<BeakerData>(context);
  if (data.isBeakerLoaded) {
    return (
      <Fragment>
        {data.beakerLabel ? (
          data.beakerLabel
        ) : (
          <Box color="average">No label</Box>
        )}
        <Box color={!data.beakerVolume && 'bad'}>
          {data.beakerVolume ? (
            <AnimatedNumber
              value={data.beakerVolume}
              format={(v) => Math.round(v) + ' units remaining'}
            />
          ) : (
            'Beaker is empty'
          )}
        </Box>
      </Fragment>
    );
  } else {
    return <Box color="average">No beaker loaded</Box>;
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
