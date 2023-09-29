import { useBackend } from '../backend';
import { Button, Section, Box, Table } from '../components';
import { Window } from '../layouts';

export type OreListData = {
  name: string;
  processing: number;
  stored: number;
  ore: string;
};

export type MiningProcessorData = {
  hasId: boolean;
  enabled: boolean;
  showAllOres: boolean;
  miningPoints: number;
  points: number;
  oreList: OreListData[];
};

export const MiningProcessor = (props, context) => {
  const { act, data } = useBackend<MiningProcessorData>(context);

  return (
    <Window resizable theme="hephaestus">
      <Window.Content scrollable>
        <Section title="Mining Points">
          <Box pb={1}>Current unclaimed points: {data.points}</Box>
          {data.hasId ? (
            <Box>
              <Box pb={1}>
                You have {data.miningPoints} mining points collected.
              </Box>
              <Button
                content="Claim Points"
                icon="plus"
                onClick={() => act('choice', { choice: 'claim' })}
              />
              <Button
                content="Print Yield Declaration"
                icon="print"
                onClick={() => act('choice', { choice: 'print_report' })}
              />
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
        <Section title="Ore Processing">
          <Table>
            <Table.Row header>
              <Table.Cell>Name</Table.Cell>
              <Table.Cell>Stored</Table.Cell>
              <Table.Cell>Setting</Table.Cell>
            </Table.Row>
            {data.oreList.map((ore) => (
              <Table.Row key={ore.name}>
                <Table.Cell>
                  <Box pb={1}>{ore.name}</Box>
                </Table.Cell>
                <Table.Cell>{ore.stored}</Table.Cell>
                <Table.Cell>
                  <Button
                    content={ore.processing}
                    onClick={() =>
                      act('toggle_smelting', { toggle_smelting: ore.ore })
                    }
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
        <Section title="Settings">
          <Table>
            <Table.Row>
              <Table.Cell>
                <Box pb={1}>
                  Currently displaying{' '}
                  {data.showAllOres
                    ? 'all ore types'
                    : 'only available ore types'}
                </Box>
              </Table.Cell>
              <Table.Cell>
                <Box pb={1}>
                  <Button
                    content={data.showAllOres ? 'Show Less' : 'Show More'}
                    onClick={() => act('toggle_ores')}
                  />
                </Box>
              </Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell>
                <Box pb={1}>
                  The ore processor is currently{' '}
                  {data.enabled ? 'processing' : 'disabled'}
                </Box>
              </Table.Cell>
              <Table.Cell>
                <Box pb={1}>
                  <Button
                    content={data.enabled ? 'Disable' : 'Enable'}
                    onClick={() => act('toggle_power')}
                  />
                </Box>
              </Table.Cell>
            </Table.Row>
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
