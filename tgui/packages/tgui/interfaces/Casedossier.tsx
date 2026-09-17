import {
  Box,
  Button,
  Dropdown,
  Input,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Table,
  Tabs,
  TextArea,
} from 'tgui-core/components';
import { useBackend, useLocalState } from '../backend';
import { NtosWindow } from '../layouts';
import { sanitizeText } from '../sanitize';

type CaseStatus = 'Open' | 'Submitted' | 'Archived';

type ActFinal = (action: string, payload?: Record<string, any>) => void;
type SetStateFinal<T> = (value: T) => void;

type DossierPerson = {
  id: string;
  name: string;
  role: string;
  notes?: string;
};

type DossierEvidence = {
  id: string;
  label: string;
  type: string;
  location?: string;
  evidence_locker?: string;
  collected_by?: string;
  collected_at?: string;
  notes?: string;
  linked_people?: string[];
};

type DossierPhoto = {
  id: string;
  photo_id?: string;
  caption: string;
  label?: string;
  type?: string;
  location?: string;
  taken_by?: string;
  taken_at?: string;
  collected_by?: string;
  collected_at?: string;
  notes?: string;
  scribble?: string;
  linked_evidence?: string[];
  image?: string;
};

type DossierReport = {
  id: string;
  title: string;
  label?: string;
  type: string;
  author?: string;
  created_at?: string;
  collected_by?: string;
  collected_at?: string;
  notes?: string;

  scanned_by?: string;
  scanned_at?: string;
  content?: string;
};

type InvestigationCase = {
  id: string;
  title: string;
  status: CaseStatus;
  investigator?: string;
  created_at?: string;
  updated_at?: string;
  tags?: string[];

  summary?: string;
  timeline?: string;
  findings?: string;

  victims?: DossierPerson[];
  suspects?: DossierPerson[];
  witnesses?: DossierPerson[];

  evidence?: DossierEvidence[];
  photos?: DossierPhoto[];
  reports?: DossierReport[];
};

type Data = {
  open_case?: InvestigationCase;
  cases: InvestigationCase[];
  available_statuses: CaseStatus[];
  can_edit: boolean;
};

