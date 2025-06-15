import { capitalize } from '../../common/string';
import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Collapsible, Input, LabeledList, NoticeBox, Section, Stack, Tabs, Tooltip } from '../components';
import { NtosWindow } from '../layouts';
import { Dropdown } from '../components/Dropdown';

export type RecordsData = {
  activeview: string;
  editingvalue: string;
  physical_status_options: string[];
  criminal_status_options: string[];
  mental_status_options: string[];
  medical_options: string[];

  authenticated: BooleanLike;
  canprint: BooleanLike;
  available_types: number;
  editable: number;
  allrecords: Record[];
  allrecords_locked: RecordLocked[];

  front: string;
  side: string;
  active: Record;
};

type Record = {
  id: string;
  name: string;
  rank: string;
  sex: string;
  age: string;
  fingerprint: string;
  has_notes: string;
  blood: string;
  dna: string;
  physical_status: string;
  mental_status: string;
  species: string;
  citizenship: string;
  religion: string;
  employer: string;
  notes: string;
  security: Security;
  medical: Medical;
  ccia_notes: string;
  ccia_actions: string[];
};

type Security = {
  notes: string;
  criminal: string;
  crimes: string;
  incidents: Incident[];
};

type Incident = {
  charges: string[];
  datetime: string;
  fine: number;
  brig_sentence: number;
  id: string;
  notes: string;
};

type Medical = {
  notes: string;
  disabilities: string;
  allergies: string;
  diseases: string;
  blood_type: string;
  blood_dna: string;
};

type RecordLocked = {
  id: string;
  name: string;
  rank: string;
};

