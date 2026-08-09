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
  generics: PersistenceGenericTypeGroup[];
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

type PersistenceAttributeGroup<T> = {
  attribute: string | null;
  records?: T[];
};

type PersistenceRecordAttributeGroup = PersistenceAttributeGroup<PersistenceRecordEntry>;

type PersistenceRecordTypeGroup = {
  type: string;
  title: string;
  description?: string | null;
  requires_attribute: boolean;
  attributes: PersistenceRecordAttributeGroup[];
};

type PersistenceGenericAttributeGroup = {
  attribute: string | null;
  created_at: string | null;
  expires_at: string | null;
  json: string;
};

type PersistenceGenericTypeGroup = {
  type: string;
  title: string;
  description?: string | null;
  requires_attribute: boolean;
  attributes: PersistenceGenericAttributeGroup[];
};

const getObjectPosition = (object: PersistenceObject) => {
  if (object.x === null || object.y === null || object.z === null) {
    return 'Unknown';
  }

  return `${object.x}-${object.y}-${object.z}`;
};

const getAttributeLabel = (attribute: string | null) => attribute || 'Unattributed';

const formatTitleWithCount = (title: string, count: number) => {
  if (!count) {
    return title;
  }

  return `${title} (${count})`;
};

const sortObjects = (objects: PersistenceObject[]) =>
  objects.slice().sort((a, b) => {
    const typeCompare = a.type.localeCompare(b.type);
    if (typeCompare !== 0) {
      return typeCompare;
    }
    return a.name.localeCompare(b.name);
  });

const groupObjectsByType = (objects: PersistenceObject[]) =>
  objects.reduce<Record<string, PersistenceObject[]>>((acc, object) => {
    const currentGroup = acc[object.type] || [];
    currentGroup.push(object);
    acc[object.type] = currentGroup;
    return acc;
  }, {});

const sortAttributeGroups = <T extends { attribute: string | null }>(
  groups: T[],
) =>
  groups.slice().sort((a, b) => {
    const attributeCompare = getAttributeLabel(a.attribute).localeCompare(
      getAttributeLabel(b.attribute),
    );
    if (attributeCompare !== 0) {
      return attributeCompare;
    }
    return 0;
  });

const sortRecords = (records: PersistenceRecordEntry[]) =>
  records.slice().sort((a, b) => {
    const createdCompare = b.created_at.localeCompare(a.created_at);
    if (createdCompare !== 0) {
      return createdCompare;
    }
    return a.game_id.localeCompare(b.game_id);
  });

const filterObjectGroups = (
  objects: PersistenceObject[],
  searchValue: string,
): Record<string, PersistenceObject[]> => {
  const normalizedSearch = searchValue.trim().toLowerCase();
  const groupedObjects = groupObjectsByType(sortObjects(objects));
  const filteredObjectGroups: Record<string, PersistenceObject[]> = {};

  for (const type of Object.keys(groupedObjects).sort((a, b) => a.localeCompare(b))) {
    const matches = groupedObjects[type].filter((object) => {
      const haystack = [
        object.name,
        object.type,
        getObjectPosition(object),
        object.created_at,
        object.expires_at,
      ]
        .join(' ')
        .toLowerCase();

      return !normalizedSearch || haystack.includes(normalizedSearch);
    });

    if (matches.length > 0) {
      filteredObjectGroups[type] = matches;
    }
  }

  return filteredObjectGroups;
};

const filterRecordGroups = (
  groups: PersistenceRecordTypeGroup[],
  searchValue: string,
): PersistenceRecordTypeGroup[] => {
  const normalizedSearch = searchValue.trim().toLowerCase();
  const filteredRecordGroups: PersistenceRecordTypeGroup[] = [];

  for (const group of groups) {
    const filteredAttributes: PersistenceRecordAttributeGroup[] = [];

    for (const attributeGroup of sortAttributeGroups(group.attributes || [])) {
      const matches = sortRecords(attributeGroup.records || []);
      const attributeSearch = !normalizedSearch
        ? matches
        : matches.filter((record) => {
            const haystack = [
              group.type,
              getAttributeLabel(attributeGroup.attribute),
              record.created_at,
              record.game_id,
              record.value,
            ]
              .join(' ')
              .toLowerCase();

            return haystack.includes(normalizedSearch);
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
        description: group.description,
        requires_attribute: group.requires_attribute,
        attributes: filteredAttributes,
      });
    }
  }

  return filteredRecordGroups;
};

