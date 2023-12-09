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
  occupant: Occupant[];
  isBeakerLoaded: BooleanLike;
  currentStasisMult: number;
  fastStasisMult: number;
  slowStasisMult: number;
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
            disabled={!hasOccupant}>
            Eject
          </Button>
        }>
        {hasOccupant ? (
          <LabeledList>
            <LabeledList.Item label="Occupant">
              {occupant.name || 'Unknown'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Status"
              color={statNames[occupant.stat][0]}>
              {statNames[occupant.stat][1]}
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item
              label="Brain Activity"
              color={progressClass(occupant.brainActivity)}>
              {brainText(occupant.brainActivity)}
            </LabeledList.Item>
            <LabeledList.Item
              label="Pulse Rate"
              color={progressClass(occupant.brainActivity)}>
              <AnimatedNumber value={occupant.Pulse}> BPM</AnimatedNumber>
            </LabeledList.Item>
            <LabeledList.Item
              label="Blood Pressure"
              color={getPressureClass(occupant.bloodPressureLevel)}>
              {occupant.bloodPressure}
            </LabeledList.Item>
            <LabeledList.Item label="Blood Oxygenation">
              <ProgressBar
                value={occupant.bloodOxygenation}
                ranges={{
                  bad: [0.01, 50],
                  average: [50.01, 90],
                  good: [90.01, Infinity],
                }}>
                <AnimatedNumber value={Math.round(occupant.bloodOxygenation)} />
                {'%'}
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Temperature">
              <AnimatedNumber value={Math.round(occupant.bodyTemperature)} />
              {' K'}
            </LabeledList.Item>
            <LabeledList.Item label="Cryostasis Multiplier">
              <AnimatedNumber value={Math.round(occupant.cryostasis)} />
              {'x'}
            </LabeledList.Item>
            <LabeledList.Divider />
            {damageTypes.map((damageType) => (
              <LabeledList.Item key={damageType.id} label={damageType.label}>
                <ProgressBar
                  value={occupant[damageType.type] / 100}
                  ranges={{ bad: [0.01, Infinity] }}>
                  <AnimatedNumber
                    value={Math.round(occupant[damageType.type])}
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
            disabled={!isBeakerLoaded}>
            Eject Beaker
          </Button>
        }>
        <LabeledList>
          <LabeledList.Item label="Power">
            <Button
              icon="power-off"
              onClick={() => act(isOperating ? 'switchOff' : 'switchOn')}
              selected={isOperating}>
              {isOperating ? 'On' : 'Off'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Temperature" color={cellTemperatureStatus}>
            <AnimatedNumber value={cellTemperature} /> K
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
              selected={currentStasisMult === slowStasisMult}>
              Prioritize Stasis
            </Button>
            <Button
              icon="forward"
              onClick={() => act('goRegular')}
              selected={currentStasisMult === 1}>
              Balanced
            </Button>
            <Button
              icon="forward-fast"
              onClick={() => act('goFast')}
              selected={currentStasisMult === fastStasisMult}>
              Prioritize Metabolism
            </Button>
          </LabeledList.Item>
        </LabeledList>
      </Section>
    </Fragment>
  );
};

const CryoBeaker = (props, context) => {
  const { act, data } = useBackend(context);
  const { isBeakerLoaded, beakerLabel, beakerVolume } = data;
  if (isBeakerLoaded) {
    return (
      <Fragment>
        {beakerLabel ? beakerLabel : <Box color="average">No label</Box>}
        <Box color={!beakerVolume && 'bad'}>
          {beakerVolume ? (
            <AnimatedNumber
              value={beakerVolume}
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
