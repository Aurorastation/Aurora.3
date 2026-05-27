import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
  Table,
} from '../components';
import { Window } from '../layouts';

// Screen constants (must match DM defines)
const RCS_MAINMENU = 0;
const RCS_RQASSIST = 1;
const RCS_RQSUPPLY = 2;
const RCS_SENDINFO = 3;
const RCS_SENTPASS = 4;
const RCS_SENTFAIL = 5;
const RCS_VIEWMSGS = 6;
const RCS_MESSAUTH = 7;
const RCS_ANNOUNCE = 8;
const RCS_FORMS = 9;

type RequestsConsoleData = {
  department: string;
  screen: number;
  message_log: LogEntry[];
  newmessagepriority: number;
  silent: BooleanLike;
  announcementConsole: BooleanLike;
  assist_dept: string[];
  supply_dept: string[];
  info_dept: string[];
  message: string;
  recipient: string;
  priority: number;
  msgStamped: string;
  msgVerified: string;
  announceAuth: BooleanLike;
  lid: BooleanLike;
  paper: number;
  pda_list: PdaEntry[];
  forms?: FormEntry[];
  sql_error?: BooleanLike;
};

type PdaEntry = {
  name: string;
  pda: string;
};

type FormEntry = {
  id: string;
  name: string;
  department: string;
};

type LogEntry = {
  type: 'sent' | 'received' | 'error';
  category?: 'assist' | 'supply' | 'info' | 'reply';
  priority?: 'normal' | 'high';
  sender?: string;
  recipient?: string;
  body: string;
  stamp?: string;
  id_auth?: string;
};

const CATEGORY_LABEL: Record<NonNullable<LogEntry['category']>, string> = {
  assist: 'Assistance Request',
  supply: 'Supply Request',
  info: 'Information',
  reply: 'Reply',
};

export const RequestsConsole = (props, context) => {
  const { act, data } = useBackend<RequestsConsoleData>(context);
  const { screen, department } = data;

  return (
    <Window
      title={`${department} Requests Console`}
      width={520}
      height={440}
      theme="ntos"
    >
      <Window.Content scrollable>
        {screen === RCS_MAINMENU && <MainMenu act={act} data={data} />}
        {screen === RCS_RQASSIST && (
          <ComposeScreen act={act} data={data} type="assist" />
        )}
        {screen === RCS_RQSUPPLY && (
          <ComposeScreen act={act} data={data} type="supply" />
        )}
        {screen === RCS_SENDINFO && (
          <ComposeScreen act={act} data={data} type="info" />
        )}
        {screen === RCS_SENTPASS && <SentScreen act={act} success />}
        {screen === RCS_SENTFAIL && <SentScreen act={act} success={false} />}
        {screen === RCS_VIEWMSGS && <ViewMessages act={act} data={data} />}
        {screen === RCS_MESSAUTH && <MessAuth act={act} data={data} />}
        {screen === RCS_ANNOUNCE && <AnnounceScreen act={act} data={data} />}
        {screen === RCS_FORMS && <FormsScreen act={act} data={data} />}
      </Window.Content>
    </Window>
  );
};

// ---- Main Menu ----

const MainMenu = ({ act, data }: { act: any; data: RequestsConsoleData }) => (
  <Section title="Main Menu">
    <LabeledList>
      <LabeledList.Item label="Status">
        <Box
          color={
            data.newmessagepriority === 2
              ? 'bad'
              : data.newmessagepriority === 1
                ? 'average'
                : 'good'
          }
        >
          {data.newmessagepriority === 0
            ? 'No new messages'
            : data.newmessagepriority === 1
              ? 'New messages!'
              : 'Urgent messages!'}
        </Box>
      </LabeledList.Item>
    </LabeledList>
    <Box mt={1}>
      {!!data.assist_dept.length && (
        <Button
          fluid
          mb={0.5}
          icon="ambulance"
          content="Request Assistance"
          onClick={() => act('set_screen', { screen: RCS_RQASSIST })}
        />
      )}
      {!!data.supply_dept.length && (
        <Button
          fluid
          mb={0.5}
          icon="box"
          content="Request Supplies"
          onClick={() => act('set_screen', { screen: RCS_RQSUPPLY })}
        />
      )}
      {!!data.info_dept.length && (
        <Button
          fluid
          mb={0.5}
          icon="info-circle"
          content="Relay Information"
          onClick={() => act('set_screen', { screen: RCS_SENDINFO })}
        />
      )}
      <Button
        fluid
        mb={0.5}
        icon="envelope-open-text"
        content={`View Messages${data.newmessagepriority ? ' (!)' : ''}`}
        onClick={() => act('set_screen', { screen: RCS_VIEWMSGS })}
      />
      {!!data.announcementConsole && (
        <Button
          fluid
          mb={0.5}
          icon="bullhorn"
          content="Send Announcement"
          onClick={() => act('set_screen', { screen: RCS_ANNOUNCE })}
        />
      )}
      <Button
        fluid
        mb={0.5}
        icon="file-alt"
        content="Forms Database"
        onClick={() => act('set_screen', { screen: RCS_FORMS })}
      />
    </Box>
    <Box mt={1}>
      <Button
        icon={data.silent ? 'volume-mute' : 'volume-up'}
        content={data.silent ? 'Muted' : 'Sound On'}
        selected={!data.silent}
        onClick={() => act('toggle_silent')}
      />
      <Button
        ml={1}
        icon={data.lid ? 'box-open' : 'box'}
        content={`Paper Bin: ${data.lid ? 'Open' : 'Closed'} (${data.paper} sheets)`}
        onClick={() => act('toggle_lid')}
      />
    </Box>
    <Box mt={1} fontSize="0.85em" color="label">
      Link a PDA (hold in active hand):{' '}
      <Button icon="link" content="Link PDA" onClick={() => act('link_pda')} />
    </Box>
    {data.pda_list.length > 0 && (
      <Box mt={0.5}>
        {data.pda_list.map((pda) => (
          <Box key={pda.pda} fontSize="0.85em">
            {pda.name}{' '}
            <Button
              icon="unlink"
              color="bad"
              onClick={() => act('unlink_pda', { pda: pda.pda })}
            />
          </Box>
        ))}
      </Box>
    )}
  </Section>
);

