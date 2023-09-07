import { useBackend } from '../backend';
import { Section, Table, Button, NoticeBox } from '../components';
import { BooleanLike } from '../../common/react';
import { Window } from '../layouts';

export type AreaAtmosScrubberData = {
  scrubbers: Scrubber[];
};

type Scrubber = {
  id: number;
  name: string;
  status: BooleanLike;
  pressure: number;
  flowrate: number;
};

export const AreaAtmos = (props, context) => {
  const { act, data } = useBackend<AreaAtmosScrubberData>(context);

  return (
    <Window resizable width={500} height={300}>
      <Window.Content scrollable>
        {' '}
        {data.scrubbers && data.scrubbers.length ? (
          <AreaScrubbers />
        ) : (
          <AreaScan />
        )}
      </Window.Content>
    </Window>
  );
};

export const AreaScan = (props, context) => {
  const { act, data } = useBackend<AreaAtmosScrubberData>(context);

  return (
    <Section>
      <NoticeBox>No scrubbers detected within the 15 meter range.</NoticeBox>
      <Button content="Scan" color="blue" onClick={() => act('scan')} />
    </Section>
  );
};

export const AreaScrubbers = (props, context) => {
  const { act, data } = useBackend<AreaAtmosScrubberData>(context);

  return (
    <Section title="Area Air Control">
      <Table>
        <Table.Row header>
          <Table.Cell>Scrubber</Table.Cell>
          <Table.Cell>Pressure</Table.Cell>
          <Table.Cell>Flow Rate</Table.Cell>
          <Table.Cell>Status</Table.Cell>
        </Table.Row>
        {data.scrubbers.map((Scrubber) => (
          <Table.Row key={Scrubber.id}>
            <Table.Cell>{Scrubber.name}</Table.Cell>
            <Table.Cell>{Scrubber.pressure} kPa</Table.Cell>
            <Table.Cell>{Scrubber.flowrate} L/s</Table.Cell>
            <Table.Cell>
              <Button
                content={Scrubber.status ? 'On' : 'Off'}
                color={Scrubber.status ? 'good' : 'bad'}
                onClick={() => act('cmode', { cmode: Scrubber.id })}
              />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
