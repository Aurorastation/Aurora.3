import { Fragment, useEffect } from 'react';
import {
  Box,
  Button,
  Collapsible,
  Divider,
  Dropdown,
  Image,
  Input,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Tabs,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { capitalize } from 'tgui-core/string';
import { useBackend, useLocalState } from '../backend';
import { NtosWindow } from '../layouts';
import { sanitizePaperText } from '../sanitize';
import { ActivityCard } from './common/ActivityCard';
import { SearchBar } from './common/SearchBar';

export type RecordsData = {
  activeview: string;
  editingvalue: string;
  physical_status_options: string[];
  criminal_status_options: string[];
  mental_status_options: string[];
  blood_type_options: string[];
  medical_options: string[];

  authenticated: BooleanLike;
  authenticated_name?: string;
  canprint: BooleanLike;
  available_types: number;
  editable: number;
  allrecords: Record[];
  allrecords_locked: RecordLocked[];

  front: string;
  side: string;
  active: Record;
  record_comments: RecordComment[];
  record_comments_type?: 'employment' | 'medical' | 'security';
  record_comments_page: number;
  record_comments_total: number;
  record_comments_page_size: number;
  record_comments_loading: BooleanLike;
  record_comments_error: BooleanLike;
};

type Record = {
  id: string;
  name: string;
  rank: string;
  sex: string;
  age: string;
  fingerprint?: string;
  has_notes: string;
  blood_dna: string;
  dna: string;
  physical_status: string;
  mental_status?: string;
  species: string;
  citizenship?: string;
  religion?: string;
  employer?: string;
  notes?: string;
  notes_html?: string;
  security?: Security;
  medical?: Medical;
  ccia_notes?: string;
  ccia_actions?: string[];
};

type Security = {
  notes: string;
  notes_html?: string;
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
  notes_html?: string;
  blood_type: string;
  blood_dna: string;
};

type RecordComment = {
  id: string;
  comment: string;
  author: string;
  created_at: string;
  updated_at?: string;
  editable: BooleanLike;
};

type RecordLocked = {
  id: string;
  name: string;
  rank: string;
};

export const Records = (props) => {
  const { act, data } = useBackend<RecordsData>();

  if (!data.authenticated) {
    return (
      <NtosWindow width={900} height={900} theme="scc">
        <NtosWindow.Content>
          <NoticeBox color="white">
            Log in with an ID to access the employee directory. Departmental
            sections are made available according to the ID&apos;s access.
          </NoticeBox>
          <Stack justify="center">
            <Stack.Item>
              <Button
                content="Log in with ID"
                icon="unlock"
                color="green"
                onClick={() => act('login')}
              />
            </Stack.Item>
          </Stack>
        </NtosWindow.Content>
      </NtosWindow>
    );
  }

  return (
    <NtosWindow width={900} height={900} theme="scc">
      <NtosWindow.Content scrollable>
        <NoticeBox color="white">
          {data.authenticated
            ? `Authenticated as ${data.authenticated_name}. Protected sections reflect this ID's access.`
            : 'Public directory access. Log in with an ID to access authorized departmental records.'}
        </NoticeBox>
        <RecordsView />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const RecordsView = (props) => {
  const { data } = useBackend<RecordsData>();

  return (
    <Stack>
      <Stack.Item width={'300px'}>
        <ListAllRecords />
      </Stack.Item>
      <Stack.Item grow>{data.active ? <ListActive /> : ''}</Stack.Item>
    </Stack>
  );
};

export const ListAllRecords = (props) => {
  const { act, data } = useBackend<RecordsData>();
  const [searchTerm, setSearchTerm] = useLocalState<string>(`searchTerm`, ``);

  return (
    <Section
      title="Employee Directory"
      fill
      buttons={
        <Button
          icon={data.authenticated ? 'lock' : 'unlock'}
          tooltip={
            data.authenticated
              ? `Log out ${data.authenticated_name}`
              : 'Log in with your ID'
          }
          color={data.authenticated ? 'red' : 'green'}
          onClick={() => act(data.authenticated ? 'logout' : 'login')}
        />
      }
    >
      <Tooltip content="Search by name, or by authorized fingerprint and DNA data.">
        <SearchBar
          autoFocus
          query={searchTerm}
          onSearch={(value) => {
            setSearchTerm(value);
          }}
          style={{
            width: '100%',
            height: '2rem',
            marginBottom: '0.5rem',
          }}
        />
      </Tooltip>
      <Tabs vertical>
        {data.allrecords
          .filter(
            (record) =>
              record.name.toLowerCase().indexOf(searchTerm) > -1 ||
              (record.fingerprint || '').toLowerCase().indexOf(searchTerm) >
                -1 ||
              record.dna.toLowerCase().indexOf(searchTerm) > -1,
          )
          .map((record) => (
            <Tabs.Tab
              key={record.id}
              icon={
                data.available_types & 1 &&
                record.has_notes !== 'No notes found.'
                  ? 'align-justify'
                  : 'user'
              }
              onClick={() => act('setactive', { setactive: record.id })}
            >
              {`${record.id}: ${record.name} (${record.rank})`}
            </Tabs.Tab>
          ))}
      </Tabs>
    </Section>
  );
};

// Omega shitcode ahead but this is my like 56th UI and I don't give a fuck anymore.
export const ListActive = (props) => {
  const { act, data } = useBackend<RecordsData>();
  const security = data.active.security;
  const medical = data.active.medical;
  const mentalStatus = data.active.mental_status;
  const fingerprint = data.active.fingerprint;
  const [recordTab, setRecordTab] = useLocalState(
    'employeeDirectoryTab',
    'Public',
  );
  const activeTab =
    (recordTab === 'Employment' && !(data.available_types & 1)) ||
    (recordTab === 'Medical' && !(data.available_types & 2)) ||
    (recordTab === 'Security' && !(data.available_types & 4))
      ? 'Public'
      : recordTab;
  useEffect(() => {
    if (
      activeTab === 'Employment' ||
      activeTab === 'Medical' ||
      activeTab === 'Security'
    ) {
      act('loadcomments', { record_type: activeTab.toLowerCase() });
    }
  }, [act, activeTab, data.active.id]);
  const [editingPhysStatus, setEditingPhysStatus] = useLocalState<boolean>(
    'editingPhysStatus',
    false,
  );
  const [editingMentalStatus, setEditingMentalStatus] = useLocalState<boolean>(
    'editingMentalStatus',
    false,
  );
  const [editingBloodType, setEditingBloodType] = useLocalState<boolean>(
    'editingBloodType',
    false,
  );
  const [editingFingerprint, setEditingFingerprint] = useLocalState<boolean>(
    'editingFingerprint',
    false,
  );
  const [editingCriminalStatus, setEditingCriminalStatus] =
    useLocalState<boolean>('editingCriminalStatus', false);
  const [editingSpecies, setEditingSpecies] = useLocalState<boolean>(
    'editingSpecies',
    false,
  );
  const [editingCitizenship, setEditingCitizenship] = useLocalState<boolean>(
    'editingCitizenship',
    false,
  );
  const [editingReligion, setEditingReligion] = useLocalState<boolean>(
    'editingReligion',
    false,
  );
  const [editingEmployer, setEditingEmployer] = useLocalState<boolean>(
    'editingEmployer',
    false,
  );
  const [editingDNA, setEditingDNA] = useLocalState<boolean>(
    'editingDNA',
    false,
  );

  return (
    <Section
      fill
      title={data.active.name}
      buttons={
        <>
          <Button
            color={!data.canprint ? 'bad' : undefined}
            content={`Print ${activeTab}`}
            icon="print"
            tooltip={
              data.canprint
                ? `Print only the ${activeTab.toLowerCase()} record`
                : 'No printer installed'
            }
            onClick={() =>
              act('print', { scope: activeTab.toLowerCase() })
            }
          />
          <Button
            color={!data.canprint ? 'bad' : undefined}
            content="Print All"
            icon="print"
            tooltip={
              data.canprint
                ? 'Print every record section available to this login'
                : 'No printer installed'
            }
            onClick={() => act('print', { scope: 'all' })}
          />
        </>
      }
    >
      <Tabs>
        {data.active ? (
          <>
            <Tabs.Tab
              selected={activeTab === 'Public'}
              onClick={() => setRecordTab('Public')}
            >
              Public - #{data.active.id}
            </Tabs.Tab>{' '}
            {data.available_types & 1 ? (
              <Tabs.Tab
                selected={activeTab === 'Employment'}
                onClick={() => setRecordTab('Employment')}
              >
                Employment - #{data.active.id}
              </Tabs.Tab>
            ) : (
              ''
            )}{' '}
            {data.available_types & 4 ? (
              <Tabs.Tab
                selected={activeTab === 'Security'}
                onClick={() => setRecordTab('Security')}
              >
                Security - #{data.active.id}
              </Tabs.Tab>
            ) : (
              ''
            )}{' '}
            {data.available_types & 2 ? (
              <Tabs.Tab
                selected={activeTab === 'Medical'}
                onClick={() => setRecordTab('Medical')}
              >
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
      <Image
        width="64px"
        height="64px"
        src={`data:image/jpeg;base64,${data.front}`}
      />
      <Image
        width="64px"
        height="64px"
        src={`data:image/jpeg;base64,${data.side}`}
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
                  onChange={(v) =>
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
        {activeTab === 'Medical' && mentalStatus ? (
          <LabeledList.Item label="Mental Status">
            {data.editable & 2 ? (
              <Box>
                {editingMentalStatus ? (
                  <Dropdown
                    options={data.mental_status_options}
                    displayText={mentalStatus}
                    selected={mentalStatus}
                    onSelected={(v) =>
                      act('editrecord', {
                        key: 'mental_status',
                        value: v,
                      })
                    }
                  />
                ) : (
                  <Box>
                    {mentalStatus}&nbsp;
                    <Button
                      icon="pencil-ruler"
                      onClick={() => setEditingMentalStatus(true)}
                    />
                  </Box>
                )}
              </Box>
            ) : (
              mentalStatus
            )}
          </LabeledList.Item>
        ) : (
          ''
        )}
        {activeTab === 'Medical' && medical ? (
          <LabeledList.Item label="Blood Type">
            {data.editable & 2 ? (
              <Box>
                {editingBloodType ? (
                  <Dropdown
                    options={data.blood_type_options}
                    displayText={medical.blood_type}
                    selected={medical.blood_type}
                    onSelected={(v) =>
                      act('editrecord', {
                        record_type: 'medical',
                        key: 'blood_type',
                        value: v,
                      })
                    }
                  />
                ) : (
                  <Box>
                    {medical.blood_type}&nbsp;
                    <Button
                      icon="pencil-ruler"
                      onClick={() => setEditingBloodType(true)}
                    />
                  </Box>
                )}
              </Box>
            ) : (
              medical.blood_type
            )}
          </LabeledList.Item>
        ) : (
          ''
        )}
        {activeTab === 'Medical' && medical ? (
          <LabeledList.Item label="DNA">
            {data.editable & 2 ? (
              <Box>
                {editingDNA ? (
                  <Input
                    placeholder={medical.blood_dna}
                    width="100%"
                    onChange={(v) =>
                      act('editrecord', {
                        record_type: 'medical',
                        key: 'blood_dna',
                        value: v,
                      })
                    }
                  />
                ) : (
                  <Box>
                    {medical.blood_dna}&nbsp;
                    <Button
                      icon="pencil-ruler"
                      onClick={() => setEditingDNA(true)}
                    />
                  </Box>
                )}
              </Box>
            ) : (
              medical.blood_dna
            )}
          </LabeledList.Item>
        ) : (
          ''
        )}
        {activeTab === 'Security' && security ? (
          <LabeledList.Item label="Criminal Status">
            {data.editable & 4 ? (
              <Box>
                {editingCriminalStatus ? (
                  <Dropdown
                    options={data.criminal_status_options}
                    displayText={security.criminal}
                    selected={security.criminal}
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
                    {security.criminal}&nbsp;
                    <Button
                      icon="pencil-ruler"
                      onClick={() => setEditingCriminalStatus(true)}
                    />
                  </Box>
                )}
              </Box>
            ) : (
              security.criminal
            )}
          </LabeledList.Item>
        ) : (
          ''
        )}
        {activeTab === 'Security' && fingerprint ? (
          <LabeledList.Item label="Fingerprint">
            {data.editable & 4 ? (
              <Box>
                {editingFingerprint ? (
                  <Input
                    placeholder={fingerprint}
                    width="100%"
                    onChange={(v) =>
                      act('editrecord', {
                        key: 'fingerprint',
                        value: v,
                      })
                    }
                  />
                ) : (
                  <Box>
                    {fingerprint}&nbsp;
                    <Button
                      icon="pencil-ruler"
                      onClick={() => setEditingFingerprint(true)}
                    />
                  </Box>
                )}
              </Box>
            ) : (
              fingerprint
            )}
          </LabeledList.Item>
        ) : (
          ''
        )}
        {data.available_types & 1 && activeTab === 'Employment' ? (
          <>
            <LabeledList.Item label="Citizenship">
              {data.editable & 1 ? (
                <Box>
                  {editingCitizenship ? (
                    <Input
                      placeholder={data.active.citizenship}
                      width="100%"
                      onChange={(v) =>
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
                      onChange={(v) =>
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
                      onChange={(v) =>
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
      {activeTab === 'Employment' && (data.available_types & 1) ? (
        <>
          <Section title="Employment Records">
            <PaperRecordText
              html={data.active.notes_html}
              fallback={data.active.notes}
            />
          </Section>
          <RecordComments
            recordType="employment"
            editable={!!(data.editable & 1)}
          />
        </>
      ) : activeTab === 'Security' && security ? (
        <>
          <Section title="Security Records">
            <PaperRecordText
              html={security.notes_html}
              fallback={security.notes}
            />
          </Section>
          <RecordComments
            recordType="security"
            editable={!!(data.editable & 4)}
          />
        </>
      ) : activeTab === 'Medical' && medical ? (
        <>
          <Section title="Medical Records">
            <PaperRecordText
              html={medical.notes_html}
              fallback={medical.notes}
            />
          </Section>
          <RecordComments
            recordType="medical"
            editable={!!(data.editable & 2)}
          />
        </>
      ) : (
        ''
      )}

      {activeTab === 'Security' && security ? (
        <>
          <Section title="Incidents">
            {security.incidents?.length
              ? security.incidents.map((incident) => (
                  <Box backgroundColor="#223449" key={incident.id}>
                    <Collapsible title={incident.datetime}>
                      <Box fontSize={1.3} bold color="red">
                        {incident.charges.toLocaleString()}
                      </Box>
                      <Box color="red">
                        {incident.fine
                          ? `Fined ${incident.fine.toFixed(2)}电.`
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
          <Section title="Crimes">{security.crimes}</Section>
        </>
      ) : (
        ''
      )}

      {activeTab === 'Employment' && data.active.ccia_notes ? (
        <Section title="CCIA Notes">
          {data.active.ccia_notes.split('\n').map((line) => (
            <Box key={line}>{line}</Box>
          ))}
        </Section>
      ) : (
        ''
      )}
      {activeTab === 'Employment' && data.active.ccia_actions ? (
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

const PaperRecordText = (props: { html?: string; fallback?: string }) => {
  const { html, fallback } = props;

  if (html) {
    const contentHtml = {
      __html: sanitizePaperText(html),
    };

    return (
      // biome-ignore lint/security/noDangerouslySetInnerHtml: BYOND papercode output is sanitized before display.
      <Box dangerouslySetInnerHTML={contentHtml} />
    );
  }

  return (
    <>
      {(fallback || '').split('\n').map((line, index) => (
        <Box key={`${index}-${line}`}>{line}</Box>
      ))}
    </>
  );
};

const RecordComments = (props: {
  recordType: 'employment' | 'medical' | 'security';
  editable: boolean;
}) => {
  const { act, data } = useBackend<RecordsData>();
  const { recordType, editable } = props;
  const isLoadedType = data.record_comments_type === recordType;
  const comments = isLoadedType ? data.record_comments : [];
  const loading = !isLoadedType || !!data.record_comments_loading;
  const error = isLoadedType && !!data.record_comments_error;
  const totalPages = Math.max(
    1,
    Math.ceil(data.record_comments_total / data.record_comments_page_size),
  );

  return (
    <Section
      title="Comments"
      buttons={
        <>
          <Button
            icon="rotate"
            tooltip="Refresh comments"
            disabled={loading}
            onClick={() =>
              act('commentpage', {
                record_type: recordType,
                page: data.record_comments_page,
              })
            }
          />
          {editable ? (
            <Button
              icon="plus"
              content="Add Comment"
              onClick={() => act('addcomment', { record_type: recordType })}
            />
          ) : null}
        </>
      }
    >
      {loading ? (
        <NoticeBox color="blue">Loading comments...</NoticeBox>
      ) : (
        <>
          {error ? (
            <NoticeBox danger>
              Persistent comments could not be loaded. Showing comments created
              this round.
            </NoticeBox>
          ) : null}
          {comments.length ? (
            <Stack vertical>
              {comments.map((comment, index) => (
                <Fragment key={comment.id}>
                  {index > 0 ? (
                    <Stack.Item>
                      <Divider />
                    </Stack.Item>
                  ) : null}
                  <Stack.Item>
                    <ActivityCard
                      title={comment.author}
                      subtitle={comment.created_at}
                      actions={
                        editable && comment.editable ? (
                          <>
                            <Button
                              compact
                              icon="pen"
                              tooltip="Edit this comment"
                              onClick={() =>
                                act('editcomment', {
                                  record_type: recordType,
                                  comment_id: comment.id,
                                })
                              }
                            />
                            <Button
                              compact
                              icon="trash"
                              color="bad"
                              tooltip="Delete this comment"
                              onClick={() =>
                                act('deletecomment', {
                                  record_type: recordType,
                                  comment_id: comment.id,
                                })
                              }
                            />
                          </>
                        ) : undefined
                      }
                      footer={
                        comment.updated_at
                          ? `Edited ${comment.updated_at}`
                          : undefined
                      }
                    >
                      {comment.comment}
                    </ActivityCard>
                  </Stack.Item>
                </Fragment>
              ))}
            </Stack>
          ) : (
            <Box color="label" italic textAlign="center" py={1}>
              No comments found.
            </Box>
          )}
        </>
      )}
      {!loading && !error && data.record_comments_total > 0 ? (
        <Stack align="center" justify="center" mt={1}>
          <Stack.Item>
            <Button
              icon="chevron-left"
              disabled={data.record_comments_page <= 1}
              onClick={() =>
                act('commentpage', {
                  record_type: recordType,
                  page: data.record_comments_page - 1,
                })
              }
            />
          </Stack.Item>
          <Stack.Item>
            Page {data.record_comments_page} of {totalPages} (
            {data.record_comments_total} comments)
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="chevron-right"
              disabled={data.record_comments_page >= totalPages}
              onClick={() =>
                act('commentpage', {
                  record_type: recordType,
                  page: data.record_comments_page + 1,
                })
              }
            />
          </Stack.Item>
        </Stack>
      ) : null}
    </Section>
  );
};
