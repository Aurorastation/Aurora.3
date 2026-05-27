import { Box, Button, Section, Table } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type PanelData = {
  admins: Admin[];
  forumuserui_enabled: BooleanLike;
};

type Admin = {
  ckey: string;
  rank: string;
  rights: string;
};

export const PermissionsPanel = (props) => {
  const { act, data } = useBackend<PanelData>();

  return (
    <Window theme="admin">
      <Window.Content scrollable>
        <Section title="Staff">
          {data.forumuserui_enabled ? (
            <Box color="red">
              Modifications done will not last beyond this round! Use the WI if
              you want permanent changes! &nbsp;
            </Box>
          ) : (
            ''
          )}

          <Table>
            <Table.Row header>
              <Table.Cell>
                Username <Button contents="Add" onClick={() => act('add')} />
              </Table.Cell>
              <Table.Cell>Rank</Table.Cell>
              <Table.Cell>Permissions</Table.Cell>
            </Table.Row>
            {data.admins.map((admin) => (
              <Table.Row key={admin.ckey}>
                <Table.Cell>
                  <Button
                    content={admin.ckey}
                    onClick={() => act('remove', { ckey: admin.ckey })}
                  />
                </Table.Cell>
                <Table.Cell>
                  <Button
                    content={admin.rank}
                    onClick={() => act('rank', { ckey: admin.ckey })}
                  />
                </Table.Cell>
                <Table.Cell>
                  <Button
                    content={admin.rights}
                    onClick={() => act('rights', { ckey: admin.ckey })}
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
