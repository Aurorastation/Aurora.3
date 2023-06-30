import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { Button, Input, Section, Table, Tabs } from '../components';
import { Window } from '../layouts';

export type SpawnerData = {
  spawners: Spawner[];
  categories: string[];
};

type Spawner = {
  short_name: string;
  name: string;
  desc: string;
  type: string;
  cant_spawn: BooleanLike;
  can_edit: BooleanLike;
  can_jump_to: BooleanLike;
  enabled: BooleanLike;
  count: number;
  max_count: number;
  spawn_atoms: any;
  tags: string[];
  spawnpoints: string[];
};

export const GhostSpawner = (props, context) => {
  const { act, data } = useBackend<SpawnerData>(context);
  const [tab, setTab] = useLocalState(context, 'tab', 'All');
  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    `searchTerm`,
    ``
  );

  return (
    <Window resizable width={1000} height={700}>
      <Window.Content scrollable>
        <Section
          title="Spawners"
          buttons={
            <Input
              autoFocus
              autoSelect
              placeholder="Search by name"
              width="40vw"
              maxLength={512}
              onInput={(e, value) => {
                setSearchTerm(value);
              }}
              value={searchTerm}
            />
          }>
          <Tabs>
            <Tabs.Tab selected={tab === 'All'} onClick={() => setTab('All')}>
              All
            </Tabs.Tab>
            {data.categories.map((cat) => (
              <Tabs.Tab
                key={cat}
                selected={tab === cat}
                onClick={() => setTab(cat)}>
                {cat}
              </Tabs.Tab>
            ))}
          </Tabs>
          <Table preserveWhitespace>
            <Table.Row header>
              <Table.Cell>Name</Table.Cell>
              <Table.Cell>Description</Table.Cell>
              <Table.Cell>Available Slots</Table.Cell>
              <Table.Cell>Actions</Table.Cell>
            </Table.Row>
            {data.spawners
              .filter(
                (S) =>
                  S.name.toLowerCase().indexOf(searchTerm.toLowerCase()) > -1
              )
              .map(
                (spawner) =>
                  (spawner.tags.indexOf(tab) > -1 || tab === 'All') && (
                    <Table.Row key={spawner.short_name}>
                      <Table.Cell>{spawner.name}</Table.Cell>
                      <Table.Cell>{spawner.desc}</Table.Cell>
                      <Table.Cell>
                        {spawner.max_count > 0
                          ? spawner.max_count -
                          spawner.count +
                          ' / ' +
                          spawner.max_count
                          : spawner.spawn_atoms}
                      </Table.Cell>
                      <Table.Cell inline nowrap>
                        <Button
                          content="Spawn"
                          color="good"
                          icon="star"
                          disabled={spawner.cant_spawn}
                          onClick={() =>
                            act('spawn', { spawn: spawner.short_name })
                          }
                        />
                        {spawner.can_jump_to ? (
                          <Button
                            content="J"
                            onClick={() =>
                              act('jump_to', { jump_to: spawner.short_name })
                            }
                          />
                        ) : (
                          ''
                        )}
                        {spawner.can_edit ? (
                          <>
                            <Button
                              content="E"
                              disabled={spawner.enabled}
                              onClick={() =>
                                act('enable', { enable: spawner.short_name })
                              }
                            />
                            <Button
                              content="D"
                              disabled={!spawner.enabled}
                              onClick={() =>
                                act('disable', { disable: spawner.short_name })
                              }
                            />
                          </>
                        ) : (
                          ' '
                        )}
                      </Table.Cell>
                    </Table.Row>
                  )
              )}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