export const Casedossier = () => {
  const { act, data } = useBackend<Data>();
  const {
    open_case,
    cases = [],
    available_statuses = ['Open', 'Submitted', 'Archived'],
    can_edit = false,
  } = data;

  const [tab, setTab] = useLocalState('case_dossier_tab', 'open');
  const [caseFilter, setCaseFilter] = useLocalState(
    'case_dossier_filter',
    'All',
  );
  const [search, setSearch] = useLocalState('case_dossier_search', '');

  const [readOnly, setReadOnly] = useLocalState(
    'case_dossier_read_only',
    false,
  );

  const permissionReadOnly = readOnly || !can_edit;
  const caseStatusReadOnly = !!open_case && open_case.status !== 'Open';
  const effectiveOpenFileReadOnly = permissionReadOnly || caseStatusReadOnly;

  return (
    <NtosWindow width={980} height={760} theme="dossier">
      <NtosWindow.Content scrollable>
        <Tabs>
          <Tabs.Tab
            selected={tab === 'open'}
            icon="folder-open"
            onClick={() => setTab('open')}
          >
            Open File
          </Tabs.Tab>
          <Tabs.Tab
            selected={tab === 'storage'}
            icon="box-archive"
            onClick={() => setTab('storage')}
          >
            Short-Term Storage
          </Tabs.Tab>
        </Tabs>

        <Box mb={1}>
          {!can_edit ? (
            <NoticeBox>
              You do not have forensic access. This dossier is locked to
              read-only mode.
            </NoticeBox>
          ) : open_case && open_case.status !== 'Open' ? (
            <NoticeBox>
              This case is {open_case.status.toLowerCase()} and is locked to
              read-only mode.
            </NoticeBox>
          ) : (
            <Button
              icon={readOnly ? 'pen-to-square' : 'eye'}
              selected={readOnly}
              onClick={() => setReadOnly(!readOnly)}
            >
              {readOnly ? 'Enable Editing' : 'Read-Only View'}
            </Button>
          )}
        </Box>

        {tab === 'open' && (
          <OpenFileTab
            caseFile={open_case}
            statuses={available_statuses}
            readOnly={effectiveOpenFileReadOnly}
            act={act}
          />
        )}

        {tab === 'storage' && (
          <ShortTermStorageTab
            cases={cases}
            caseFilter={caseFilter}
            setCaseFilter={setCaseFilter}
            search={search}
            setSearch={setSearch}
            setTab={setTab}
            readOnly={permissionReadOnly}
            act={act}
          />
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const OpenFileTab = (props: {
  caseFile?: InvestigationCase;
  statuses: CaseStatus[];
  readOnly: boolean;
  act: ActFinal;
}) => {
  const { caseFile, statuses, readOnly, act } = props;

  const [notesOpen, setNotesOpen] = useLocalState(
    'case_dossier_notes_open',
    true,
  );
  const [peopleOpen, setPeopleOpen] = useLocalState(
    'case_dossier_people_open',
    true,
  );
  const [evidenceOpen, setEvidenceOpen] = useLocalState(
    'case_dossier_evidence_open',
    true,
  );
  const [photosOpen, setPhotosOpen] = useLocalState(
    'case_dossier_photos_open',
    true,
  );
  const [reportsOpen, setReportsOpen] = useLocalState(
    'case_dossier_reports_open',
    true,
  );

  if (!caseFile) {
    return (
      <Section title="Open File">
        <NoticeBox>
          No case file is currently open. Create or open a file from Short-Term
          Storage.
        </NoticeBox>
        {!readOnly && (
          <Button icon="plus" color="good" onClick={() => act('new_case')}>
            Create New Case
          </Button>
        )}
      </Section>
    );
  }

  return (
    <Stack vertical>
      <Stack.Item>
        <CaseHeader
          caseFile={caseFile}
          statuses={statuses}
          readOnly={readOnly}
          act={act}
        />
      </Stack.Item>

      <Stack.Item>
        <Stack>
          <Stack.Item grow basis="65%">
            <CollapsibleSection
              title="Case Notes"
              count={countCompletedNotes(caseFile)}
              total={3}
              open={notesOpen}
              setOpen={setNotesOpen}
            >
              <CaseNarrativeSection
                caseFile={caseFile}
                readOnly={readOnly}
                act={act}
              />
            </CollapsibleSection>
          </Stack.Item>

          <Stack.Item basis="35%">
            <CaseOverview caseFile={caseFile} />
            <CaseChecklist caseFile={caseFile} />
          </Stack.Item>
        </Stack>
      </Stack.Item>

      <Stack.Item>
        <CollapsibleSection
          title="People"
          count={getPeopleCount(caseFile)}
          open={peopleOpen}
          setOpen={setPeopleOpen}
        >
          <PeopleDashboard caseFile={caseFile} readOnly={readOnly} act={act} />
        </CollapsibleSection>
      </Stack.Item>

      <Stack.Item>
        <CollapsibleSection
          title="Evidence"
          count={(caseFile.evidence || []).length}
          open={evidenceOpen}
          setOpen={setEvidenceOpen}
          buttons={
            !readOnly && (
              <>
                <Button icon="plus" onClick={() => act('add_manual_evidence')}>
                  Add Manual Entry
                </Button>
                <Button icon="barcode" onClick={() => act('scan_evidence')}>
                  Scan Held Evidence
                </Button>
              </>
            )
          }
        >
          <EvidenceSection
            evidence={caseFile.evidence || []}
            people={getAllPeople(caseFile)}
            readOnly={readOnly}
            act={act}
          />
        </CollapsibleSection>
      </Stack.Item>

      <Stack.Item>
        <CollapsibleSection
          title="Photos"
          count={(caseFile.photos || []).length}
          open={photosOpen}
          setOpen={setPhotosOpen}
          buttons={
            !readOnly && (
              <Button icon="camera" onClick={() => act('scan_photo')}>
                Scan Held Photo
              </Button>
            )
          }
        >
          <PhotoSection
            photos={caseFile.photos || []}
            readOnly={readOnly}
            act={act}
          />
        </CollapsibleSection>
      </Stack.Item>

      <Stack.Item>
        <CollapsibleSection
          title="Reports & Paperwork"
          count={(caseFile.reports || []).length}
          open={reportsOpen}
          setOpen={setReportsOpen}
          buttons={
            !readOnly && (
              <Button icon="file-import" onClick={() => act('scan_report')}>
                Scan Held Paper
              </Button>
            )
          }
        >
          <ReportSection
            reports={caseFile.reports || []}
            readOnly={readOnly}
            act={act}
          />
        </CollapsibleSection>
      </Stack.Item>
    </Stack>
  );
};

const CaseHeader = (props: {
  caseFile: InvestigationCase;
  statuses: CaseStatus[];
  readOnly: boolean;
  act: ActFinal;
}) => {
  const { caseFile, statuses, readOnly, act } = props;

  return (
    <Section>
      <Stack align="center">
        <Stack.Item grow>
          <Box className="CaseDossier__caseTitle">
            {caseFile.id || 'Unnumbered'} - {caseFile.title || 'Untitled Case'}
            {' - '}
            <StatusBadge status={caseFile.status} />
            {readOnly && (
              <Box inline className="CaseDossier__modeBadge">
                Read-only
              </Box>
            )}
          </Box>

          <Box color="label" mt={0.5}>
            Investigator: {caseFile.investigator || 'Unassigned'} | Created:{' '}
            {caseFile.created_at || 'Unknown'} | Updated:{' '}
            {caseFile.updated_at || 'Unknown'}
          </Box>

          <TagList tags={caseFile.tags || []} />
        </Stack.Item>

        <Stack.Item>
          <Stack>
            {!readOnly && (
              <Stack.Item>
                <Button
                  icon="save"
                  color="good"
                  onClick={() => act('save_case')}
                >
                  Save
                </Button>
                <Button
                  icon="check"
                  onClick={() =>
                    act('edit_case_field', {
                      field: 'status',
                      value: 'Submitted',
                    })
                  }
                >
                  Submit
                </Button>
              </Stack.Item>
            )}

            <Stack.Item>
              <Button icon="print" onClick={() => act('print_summary')}>
                Print Summary
              </Button>
              <Button
                icon="file-lines"
                onClick={() => act('print_evidence_log')}
              >
                Print Evidence Log
              </Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>

      {!readOnly && (
        <>
          <Box className="CaseDossier__divider" />

          <LabeledList>
            <LabeledList.Item label="Title">
              <EditableInput
                readOnly={readOnly}
                fluid
                value={caseFile.title || ''}
                placeholder="Untitled Investigation"
                empty="Untitled Investigation"
                onBlur={(value) =>
                  act('edit_case_field', {
                    field: 'title',
                    value,
                  })
                }
              />
            </LabeledList.Item>

            <LabeledList.Item label="Status">
              <EditableDropdown
                readOnly={readOnly}
                width="160px"
                selected={caseFile.status}
                options={statuses}
                onSelected={(value) =>
                  act('edit_case_field', {
                    field: 'status',
                    value,
                  })
                }
              />
            </LabeledList.Item>

            <LabeledList.Item label="Investigator">
              <EditableInput
                readOnly={readOnly}
                fluid
                value={caseFile.investigator || ''}
                placeholder="Unassigned"
                empty="Unassigned"
                onBlur={(value) =>
                  act('edit_case_field', {
                    field: 'investigator',
                    value,
                  })
                }
              />
            </LabeledList.Item>

            <LabeledList.Item label="Tags">
              <EditableInput
                readOnly={readOnly}
                fluid
                value={(caseFile.tags || []).join(', ')}
                placeholder="assault, theft, autopsy, engineering..."
                empty="No tags."
                onBlur={(value) =>
                  act('edit_case_tags', {
                    value,
                  })
                }
              />
            </LabeledList.Item>

            <LabeledList.Item label="Created">
              {caseFile.created_at || 'Unknown'}
            </LabeledList.Item>
          </LabeledList>
        </>
      )}
    </Section>
  );
};

const CaseNarrativeSection = (props: {
  caseFile: InvestigationCase;
  readOnly: boolean;
  act: ActFinal;
}) => {
  const { caseFile, readOnly, act } = props;

  return (
    <Stack vertical>
      <Stack.Item>
        <Box bold mb={0.5}>
          Summary
        </Box>
        <EditableTextArea
          readOnly={readOnly}
          fluid
          height="110px"
          value={caseFile.summary || ''}
          placeholder="Brief overview of the case."
          empty="No summary written."
          onBlur={(value) =>
            act('edit_case_field', {
              field: 'summary',
              value,
            })
          }
        />
      </Stack.Item>

      <Stack.Item>
        <Stack>
          <Stack.Item basis="50%">
            <Box bold mb={0.5}>
              Timeline
            </Box>
            <EditableTextArea
              readOnly={readOnly}
              fluid
              height="110px"
              value={caseFile.timeline || ''}
              placeholder="Timeline of known events."
              empty="No timeline written."
              onBlur={(value) =>
                act('edit_case_field', {
                  field: 'timeline',
                  value,
                })
              }
            />
          </Stack.Item>

          <Stack.Item basis="50%">
            <Box bold mb={0.5}>
              Findings
            </Box>
            <EditableTextArea
              readOnly={readOnly}
              fluid
              height="110px"
              value={caseFile.findings || ''}
              placeholder="Means, motive, forensic findings, witness statements..."
              empty="No findings written."
              onBlur={(value) =>
                act('edit_case_field', {
                  field: 'findings',
                  value,
                })
              }
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const CaseOverview = (props: { caseFile: InvestigationCase }) => {
  const { caseFile } = props;
  const evidenceCount = (caseFile.evidence || []).length;
  const photoCount = (caseFile.photos || []).length;
  const reportCount = (caseFile.reports || []).length;

  return (
    <Section title="Case Overview">
      <LabeledList>
        <LabeledList.Item label="Status">
          <StatusBadge status={caseFile.status} />
        </LabeledList.Item>
        <LabeledList.Item label="People">
          {getPeopleCount(caseFile)} total
        </LabeledList.Item>
        <LabeledList.Item label="Evidence">{evidenceCount}</LabeledList.Item>
        <LabeledList.Item label="Photos">{photoCount}</LabeledList.Item>
        <LabeledList.Item label="Reports">{reportCount}</LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const CaseChecklist = (props: { caseFile: InvestigationCase }) => {
  const { caseFile } = props;
  const checks = [
    {
      label: 'Summary written',
      done: hasText(caseFile.summary),
    },
    {
      label: 'People listed',
      done: getPeopleCount(caseFile) > 0,
    },
    {
      label: 'Evidence attached',
      done: (caseFile.evidence || []).length > 0,
    },
    {
      label: 'Photo documentation attached',
      done: (caseFile.photos || []).length > 0,
    },
    {
      label: 'Reports or paperwork attached',
      done: (caseFile.reports || []).length > 0,
    },
    {
      label: 'Findings recorded',
      done: hasText(caseFile.findings),
    },
  ];

  return (
    <Section title="Case Checklist">
      {checks.map((check) => (
        <Box key={check.label} mb={0.4}>
          <Box
            inline
            className={
              check.done
                ? 'CaseDossier__check CaseDossier__check--done'
                : 'CaseDossier__check CaseDossier__check--missing'
            }
          >
            {check.done ? '✓' : '✗'}
          </Box>{' '}
          {check.label}
        </Box>
      ))}
    </Section>
  );
};

const PeopleDashboard = (props: {
  caseFile: InvestigationCase;
  readOnly: boolean;
  act: ActFinal;
}) => {
  const { caseFile, readOnly, act } = props;

  return (
    <Stack vertical>
      <Stack.Item>
        <Stack>
          <Stack.Item>
            <CountBadge
              label="Victims"
              count={(caseFile.victims || []).length}
            />
          </Stack.Item>
          <Stack.Item>
            <CountBadge
              label="Suspects"
              count={(caseFile.suspects || []).length}
            />
          </Stack.Item>
          <Stack.Item>
            <CountBadge
              label="Witnesses"
              count={(caseFile.witnesses || []).length}
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>

      <Stack.Item>
        <PeopleSection
          title="Victims"
          listKey="victims"
          people={caseFile.victims || []}
          readOnly={readOnly}
          act={act}
        />
      </Stack.Item>

      <Stack.Item>
        <PeopleSection
          title="Suspects"
          listKey="suspects"
          people={caseFile.suspects || []}
          readOnly={readOnly}
          act={act}
        />
      </Stack.Item>

      <Stack.Item>
        <PeopleSection
          title="Witnesses"
          listKey="witnesses"
          people={caseFile.witnesses || []}
          readOnly={readOnly}
          act={act}
        />
      </Stack.Item>
    </Stack>
  );
};

const PeopleSection = (props: {
  title: string;
  listKey: string;
  people: DossierPerson[];
  readOnly: boolean;
  act: ActFinal;
}) => {
  const { title, listKey, people, readOnly, act } = props;

  return (
    <Section
      title={`${title} — ${people.length}`}
      buttons={
        !readOnly && (
          <Button
            icon="plus"
            onClick={() =>
              act('add_person', {
                list: listKey,
              })
            }
          >
            Add
          </Button>
        )
      }
    >
      {!people.length ? (
        <EmptyState>No {title.toLowerCase()} listed.</EmptyState>
      ) : (
        <Table>
          <Table.Row header>
            <Table.Cell collapsing>ID</Table.Cell>
            <Table.Cell>Name</Table.Cell>
            <Table.Cell>Role</Table.Cell>
            <Table.Cell>Notes</Table.Cell>
            {!readOnly && <Table.Cell collapsing />}
          </Table.Row>

          {people.map((person) => (
            <Table.Row key={person.id}>
              <Table.Cell collapsing>{person.id}</Table.Cell>
              <Table.Cell>
                <EditableInput
                  readOnly={readOnly}
                  fluid
                  value={person.name || ''}
                  placeholder="Name"
                  empty="Unnamed"
                  onBlur={(value) =>
                    act('edit_person', {
                      list: listKey,
                      id: person.id,
                      field: 'name',
                      value,
                    })
                  }
                />
              </Table.Cell>

              <Table.Cell>
                <EditableInput
                  readOnly={readOnly}
                  fluid
                  value={person.role || ''}
                  placeholder="Victim, suspect, witness..."
                  empty="No role"
                  onBlur={(value) =>
                    act('edit_person', {
                      list: listKey,
                      id: person.id,
                      field: 'role',
                      value,
                    })
                  }
                />
              </Table.Cell>

              <Table.Cell>
                <EditableInput
                  readOnly={readOnly}
                  fluid
                  value={person.notes || ''}
                  placeholder="Notes"
                  empty="No notes"
                  onBlur={(value) =>
                    act('edit_person', {
                      list: listKey,
                      id: person.id,
                      field: 'notes',
                      value,
                    })
                  }
                />
              </Table.Cell>

              {!readOnly && (
                <Table.Cell collapsing>
                  <Button
                    icon="trash"
                    color="bad"
                    onClick={() =>
                      act('remove_person', {
                        list: listKey,
                        id: person.id,
                      })
                    }
                  />
                </Table.Cell>
              )}
            </Table.Row>
          ))}
        </Table>
      )}
    </Section>
  );
};

const EvidenceSection = (props: {
  evidence: DossierEvidence[];
  people: DossierPerson[];
  readOnly: boolean;
  act: ActFinal;
}) => {
  const { evidence, people, readOnly, act } = props;

  return !evidence.length ? (
    <EmptyState>
      No evidence attached. Scan held evidence or add a manual entry.
    </EmptyState>
  ) : (
    <Stack vertical>
      {evidence.map((item) => (
        <Stack.Item key={item.id}>
          <EvidenceEntry
            item={item}
            people={people}
            readOnly={readOnly}
            act={act}
          />
        </Stack.Item>
      ))}
    </Stack>
  );
};

const LinkedPeopleSelector = (props: {
  item: DossierEvidence;
  people: DossierPerson[];
  readOnly: boolean;
  act: ActFinal;
}) => {
  const { item, people, readOnly, act } = props;
  const linkedPeople = item.linked_people || [];

  if (readOnly) {
    return (
      <ReadOnlyValue
        value={linkedPeople
          .map((personId) => {
            const person = people.find(
              (candidate) => candidate.id === personId,
            );

            return person
              ? `${person.name || person.id} (${person.role || 'No role'})`
              : personId;
          })
          .join(', ')}
        empty="No linked people."
      />
    );
  }

  const options = people
    .filter((person) => !linkedPeople.includes(person.id))
    .map((person) => ({
      displayText: `${person.id} - ${person.name || 'Unnamed'} (${person.role || 'No role'})`,
      value: person.id,
    }));

  const setLinkedPeople = (newLinkedPeople: string[]) => {
    act('edit_evidence', {
      id: item.id,
      field: 'linked_people',
      value: newLinkedPeople.join(', '),
    });
  };

  return (
    <Stack vertical>
      <Stack.Item>
        <Dropdown
          width="220px"
          selected={null}
          options={options}
          placeholder="Add linked person..."
          onSelected={(value) => {
            setLinkedPeople([...linkedPeople, value]);
          }}
        />
      </Stack.Item>

      {!!linkedPeople.length && (
        <Stack.Item>
          <Stack wrap>
            {linkedPeople.map((personId) => {
              const person = people.find(
                (candidate) => candidate.id === personId,
              );

              return (
                <Stack.Item key={personId}>
                  <Button
                    icon="xmark"
                    onClick={() =>
                      setLinkedPeople(
                        linkedPeople.filter(
                          (linkedId) => linkedId !== personId,
                        ),
                      )
                    }
                  >
                    {person
                      ? `${person.name || person.id} (${person.role || 'No role'})`
                      : personId}
                  </Button>
                </Stack.Item>
              );
            })}
          </Stack>
        </Stack.Item>
      )}
    </Stack>
  );
};

const EvidenceEntry = (props: {
  item: DossierEvidence;
  people: DossierPerson[];
  readOnly: boolean;
  act: ActFinal;
}) => {
  const { item, people, readOnly, act } = props;

  const [open, setOpen] = useLocalState(
    `case_dossier_evidence_${item.id}_open`,
    false,
  );

  const linkedPeople = item.linked_people || [];
  const linkedPeopleText = linkedPeople
    .map((personId) => {
      const person = people.find((candidate) => candidate.id === personId);

      return person
        ? `${person.name || person.id} (${person.role || 'No role'})`
        : personId;
    })
    .join(', ');

  return (
    <Box className="CaseDossier__evidenceCard">
      <Stack align="center">
        <Stack.Item grow>
          <Box className="CaseDossier__entryTitle">
            {item.id} - {item.label || 'Unnamed evidence'}
          </Box>

          <Box color="label" mt={0.35}>
            {item.type || 'No type'} | {item.location || 'No location'}
          </Box>

          <Box color="label" mt={0.35}>
            Locker: {item.evidence_locker || 'No locker'} | Collected by:{' '}
            {item.collected_by || 'Unknown'} | {item.collected_at || 'Unknown'}
          </Box>

          {!!linkedPeople.length && (
            <Box mt={0.5}>
              <Box inline color="label" mr={0.5}>
                Linked:
              </Box>
              {linkedPeople.map((personId) => {
                const person = people.find(
                  (candidate) => candidate.id === personId,
                );

                return (
                  <Box key={personId} className="CaseDossier__tag">
                    {person
                      ? `${person.name || person.id} (${person.role || 'No role'})`
                      : personId}
                  </Box>
                );
              })}
            </Box>
          )}
        </Stack.Item>

        <Stack.Item>
          <Button
            icon={open ? 'chevron-up' : 'chevron-down'}
            tooltip={open ? 'Collapse' : 'Expand'}
            onClick={() => setOpen(!open)}
          />
          {!readOnly && (
            <Button
              icon="trash"
              color="bad"
              onClick={() =>
                act('remove_evidence', {
                  id: item.id,
                })
              }
            />
          )}
        </Stack.Item>
      </Stack>

      {open && (
        <>
          <Box className="CaseDossier__divider" />

          {readOnly ? (
            <LabeledList>
              <LabeledList.Item label="Label">
                <ReadOnlyValue value={item.label} empty="Unnamed evidence" />
              </LabeledList.Item>

              <LabeledList.Item label="Type">
                <ReadOnlyValue value={item.type} empty="No type" />
              </LabeledList.Item>

              <LabeledList.Item label="Location">
                <ReadOnlyValue value={item.location} empty="No location" />
              </LabeledList.Item>

              <LabeledList.Item label="Evidence Locker">
                <ReadOnlyValue value={item.evidence_locker} empty="No locker" />
              </LabeledList.Item>

              <LabeledList.Item label="Collected By">
                <ReadOnlyValue
                  value={item.collected_by}
                  empty="Unknown collector"
                />
              </LabeledList.Item>

              <LabeledList.Item label="Collected At">
                <ReadOnlyValue value={item.collected_at} empty="Unknown time" />
              </LabeledList.Item>

              <LabeledList.Item label="Linked People">
                <ReadOnlyValue
                  value={linkedPeopleText}
                  empty="No linked people."
                />
              </LabeledList.Item>
            </LabeledList>
          ) : (
            <Stack vertical>
              <Stack.Item>
                <Stack>
                  <Stack.Item basis="50%">
                    <LabeledList>
                      <LabeledList.Item label="Label">
                        <EditableInput
                          readOnly={readOnly}
                          fluid
                          value={item.label || ''}
                          placeholder="Evidence label"
                          empty="Unnamed evidence"
                          onBlur={(value) =>
                            act('edit_evidence', {
                              id: item.id,
                              field: 'label',
                              value,
                            })
                          }
                        />
                      </LabeledList.Item>

                      <LabeledList.Item label="Type">
                        <EditableInput
                          readOnly={readOnly}
                          fluid
                          value={item.type || ''}
                          placeholder="Weapon, swab, fibers, print..."
                          empty="No type"
                          onBlur={(value) =>
                            act('edit_evidence', {
                              id: item.id,
                              field: 'type',
                              value,
                            })
                          }
                        />
                      </LabeledList.Item>

                      <LabeledList.Item label="Location">
                        <EditableInput
                          readOnly={readOnly}
                          fluid
                          value={item.location || ''}
                          placeholder="Collection location"
                          empty="No location"
                          onBlur={(value) =>
                            act('edit_evidence', {
                              id: item.id,
                              field: 'location',
                              value,
                            })
                          }
                        />
                      </LabeledList.Item>
                    </LabeledList>
                  </Stack.Item>

                  <Stack.Item basis="50%">
                    <LabeledList>
                      <LabeledList.Item label="Evidence Locker">
                        <EditableInput
                          readOnly={readOnly}
                          fluid
                          value={item.evidence_locker || ''}
                          placeholder="Locker, shelf, archive box..."
                          empty="No locker"
                          onBlur={(value) =>
                            act('edit_evidence', {
                              id: item.id,
                              field: 'evidence_locker',
                              value,
                            })
                          }
                        />
                      </LabeledList.Item>

                      <LabeledList.Item label="Collected By">
                        <EditableInput
                          readOnly={readOnly}
                          fluid
                          value={item.collected_by || ''}
                          placeholder="Collected by"
                          empty="Unknown collector"
                          onBlur={(value) =>
                            act('edit_evidence', {
                              id: item.id,
                              field: 'collected_by',
                              value,
                            })
                          }
                        />
                      </LabeledList.Item>

                      <LabeledList.Item label="Collected At">
                        <EditableInput
                          readOnly={readOnly}
                          fluid
                          value={item.collected_at || ''}
                          placeholder="Collected at"
                          empty="Unknown time"
                          onBlur={(value) =>
                            act('edit_evidence', {
                              id: item.id,
                              field: 'collected_at',
                              value,
                            })
                          }
                        />
                      </LabeledList.Item>
                    </LabeledList>
                  </Stack.Item>
                </Stack>
              </Stack.Item>

              <Stack.Item>
                <Box bold mb={0.5}>
                  Linked People
                </Box>
                <LinkedPeopleSelector
                  item={item}
                  people={people}
                  readOnly={readOnly}
                  act={act}
                />
              </Stack.Item>
            </Stack>
          )}
        </>
      )}
    </Box>
  );
};

const PhotoSection = (props: {
  photos: DossierPhoto[];
  readOnly: boolean;
  act: ActFinal;
}) => {
  const { photos, readOnly, act } = props;

  return !photos.length ? (
    <EmptyState>No photos attached. Scan a held photo to attach it.</EmptyState>
  ) : (
    <Stack vertical>
      {photos.map((photo, index) => (
        <Stack.Item key={photo.id}>
          <Box
            className={
              index > 0
                ? 'CaseDossier__photoEntry CaseDossier__photoEntry--divided'
                : 'CaseDossier__photoEntry'
            }
          >
            <PhotoEntry photo={photo} readOnly={readOnly} act={act} />
          </Box>
        </Stack.Item>
      ))}
    </Stack>
  );
};

const PhotoEntry = (props: {
  photo: DossierPhoto;
  readOnly: boolean;
  act: ActFinal;
}) => {
  const { photo, readOnly, act } = props;

  const [open, setOpen] = useLocalState(
    `case_dossier_photo_${photo.id}_open`,
    true,
  );

  return (
    <Box className="CaseDossier__photoCard">
      <Stack align="center">
        <Stack.Item grow>
          <Box className="CaseDossier__entryTitle">
            {photo.id} - {photo.caption || 'No caption'}
          </Box>

          <Box color="label" mt={0.35}>
            {photo.location || 'No location'} | Linked evidence:{' '}
            {(photo.linked_evidence || []).join(', ') || 'None'}
          </Box>

          <Box color="label" mt={0.35}>
            Taken by: {photo.taken_by || 'Unknown'} |{' '}
            {photo.taken_at || 'Unknown time'}
          </Box>
        </Stack.Item>

        <Stack.Item>
          <Button
            icon={open ? 'chevron-up' : 'chevron-down'}
            tooltip={open ? 'Collapse' : 'Expand'}
            onClick={() => setOpen(!open)}
          />

          {!readOnly && (
            <Button
              icon="trash"
              color="bad"
              onClick={() =>
                act('remove_photo', {
                  id: photo.id,
                })
              }
            />
          )}
        </Stack.Item>
      </Stack>

      {open && (
        <>
          <Box className="CaseDossier__divider" />

          {!readOnly && (
            <Stack vertical>
              <Stack.Item>
                <Stack>
                  <Stack.Item basis="50%">
                    <LabeledList>
                      <LabeledList.Item label="Caption">
                        <EditableInput
                          readOnly={readOnly}
                          fluid
                          value={photo.caption || ''}
                          placeholder="Photo caption"
                          empty="No caption"
                          onBlur={(value) =>
                            act('edit_photo', {
                              id: photo.id,
                              field: 'caption',
                              value,
                            })
                          }
                        />
                      </LabeledList.Item>

                      <LabeledList.Item label="Location">
                        <EditableInput
                          readOnly={readOnly}
                          fluid
                          value={photo.location || ''}
                          placeholder="Photo location"
                          empty="No location"
                          onBlur={(value) =>
                            act('edit_photo', {
                              id: photo.id,
                              field: 'location',
                              value,
                            })
                          }
                        />
                      </LabeledList.Item>

                      <LabeledList.Item label="Linked Evidence">
                        <EditableInput
                          readOnly={readOnly}
                          fluid
                          value={(photo.linked_evidence || []).join(', ')}
                          placeholder="E-1"
                          empty="No linked evidence"
                          onBlur={(value) =>
                            act('edit_photo', {
                              id: photo.id,
                              field: 'linked_evidence',
                              value,
                            })
                          }
                        />
                      </LabeledList.Item>
                    </LabeledList>
                  </Stack.Item>

                  <Stack.Item basis="50%">
                    <LabeledList>
                      <LabeledList.Item label="Taken By">
                        <EditableInput
                          readOnly={readOnly}
                          fluid
                          value={photo.taken_by || ''}
                          placeholder="Taken by"
                          empty="Unknown photographer"
                          onBlur={(value) =>
                            act('edit_photo', {
                              id: photo.id,
                              field: 'taken_by',
                              value,
                            })
                          }
                        />
                      </LabeledList.Item>

                      <LabeledList.Item label="Taken At">
                        <EditableInput
                          readOnly={readOnly}
                          fluid
                          value={photo.taken_at || ''}
                          placeholder="Taken at"
                          empty="Unknown time"
                          onBlur={(value) =>
                            act('edit_photo', {
                              id: photo.id,
                              field: 'taken_at',
                              value,
                            })
                          }
                        />
                      </LabeledList.Item>
                    </LabeledList>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          )}

          <Box mt={1}>
            <Box bold mb={0.5}>
              Description
            </Box>

            <EditableTextArea
              readOnly={readOnly}
              fluid
              height="70px"
              value={photo.notes || ''}
              placeholder="Longer description or investigator notes."
              empty="No description."
              onBlur={(value) =>
                act('edit_photo', {
                  id: photo.id,
                  field: 'notes',
                  value,
                })
              }
            />
          </Box>

          {!!photo.scribble && (
            <Box color="label" mt={1}>
              Written on the back: <i>{photo.scribble}</i>
            </Box>
          )}

          {!!photo.image && (
            <Box mt={1}>
              <img
                src={photo.image}
                className="CaseDossier__photoPreview"
                alt={photo.caption || 'Case photo preview'}
              />
            </Box>
          )}
        </>
      )}
    </Box>
  );
};

const ReportSection = (props: {
  reports: DossierReport[];
  readOnly: boolean;
  act: ActFinal;
}) => {
  const { reports, readOnly, act } = props;

  return !reports.length ? (
    <EmptyState>No reports attached. Scan held paperwork.</EmptyState>
  ) : (
    <Stack vertical>
      {reports.map((report) => (
        <Stack.Item key={report.id}>
          <ReportEntry report={report} readOnly={readOnly} act={act} />
        </Stack.Item>
      ))}
    </Stack>
  );
};

const ReportEntry = (props: {
  report: DossierReport;
  readOnly: boolean;
  act: ActFinal;
}) => {
  const { report, readOnly, act } = props;

  const [open, setOpen] = useLocalState(
    `case_dossier_report_${report.id}_open`,
    false,
  );

  const contentHtml = {
    __html: sanitizeText(report.content || ''),
  };

  return (
    <Box className="CaseDossier__reportCard">
      <Stack align="center">
        <Stack.Item grow>
          <Box className="CaseDossier__entryTitle">
            {report.id} - {report.title || 'Untitled paperwork'}
          </Box>

          <Box color="label" mt={0.35}>
            {report.type || 'Scanned paper'} | Scanned by:{' '}
            {report.scanned_by || report.collected_by || 'Unknown'} |{' '}
            {report.scanned_at || report.collected_at || 'Unknown time'}
          </Box>
        </Stack.Item>

        <Stack.Item>
          <Button
            icon={open ? 'chevron-up' : 'chevron-down'}
            tooltip={open ? 'Collapse' : 'Expand'}
            onClick={() => setOpen(!open)}
          />

          {!readOnly && (
            <Button
              icon="trash"
              color="bad"
              onClick={() =>
                act('remove_report', {
                  id: report.id,
                })
              }
            />
          )}
        </Stack.Item>
      </Stack>

      {open && (
        <>
          <Box className="CaseDossier__divider" />

          <NoticeBox>
            This is a scanned copy of paperwork. It cannot be edited from the
            case dossier.
          </NoticeBox>

          <Box className="CaseDossier__paperScan">
            {report.content ? (
              // biome-ignore lint/security/noDangerouslySetInnerHtml: Is sanitized by DOMPurify.
              <Box
                className="CaseDossier__paperContent"
                dangerouslySetInnerHTML={contentHtml}
              />
            ) : (
              <Box italic color="label">
                This scanned paper was blank.
              </Box>
            )}
          </Box>
        </>
      )}
    </Box>
  );
};

const ShortTermStorageTab = (props: {
  cases: InvestigationCase[];
  caseFilter: string;
  setCaseFilter: SetStateFinal<string>;
  search: string;
  setSearch: SetStateFinal<string>;
  setTab: SetStateFinal<string>;
  readOnly: boolean;
  act: ActFinal;
}) => {
  const {
    cases,
    caseFilter,
    setCaseFilter,
    search,
    setSearch,
    setTab,
    readOnly,
    act,
  } = props;

  const loweredSearch = search.toLowerCase();

  const visibleCases = cases.filter((caseFile) => {
    const matchesStatus =
      caseFilter === 'All' || caseFile.status === caseFilter;

    const searchable = [
      caseFile.id,
      caseFile.title,
      caseFile.investigator,
      ...(caseFile.tags || []),
    ]
      .join(' ')
      .toLowerCase();

    const matchesSearch = !loweredSearch || searchable.includes(loweredSearch);

    return matchesStatus && matchesSearch;
  });

  return (
    <Stack vertical>
      <Stack.Item>
        <Section
          title="Short-Term Storage"
          buttons={
            !readOnly && (
              <Button
                icon="plus"
                color="good"
                onClick={() => {
                  act('new_case');
                  setTab('open');
                }}
              >
                New Case
              </Button>
            )
          }
        >
          <Stack>
            <Stack.Item width="180px">
              <Dropdown
                fluid
                selected={caseFilter}
                options={['All', 'Open', 'Submitted', 'Archived']}
                onSelected={(value) => setCaseFilter(value)}
              />
            </Stack.Item>

            <Stack.Item grow>
              <Input
                fluid
                value={search}
                placeholder="Search by title, ID, investigator, or tag..."
                onChange={(value) => setSearch(value)}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>

      <Stack.Item>
        <Section title={`Stored Case Files — ${visibleCases.length}`}>
          {!visibleCases.length ? (
            <EmptyState>No matching case files.</EmptyState>
          ) : (
            <Stack vertical>
              {visibleCases.map((caseFile) => (
                <Stack.Item key={caseFile.id}>
                  <Box className="CaseDossier__storageCard">
                    <Stack align="center">
                      <Stack.Item grow>
                        <Box bold>
                          {caseFile.id || 'Unnumbered'} -{' '}
                          {caseFile.title || 'Untitled Case'}
                          {' - '}
                          <StatusBadge status={caseFile.status} />
                        </Box>
                        <Box color="label" mt={0.4}>
                          Investigator: {caseFile.investigator || 'Unassigned'}{' '}
                          | Updated: {caseFile.updated_at || 'Unknown'}
                        </Box>
                        <Box mt={0.5}>
                          <CountBadge
                            label="Evidence"
                            count={(caseFile.evidence || []).length}
                          />
                          <CountBadge
                            label="Photos"
                            count={(caseFile.photos || []).length}
                          />
                          <CountBadge
                            label="Reports"
                            count={(caseFile.reports || []).length}
                          />
                          <CountBadge
                            label="People"
                            count={getPeopleCount(caseFile)}
                          />
                        </Box>

                        <TagList tags={caseFile.tags || []} />
                      </Stack.Item>

                      <Stack.Item>
                        <Stack vertical>
                          <Stack.Item>
                            <Button
                              icon="folder-open"
                              onClick={() => {
                                act('open_case', {
                                  id: caseFile.id,
                                });
                                setTab('open');
                              }}
                            >
                              Open
                            </Button>

                            {!readOnly && (
                              <Button
                                icon="copy"
                                onClick={() =>
                                  act('duplicate_case', {
                                    id: caseFile.id,
                                  })
                                }
                              >
                                Copy
                              </Button>
                            )}
                          </Stack.Item>

                          {!readOnly && (
                            <Stack.Item>
                              {caseFile.status !== 'Open' && (
                                <Button
                                  icon="lock-open"
                                  color="good"
                                  onClick={() =>
                                    act('set_case_status', {
                                      id: caseFile.id,
                                      status: 'Open',
                                    })
                                  }
                                >
                                  Reopen
                                </Button>
                              )}

                              <Button
                                icon="box-archive"
                                disabled={caseFile.status === 'Archived'}
                                onClick={() =>
                                  act('set_case_status', {
                                    id: caseFile.id,
                                    status: 'Archived',
                                  })
                                }
                              >
                                Archive
                              </Button>

                              <Button
                                icon="trash"
                                color="bad"
                                onClick={() =>
                                  act('delete_case', {
                                    id: caseFile.id,
                                  })
                                }
                              >
                                Delete
                              </Button>
                            </Stack.Item>
                          )}
                        </Stack>
                      </Stack.Item>
                    </Stack>
                  </Box>
                </Stack.Item>
              ))}
            </Stack>
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const CollapsibleSection = (props: {
  title: string;
  count?: number;
  total?: number;
  open: boolean;
  setOpen: SetStateFinal<boolean>;
  buttons?: any;
  children: any;
}) => {
  const { title, count, total, open, setOpen, buttons, children } = props;
  const titleText =
    typeof count === 'number'
      ? total
        ? `${title} — ${count}/${total}`
        : `${title} — ${count}`
      : title;

  return (
    <Section
      title={titleText}
      buttons={
        <>
          {buttons}
          <Button
            icon={open ? 'chevron-up' : 'chevron-down'}
            tooltip={open ? 'Collapse' : 'Expand'}
            onClick={() => setOpen(!open)}
          />
        </>
      }
    >
      {open ? children : <Box color="label">Section collapsed.</Box>}
    </Section>
  );
};

const ReadOnlyValue = (props: { value?: any; empty?: string }) => {
  const { value, empty = '—' } = props;
  const text = hasText(value) ? String(value) : empty;

  return (
    <Box
      className={
        hasText(value)
          ? 'CaseDossier__readonly'
          : 'CaseDossier__readonly CaseDossier__readonly--empty'
      }
    >
      {text}
    </Box>
  );
};

const EditableInput = (props: {
  readOnly: boolean;
  value?: string;
  empty?: string;
  [key: string]: any;
}) => {
  const { readOnly, value, empty, ...rest } = props;

  if (readOnly) {
    return <ReadOnlyValue value={value} empty={empty} />;
  }

  return <Input value={value || ''} {...rest} />;
};

const EditableTextArea = (props: {
  readOnly: boolean;
  value?: string;
  empty?: string;
  [key: string]: any;
}) => {
  const { readOnly, value, empty, ...rest } = props;

  if (readOnly) {
    return <ReadOnlyValue value={value} empty={empty} />;
  }

  return <TextArea value={value || ''} {...rest} />;
};

const EditableDropdown = (props: {
  readOnly: boolean;
  selected?: any;
  options: any[];
  onSelected: (value: any) => void;
  empty?: string;
  [key: string]: any;
}) => {
  const { readOnly, selected, options, onSelected, empty, ...rest } = props;

  if (readOnly) {
    return <ReadOnlyValue value={selected} empty={empty} />;
  }

  return (
    <Dropdown
      selected={selected}
      options={options}
      onSelected={onSelected}
      {...rest}
    />
  );
};

const StatusBadge = (props: { status: CaseStatus }) => {
  const { status } = props;
  return (
    <Box
      inline
      ml={0.5}
      className={`CaseDossier__badge CaseDossier__badge--${status.toLowerCase()}`}
    >
      {status}
    </Box>
  );
};

const CountBadge = (props: { label: string; count: number }) => {
  const { label, count } = props;
  return (
    <Box
      inline
      mr={0.5}
      className="CaseDossier__badge CaseDossier__badge--count"
    >
      {label}: {count}
    </Box>
  );
};

const TagList = (props: { tags: string[] }) => {
  const { tags } = props;

  if (!tags.length) {
    return (
      <Box color="label" mt={0.5}>
        No tags.
      </Box>
    );
  }

  return (
    <Box mt={0.5}>
      <Box inline color="label" mr={0.5}>
        Tags:
      </Box>
      {tags.map((tag) => (
        <Box key={tag} className="CaseDossier__tag">
          {tag}
        </Box>
      ))}
    </Box>
  );
};

const EmptyState = (props: { children: any }) => {
  return <Box className="CaseDossier__emptyState">{props.children}</Box>;
};

const hasText = (value) => {
  return !!value && !!String(value).trim();
};

const getPeopleCount = (caseFile: InvestigationCase) => {
  return (
    (caseFile.victims || []).length +
    (caseFile.suspects || []).length +
    (caseFile.witnesses || []).length
  );
};

const countCompletedNotes = (caseFile: InvestigationCase) => {
  return [caseFile.summary, caseFile.timeline, caseFile.findings].filter(
    hasText,
  ).length;
};

const getAllPeople = (caseFile: InvestigationCase) => {
  return [
    ...(caseFile.victims || []),
    ...(caseFile.suspects || []),
    ...(caseFile.witnesses || []),
  ];
};
