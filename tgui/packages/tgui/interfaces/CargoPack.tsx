import { useBackend } from '../backend';
import { Section, Table } from '../components';
import { Window } from '../layouts';

export type CargoPackData = {
  cargo_pack_details: PackageData[];
};

export type PackageData = {
  package_id: string;
  delivery_point_sector: string;
  delivery_point_coordinates: string;
  delivery_point_id: string;
};

export const CargoPack = (props, context) => {
  const { act, data } = useBackend<CargoPackData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section>
          <Table>
            <Table.Row header>
              <Table.Cell>Site</Table.Cell>
              <Table.Cell>Coordinates</Table.Cell>
              <Table.Cell>Delivery ID</Table.Cell>
            </Table.Row>
            {data.cargo_pack_details.map((cargo_package) => (
              <Table.Row key={cargo_package.package_id}>
                <Table.Cell>{cargo_package.delivery_point_sector}</Table.Cell>
                <Table.Cell>
                  {cargo_package.delivery_point_coordinates}
                </Table.Cell>
                <Table.Cell>{cargo_package.delivery_point_id}</Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
