import { useBackend } from '../backend';
import { Button, Section, Box, Table } from '../components';
import { Window } from '../layouts';

export type PrizeListData = {
  name: string;
  cost: number;
  stock: number;
  ref: string;
};

export type MiningVendorData = {
  hasId: boolean;
  miningPoints: number;
  prizeList: PrizeListData[];
};

export const MiningVendor = (props, context) => {
  const { act, data } = useBackend<MiningVendorData>(context);

  return (
    <Window resizable theme="hephaestus">
      <Window.Content scrollable>
        <Section title="Mining Points">
          {data.hasId ? (
            <Box>
              <Box>You have {data.miningPoints} mining points collected.</Box>
            </Box>
          ) : (
            <Box>
              <Box>No ID detected.</Box>
              <Button
                content="Scan ID"
                icon="plus"
                onClick={() => act('choice', { choice: 'scan' })}
              />
            </Box>
          )}
        </Section>
        <Section title="Mining Equipment">
          <Table>
            <Table.Row header>
              <Table.Cell>Name</Table.Cell>
              <Table.Cell>Cost</Table.Cell>
              <Table.Cell>Stock</Table.Cell>
              <Table.Cell>Action</Table.Cell>
            </Table.Row>
            {data.prizeList.map((prize) => (
              <Table.Row key={prize.name}>
                <Table.Cell>
                  <Box pb={1}>{prize.name}</Box>
                </Table.Cell>
                <Table.Cell>{prize.cost}</Table.Cell>
                <Table.Cell>
                  {prize.stock === -1 ? '(No limit.)' : prize.stock}
                </Table.Cell>
                <Table.Cell>
                  <Button
                    content="Purchase"
                    disabled={prize.stock === 0}
                    onClick={() => act('purchase', { purchase: prize.ref })}
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
