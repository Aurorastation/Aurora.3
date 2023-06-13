import { capitalize } from '../../common/string';
import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section, Stack, Tabs } from '../components';
import { NtosWindow } from '../layouts';

export type RecordsData = {
  activeview: string;
  editingvalue: string;
  choices: string[];

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
};

type RecordLocked = {
  id: string;
  name: string;
  rank: string;
};

export const Records = (props, context) => {
  const { act, data } = useBackend<RecordsData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section
          title="Records"
          buttons={
            <Button
              content="Login"
              icon="exclamation"
              color="green"
              onClick={() => act('login')}
            />
          }>
          {!data.authenticated ? (
            <NoticeBox color="white">
              Please log in to continue to the database.
            </NoticeBox>
          ) : (
            <RecordsView />
          )}
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const RecordsView = (props, context) => {
  const { act, data } = useBackend<RecordsData>(context);
  const [recordTab, setRecordTab] = useLocalState(context, 'recordTab', 'All');

  return (
    <Section>
      <Tabs>
        {data.available_types & 7 ? (
          <Tabs.Tab
            selected={recordTab === 'All'}
            onClick={() => setRecordTab('All')}>
            All
          </Tabs.Tab>
        ) : (
          ''
        )}
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
          data.available_types & 1 ? (
            <Tabs.Tab
              selected={recordTab === 'General'}
              onClick={() => setRecordTab('General')}>
              General
            </Tabs.Tab>
          ) : data.available_types & 4 ? (
            <Tabs.Tab
              selected={recordTab === 'Security'}
              onClick={() => setRecordTab('Security')}>
              Security
            </Tabs.Tab>
          ) : data.available_types & 2 ? (
            <Tabs.Tab
              selected={recordTab === 'Medical'}
              onClick={() => setRecordTab('Medical')}>
              Medical
            </Tabs.Tab>
          ) : (
            ''
          )
        ) : (
          ''
        )}
      </Tabs>
      {recordTab === 'All' ? <ListAllRecords /> : ''}
      {recordTab !== 'All' && data.active ? <ListActive /> : ''}
    </Section>
  );
};

export const ListAllRecords = (props, context) => {
  const { act, data } = useBackend<RecordsData>(context);
  const [recordTab, setRecordTab] = useLocalState(context, 'recordTab', 'All');

  return (
    <Section>
      <Stack vertical>
        {data.allrecords.map((record) => (
          <Stack.Item key={record.name}>
            <Button
              content={
                record.id + ': ' + record.name + ' (' + record.rank + ')'
              }
              icon={record.has_notes ? 'align-justify' : ''}
              onClick={() => act('setactive', { setactive: record.id })}
            />
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

export const ListActive = (props, context) => {
  const { act, data } = useBackend<RecordsData>(context);
  const [recordTab, setRecordTab] = useLocalState(context, 'recordTab', 'All');

  return (
    <Section>
      <Box
        as="img"
        m={0}
        src={`data:image/jpeg;base64,${data.front}`}
        width="10%"
        height="10%"
        style={{
          '-ms-interpolation-mode': 'nearest-neighbor',
        }}
      />
      <Box
        as="img"
        m={0}
        src={`data:image/jpeg;base64,${data.side}`}
        width="10%"
        height="10%"
        style={{
          '-ms-interpolation-mode': 'nearest-neighbor',
        }}
      />
      <LabeledList>
        <LabeledList.Item label="ID">#{data.active.id}</LabeledList.Item>
        <LabeledList.Item label="Name">{data.active.name}</LabeledList.Item>
        <LabeledList.Item label="Age">{data.active.age}</LabeledList.Item>
        <LabeledList.Item label="Sex">
          {capitalize(data.active.sex)}
        </LabeledList.Item>
        <LabeledList.Item label="Rank">{data.active.rank}</LabeledList.Item>
        <LabeledList.Item label="Physical Status"></LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
