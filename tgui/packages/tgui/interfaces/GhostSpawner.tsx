import { paginate } from 'common/collections';
import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Input, Section, Table, Tabs, Tooltip } from '../components';
import { TableCell, TableRow } from '../components/Table';
import { Window } from '../layouts';

export type SpawnerData = {
  spawners: Spawner[];
  categories: string[];
};

type Spawner = {
  short_name: string;
  name: string;
  desc: string;
  desc_ooc: string;
  type: string;
  cant_spawn: BooleanLike;
  can_edit: BooleanLike;
  can_jump_to: BooleanLike;
  enabled: BooleanLike;
  count: number;
  max_count: number;
  spawn_atoms: any;
  spawn_overmap_location: string;
  tags: string[];
  spawnpoints: string[];
  manifest: string[];
};

const ManifestTable = function (act, spawner: Spawner) {
  return (
    <Table>
      {paginate(spawner.manifest, 2).map((page) => {
        const spawned_mob_name_1 = page[0];
        const spawned_mob_name_2 = page[1];

        const ManifestCell = function (
          act,
          spawner: Spawner,
          spawned_mob_name: string
        ) {
          if (spawned_mob_name) {
            return (
              <TableCell>
                {' - ' + spawned_mob_name + ' '}
                {spawner.can_jump_to ? (
                  <Tooltip content="Follow mob">
                    <Button
                      content="F"
                      onClick={() =>
                        act('follow_manifest_entry', {
                          spawner_id: spawner.short_name,
                          spawned_mob_name: spawned_mob_name,
                        })
                      }
                    />
                  </Tooltip>
                ) : (
                  ''
                )}
              </TableCell>
            );
          } else {
            return '';
          }
        };

        return (
          <TableRow pb={1} key={page} overflow="hidden">
            {ManifestCell(act, spawner, spawned_mob_name_1)}
            {ManifestCell(act, spawner, spawned_mob_name_2)}
          </TableRow>
        );
      })}
    </Table>
  );
};

export const GhostSpawner = (props, context) => {
  const { act, data } = useBackend<SpawnerData>(context);

  const [tab, setTab] = useLocalState(context, 'tab', 'All');
  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    `searchTerm`,
    ``
  );

  const spawners = data.spawners?.filter(
    (S) => S.name.toLowerCase().indexOf(searchTerm.toLowerCase()) > -1
  );

  const colors = [
    'blue',
    'purple',
    'maroon',
    'olive',
    'orange',
    'cyan',
    'red',
    'green',
    'yellow',
  ];

  let loc_to_color: Map<string, string> = new Map();

  if (spawners) {
    paginate(
      Array.from(
        new Set(
          spawners
            .filter((s) => s.spawn_overmap_location)
            .map((s) => s.spawn_overmap_location)
        )
      ),
      colors.length
    ).map((p) =>
      p.map((l, i) => (loc_to_color[l] = colors[i % colors.length]))
    );
  }

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
              <Table.Cell>Location</Table.Cell>
              <Table.Cell>Description</Table.Cell>
              <Table.Cell>Available Slots</Table.Cell>
              <Table.Cell>Actions</Table.Cell>
            </Table.Row>
            {spawners?.map(
              (spawner) =>
                (spawner.tags.indexOf(tab) > -1 || tab === 'All') && (
                  <Table.Row
                    key={spawner.short_name}
                    className="candystripe"
                    color={spawner.cant_spawn ? 'gray' : null}>
                    <Table.Cell>{spawner.name}</Table.Cell>
                    <Table.Cell
                      color={loc_to_color[spawner.spawn_overmap_location]}>
                      {spawner.spawn_overmap_location}
                    </Table.Cell>
                    <Table.Cell>
                      <Box pb={2} pt={2}>
                        <Box>{spawner.desc}</Box>
                        {spawner.desc_ooc ? (
                          <Box color={spawner.cant_spawn ? null : 'blue'}>
                            OOC Note: {spawner.desc_ooc}
                          </Box>
                        ) : (
                          ''
                        )}
                        {spawner.manifest.length > 0 ? (
                          <Box
                            style={{
                              'background-color': 'rgba(0, 0, 0, 0.25)',
                              'border': '1px solid rgba(0, 0, 0, 0.5)',
                            }}
                            mt={2}
                            pb={1}
                            pt={1}
                            pl={1}>
                            <Box fontSize="1.2rem" textAlign="center">
                              Manifest
                            </Box>
                            {ManifestTable(act, spawner)}
                          </Box>
                        ) : null}
                      </Box>
                    </Table.Cell>
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
                            act('jump_to', { spawner_id: spawner.short_name })
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
