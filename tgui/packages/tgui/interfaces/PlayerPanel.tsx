import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { Input, Box, Button, Section, Table } from '../components';
import { Window } from '../layouts';

export type PanelData = {
  holder_ref: string;
  is_mod: BooleanLike;
  players: Player[];
};

type Player = {
  ckey: BooleanLike;
  ref: string;
  name: string;
  real_name: string;
  assigment: string;
  key: string;
  ip: string;
  connected: BooleanLike;
  antag: number; // 0 (non-antag), 1 (special role) or 2 (antag)
  age: any; // string or number
};

export const PlayerPanel = (props, context) => {
  const { act, data } = useBackend<PanelData>(context);

  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    `searchTerm`,
    ``
  );

  return (
    <Window resizable theme="admin">
      <Window.Content scrollable>
        <Section
          title="Players"
          buttons={
            <Input
              autoFocus
              autoSelect
              placeholder="Search by ckey, name, or assignment"
              width="40vw"
              maxLength={512}
              onInput={(e, value) => {
                setSearchTerm(value);
              }}
              value={searchTerm}
            />
          }>
          <Table>
            <Table.Row header>
              <Table.Cell>Name</Table.Cell>
              <Table.Cell>Assignment</Table.Cell>
              <Table.Cell>Key</Table.Cell>
              {data.is_mod ? <Table.Cell>Age</Table.Cell> : ''}
              {data.is_mod ? <Table.Cell>Antag</Table.Cell> : ''}
              <Table.Cell textAlign="right">Actions</Table.Cell>
            </Table.Row>
            {data.players
              .filter(
                (player) =>
                  player.key?.toLowerCase().indexOf(searchTerm.toLowerCase()) >
                    -1 ||
                  player.name?.toLowerCase().indexOf(searchTerm.toLowerCase()) >
                    -1 ||
                  player.real_name
                    ?.toLowerCase()
                    .indexOf(searchTerm.toLowerCase()) > -1 ||
                  player.assigment
                    ?.toLowerCase()
                    .indexOf(searchTerm.toLowerCase()) > -1
              )
              .map((player) => (
                <Table.Row key={player.name}>
                  <Table.Cell>
                    {player.name === player.real_name ||
                    player.assigment === 'NA'
                      ? player.name
                      : player.real_name}
                  </Table.Cell>
                  <Table.Cell>
                    {player.assigment === 'NA'
                      ? player.real_name
                      : player.assigment}
                  </Table.Cell>
                  <Table.Cell>
                    {player.key}
                    {!player.connected ? ' (DC)' : ''}
                  </Table.Cell>
                  <Table.Cell>{data.is_mod ? player.age : ''}</Table.Cell>
                  <Table.Cell>
                    {player.antag === 2
                      ? 'Added by Gamemode'
                      : player.antag === 1
                        ? 'Added by Admin'
                        : player.antag === 0
                          ? 'No'
                          : 'NA'}
                  </Table.Cell>
                  <Table.Cell>
                    <Box textAlign="right">
                      <Button
                        content="PP"
                        onClick={() =>
                          act('show_player_panel', {
                            show_player_panel: player.ref,
                          })
                        }
                      />
                      <Button
                        content="PM"
                        onClick={() =>
                          act('private_message', {
                            private_message: player.ref,
                          })
                        }
                      />
                      <Button
                        content="VV"
                        onClick={() =>
                          act('view_variables', {
                            view_variables: player.ref,
                          })
                        }
                      />
                      <Button
                        content="SM"
                        onClick={() =>
                          act('subtle_message', { subtle_message: player.ref })
                        }
                      />
                      <Button
                        content="N"
                        onClick={() => act('notes', { ckey: player.key })}
                      />
                      <Button
                        content="TP"
                        onClick={() =>
                          act('traitor_panel', { traitor_panel: player.ref })
                        }
                      />
                      <Button
                        content="JMP"
                        onClick={() => act('jump_to', { jump_to: player.ref })}
                      />
                      <Button
                        content="WND"
                        onClick={() => act('wind', { wind: player.ref })}
                      />
                    </Box>
                  </Table.Cell>
                </Table.Row>
              ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
