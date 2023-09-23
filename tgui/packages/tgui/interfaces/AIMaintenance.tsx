import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, ProgressBar, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export type AIData = {
  error: BooleanLike;
  ai_name: string;
  ai_integrity: number;
  ai_capacitor: number;
  ai_isdamaged: BooleanLike;
  ai_isdead: BooleanLike;
  ai_laws: Law[];
};

type Law = {
  index: number;
  text: string;
};

export const AIMaintenance = (props, context) => {
  const { act, data } = useBackend<AIData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        {data.error ? (
          <NoticeBox>No AI card inserted.</NoticeBox>
        ) : (
          <MaintenanceWindow />
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const MaintenanceWindow = (props, context) => {
  const { act, data } = useBackend<AIData>(context);

  return (
    <>
      <Section title="Maintenance">
        <LabeledList>
          <LabeledList.Item label="AI">{data.ai_name}</LabeledList.Item>
          <LabeledList.Item label="Status">
            {data.ai_isdead ? 'Nonfunctional' : 'Functional'}
          </LabeledList.Item>
          <LabeledList.Item label="System Integrity">
            <ProgressBar
              ranges={{
                good: [75, 100],
                average: [30, 75],
                bad: [0, 30],
              }}
              value={data.ai_integrity}
              maxValue={100}
              minValue={0}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Backup Capacitor">
            <ProgressBar
              ranges={{
                good: [75, 100],
                average: [30, 75],
                bad: [0, 30],
              }}
              value={data.ai_capacitor}
              maxValue={100}
              minValue={0}
            />
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section
        title="Laws"
        buttons={
          <>
            <Button
              content="Purge"
              color="red"
              icon="trash"
              onClick={() => act('PRG_purgeAiLaws')}
            />
            <Button
              content="Add"
              icon="plus"
              onClick={() => act('PRG_addCustomSuppliedLaw')}
            />
            <Button
              content="Reset"
              icon="circle"
              tooltip="This clears all non-core laws, such as ion laws or supplied laws."
              onClick={() => act('PRG_resetLaws')}
            />
            <Button
              content="Default"
              color="good"
              icon="arrow-alt-circle-left"
              tooltip="This resets the AI laws to a copy of NT Default."
              onClick={() => act('PRG_uploadNTDefault')}
            />
          </>
        }>
        {data.ai_laws && data.ai_laws.length ? (
          <Table>
            <Table.Row header>
              <Table.Cell>Index</Table.Cell>
              <Table.Cell>Law</Table.Cell>
            </Table.Row>
            {data.ai_laws.map((law) => (
              <Table.Row key={law.index}>
                <Table.Cell>{law.index}</Table.Cell>
                <Table.Cell>{law.text}</Table.Cell>
              </Table.Row>
            ))}
          </Table>
        ) : (
          <NoticeBox color="red">No laws detected!</NoticeBox>
        )}
      </Section>
    </>
  );
};