// ---- Compose Screen (Assist / Supply / Info) ----

const ComposeScreen = ({
  act,
  data,
  type,
}: {
  act: any;
  data: RequestsConsoleData;
  type: 'assist' | 'supply' | 'info';
}) => {
  const depts =
    type === 'assist'
      ? data.assist_dept
      : type === 'supply'
        ? data.supply_dept
        : data.info_dept;

  const backScreen = RCS_MAINMENU;

  return (
    <Section
      title={
        type === 'assist'
          ? 'Request Assistance'
          : type === 'supply'
            ? 'Request Supplies'
            : 'Relay Information'
      }
      buttons={
        <Button
          icon="arrow-left"
          content="Back"
          onClick={() => act('set_screen', { screen: backScreen })}
        />
      }
    >
      <Box mb={1}>Select a department and priority to compose a message:</Box>
      {depts.map((dept) => (
        <Box key={dept} mb={0.5}>
          <Box bold mb={0.25}>
            {dept}
          </Box>
          <Button
            content="Normal"
            onClick={() => act('compose', { recipient: dept, priority: 1 })}
          />
          <Button
            ml={0.5}
            content="Urgent"
            color="average"
            onClick={() => act('compose', { recipient: dept, priority: 2 })}
          />
        </Box>
      ))}
    </Section>
  );
};

// ---- Message Auth Screen ----

const MessAuth = ({ act, data }: { act: any; data: RequestsConsoleData }) => (
  <Section
    title="Message Authentication"
    buttons={
      <Button
        icon="arrow-left"
        content="Back"
        onClick={() => act('set_screen', { screen: RCS_MAINMENU })}
      />
    }
  >
    <LabeledList>
      <LabeledList.Item label="Recipient">{data.recipient}</LabeledList.Item>
      <LabeledList.Item label="Message">{data.message}</LabeledList.Item>
      {!!data.msgStamped && (
        <LabeledList.Item label="Stamp">
          <Box color="good" bold>
            Stamped with the {data.msgStamped}
          </Box>
        </LabeledList.Item>
      )}
      {!!data.msgVerified && (
        <LabeledList.Item label="Verified">
          <Box color="good" bold>
            Verified by {data.msgVerified}
          </Box>
        </LabeledList.Item>
      )}
    </LabeledList>
    <Box mt={1} color="label" fontSize="0.85em">
      Swipe an ID card or stamp to authenticate, then send.
    </Box>
    <Box mt={1}>
      <Button
        icon="paper-plane"
        content="Send Message"
        color="good"
        onClick={() => act('send_message')}
      />
    </Box>
  </Section>
);

// ---- Sent Screens ----

const SentScreen = ({ act, success }: { act: any; success: boolean }) => (
  <Section title={success ? 'Message Sent' : 'Send Failed'}>
    {success ? (
      <NoticeBox color="good">
        Your message has been sent successfully.
      </NoticeBox>
    ) : (
      <NoticeBox danger>
        Failed to send message. No message server detected.
      </NoticeBox>
    )}
    <Button
      mt={1}
      icon="home"
      content="Main Menu"
      onClick={() => act('set_screen', { screen: RCS_MAINMENU })}
    />
  </Section>
);

// ---- View Messages ----

