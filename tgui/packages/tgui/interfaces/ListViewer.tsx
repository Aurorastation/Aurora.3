import { Box, Button, Section, Table } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type ListData = {
  listvar: List[];
};

type List = {
  key: any;
  value: any;
};

export const ListViewer = (props) => {
  const { act, data } = useBackend<ListData>();

  return (
    <Window>
      <Window.Content scrollable>
        <Section
          title="List"
          buttons={
            <Button onClick={() => act('open_whole_list')}>
              Open Whole List
            </Button>
          }
        >
          <Table preserveWhitespace>
            <Table.Row header>
              <Table.Cell>Key</Table.Cell>
              <Table.Cell>Value</Table.Cell>
              <Table.Cell>Actions</Table.Cell>
            </Table.Row>
            {data.listvar.map((list) => (
              <Box key={list.key}>
                <Table.Row>
                  <Table.Cell>{list.key}</Table.Cell>
                  <Table.Cell>{list.value}</Table.Cell>
                  <Table.Cell>
                    <Button
                      onClick={() =>
                        act('open_entry', { open_entry_key: list.key })
                      }
                    >
                      Edit
                    </Button>
                  </Table.Cell>
                </Table.Row>
              </Box>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
