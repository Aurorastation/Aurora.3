import {
  Box,
  Button,
  Collapsible,
  LabeledList,
  NoticeBox,
  Section,
  Table,
  Tabs,
} from 'tgui-core/components';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';
import { SearchBar } from './common/SearchBar';

type PersistencePanelData = {
  status_initialized: boolean;
  saving_active: boolean;
  objects_tracked: number;
  records_cached: number;
  generics_cached: number;
  objects: PersistenceObject[];
  records: PersistenceRecordTypeGroup[];
  is_admin: boolean;
};

type PersistenceObject = {
  ref: string;
  type: string;
  name: string;
  x: number | null;
  y: number | null;
  z: number | null;
  created_at: string;
  expires_at: string;
};

type PersistenceRecordEntry = {
  created_at: string;
  game_id: string;
  value: string;
};

type PersistenceRecordAttributeGroup = {
  attribute: string | null;
  records: PersistenceRecordEntry[];
};

type PersistenceRecordTypeGroup = {
  type: string;
  title: string;
  description?: string | null;
  requires_attribute: boolean;
  attributes: PersistenceRecordAttributeGroup[];
};

export const PersistencePanel = (props) => {
  const { act, data } = useBackend<PersistencePanelData>();
  const [tab, setTab] = useLocalState('tab', 'Subsystem');
  const [objectsSearch, setObjectsSearch] = useLocalState('objectsSearch', '');
  const [recordsSearch, setRecordsSearch] = useLocalState('recordsSearch', '');
  const [genericsSearch, setGenericsSearch] = useLocalState('genericsSearch', '');

  const statusText = data.status_initialized ? 'Initialized' : 'Error';
  const statusColor = data.status_initialized ? 'good' : 'bad';
  const savingText = data.saving_active ? 'Active' : 'Disabled';
  const savingColor = data.saving_active ? 'good' : 'bad';
  const savingButtonText = data.saving_active ? 'Disable saving' : 'Re-enable saving';
  const savingButtonColor = data.saving_active ? 'good' : 'bad';

  const objects = (Array.isArray(data.objects) ? data.objects : []).slice().sort((a, b) => {
    const typeCompare = a.type.localeCompare(b.type);
    if (typeCompare !== 0) {
      return typeCompare;
    }
    return a.name.localeCompare(b.name);
  });

  const getPosition = (object: PersistenceObject) => {
    if (object.x === null || object.y === null || object.z === null) {
      return 'Unknown';
    }

    return `${object.x}-${object.y}-${object.z}`;
  };

  const groupedObjects = objects.reduce<Record<string, PersistenceObject[]>>(
    (acc, object) => {
      const current = acc[object.type] || [];
      current.push(object);
      acc[object.type] = current;
      return acc;
    },
    {},
  );

  const orderedTypes = Object.keys(groupedObjects).sort((a, b) =>
    a.localeCompare(b),
  );

  const normalizedObjectsSearch = objectsSearch.trim().toLowerCase();
  const filteredObjectGroups: Record<string, PersistenceObject[]> = {};

  for (const type of orderedTypes) {
    const currentGroup = groupedObjects[type] || [];
    const matches: PersistenceObject[] = [];

    for (const object of currentGroup) {
      const position =
        object.x === null || object.y === null || object.z === null
          ? 'Unknown'
          : `${object.x}-${object.y}-${object.z}`;

      const haystack = [
        object.name,
        object.type,
        position,
        object.created_at,
        object.expires_at,
      ]
        .join(' ')
        .toLowerCase();

      if (!normalizedObjectsSearch || haystack.includes(normalizedObjectsSearch)) {
        matches.push(object);
      }
    }

    if (matches.length > 0) {
      filteredObjectGroups[type] = matches;
    }
  }

  const filteredObjectTypes = Object.keys(filteredObjectGroups).sort((a, b) =>
    a.localeCompare(b),
  );

  const recordGroups = (Array.isArray(data.records) ? data.records : [])
    .slice()
    .sort((a, b) => a.type.localeCompare(b.type))
    .map((group) => ({
      ...group,
      attributes: (group.attributes || [])
        .slice()
        .sort((a, b) => {
          const attributeCompare = (a.attribute || 'unattributed').localeCompare(
            b.attribute || 'unattributed',
          );
          if (attributeCompare !== 0) {
            return attributeCompare;
          }
          return 0;
        }),
    }));

  const dummyGenerics = [
    {
      persistent_type: 'horizon_overmap_position',
      value: 'Dummy generic entry A',
    },
    {
      persistent_type: 'persistence_test_generic',
      value: 'Dummy generic entry B',
    },
  ].sort((a, b) => a.persistent_type.localeCompare(b.persistent_type));

  const normalizedRecordsSearch = recordsSearch.trim().toLowerCase();
  const filteredRecordGroups: PersistenceRecordTypeGroup[] = [];

  for (const group of recordGroups) {
    const filteredAttributes: PersistenceRecordAttributeGroup[] = [];

    for (const attributeGroup of group.attributes) {
      const matches = (attributeGroup.records || []).slice().sort((a, b) => {
        const createdCompare = b.created_at.localeCompare(a.created_at);
        if (createdCompare !== 0) {
          return createdCompare;
        }
        return a.game_id.localeCompare(b.game_id);
      });

      const attributeSearch = !normalizedRecordsSearch
        ? matches
        : matches.filter((record) => {
            const haystack = [
              group.type,
              attributeGroup.attribute || 'unattributed',
              record.created_at,
              record.game_id,
              record.value,
            ]
              .join(' ')
              .toLowerCase();

            return haystack.includes(normalizedRecordsSearch);
          });

      if (attributeSearch.length > 0) {
        filteredAttributes.push({
          attribute: attributeGroup.attribute,
          records: attributeSearch,
        });
      }
    }

    if (filteredAttributes.length > 0) {
      filteredRecordGroups.push({
        type: group.type,
        title: group.title,
        requires_attribute: group.requires_attribute,
        attributes: filteredAttributes,
      });
    }
  }

  const groupedGenerics = dummyGenerics.reduce<Record<string, typeof dummyGenerics>>(
    (acc, entry) => {
      const current = acc[entry.persistent_type] || [];
      current.push(entry);
      acc[entry.persistent_type] = current;
      return acc;
    },
    {},
  );

  const orderedGenericTypes = Object.keys(groupedGenerics).sort((a, b) =>
    a.localeCompare(b),
  );

  const normalizedGenericsSearch = genericsSearch.trim().toLowerCase();
  const filteredGenericGroups: Record<string, typeof dummyGenerics> = {};

  for (const type of orderedGenericTypes) {
    const currentGroup = groupedGenerics[type] || [];
    const matches: typeof dummyGenerics = [];

    for (const entry of currentGroup) {
      const haystack = [entry.persistent_type, entry.value].join(' ').toLowerCase();
      if (!normalizedGenericsSearch || haystack.includes(normalizedGenericsSearch)) {
        matches.push(entry);
      }
    }

    if (matches.length > 0) {
      filteredGenericGroups[type] = matches;
    }
  }

  const filteredGenericTypes = Object.keys(filteredGenericGroups).sort((a, b) =>
    a.localeCompare(b),
  );

  return (
    <Window theme="admin" width={900} height={700}>
      <Window.Content scrollable>
        <div
          style={{
            alignItems: 'center',
            display: 'flex',
            justifyContent: 'space-between',
          }}
        >
          <Tabs>
            <Tabs.Tab selected={tab === 'Subsystem'} onClick={() => setTab('Subsystem')}>
              Subsystem
            </Tabs.Tab>
            <Tabs.Tab selected={tab === 'Objects'} onClick={() => setTab('Objects')}>
              Objects
            </Tabs.Tab>
            <Tabs.Tab selected={tab === 'Records'} onClick={() => setTab('Records')}>
              Records
            </Tabs.Tab>
            <Tabs.Tab selected={tab === 'Generics'} onClick={() => setTab('Generics')}>
              Generics
            </Tabs.Tab>
          </Tabs>
          <Button
            content="Refresh"
            color="blue"
            icon="sync"
            onClick={() => act('refresh')}
          />
        </div>

        {tab === 'Subsystem' && (
          <Section
            title="Persistence Subsystem"
            buttons={
              <Button
                content={savingButtonText}
                color={savingButtonColor}
                icon={data.saving_active ? 'toggle-on' : 'toggle-off'}
                disabled={!data.is_admin}
                onClick={() => act('toggle_saving')}
              />
            }
          >
            <LabeledList>
              <LabeledList.Item label="Subsystem status">
                <Box as="span" color={statusColor}>
                  {statusText}
                </Box>
              </LabeledList.Item>
              <LabeledList.Item label="Persistent saving">
                <Box as="span" color={savingColor} bold={!data.saving_active}>
                  {savingText}
                </Box>
              </LabeledList.Item>
              <LabeledList.Item label="Objects tracked">
                {data.objects_tracked}
              </LabeledList.Item>
              <LabeledList.Item label="Generics cached">
                {data.generics_cached}
              </LabeledList.Item>
              <LabeledList.Item label="Records cached">
                {data.records_cached}
              </LabeledList.Item>
            </LabeledList>
          </Section>
        )}

        {tab === 'Objects' && (
          <Section
            title="Tracked Objects"
            buttons={
              <SearchBar
                placeholder="Search objects"
                query={objectsSearch}
                onSearch={(value) => setObjectsSearch(value)}
                style={{ width: '18rem' }}
              />
            }
          >
            {data.objects.length === 0 && (
              <NoticeBox>Nothing to display.</NoticeBox>
            )}
            {data.objects.length > 0 && filteredObjectTypes.length === 0 && (
              <NoticeBox>No tracked objects match the current filter.</NoticeBox>
            )}
            {filteredObjectTypes.map((type) => (
              <Collapsible key={type} title={`${type} (${filteredObjectGroups[type].length})`}>
                <Table>
                  <Table.Row header className="candystripe">
                    <Table.Cell>Name</Table.Cell>
                    <Table.Cell>Position</Table.Cell>
                    <Table.Cell>Create date</Table.Cell>
                    <Table.Cell>Expire date</Table.Cell>
                    <Table.Cell>Edit</Table.Cell>
                  </Table.Row>
                  {filteredObjectGroups[type].map((object) => (
                    <Table.Row key={object.ref} className="candystripe">
                      <Table.Cell>{object.name}</Table.Cell>
                      <Table.Cell>{getPosition(object)}</Table.Cell>
                      <Table.Cell>{object.created_at || 'This round'}</Table.Cell>
                      <Table.Cell>{object.expires_at || 'To be determined'}</Table.Cell>
                      <Table.Cell>
                        <Button
                          icon="pencil"
                          tooltip="Open VV for this object"
                          onClick={() => act('edit', { ref: object.ref })}
                        />
                      </Table.Cell>
                    </Table.Row>
                  ))}
                </Table>
              </Collapsible>
            ))}
          </Section>
        )}

        {tab === 'Records' && (
          <Section
            title="Records"
            buttons={
              <SearchBar
                placeholder="Search records"
                query={recordsSearch}
                onSearch={(value) => setRecordsSearch(value)}
                style={{ width: '18rem' }}
              />
            }
          >
            {data.records.length === 0 && (
              <NoticeBox>Nothing to display.</NoticeBox>
            )}
            {data.records.length > 0 && filteredRecordGroups.length === 0 && (
              <NoticeBox>No history records match the current filter.</NoticeBox>
            )}
            {filteredRecordGroups.map((group) => (
              <Collapsible
                key={group.type}
                title={`${group.type} (${group.attributes.reduce((count, attributeGroup) => count + attributeGroup.records.length, 0)})`}
              >
                {group.description && <Box mb={1}>{group.description}</Box>}
                {group.requires_attribute ? (
                  group.attributes.map((attributeGroup) => (
                    <Box key={`${group.type}-${attributeGroup.attribute || 'unattributed'}`} ml={1}>
                      <Collapsible
                        title={attributeGroup.attribute || 'Unattributed'}
                      >
                        <Table>
                          <Table.Row header className="candystripe">
                            <Table.Cell>Created at</Table.Cell>
                            <Table.Cell>Game ID</Table.Cell>
                            <Table.Cell>Value</Table.Cell>
                          </Table.Row>
                          {attributeGroup.records.map((record, index) => (
                            <Table.Row key={`${group.type}-${attributeGroup.attribute || 'unattributed'}-${record.created_at}-${record.game_id}-${index}`} className="candystripe">
                              <Table.Cell>{record.created_at}</Table.Cell>
                              <Table.Cell>{record.game_id}</Table.Cell>
                              <Table.Cell>{record.value}</Table.Cell>
                            </Table.Row>
                          ))}
                        </Table>
                      </Collapsible>
                    </Box>
                  ))
                ) : (
                  <Table>
                    <Table.Row header className="candystripe">
                      <Table.Cell>Created at</Table.Cell>
                      <Table.Cell>Game ID</Table.Cell>
                      <Table.Cell>Value</Table.Cell>
                    </Table.Row>
                    {group.attributes[0]?.records.map((record, index) => (
                      <Table.Row key={`${group.type}-${record.created_at}-${record.game_id}-${index}`} className="candystripe">
                        <Table.Cell>{record.created_at}</Table.Cell>
                        <Table.Cell>{record.game_id}</Table.Cell>
                        <Table.Cell>{record.value}</Table.Cell>
                      </Table.Row>
                    ))}
                  </Table>
                )}
              </Collapsible>
            ))}
          </Section>
        )}

        {tab === 'Generics' && (
          <Section
            title="Generics"
            buttons={
              <SearchBar
                placeholder="Search generics"
                query={genericsSearch}
                onSearch={(value) => setGenericsSearch(value)}
                style={{ width: '18rem' }}
              />
            }
          >
            {filteredGenericTypes.length === 0 && (
              <NoticeBox>No persistent generics match the current filter.</NoticeBox>
            )}
            {filteredGenericTypes.map((type) => (
              <Collapsible key={type} title={`${type} (${filteredGenericGroups[type].length})`}>
                <Table>
                  <Table.Row header className="candystripe">
                    <Table.Cell>Persistent type</Table.Cell>
                    <Table.Cell>Value</Table.Cell>
                  </Table.Row>
                  {filteredGenericGroups[type].map((entry, index) => (
                    <Table.Row key={`${type}-${index}`} className="candystripe">
                      <Table.Cell>{entry.persistent_type}</Table.Cell>
                      <Table.Cell>{entry.value}</Table.Cell>
                    </Table.Row>
                  ))}
                </Table>
              </Collapsible>
            ))}
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
