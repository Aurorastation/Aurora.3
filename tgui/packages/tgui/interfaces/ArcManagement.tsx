import { useEffect } from 'react';
import {
  Box,
  Button,
  Divider,
  Input,
  NoticeBox,
  Section,
  Stack,
  Table,
  TextArea,
} from 'tgui-core/components';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

type EventArc = {
  id: number;
  name: string;
  description: string;
  started_at: string | null;
  finished_at: string | null;
  active: boolean;
};

type EventDecision = {
  id: number;
  decision: string;
  result: string;
  created_at: string;
  game_id: string;
};

type EventManagementData = {
  arcs: EventArc[];
  decisions: EventDecision[];
  selected_arc_id: number | null;
  active_arc_id: number | null;
  is_admin: boolean;
};

const MAX_ARC_NAME_LENGTH = 64;
const MAX_ARC_DESCRIPTION_LENGTH = 512;
const MAX_ARC_DECISION_LENGTH = 128;
const MAX_ARC_RESULT_LENGTH = 512;

export const ArcManagement = (props) => {
  const { act, data } = useBackend<EventManagementData>();
  const [selectedArcId, setSelectedArcId] = useLocalState<number | null>(
    'event_management_selected_arc_id',
    data.selected_arc_id ?? null,
  );
  const [arcName, setArcName] = useLocalState('event_management_arc_name', '');
  const [arcDescription, setArcDescription] = useLocalState(
    'event_management_arc_description',
    '',
  );
  const [decisionText, setDecisionText] = useLocalState(
    'event_management_decision',
    '',
  );
  const [decisionResult, setDecisionResult] = useLocalState(
    'event_management_result',
    '',
  );

  const arcs = data.arcs || [];
  const decisions = data.decisions || [];
  const activeArcId = data.active_arc_id ?? null;
  const addDisabled = !!activeArcId;
  const [showAddArc, setShowAddArc] = useLocalState('event_management_show_add_arc', false);
  const arcNameTooLong = arcName.length > MAX_ARC_NAME_LENGTH;
  const arcDescriptionTooLong = arcDescription.length > MAX_ARC_DESCRIPTION_LENGTH;
  const decisionTextTooLong = decisionText.length > MAX_ARC_DECISION_LENGTH;
  const decisionResultTooLong = decisionResult.length > MAX_ARC_RESULT_LENGTH;
  const currentArc =
    arcs.find((arc) => arc.id === (selectedArcId ?? data.selected_arc_id)) ||
    arcs[0] ||
    null;

  const selectedArc = currentArc?.id ?? null;

  useEffect(() => {
    setArcName(currentArc?.name || '');
    setArcDescription(currentArc?.description || '');
  }, [currentArc?.id]);

  const applySelection = (arcId: number | null) => {
    setSelectedArcId(arcId);
    act('select_arc', { arc_id: arcId });
  };

  const saveArc = (isNew: boolean) => {
    const name = arcName.trim();
    const description = arcDescription.trim();
    if (!name || !description) {
      return;
    }
    if (name.length > MAX_ARC_NAME_LENGTH) {
      return;
    }
    if (description.length > MAX_ARC_DESCRIPTION_LENGTH) {
      return;
    }

    if (isNew) {
      act('add_arc', { name, description });
      setArcName('');
      setArcDescription('');
      return;
    }

    if (!selectedArc) {
      return;
    }

    act('update_arc', {
      arc_id: selectedArc,
      name,
      description,
    });
  };

  const addDecision = () => {
    if (!selectedArc) {
      return;
    }
    if (
      decisionText.trim().length > MAX_ARC_DECISION_LENGTH ||
      decisionResult.trim().length > MAX_ARC_RESULT_LENGTH
    ) {
      return;
    }

    act('add_decision', {
      arc_id: selectedArc,
      decision: decisionText.trim(),
      result: decisionResult.trim(),
    });
    setDecisionText('');
    setDecisionResult('');
  };

  const startArc = (arcId: number) => {
    act('start_arc', { arc_id: arcId });
  };

  const finishArc = (arcId: number) => {
    act('finish_arc', { arc_id: arcId });
  };

  const addArcButtonTitle = addDisabled
    ? 'An arc is already active. Finish the active arc before creating a new one.'
    : 'Create a new arc';

  return (
    <Window theme="admin" width={1100} height={760}>
      <Window.Content scrollable>
        <Stack fill vertical>
          <Section title="Arc Management" buttons={
            <>
              <Button
                content="Add new arc"
                color="good"
                icon="plus"
                disabled={addDisabled}
                title={addArcButtonTitle}
                onClick={() => setShowAddArc((value) => !value)}
              />
              <Button
                content="Refresh"
                icon="sync"
                onClick={() => act('refresh')}
              />
            </>
          }>
            <Box color="label">
              Use this panel to create, update, and track upcoming arcs and their decisions.
            </Box>
          </Section>

          {showAddArc && (
            <Section title={selectedArc ? 'Edit Arc' : 'Add Arc'}>
              <Stack vertical>
                {addDisabled && (
                  <NoticeBox>
                    An arc is already active. Finish the active arc before creating a new one.
                  </NoticeBox>
                )}
                {(arcNameTooLong || arcDescriptionTooLong) && (
                  <NoticeBox>
                    Arc name must be 1-64 characters and description must be 1-512 characters.
                  </NoticeBox>
                )}
                <Input
                  fluid
                  value={arcName}
                  placeholder="Arc name"
                  onChange={(value) => setArcName(value)}
                  disabled={addDisabled && !selectedArc}
                  maxLength={MAX_ARC_NAME_LENGTH}
                />
                <TextArea
                  fluid
                  value={arcDescription}
                  placeholder="Arc description"
                  onChange={(value) => setArcDescription(value)}
                  height="6rem"
                  disabled={addDisabled && !selectedArc}
                  maxLength={MAX_ARC_DESCRIPTION_LENGTH}
                />
                <Box>
                  <Button
                    content={selectedArc ? 'Save Changes' : 'Create Arc'}
                    color="good"
                    disabled={
                      (addDisabled && !selectedArc) ||
                      !arcName.trim() ||
                      !arcDescription.trim() ||
                      arcNameTooLong ||
                      arcDescriptionTooLong
                    }
                    onClick={() => saveArc(!selectedArc)}
                  />
                </Box>
              </Stack>
            </Section>
          )}

          <Section title="Arc List">
            {!arcs.length && <NoticeBox>No arcs found. Create one to begin.</NoticeBox>}
            {arcs.length > 0 && (
              <Table>
                <Table.Row header>
                  <Table.Cell>Arc</Table.Cell>
                  <Table.Cell>Status</Table.Cell>
                  <Table.Cell>Start date</Table.Cell>
                  <Table.Cell>Finish date</Table.Cell>
                  <Table.Cell>Actions</Table.Cell>
                </Table.Row>
                {arcs.map((arc) => {
                  const isActive = activeArcId === arc.id;
                  return (
                    <Table.Row key={arc.id}>
                      <Table.Cell>{arc.name}</Table.Cell>
                      <Table.Cell>
                        {isActive ? 'Active' : arc.finished_at ? 'Finished' : 'Planned'}
                      </Table.Cell>
                      <Table.Cell>{arc.started_at || '—'}</Table.Cell>
                      <Table.Cell>{arc.finished_at || (isActive ? 'Current arc' : '—')}</Table.Cell>
                      <Table.Cell>
                        <Button
                          content="View"
                          onClick={() => applySelection(arc.id)}
                        />
                        {!isActive && (
                          <Button
                            content="Start"
                            color="good"
                            disabled={!!activeArcId && activeArcId !== arc.id}
                            onClick={() => startArc(arc.id)}
                          />
                        )}
                        {isActive && (
                          <Button
                            content="Finish"
                            color="bad"
                            onClick={() => finishArc(arc.id)}
                          />
                        )}
                      </Table.Cell>
                    </Table.Row>
                  );
                })}
              </Table>
            )}
          </Section>

          <Section title="Arc Decisions">
            {!selectedArc && <NoticeBox>Select an arc to manage its decisions.</NoticeBox>}
            {!!selectedArc && (
              <Stack vertical>
                <Table>
                  <Table.Row header>
                    <Table.Cell width="25%">Decision</Table.Cell>
                    <Table.Cell width="35%">Result</Table.Cell>
                    <Table.Cell width="15%">Game ID</Table.Cell>
                    <Table.Cell width="25%">Decision made</Table.Cell>
                  </Table.Row>
                  {decisions.length === 0 && (
                    <Table.Row>
                      <Table.Cell colspan={4}>No decisions recorded yet.</Table.Cell>
                    </Table.Row>
                  )}
                  {decisions.map((decision) => (
                    <Table.Row key={decision.id}>
                      <Table.Cell>{decision.decision}</Table.Cell>
                      <Table.Cell>{decision.result}</Table.Cell>
                      <Table.Cell>{decision.game_id}</Table.Cell>
                      <Table.Cell>{decision.created_at || '—'}</Table.Cell>
                    </Table.Row>
                  ))}
                </Table>

                <Divider />

                <Stack vertical>
                  {(decisionTextTooLong || decisionResultTooLong) && (
                    <NoticeBox>
                      Decision must be 1-128 characters and result must be 1-512 characters.
                    </NoticeBox>
                  )}
                  <Input
                    fluid
                    value={decisionText}
                    placeholder="Decision title"
                    onChange={(value) => setDecisionText(value)}
                    maxLength={MAX_ARC_DECISION_LENGTH}
                  />
                  <TextArea
                    fluid
                    value={decisionResult}
                    placeholder="Decision result"
                    onChange={(value) => setDecisionResult(value)}
                    height="4rem"
                    maxLength={MAX_ARC_RESULT_LENGTH}
                  />
                  <Button
                    content="Add Decision"
                    color="good"
                    disabled={
                      !decisionText.trim() ||
                      !decisionResult.trim() ||
                      decisionTextTooLong ||
                      decisionResultTooLong
                    }
                    onClick={addDecision}
                  />
                </Stack>
              </Stack>
            )}
          </Section>
        </Stack>
      </Window.Content>
    </Window>
  );
};
