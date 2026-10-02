import {
  Box,
  Button,
  Divider,
  Input,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
  Stack,
  Table,
  Tabs,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { capitalize } from 'tgui-core/string';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

type Warrant = {
  id: number;
  name: string;
  notes: string;
  authorization: string;
  wtype: string;
};

type FineableLaw = {
  id: string;
  name: string;
  description: string;
  minimum: number;
  maximum: number;
  selected: BooleanLike;
};

type IncidentEntry = {
  name: string;
  notes: string;
  ref: string;
};

type WarrantProjectorData = {
  presentation: BooleanLike;
  fine_presentation: BooleanLike;
  display_mode: 'warrants' | 'fines';
  authenticated: BooleanLike;
  awaiting_payment: BooleanLike;
  payment_issuer: string | null;
  facility: string;
  date: string;
  warrants: Warrant[];
  selected_warrant: Warrant | null;
  fine_recipient: string | null;
  fine: number;
  fine_min: number;
  fine_max: number;
  fine_notes: string;
  fine_charges: string[];
  fineable_laws: FineableLaw[];
  witnesses: IncidentEntry[];
  evidence: IncidentEntry[];
};

export const WarrantProjector = (props) => {
  const { data } = useBackend<WarrantProjectorData>();

  return (
    <Window
      width={data.presentation ? 700 : 850}
      height={700}
      theme="ntos"
    >
      <Window.Content scrollable>
        {data.presentation ? (
          data.fine_presentation ? (
            <FineDocument />
          ) : (
            <WarrantDocument />
          )
        ) : (
          <ProjectorControls />
        )}
      </Window.Content>
    </Window>
  );
};

const ProjectorControls = (props) => {
  const { act, data } = useBackend<WarrantProjectorData>();
  const tab = data.display_mode;

  return (
    <>
      <Tabs>
        <Tabs.Tab
          icon="file-signature"
          selected={tab === 'warrants'}
          onClick={() => act('set_display_mode', { mode: 'warrants' })}
        >
          Warrants
        </Tabs.Tab>
        <Tabs.Tab
          icon="money-check-dollar"
          selected={tab === 'fines'}
          onClick={() => act('set_display_mode', { mode: 'fines' })}
        >
          Issue Fine
        </Tabs.Tab>
      </Tabs>
      {tab === 'warrants' ? <WarrantBrowser /> : <FineEditor />}
    </>
  );
};

const WarrantBrowser = (props) => {
  const { act, data } = useBackend<WarrantProjectorData>();
  const [search, setSearch] = useLocalState('warrantSearch', '');
  const normalizedSearch = search.toLowerCase();
  const warrants = (data.warrants || []).filter(
    (warrant) =>
      warrant.name.toLowerCase().includes(normalizedSearch) ||
      warrant.notes.toLowerCase().includes(normalizedSearch) ||
      warrant.wtype.toLowerCase().includes(normalizedSearch),
  );

  return (
    <Stack>
      <Stack.Item width="40%">
        <Section
          fill
          title="Warrant Database"
          buttons={
            <Input
              value={search}
              placeholder="Search warrants..."
              onChange={setSearch}
            />
          }
        >
          {warrants.length ? (
            <Table>
              <Table.Row header>
                <Table.Cell>Type</Table.Cell>
                <Table.Cell>Subject</Table.Cell>
              </Table.Row>
              {warrants.map((warrant) => (
                <Table.Row key={warrant.id}>
                  <Table.Cell>{capitalize(warrant.wtype)}</Table.Cell>
                  <Table.Cell>
                    <Button
                      fluid
                      selected={data.selected_warrant?.id === warrant.id}
                      content={warrant.name}
                      onClick={() => act('load_warrant', { id: warrant.id })}
                    />
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          ) : (
            <NoticeBox>No matching warrants detected.</NoticeBox>
          )}
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        {data.selected_warrant ? (
          <Section
            title="Loaded Warrant"
            buttons={
              <Button
                icon="eject"
                content="Unload"
                onClick={() => act('unload_warrant')}
              />
            }
          >
            <WarrantDocument embedded />
          </Section>
        ) : (
          <NoticeBox>Select a warrant to load it into the projector.</NoticeBox>
        )}
      </Stack.Item>
    </Stack>
  );
};

const WarrantDocument = ({ embedded = false }) => {
  const { data } = useBackend<WarrantProjectorData>();
  const warrant = data.selected_warrant;

  if (!warrant) {
    return <NoticeBox color="bad">The displayed warrant is unavailable.</NoticeBox>;
  }

  const isArrest = warrant.wtype === 'arrest';
  return (
    <Box
      backgroundColor="rgba(12, 4, 4, 0.92)"
      color="#e8dddd"
      minHeight={embedded ? '480px' : '540px'}
      p={3}
      style={{
        border: '1px solid #761919',
        boxShadow: 'inset 0 0 18px rgba(0, 0, 0, 0.65)',
      }}
    >
      <Box textAlign="center" fontSize="16px" bold color="#d9bcbc">
        Stellar Corporate Conglomerate
        <br />
        Civilian Branch of Operation
      </Box>
      <Box
        textAlign="center"
        fontSize="15px"
        bold
        color="#f0d7d7"
        mt={2}
        mb={2}
      >
        DIGITAL {warrant.wtype.toUpperCase()} WARRANT
      </Box>
      <Box style={{ borderTop: '2px solid #8a1414' }} mb={1} />
      <Stack>
        <Stack.Item grow>
          <b>Facility:</b>__<u>{data.facility}</u>__
        </Stack.Item>
        <Stack.Item>
          <b>Date:</b>__<u>{data.date}</u>__
        </Stack.Item>
      </Stack>
      <Box mt={2} fontSize="10px" italic color="#bfaeae">
        {isArrest ? (
          <>
            This document serves as a notice and permits the sanctioned arrest
            of the denoted employee of the SCC Civilian Branch of Operation by
            the Security Department of the denoted vessel.
            <br />
            In accordance with Corporate Regulations, the denoted employee must
            be presented with a signed and stamped or digitally authorized
            warrant before the actions entailed can be conducted legally.
            <br />
            The suspect and departmental staff are expected to offer full
            cooperation.
            <br />
            In the event of the suspect attempting to resist or flee, resisting
            arrest charges need to be applied.
            <br />
            In the event of staff attempting to interfere with a lawful arrest,
            they are to be detained as an accomplice.
            <br />
            In the event of no warrant being displayed <b>prior</b> to the
            arrest, security personnel performing the arrest are subject to
            illegal detention charges.
          </>
        ) : (
          <>
            This document serves as notice and permits the sanctioned search of
            the suspect&apos;s person, belongings, premises, or department for
            any items and materials that could be connected to the suspected
            regulation violation described below, pending an investigation in
            progress.
            <br />
            Security officers are obligated to remove any and all such items
            from the suspect&apos;s possession or department and file them as
            evidence.
            <br />
            In accordance with Corporate Regulations, the denoted employee must
            be presented with a signed and stamped or digitally authorized
            warrant before the actions entailed can be conducted legally.
            <br />
            The suspect and departmental staff are expected to offer full
            cooperation.
            <br />
            In the event of the suspect or departmental staff attempting to
            resist, impede this search, or flee, they must be taken into custody
            immediately. All confiscated items must be filed and taken to
            Evidence.
          </>
        )}
      </Box>
      <Box mt={3}>
        <Box as="span" bold color="#d9bcbc">
          {isArrest ? "Suspect's name:" : "Suspect's/location name:"}
        </Box>
        <br />
        {warrant.name}
      </Box>
      <Box mt={2}>
        <Box as="span" bold color="#d9bcbc">
          {isArrest ? 'Reason(s):' : 'For the following reasons:'}
        </Box>
        <br />
        {warrant.notes}
      </Box>
      <Box mt={3}>
        __<u>{warrant.authorization}</u>__
        <br />
        <Box as="span" fontSize="10px">
          Person authorizing {isArrest ? 'arrest' : 'search'}
        </Box>
      </Box>
    </Box>
  );
};

const FineDocument = (props) => {
  const { data } = useBackend<WarrantProjectorData>();

  return (
    <Box
      backgroundColor="rgba(12, 4, 4, 0.92)"
      color="#e8dddd"
      minHeight="540px"
      p={3}
      style={{
        border: '1px solid #761919',
        boxShadow: 'inset 0 0 18px rgba(0, 0, 0, 0.65)',
      }}
    >
      <Box textAlign="center" fontSize="16px" bold color="#d9bcbc">
        Stellar Corporate Conglomerate
        <br />
        Civilian Branch of Operation
      </Box>
      <Box
        textAlign="center"
        fontSize="15px"
        bold
        color="#f0d7d7"
        mt={2}
        mb={2}
      >
        DIGITAL FINE NOTICE
      </Box>
      <Box style={{ borderTop: '2px solid #8a1414' }} mb={1} />
      <Stack>
        <Stack.Item grow>
          <b>Facility:</b>__<u>{data.facility}</u>__
        </Stack.Item>
        <Stack.Item>
          <b>Date:</b>__<u>{data.date}</u>__
        </Stack.Item>
      </Stack>
      <Box mt={2} fontSize="10px" italic color="#bfaeae">
        This document serves as notice that the person named below has been
        assessed a monetary fine under Corporate Regulations. Payment will only
        be collected when the registered identification card scanned for the
        named recipient is tapped against the warrant projector.
      </Box>
      <Box mt={3}>
        <b>Recipient&apos;s name:</b>
        <br />
        {data.fine_recipient}
      </Box>
      <Box mt={2}>
        <b>Charge(s):</b>
        {(data.fine_charges || []).map((charge, index) => (
          <Box
            key={charge}
            mt={index ? 0 : 1}
            py={0.5}
            style={{ borderTop: '1px solid rgba(190, 70, 70, 0.45)' }}
          >
            {charge}
          </Box>
        ))}
        <Box style={{ borderTop: '1px solid rgba(190, 70, 70, 0.45)' }} />
      </Box>
      <Box mt={2}>
        <b>Fine:</b>
        <br />
        {data.fine} credits
      </Box>
      <Box mt={2}>
        <b>Incident summary:</b>
        <br />
        {data.fine_notes || 'No incident summary entered.'}
      </Box>
      <Box mt={3}>
        __<u>{data.payment_issuer}</u>__
        <br />
        <Box as="span" fontSize="10px">
          Person issuing fine
        </Box>
      </Box>
      <Box mt={3} textAlign="center" bold>
        TAP THE SCANNED RECIPIENT ID AGAINST THE PROJECTOR TO AUTHORIZE PAYMENT
      </Box>
    </Box>
  );
};

const FineEditor = (props) => {
  const { act, data } = useBackend<WarrantProjectorData>();
  const selectedLaws = (data.fineable_laws || []).filter((law) => law.selected);
  const validFine =
    selectedLaws.length > 0 &&
    data.fine >= data.fine_min &&
    data.fine <= data.fine_max;

  return (
    <>
      {!!data.awaiting_payment && (
        <NoticeBox color="average">
          Awaiting payment authorization. The ID scanned for{' '}
          {data.fine_recipient} must be tapped against the projector. The fine
          is locked until this request is cancelled or paid.
        </NoticeBox>
      )}
      {!data.authenticated && (
        <NoticeBox>
          Fine preparation is available. An ID with security access is required
          to issue or cancel a fine.
        </NoticeBox>
      )}
      <Section
        title="Recipient"
        buttons={
          data.fine_recipient ? (
            <Button
              icon="xmark"
              content="Clear"
              disabled={!!data.awaiting_payment}
              onClick={() => act('clear_recipient')}
            />
          ) : null
        }
      >
        {data.fine_recipient ? (
          <Box bold>{data.fine_recipient}</Box>
        ) : (
          <NoticeBox>
            Use the projector on a person wearing a registered ID to scan them.
          </NoticeBox>
        )}
      </Section>

      <Section title="Fineable Regulations">
        <Table>
          <Table.Row header>
            <Table.Cell>Charge</Table.Cell>
            <Table.Cell>Description</Table.Cell>
            <Table.Cell collapsing>Fine Range</Table.Cell>
          </Table.Row>
          {(data.fineable_laws || []).map((law) => (
            <Table.Row key={law.id}>
              <Table.Cell
                py={1}
                style={{ borderBottom: '1px solid rgba(190, 70, 70, 0.45)' }}
              >
                <Button
                  fluid
                  selected={!!law.selected}
                  disabled={!!data.awaiting_payment}
                  content={law.name}
                  onClick={() => act('toggle_charge', { id: law.id })}
                />
              </Table.Cell>
              <Table.Cell
                py={1}
                style={{ borderBottom: '1px solid rgba(190, 70, 70, 0.45)' }}
              >
                {law.description}
              </Table.Cell>
              <Table.Cell
                collapsing
                py={1}
                style={{ borderBottom: '1px solid rgba(190, 70, 70, 0.45)' }}
              >
                {law.minimum}-{law.maximum} credits
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Section>

      <IncidentDetails />

      <Section title="Disposition">
        <LabeledList>
          <LabeledList.Item label="Permitted range">
            {selectedLaws.length
              ? `${data.fine_min}-${data.fine_max} credits`
              : 'Select at least one charge'}
          </LabeledList.Item>
          <LabeledList.Item label="Fine">
            <NumberInput
              value={data.fine}
              minValue={data.fine_min}
              maxValue={Math.max(data.fine_max, data.fine_min)}
              step={1}
              unit=" credits"
              disabled={!selectedLaws.length || !!data.awaiting_payment}
              onChange={(fine) => act('set_fine', { fine })}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Incident summary">
            {data.fine_notes || 'No summary entered.'}{' '}
            <Button
              icon="pen"
              content="Edit"
              disabled={!!data.awaiting_payment}
              onClick={() => act('edit_notes')}
            />
          </LabeledList.Item>
        </LabeledList>
      </Section>

      {data.awaiting_payment ? (
        <Button
          fluid
          color="bad"
          icon="times"
          content="Cancel Payment Request"
          disabled={!data.authenticated}
          tooltip={
            data.authenticated
              ? undefined
              : 'An ID with security access is required to cancel payment.'
          }
          onClick={() => act('cancel_payment')}
        />
      ) : (
        <Button
          fluid
          color="good"
          icon="money-check-dollar"
          content="Request ID Payment"
          disabled={!data.authenticated || !data.fine_recipient || !validFine}
          tooltip={
            data.authenticated
              ? undefined
              : 'An ID with security access is required to request payment.'
          }
          onClick={() => act('issue_fine')}
        />
      )}
    </>
  );
};

const IncidentDetails = (props) => {
  const { act, data } = useBackend<WarrantProjectorData>();

  return (
    <Stack>
      <Stack.Item grow basis={0}>
        <Section
          title="Witnesses"
          buttons={
            <Button
              icon="plus"
              content="Add from ID"
              disabled={!data.fine_recipient || !!data.awaiting_payment}
              tooltip="Hold the witness's registered ID in your other hand."
              onClick={() => act('add_witness')}
            />
          }
        >
          {data.witnesses?.length ? (
            data.witnesses.map((witness, index) => (
              <Box key={witness.ref}>
                {!!index && <Divider />}
                <Stack align="center">
                  <Stack.Item grow bold>
                    {witness.name}
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="sticky-note"
                      disabled={!!data.awaiting_payment}
                      tooltip="Edit witness notes"
                      onClick={() =>
                        act('edit_witness_notes', { ref: witness.ref })
                      }
                    />
                    <Button
                      icon="trash"
                      color="bad"
                      disabled={!!data.awaiting_payment}
                      tooltip="Remove witness"
                      onClick={() =>
                        act('remove_witness', { ref: witness.ref })
                      }
                    />
                  </Stack.Item>
                </Stack>
                <Box color="label" italic>
                  {witness.notes || 'No witness notes entered.'}
                </Box>
              </Box>
            ))
          ) : (
            <Box color="label">No witnesses entered.</Box>
          )}
        </Section>
      </Stack.Item>

      <Stack.Item grow basis={0}>
        <Section
          title="Evidence"
          buttons={
            <Button
              icon="plus"
              content="Add Held Item"
              disabled={!data.fine_recipient || !!data.awaiting_payment}
              tooltip="Hold the evidence item in your other hand."
              onClick={() => act('add_evidence')}
            />
          }
        >
          {data.evidence?.length ? (
            data.evidence.map((evidence, index) => (
              <Box key={evidence.ref}>
                {!!index && <Divider />}
                <Stack align="center">
                  <Stack.Item grow bold>
                    {evidence.name}
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="sticky-note"
                      disabled={!!data.awaiting_payment}
                      tooltip="Edit evidence notes"
                      onClick={() =>
                        act('edit_evidence_notes', { ref: evidence.ref })
                      }
                    />
                    <Button
                      icon="trash"
                      color="bad"
                      disabled={!!data.awaiting_payment}
                      tooltip="Remove evidence"
                      onClick={() =>
                        act('remove_evidence', { ref: evidence.ref })
                      }
                    />
                  </Stack.Item>
                </Stack>
                <Box color="label" italic>
                  {evidence.notes || 'No evidence notes entered.'}
                </Box>
              </Box>
            ))
          ) : (
            <Box color="label">No evidence entered.</Box>
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
