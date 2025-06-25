import { useBackend, useLocalState } from '../backend';
import { Section, Table, Tabs } from '../components';
import { NtosWindow } from '../layouts';

export type JanitorData = {
  categories: string[];
  supplies: Supply[];
  user_x: number;
  user_y: number;
};

type Supply = {
  name: string;
  key: number;
  x: number;
  y: number;
  z: number;
  dir: string;
  status: string;
  supply_type: string;
};

export const Janitor = (props, context) => {
  const { act, data } = useBackend<JanitorData>(context);
  const [tab, setTab] = useLocalState(context, 'tab', 'Mops');
  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section title="Janitorial Equipment">
          <Tabs>
            {data.categories.map((cat) => (
              <Tabs.Tab
                key={cat}
                selected={tab === cat}
                onClick={() => setTab(cat)}>
                {cat}
              </Tabs.Tab>
            ))}
          </Tabs>
          <Table>
            <Table.Row header>
              <Table.Cell>ID</Table.Cell>
              <Table.Cell>Location</Table.Cell>
              <Table.Cell>Direction</Table.Cell>
              <Table.Cell>Status</Table.Cell>
            </Table.Row>
            {data.supplies.map(
              (supply) =>
                supply.supply_type === tab && (
                  <Table.Row key={supply.name}>
                    <Table.Cell>
                      {supply.name} (#{supply.key})
                    </Table.Cell>
                    <Table.Cell>
                      ({supply.x}, {supply.y}, {supply.z})
                    </Table.Cell>
                    <Table.Cell>{supply.dir}</Table.Cell>
                    <Table.Cell>{supply.status}</Table.Cell>
                  </Table.Row>
                )
            )}
          </Table>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
