import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, Section, Table } from '../components';
import { Window } from '../layouts';

export type SeedData = {
  scan_stats: BooleanLike;
  scan_temperature: BooleanLike;
  scan_light: BooleanLike;
  scan_soil: BooleanLike;
  seeds: Seed[];
};

type Seed = {
  name: string;
  uid: number;
  pile_id: number;
  endurance: any;
  yield: any;
  maturation: any;
  production: any;
  potency: any;
  harvest: string;
  ideal_heat: string;
  ideal_light: string;
  nutrient_consumption: string;
  water_consumption: string;
  traits: string;
  amount: number;
};

export const SeedStorage = (props, context) => {
  const { act, data } = useBackend<SeedData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section
          title="Storage"
          buttons={
            <Button
              content="Purge"
              icon="times"
              color="bad"
              onClick={() => act('purge')}
            />
          }>
          <Table>
            <Table.Row header>
              <Table.Cell>Name</Table.Cell>
              <Table.Cell>Variety</Table.Cell>
              {data.scan_stats && (
                <>
                  <Table.Cell>Endurance</Table.Cell>
                  <Table.Cell>Yield</Table.Cell>
                  <Table.Cell>Maturation</Table.Cell>
                  <Table.Cell>Production</Table.Cell>
                  <Table.Cell>Potency</Table.Cell>
                  <Table.Cell>Harvest</Table.Cell>
                </>
              )}
              {data.scan_temperature && <Table.Cell>Temperature</Table.Cell>}
              {data.scan_light && <Table.Cell>Light</Table.Cell>}
              {data.scan_soil && (
                <>
                  <Table.Cell>Nutrients</Table.Cell>
                  <Table.Cell>Water</Table.Cell>
                </>
              )}
              <Table.Cell>Notes</Table.Cell>
              <Table.Cell>Amount</Table.Cell>
            </Table.Row>
            {data.seeds.map((seed) => (
              <Table.Row key={seed.name}>
                <Table.Cell>
                  <Button
                    content={seed.name}
                    icon="eject"
                    onClick={() => act('vend', { id: seed.pile_id })}
                  />
                </Table.Cell>
                <Table.Cell>#{seed.uid}</Table.Cell>
                {data.scan_stats && (
                  <>
                    <Table.Cell>{seed.endurance}</Table.Cell>
                    <Table.Cell>{seed.yield}</Table.Cell>
                    <Table.Cell>{seed.maturation}</Table.Cell>
                    <Table.Cell>{seed.production}</Table.Cell>
                    <Table.Cell>{seed.potency}</Table.Cell>
                    <Table.Cell>{seed.harvest}</Table.Cell>
                  </>
                )}
                {data.scan_temperature && (
                  <Table.Cell>{seed.ideal_heat}</Table.Cell>
                )}
                {data.scan_light && <Table.Cell>{seed.ideal_light}</Table.Cell>}
                {data.scan_soil && (
                  <>
                    <Table.Cell>{seed.nutrient_consumption}</Table.Cell>
                    <Table.Cell>{seed.water_consumption}</Table.Cell>
                  </>
                )}
                <Table.Cell>{seed.traits}</Table.Cell>
                <Table.Cell>{seed.amount}</Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