const LogEntryView = ({ entry, act }: { entry: LogEntry; act: any }) => {
  if (entry.type === 'error') {
    return (
      <NoticeBox danger mb={0.5}>
        {entry.body}
      </NoticeBox>
    );
  }
  if (entry.type === 'sent') {
    const sentLabel = entry.category
      ? CATEGORY_LABEL[entry.category]
      : 'Message';
    return (
      <Box mb={0.5} p={0.5} style={{ borderLeft: '2px solid #555' }}>
        <Box bold>
          {sentLabel} sent to {entry.recipient}
        </Box>
        <Box mt={0.25}>{entry.body}</Box>
      </Box>
    );
  }
  const isHigh = entry.priority === 'high';
  const recvLabel = entry.category ? CATEGORY_LABEL[entry.category] : 'Message';
  return (
    <Box
      mb={0.5}
      p={0.5}
      style={{
        borderLeft: `2px solid ${isHigh ? '#c44' : '#555'}`,
      }}
    >
      <Box bold color={isHigh ? 'bad' : undefined}>
        {isHigh ? 'High Priority ' : ''}
        {recvLabel} from {entry.sender}
        <Button
          ml={1}
          icon="reply"
          content="Reply"
          onClick={() =>
            act('compose', { recipient: entry.sender, priority: 1 })
          }
        />
      </Box>
      <Box mt={0.25}>{entry.body}</Box>
      {!!entry.id_auth && (
        <Box mt={0.25} color="good">
          Verified by {entry.id_auth}
        </Box>
      )}
      {!!entry.stamp && (
        <Box mt={0.25} color="good">
          Stamped with the {entry.stamp}
        </Box>
      )}
    </Box>
  );
};

const ViewMessages = ({
  act,
  data,
}: {
  act: any;
  data: RequestsConsoleData;
}) => (
  <Section
    title="Message Log"
    buttons={
      <Button
        icon="arrow-left"
        content="Back"
        onClick={() => act('set_screen', { screen: RCS_MAINMENU })}
      />
    }
  >
    {data.message_log.length === 0 ? (
      <NoticeBox>No messages on record.</NoticeBox>
    ) : (
      data.message_log.map((entry, i) => (
        <LogEntryView key={i} entry={entry} act={act} />
      ))
    )}
  </Section>
);

// ---- Announcement Screen ----

const AnnounceScreen = ({
  act,
  data,
}: {
  act: any;
  data: RequestsConsoleData;
}) => (
  <Section
    title="Department Announcement"
    buttons={
      <Button
        icon="arrow-left"
        content="Back"
        onClick={() => act('set_screen', { screen: RCS_MAINMENU })}
      />
    }
  >
    {!data.announceAuth ? (
      <>
        <NoticeBox>Swipe an authorized ID card to authenticate.</NoticeBox>
        <Box mt={1}>
          <Button
            icon="edit"
            content="Write Message"
            onClick={() => act('write_announcement')}
          />
        </Box>
        {!!data.message && (
          <Box mt={1} color="label">
            Draft: {data.message}
          </Box>
        )}
      </>
    ) : (
      <>
        <LabeledList>
          <LabeledList.Item label="Message">
            {data.message || '(none)'}
          </LabeledList.Item>
          <LabeledList.Item label="Authenticated">
            <Box color="good">Yes</Box>
          </LabeledList.Item>
        </LabeledList>
        <Box mt={1}>
          {!data.message && (
            <Button
              icon="edit"
              content="Write Message"
              onClick={() => act('write_announcement')}
            />
          )}
          <Button
            ml={data.message ? 0 : 0.5}
            icon="bullhorn"
            content="Send Announcement"
            color="good"
            disabled={!data.message}
            onClick={() => act('send_announcement')}
          />
        </Box>
      </>
    )}
  </Section>
);

// ---- Forms Screen ----

const FormsScreen = ({
  act,
  data,
}: {
  act: any;
  data: RequestsConsoleData;
}) => (
  <Section
    title="Forms Database"
    buttons={
      <Button
        icon="arrow-left"
        content="Back"
        onClick={() => act('set_screen', { screen: RCS_MAINMENU })}
      />
    }
  >
    {data.sql_error ? (
      <NoticeBox danger>
        Database connection failed or no forms found.
      </NoticeBox>
    ) : !data.forms ? (
      <NoticeBox>Loading...</NoticeBox>
    ) : (
      <>
        <Box mb={1}>
          <Button
            icon="sync"
            content="Show All"
            onClick={() => act('reset_sql')}
          />
        </Box>
        <Table>
          <Table.Row header>
            <Table.Cell>ID</Table.Cell>
            <Table.Cell>Name</Table.Cell>
            <Table.Cell>Department</Table.Cell>
            <Table.Cell />
          </Table.Row>
          {data.forms.map((form) => (
            <Table.Row key={form.id}>
              <Table.Cell>SCCF-{form.id}</Table.Cell>
              <Table.Cell>{form.name}</Table.Cell>
              <Table.Cell>
                <Button
                  content={form.department}
                  onClick={() =>
                    act('sort_forms', { department: form.department })
                  }
                />
              </Table.Cell>
              <Table.Cell collapsing>
                <Button
                  icon="info-circle"
                  tooltip="What is this?"
                  onClick={() => act('whatis', { id: form.id })}
                />
                <Button
                  icon="print"
                  tooltip={`Print (${data.paper} sheets left)`}
                  disabled={data.paper <= 0}
                  onClick={() => act('print_form', { id: form.id })}
                />
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </>
    )}
  </Section>
);
