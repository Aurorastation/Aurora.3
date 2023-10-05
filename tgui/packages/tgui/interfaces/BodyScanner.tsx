import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { BlockQuote, Box, Button, LabeledList, Section, Table } from '../components';
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
  blood_type: string;
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

  bodyparts: Organ[];
  organs: InternalOrgan[];
  has_internal_injuries: BooleanLike;
  has_external_injuries: BooleanLike;
  missing_limbs: string;
  missing_organs: string;
};

type Organ = {
  name: string;
  burn_damage: string;
  brute_damage: string;
  wounds: string;
  infection: string;
};

type InternalOrgan = {
  name: string;
  location: string;
  damage: string;
  wounds: string;
  infection: string;
};

export const BodyScanner = (props, context) => {
  const { act, data } = useBackend<ScannerData>(context);

  return (
    <Window resizable theme="zenghu">
      <Window.Content scrollable>
        {data.invalid ? <InvalidWindow /> : <ScannerWindow />}
      </Window.Content>
    </Window>
  );
};

export const InvalidWindow = (props, context) => {
  const { act, data } = useBackend<ScannerData>(context);

  return (
    <Table>
      <Table.Row>
        <Table.Cell>
          <Section>
            <BlockQuote>
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
          </Section>
        </Table.Cell>
      </Table.Row>
    </Table>
  );
};

export const ScannerWindow = (props, context) => {
  const { act, data } = useBackend<ScannerData>(context);

  return (
    <Table>
      <Table.Row>
        <Table.Cell>
          <Section
            fill={false}
            title="Patient Status"
            buttons={
              <>
                <Button
                  content="Print"
                  icon="print"
                  onClick={() => act('print')}
                />
                <Button
                  content="Eject"
                  color="red"
                  icon="arrow-right-from-bracket"
                  onClick={() => act('eject')}
                />
              </>
            }>
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
                  {data.pulse} BPM
                </LabeledList.Item>
                <LabeledList.Item label="Body Temperature">
                  {data.bodytemp}°C
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
                {data.inaprovaline_amount ? (
                  <LabeledList.Item label="Inaprovaline">
                    {Math.round(data.inaprovaline_amount)}u
                  </LabeledList.Item>
                ) : (
                  ''
                )}
                {data.soporific_amount ? (
                  <LabeledList.Item label="Soporific">
                    {Math.round(data.soporific_amount)}u
                  </LabeledList.Item>
                ) : (
                  ''
                )}
                {data.bicaridine_amount ? (
                  <LabeledList.Item label="Bicaridine">
                    {Math.round(data.bicaridine_amount)}u
                  </LabeledList.Item>
                ) : (
                  ''
                )}
                {data.dermaline_amount ? (
                  <LabeledList.Item label="Dermaline">
                    {Math.round(data.dermaline_amount)}u
                  </LabeledList.Item>
                ) : (
                  ''
                )}
                {data.dexalin_amount ? (
                  <LabeledList.Item label="Dexalin">
                    {Math.round(data.dexalin_amount)}u
                  </LabeledList.Item>
                ) : (
                  ''
                )}
                {data.thetamycin_amount ? (
                  <LabeledList.Item label="Thetamycin">
                    {Math.round(data.thetamycin_amount)}u
                  </LabeledList.Item>
                ) : (
                  ''
                )}
                {data.other_amount ? (
                  <LabeledList.Item label="Other">
                    {Math.round(data.other_amount)}u
                  </LabeledList.Item>
                ) : (
                  ''
                )}
              </LabeledList>
            </Section>
            <Section title="Symptom Status" fill:true>
              <LabeledList>
                <LabeledList.Item label="Radiation Level">
                  {Math.round(data.rads)} Gy
                </LabeledList.Item>
                <LabeledList.Item label="Genetic Damage">
                  {data.cloneLoss}
                </LabeledList.Item>
                <LabeledList.Item label="Est. Paralysis Level">
                  {data.paralysis
                    ? Math.round(data.paralysis / 4) + ' Seconds Left'
                    : 'None'}
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <Section title="Damage Status" fill:true>
              <LabeledList>
                <LabeledList.Item
                  label="Brute Trauma"
                  color={damageLabel(data.bruteLoss)}>
                  {data.bruteLoss}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Burn Severity"
                  color={damageLabel(data.fireLoss)}>
                  {data.fireLoss}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Oxygen Deprivation"
                  color={damageLabel(data.oxyLoss)}>
                  {data.oxyLoss}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Toxin Exposure"
                  color={damageLabel(data.toxLoss)}>
                  {data.toxLoss}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Section>
          <Section title="Body Status">
            {data.has_external_injuries ? (
              <ExternalOrganWindow />
            ) : (
              <BlockQuote color="green">
                No external injuries detected.
              </BlockQuote>
            )}
          </Section>
          <LabeledList>
            <Section>
              {data.missing_limbs === 'Nothing' ? '' : <MissingLimbs />}
            </Section>
          </LabeledList>
          <Section title="Internal Organ Status">
            {data.has_internal_injuries ? (
              <OrganWindow />
            ) : (
              <BlockQuote color="green">
                No internal injuries detected.
              </BlockQuote>
            )}
          </Section>
          <LabeledList>
            <Section>
              {data.missing_organs === 'Nothing' ? '' : <MissingOrgans />}
            </Section>
          </LabeledList>
        </Table.Cell>
      </Table.Row>
    </Table>
  );
};