const filterGenericGroups = (
  groups: PersistenceGenericTypeGroup[],
  searchValue: string,
): PersistenceGenericTypeGroup[] => {
  const normalizedSearch = searchValue.trim().toLowerCase();
  const filteredGenericGroups: PersistenceGenericTypeGroup[] = [];

  for (const group of groups) {
    const attributeGroups = Array.isArray(group.attributes) ? group.attributes : [];
    const filteredAttributes: PersistenceGenericAttributeGroup[] = [];

    for (const attributeGroup of attributeGroups) {
      const haystack = [
        group.type,
        group.title,
        group.description || '',
        getAttributeLabel(attributeGroup.attribute),
        attributeGroup.created_at || '',
        attributeGroup.expires_at || '',
        attributeGroup.json || '',
      ]
        .join(' ')
        .toLowerCase();

      if (!normalizedSearch || haystack.includes(normalizedSearch)) {
        filteredAttributes.push(attributeGroup);
      }
    }

    const groupHaystack = [group.type, group.title, group.description || '']
      .join(' ')
      .toLowerCase();
    const shouldIncludeGroup =
      !normalizedSearch ||
      groupHaystack.includes(normalizedSearch) ||
      filteredAttributes.length > 0;

    if (shouldIncludeGroup) {
      filteredGenericGroups.push({
        type: group.type,
        title: group.title,
        description: group.description,
        requires_attribute: group.requires_attribute,
        attributes: filteredAttributes,
      });
    }
  }

  return filteredGenericGroups;
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

  const objects = sortObjects(Array.isArray(data.objects) ? data.objects : []);
  const filteredObjectGroups = filterObjectGroups(objects, objectsSearch);
  const filteredObjectTypes = Object.keys(filteredObjectGroups).sort((a, b) =>
    a.localeCompare(b),
  );

  const recordGroups = (Array.isArray(data.records) ? data.records : [])
    .slice()
    .sort((a, b) => a.type.localeCompare(b.type))
    .map((group) => ({
      ...group,
      attributes: sortAttributeGroups((group.attributes || []).slice()),
    }));

  const genericGroups = (Array.isArray(data.generics) ? data.generics : [])
    .slice()
    .sort((a, b) => a.type.localeCompare(b.type))
    .map((group) => ({
      ...group,
      attributes: sortAttributeGroups((group.attributes || []).slice()),
    }));

  const filteredRecordGroups = filterRecordGroups(recordGroups, recordsSearch);
  const filteredGenericGroups = filterGenericGroups(genericGroups, genericsSearch);

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
          {tab !== 'Subsystem' && (
            <Button
              content="Refresh"
              color="blue"
              icon="sync"
              onClick={() => act('refresh')}
            />
          )}
        </div>

        {tab === 'Subsystem' && (
          <Section
            title="Persistence Subsystem"
            buttons={
              <Button
                content={savingButtonText}
                color={savingButtonColor}
                icon={data.saving_active ? 'toggle-off' : 'toggle-on'}
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
            <Box mb={1} italic color="label">
              This panel displays database content and requires a manual refresh. Expired objects are excluded.
            </Box>
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
                    <Table.Cell>Jump</Table.Cell>
                    <Table.Cell>Create date</Table.Cell>
                    <Table.Cell>Expire date</Table.Cell>
                    <Table.Cell>Edit</Table.Cell>
                  </Table.Row>
                  {filteredObjectGroups[type].map((object) => (
                    <Table.Row key={object.ref} className="candystripe">
                      <Table.Cell>{object.name}</Table.Cell>
                      <Table.Cell>{getObjectPosition(object)}</Table.Cell>
                      <Table.Cell>
                        <Button
                          icon="location-arrow"
                          tooltip="Jump to this object"
                          onClick={() => act('jump', { ref: object.ref })}
                        />
                      </Table.Cell>
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
            <Box mb={1} italic color="label">
              This panel displays database content (up to 1000 rows) and requires a manual refresh.
            </Box>
            {data.records.length === 0 && (
              <NoticeBox>Nothing to display.</NoticeBox>
            )}
            {data.records.length > 0 && filteredRecordGroups.length === 0 && (
              <NoticeBox>No history records match the current filter.</NoticeBox>
            )}
            {filteredRecordGroups.map((group) => (
              <Collapsible
                key={group.type}
                title={formatTitleWithCount(
                  group.title,
                  group.requires_attribute ? group.attributes.length : group.attributes.reduce((count, attributeGroup) => count + (attributeGroup.records?.length || 0), 0),
                )}
              >
                {group.description && (
                  <Box mb={1} style={{ whiteSpace: 'pre-wrap' }}>
                    {group.description}
                  </Box>
                )}
                {group.requires_attribute ? (
                  group.attributes.map((attributeGroup) => (
                    <Box key={`${group.type}-${attributeGroup.attribute || 'unattributed'}`} ml={1}>
                      <Collapsible
                        title={formatTitleWithCount(
                          attributeGroup.attribute || 'Unattributed',
                          attributeGroup.records?.length || 0,
                        )}
                      >
                        <Table>
                          <Table.Row header className="candystripe">
                            <Table.Cell>Created at</Table.Cell>
                            <Table.Cell>Game ID</Table.Cell>
                            <Table.Cell>Value</Table.Cell>
                          </Table.Row>
                          {(attributeGroup.records || []).map((record, index) => (
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
                    {(group.attributes[0]?.records || []).map((record, index) => (
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
            <Box mb={1} italic color="label">
              This panel displays database content and requires a manual refresh.
            </Box>
            {data.generics.length === 0 && (
              <NoticeBox>Nothing to display.</NoticeBox>
            )}
            {data.generics.length > 0 && filteredGenericGroups.length === 0 && (
              <NoticeBox>No persistent generics match the current filter.</NoticeBox>
            )}
            {filteredGenericGroups.map((group) => (
              <Collapsible
                key={group.type}
                title={formatTitleWithCount(
                  group.title,
                  group.requires_attribute ? group.attributes.length : 0,
                )}
              >
                {group.description && (
                  <Box mb={1} style={{ whiteSpace: 'pre-wrap' }}>
                    {group.description}
                  </Box>
                )}
                {group.requires_attribute ? (
                  group.attributes.map((attributeGroup) => (
                    <Box key={`${group.type}-${attributeGroup.attribute || 'unattributed'}`} ml={1} mb={1}>
                      <Collapsible title={attributeGroup.attribute || 'Unattributed'}>
                        <Section fill fitted title="Metadata">
                          <Box pl={1} pt={1}>
                            <LabeledList>
                              <LabeledList.Item label="Created at">
                                {attributeGroup.created_at || 'This round'}
                              </LabeledList.Item>
                              <LabeledList.Item label="Expires at">
                                {attributeGroup.expires_at || 'To be determined'}
                              </LabeledList.Item>
                            </LabeledList>
                          </Box>
                        </Section>
                        <Section fill fitted title="JSON payload">
                          <Box
                            as="pre"
                            m={0}
                            pl={1}
                            pt={1}
                            style={{
                              whiteSpace: 'pre-wrap',
                              wordBreak: 'break-word',
                            }}
                          >
                            {attributeGroup.json}
                          </Box>
                        </Section>
                      </Collapsible>
                    </Box>
                  ))
                ) : (
                  <Box>
                    <Section fill fitted title="Metadata">
                      <Box pl={1} pt={1}>
                        <LabeledList>
                          <LabeledList.Item label="Created at">
                            {group.attributes[0]?.created_at || 'This round'}
                          </LabeledList.Item>
                          <LabeledList.Item label="Expires at">
                            {group.attributes[0]?.expires_at || 'To be determined'}
                          </LabeledList.Item>
                        </LabeledList>
                      </Box>
                    </Section>
                    <Section fill fitted title="JSON payload">
                      <Box
                        as="pre"
                        m={0}
                        pl={1}
                        pt={1}
                        style={{
                          whiteSpace: 'pre-wrap',
                          wordBreak: 'break-word',
                        }}
                      >
                        {group.attributes[0]?.json}
                      </Box>
                    </Section>
                  </Box>
                )}
              </Collapsible>
            ))}
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
