import { useBackend } from '../backend';
import { Section, Table, Button } from '../components';
import { BooleanLike } from '../../common/react';

export type AreaAtmosScrubberData = {
  scrubbers: Scrubber[];
};

type Scrubber = {
  id: string;
  status: BooleanLike;
  pressure: number;
  flowrate: number;
  load: number;
};

export const AreaAtmos = (props, context) => {
  const { act, data } = useBackend<AreaAtmosScrubberData>(context);

  return (
    <Section title="Area Air Control">
      <Table>
        <Table.Row header>
          <Table.Cell>Scrubber</Table.Cell>
          <Table.Cell>Pressure</Table.Cell>
          <Table.Cell>Flow Rate</Table.Cell>
          <Table.Cell>Load</Table.Cell>
          <Table.Cell>Status</Table.Cell>
        </Table.Row>
        {data.scrubbers.map((Scrubber) => (
          <Table.Row key={Scrubber.id}>
            <Table.Cell>{Scrubber.id}</Table.Cell>
            <Table.Cell>{Scrubber.pressure} kPa</Table.Cell>
            <Table.Cell>{Scrubber.flowrate} L/s</Table.Cell>
            <Table.Cell>{Scrubber.load} W</Table.Cell>
            <Table.Cell>
              <Button
                content={Scrubber.status ? 'On' : 'Off'}
                color={Scrubber.status ? 'good' : 'bad'}
                onClick={() => act('cmode', { cmode: Scrubber.status })}
              />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