export const OrganWindow = (props, context) => {
  const { act, data } = useBackend<ScannerData>(context);

  return (
    <Table>
      <Table.Row color="blue">
        <Table.Cell>Name</Table.Cell>
        <Table.Cell>Damage</Table.Cell>
        <Table.Cell>Complications</Table.Cell>
        <Table.Cell>Immune</Table.Cell>
      </Table.Row>
      {data.organs.sort().map((organ) => (
        <Table.Row key={organ.name}>
          <Table.Cell>{organ.name}</Table.Cell>
          <Table.Cell color={damageLabel(organ.damage)}>
            {organ.damage}
          </Table.Cell>
          <Table.Cell>{organ.wounds}</Table.Cell>
          <Table.Cell>{organ.infection}</Table.Cell>
        </Table.Row>
      ))}
    </Table>
  );
};

export const ExternalOrganWindow = (props, context) => {
  const { act, data } = useBackend<ScannerData>(context);

  return (
    <Table>
      <Table.Row color="blue">
        <Table.Cell>Name</Table.Cell>
        <Table.Cell>Brute</Table.Cell>
        <Table.Cell>Burn</Table.Cell>
        <Table.Cell>Complications</Table.Cell>
        <Table.Cell>Immune</Table.Cell>
      </Table.Row>
      {data.bodyparts.sort().map((organ) => (
        <Table.Row key={organ.name}>
          <Table.Cell>{organ.name}</Table.Cell>
          <Table.Cell color={damageLabel(organ.brute_damage)}>
            {organ.brute_damage}
          </Table.Cell>
          <Table.Cell color={damageLabel(organ.burn_damage)}>
            {organ.burn_damage}
          </Table.Cell>
          <Table.Cell>{organ.wounds}</Table.Cell>
          <Table.Cell>{organ.infection}</Table.Cell>
        </Table.Row>
      ))}
    </Table>
  );
};

export const MissingOrgans = (props, context) => {
  const { act, data } = useBackend<ScannerData>(context);

  return (
    <BlockQuote>
      Missing organs:{' '}
      <Box as="span" color="red">
        {data.missing_organs}
      </Box>
    </BlockQuote>
  );
};

export const MissingLimbs = (props, context) => {
  const { act, data } = useBackend<ScannerData>(context);

  return (
    <BlockQuote>
      Missing limbs:{' '}
      <Box as="span" color="red">
        {data.missing_limbs}
      </Box>
    </BlockQuote>
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
