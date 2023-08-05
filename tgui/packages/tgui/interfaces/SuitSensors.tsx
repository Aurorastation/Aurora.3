import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export type SensorsData = {
  crewmembers: CrewMember[];
  isAI: BooleanLike;
};

type CrewMember = {
  stype: number; // sensors type
  ref: string;
  name: string;
  ass: string; // assignment...
  pulse: string;
  tpulse: number;
  cellCharge: number;
  pressure: string;
  tpressure: number;
  toxyg: number;
  oxyg: number;
  bodytemp: number;
  area: string;
  x: number;
  y: number;
  z: number;
};

export const SuitSensors = (props, context) => {
  const { act, data } = useBackend<SensorsData>(context);

  return (
    <NtosWindow resizable width={900}>
      <NtosWindow.Content scrollable>
        <Section title="Suit Sensors">
          <Table>
            <Table.Row header>
              <Table.Cell>Name</Table.Cell>
              <Table.Cell>Pulse or Charge</Table.Cell>
              <Table.Cell>Blood Pressure</Table.Cell>
              <Table.Cell>Blood Oxygenation</Table.Cell>
              <Table.Cell>Temperature</Table.Cell>
              <Table.Cell>Location</Table.Cell>
              {data.isAI ? <Table.Cell>Track</Table.Cell> : ''}
            </Table.Row>
            {data.crewmembers.map((crewmember) => (
              <Table.Row key={crewmember.name}>
                <Table.Cell>{crewmember.name}</Table.Cell>
                {crewmember.cellCharge === -1 ? (
                  <Table.Cell color={getPulseClass(crewmember.tpulse)}>
                    {crewmember.pulse} BPM
                  </Table.Cell>
                ) : (
                  <Table.Cell color={getChargeClass(crewmember.cellCharge)}>
                    {Math.round(crewmember.cellCharge)}%
                  </Table.Cell>
                )}
                <Table.Cell color={getPressureClass(crewmember.tpressure)}>
                  {crewmember.stype > 1 ? crewmember.pressure : 'N/A'}
                </Table.Cell>
                <Table.Cell color={getOxyClass(crewmember.oxyg)}>
                  {toOxyLabel(crewmember.oxyg)}
                </Table.Cell>
                <Table.Cell>
                  {crewmember.stype > 1
                    ? Math.round(crewmember.bodytemp * 10) / 10 + 'C'
                    : 'N/A'}
                </Table.Cell>
                <Table.Cell>
                  {crewmember.stype > 2
                    ? crewmember.area +
                    ' (' +
                    crewmember.x +
                    ', ' +
                    crewmember.y +
                    ', ' +
                    crewmember.z +
                    ')'
                    : 'N/A'}
                </Table.Cell>
                {data.isAI ? (
                  <Table.Cell>
                    <Button
                      content="Track"
                      onClick={() => act('track', { track: crewmember.ref })}
                    />
                  </Table.Cell>
                ) : (
                  ' '
                )}
              </Table.Row>
            ))}
          </Table>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const getChargeClass = (cellCharge) => {
  if (cellCharge > 10) {
    return 'highlight';
  }
  return 'bad';
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

const getPulseClass = (tpulse) => {
  switch (tpulse) {
    case 0:
      return 'bad';
    case 1:
      return 'average';
    case 2:
      return 'good';
    case 3:
      return 'yellow';
    case 4:
      return 'average';
    case 5:
      return 'bad';
    default:
      return 'primary';
  }
};

const getOxyClass = (value) => {
  switch (value) {
    case 5:
      return 'yellow';
    case 4:
      return 'good';
    case 3:
      return 'average';
    case 2:
      return 'bad';
    case 1:
      return 'bad';
    default:
      return 'primary';
  }
};

const toOxyLabel = (value) => {
  switch (value) {
    case 5:
      return 'increased';
    case 4:
      return 'normal';
    case 3:
      return 'low';
    case 2:
      return 'very low';
    case 1:
      return 'extremely low';
    default:
      return 'N/A';
  }
};
