import { useBackend } from '../backend';
import { Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export type DocksData = {
  docks: Dock[];
};

type Dock = {
  name: string;
  shuttle: string;
};

let sortByNameFn = function (a: Dock, b: Dock): number {
  if (a.name < b.name) {
    return -1;
  }
  if (a.name > b.name) {
    return 1;
  }
  return 0;
};

export const Docks = (props, context) => {
  const { act, data } = useBackend<DocksData>(context);
  const full_docks = data.docks
    .filter((d: Dock) => !!d.shuttle)
    .sort(sortByNameFn);
  const empty_docks = data.docks
    .filter((d: Dock) => !d.shuttle)
    .sort(sortByNameFn);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section title="Docking Ports Management Program">
          <Table>
            <Table.Row header>
              <Table.Cell>Port/Hangar</Table.Cell>
              <Table.Cell>Docked Craft</Table.Cell>
            </Table.Row>
            <Table.Row />
            {full_docks.map((dock) => (
              <Table.Row key={dock.name}>
                <Table.Cell>{dock.name}</Table.Cell>
                <Table.Cell>{dock.shuttle}</Table.Cell>
              </Table.Row>
            ))}
            {empty_docks.map((dock) => (
              <Table.Row key={dock.name} color="gray">
                <Table.Cell>{dock.name}</Table.Cell>
                <Table.Cell>{dock.shuttle}</Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