export const Records = (props, context) => {
  const { act, data } = useBackend<RecordsData>(context);
  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    `searchTerm`,
    ``
  );

  return (
    <NtosWindow resizable width={900} height={900}>
      <NtosWindow.Content scrollable>
        {!data.authenticated ? (
          <NoticeBox color="white">
            <Button
              content={'Please log in to continue to the database.'}
              icon="unlock"
              color={'green'}
              onClick={() => act('login')}
            />{' '}
          </NoticeBox>
        ) : (
          <RecordsView />
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const RecordsView = (props, context) => {
  const { act, data } = useBackend<RecordsData>(context);
  const [recordTab, setRecordTab] = useLocalState(context, 'recordTab', 'All');

  return (
    <Stack>
      <Stack.Item width={'300px'}>
        <ListAllRecords />
      </Stack.Item>
      <Stack.Item grow>{data.active ? <ListActive /> : ''}</Stack.Item>
    </Stack>
  );
};

export const ListAllRecords = (props, context) => {
  const { act, data } = useBackend<RecordsData>(context);
  const [recordTab, setRecordTab] = useLocalState(context, 'recordTab', 'All');
  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    `searchTerm`,
    ``
  );

  return (
    <Section
      title="Records"
      fill
      buttons={
        <Tooltip content="Search by name or DNA.">
          <Input
            autoFocus
            autoSelect
            maxLength={512}
            onInput={(e, value) => {
              setSearchTerm(value);
            }}
            value={searchTerm}
          />
          <Button
            icon={data.authenticated ? 'lock' : 'unlock'}
            tooltip="Log Out"
            color={data.authenticated ? 'red' : 'green'}
            onClick={() => act(data.authenticated ? 'logout' : 'login')}
          />
        </Tooltip>
      }>
      <Tabs vertical>
        {data.allrecords
          .filter(
            (record) =>
              record.name.toLowerCase().indexOf(searchTerm) > -1 ||
              record.fingerprint.toLowerCase().indexOf(searchTerm) > -1 ||
              record.dna.toLowerCase().indexOf(searchTerm) > -1
          )
          .map((record) => (
            <Tabs.Tab
              key={record.id}
              icon={
                record.has_notes !== 'No notes found.'
                  ? 'align-justify'
                  : 'strikethrough'
              }
              onClick={() => act('setactive', { setactive: record.id })}>
              {record.id + ': ' + record.name + ' (' + record.rank + ')'}
            </Tabs.Tab>
          ))}
      </Tabs>
    </Section>
  );
};

// Omega shitcode ahead but this is my like 56th UI and I don't give a fuck anymore.
export const ListActive = (props, context) => {
  const { act, data } = useBackend<RecordsData>(context);
  const [recordTab, setRecordTab] = useLocalState(context, 'recordTab', 'All');
  const [editingPhysStatus, setEditingPhysStatus] = useLocalState<boolean>(
    context,
    'editingPhysStatus',
    false
  );
  const [editingMentalStatus, setEditingMentalStatus] = useLocalState<boolean>(
    context,
    'editingMentalStatus',
    false
  );
  const [editingFingerprint, setEditingFingerprint] = useLocalState<boolean>(
    context,
    'editingFingerprint',
    false
  );
  const [editingCriminalStatus, setEditingCriminalStatus] =
    useLocalState<boolean>(context, 'editingCriminalStatus', false);
  const [editingSpecies, setEditingSpecies] = useLocalState<boolean>(
    context,
    'editingSpecies',
    false
  );
  const [editingCitizenship, setEditingCitizenship] = useLocalState<boolean>(
    context,
    'editingCitizenship',
    false
  );
  const [editingReligion, setEditingReligion] = useLocalState<boolean>(
    context,
    'editingReligion',
    false
  );
  const [editingEmployer, setEditingEmployer] = useLocalState<boolean>(
    context,
    'editingEmployer',
    false
  );
  const [editingDNA, setEditingDNA] = useLocalState<boolean>(
    context,
    'editingDNA',
    false
  );

  const [editingDisabilities, setEditingDisabilities] = useLocalState<boolean>(
    context,
    'editingDisabilities',
    false
  );
  const [editingAllergies, setEditingAllergies] = useLocalState<boolean>(
    context,
    'editingAllergies',
    false
  );
  const [editingDisease, setEditingDisease] = useLocalState<boolean>(
    context,
    'editingDisease',
    false
  );

  return (
    <Section
      fill
      title={data.active.name}
      buttons={
        <Button content="Print" icon="print" onClick={() => act('print')} />
      }>
      <Tabs>
        {data.available_types & 8 ? (
          <Tabs.Tab
            selected={recordTab === 'All (Locked)'}
            onClick={() => setRecordTab('All (Locked)')}>
            All (Locked)
          </Tabs.Tab>
        ) : (
          ''
        )}
        {data.active ? (
          <>
            {data.available_types & 1 ? (
              <Tabs.Tab
                selected={recordTab === 'General'}
                onClick={() => setRecordTab('General')}>
                General - #{data.active.id}
              </Tabs.Tab>
            ) : (
              ''
            )}{' '}
            {data.available_types & 4 ? (
              <Tabs.Tab
                selected={recordTab === 'Security'}
                onClick={() => setRecordTab('Security')}>
                Security - #{data.active.id}
              </Tabs.Tab>
            ) : (
              ''
            )}{' '}
            {data.available_types & 2 ? (
              <Tabs.Tab
                selected={recordTab === 'Medical'}
                onClick={() => setRecordTab('Medical')}>
                Medical - #{data.active.id}
              </Tabs.Tab>
            ) : (
              ''
            )}
          </>
        ) : (
          ''
        )}
      </Tabs>
      <Box
        as="img"
        m={0}
        src={`data:image/jpeg;base64,${data.front}`}
        width="30%"
        height="30%"
        style={{
          '-ms-interpolation-mode': 'nearest-neighbor',
          'pointer-events': 'none',
          'width': `${64}px`,
          'height': `${64}px`,
        }}
      />
      <Box
        as="img"
        m={0}
        src={`data:image/jpeg;base64,${data.side}`}
        width="30%"
        height="30%"
        style={{
          '-ms-interpolation-mode': 'nearest-neighbor',
          'pointer-events': 'none',
          'width': `${64}px`,
          'height': `${64}px`,
        }}
      />
      <LabeledList>
        <LabeledList.Item label="ID">#{data.active.id}</LabeledList.Item>
        <LabeledList.Item label="Name">{data.active.name}</LabeledList.Item>
        <LabeledList.Item label="Age">{data.active.age}</LabeledList.Item>
        <LabeledList.Item label="Sex">
          {capitalize(data.active.sex)}
        </LabeledList.Item>
        <LabeledList.Item label="Species">
          {data.editable & 1 ? (
            <Box>
              {editingSpecies ? (
                <Input
                  placeholder={data.active.species}
                  width="100%"
                  onInput={(e, v) =>
                    act('editrecord', {
                      key: 'species',
                      value: v,
                    })
                  }
                />
              ) : (
                <Box>
                  {data.active.species}&nbsp;
                  <Button
                    icon="pencil-ruler"
                    onClick={() => setEditingSpecies(true)}
                  />
                </Box>
              )}
            </Box>
          ) : (
            data.active.species
          )}
        </LabeledList.Item>
        <LabeledList.Item label="Rank">{data.active.rank}</LabeledList.Item>
        <LabeledList.Item label="Physical Status">
          {data.editable & 1 || data.editable & 2 ? (
            <Box>
              {editingPhysStatus ? (
                <Dropdown
                  options={data.physical_status_options}
                  displayText={data.active.physical_status}
                  selected={data.active.physical_status}
                  onSelected={(v) =>
                    act('editrecord', {
                      key: 'physical_status',
                      value: v,
                    })
                  }
                />
              ) : (
                <Box>
                  {data.active.physical_status}&nbsp;
                  <Button
                    icon="pencil-ruler"
                    onClick={() => setEditingPhysStatus(true)}
                  />
                </Box>
              )}
            </Box>
          ) : (
            data.active.physical_status
          )}
        </LabeledList.Item>
        <LabeledList.Item label="Mental Status">
          {data.editable & 1 || data.editable & 2 ? (
            <Box>
              {editingMentalStatus ? (
                <Dropdown
                  options={data.mental_status_options}
                  displayText={data.active.mental_status}
                  selected={data.active.mental_status}
                  onSelected={(v) =>
                    act('editrecord', {
                      key: 'mental_status',
                      value: v,
                    })
                  }
                />
              ) : (
                <Box>
                  {data.active.mental_status}&nbsp;
                  <Button
                    icon="pencil-ruler"
                    onClick={() => setEditingMentalStatus(true)}
                  />
                </Box>
              )}
            </Box>
          ) : (
            data.active.mental_status
          )}
        </LabeledList.Item>
        {data.active.security ? (
          <LabeledList.Item label="Criminal Status">
            {data.editable & 4 ? (
              <Box>
                {editingCriminalStatus ? (
                  <Dropdown
                    options={data.criminal_status_options}
                    displayText={data.active.security.criminal}
                    selected={data.active.security.criminal}
                    onSelected={(v) =>
                      act('editrecord', {
                        record_type: 'security',
                        key: 'criminal',
                        value: v,
                      })
                    }
                  />
                ) : (
                  <Box>
                    {data.active.security.criminal}&nbsp;
                    <Button
                      icon="pencil-ruler"
                      onClick={() => setEditingCriminalStatus(true)}
                    />
                  </Box>
                )}
              </Box>
            ) : (
              data.active.security.criminal
            )}
          </LabeledList.Item>
        ) : (
          ''
        )}
        <LabeledList.Item label="Fingerprint">
          {data.editable & 1 ? (
            <Box>
              {editingFingerprint ? (
                <Input
                  placeholder={data.active.fingerprint}
                  width="100%"
                  onInput={(e, v) =>
                    act('editrecord', {
                      key: 'fingerprint',
                      value: v,
                    })
                  }
                />
              ) : (
                <Box>
                  {data.active.fingerprint}&nbsp;
                  <Button
                    icon="pencil-ruler"
                    onClick={() => setEditingFingerprint(true)}
                  />
                </Box>
              )}
            </Box>
          ) : (
            data.active.fingerprint
          )}
        </LabeledList.Item>
        {data.active.medical && recordTab === 'Medical' ? (
          <>
            <LabeledList.Item label="DNA">
              {data.editable & 2 ? (
                <Box>
                  {editingDNA ? (
                    <Input
                      placeholder={data.active.medical.blood_dna}
                      width="100%"
                      onInput={(e, v) =>
                        act('editrecord', {
                          record_type: 'medical',
                          key: 'blood_dna',
                          value: v,
                        })
                      }
                    />
                  ) : (
                    <Box>
                      {data.active.medical.blood_dna}&nbsp;
                      <Button
                        icon="pencil-ruler"
                        onClick={() => setEditingDNA(true)}
                      />
                    </Box>
                  )}
                </Box>
              ) : (
                data.active.medical.blood_dna
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Disabilities">
              {data.editable & 2 ? (
                <Box>
                  {editingDisabilities ? (
                    <Input
                      placeholder={data.active.medical.disabilities}
                      width="100%"
                      onInput={(e, v) =>
                        act('editrecord', {
                          record_type: 'medical',
                          key: 'fingerprint',
                          value: v,
                        })
                      }
                    />
                  ) : (
                    <Box>
                      {data.active.medical.disabilities}&nbsp;
                      <Button
                        icon="pencil-ruler"
                        onClick={() => setEditingDisabilities(true)}
                      />
                    </Box>
                  )}
                </Box>
              ) : (
                data.active.medical.disabilities
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Allergies">
              {data.editable & 2 ? (
                <Box>
                  {editingAllergies ? (
                    <Input
                      placeholder={data.active.medical.allergies}
                      width="100%"
                      onInput={(e, v) =>
                        act('editrecord', {
                          record_type: 'medical',
                          key: 'allergies',
                          value: v,
                        })
                      }
                    />
                  ) : (
                    <Box>
                      {data.active.medical.allergies}&nbsp;
                      <Button
                        icon="pencil-ruler"
                        onClick={() => setEditingAllergies(true)}
                      />
                    </Box>
                  )}
                </Box>
              ) : (
                data.active.medical.allergies
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Disease">
              {data.editable & 2 ? (
                <Box>
                  {editingDisease ? (
                    <Input
                      placeholder={data.active.medical.diseases}
                      width="100%"
                      onInput={(e, v) =>
                        act('editrecord', {
                          record_type: 'medical',
                          key: 'diseases',
                          value: v,
                        })
                      }
                    />
                  ) : (
                    <Box>
                      {data.active.medical.diseases}&nbsp;
                      <Button
                        icon="pencil-ruler"
                        onClick={() => setEditingDisease(true)}
                      />
                    </Box>
                  )}
                </Box>
              ) : (
                data.active.medical.diseases
              )}
            </LabeledList.Item>
          </>
        ) : (
          ''
        )}
        {data.available_types & 1 && recordTab === 'General' ? (
          <>
            <LabeledList.Item label="Citizenship">
              {data.editable & 1 ? (
                <Box>
                  {editingCitizenship ? (
                    <Input
                      placeholder={data.active.citizenship}
                      width="100%"
                      onInput={(e, v) =>
                        act('editrecord', {
                          key: 'citizenship',
                          value: v,
                        })
                      }
                    />
                  ) : (
                    <Box>
                      {data.active.citizenship}&nbsp;
                      <Button
                        icon="pencil-ruler"
                        onClick={() => setEditingCitizenship(true)}
                      />
                    </Box>
                  )}
                </Box>
              ) : (
                data.active.citizenship
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Religion">
              {data.editable & 1 ? (
                <Box>
                  {editingReligion ? (
                    <Input
                      placeholder={data.active.religion}
                      width="100%"
                      onInput={(e, v) =>
                        act('editrecord', {
                          key: 'religion',
                          value: v,
                        })
                      }
                    />
                  ) : (
                    <Box>
                      {data.active.religion}&nbsp;
                      <Button
                        icon="pencil-ruler"
                        onClick={() => setEditingReligion(true)}
                      />
                    </Box>
                  )}
                </Box>
              ) : (
                data.active.religion
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Employer">
              {data.editable & 1 ? (
                <Box>
                  {editingEmployer ? (
                    <Input
                      placeholder={data.active.employer}
                      width="100%"
                      onInput={(e, v) =>
                        act('editrecord', {
                          key: 'employer',
                          value: v,
                        })
                      }
                    />
                  ) : (
                    <Box>
                      {data.active.employer}&nbsp;
                      <Button
                        icon="pencil-ruler"
                        onClick={() => setEditingEmployer(true)}
                      />
                    </Box>
                  )}
                </Box>
              ) : (
                data.active.employer
              )}
            </LabeledList.Item>
          </>
        ) : (
          ''
        )}
      </LabeledList>
      {recordTab === 'General' ? (
        <Section title="Employment Records">
          {data.active.notes.split('\n').map((line) => (
            <Box key={line}>{line}</Box>
          ))}
        </Section>
      ) : recordTab === 'Security' ? (
        <Section title="Security Records">
          {data.active.security.notes.split('\n').map((line) => (
            <Box key={line}>{line}</Box>
          ))}
        </Section>
      ) : recordTab === 'Medical' ? (
        <Section title="Medical Records">
          {data.active.medical.notes.split('\n').map((line) => (
            <Box key={line}>{line}</Box>
          ))}
        </Section>
      ) : (
        ''
      )}

      {recordTab === 'Security' ? (
        <>
          <Section title="Incidents">
            {data.active.security.incidents &&
            data.active.security.incidents.length
              ? data.active.security.incidents.map((incident) => (
                <Box backgroundColor="#223449" key={incident.id}>
                  <Collapsible title={incident.datetime}>
                    <Box fontSize={1.3} bold color="red">
                      {incident.charges.toLocaleString()}
                    </Box>
                    <Box color="red">
                      {incident.fine
                        ? 'Fined ' + incident.fine.toFixed(2) + '电.'
                        : 'Sentenced to ' +
                        incident.brig_sentence +
                        ' minutes of brig time.'}
                    </Box>
                    <br />
                    <br />
                    {incident.notes}
                  </Collapsible>
                </Box>
              ))
              : 'No incidents on record.'}
          </Section>
          <Section title="Crimes">{data.active.security.crimes}</Section>
        </>
      ) : (
        ''
      )}

      {data.active.ccia_notes ? (
        <Section title="CCIA Notes">
          {data.active.ccia_notes.split('\n').map((line) => (
            <Box key={line}>{line}</Box>
          ))}
        </Section>
      ) : (
        ''
      )}
      {data.active.ccia_actions ? (
        <Section title="CCIA Actions">
          {data.active.ccia_actions.length
            ? data.active.ccia_actions.map((line) => (
              <Box key={line}>{line}</Box>
            ))
            : 'No CCIA actions on record.'}
        </Section>
      ) : (
        ''
      )}
    </Section>
  );
};
