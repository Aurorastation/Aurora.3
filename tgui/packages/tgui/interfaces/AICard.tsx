import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { LabeledList, Section, Table, Button } from '../components';
import { Window } from '../layouts';

export type AIData = {
  has_ai: BooleanLike;
  name: string;
  hardware_integrity: number;
  backup_capacitor: number;
  radio: BooleanLike;
  wireless: BooleanLike;
  operational: BooleanLike;
  flushing: BooleanLike;
  laws: Law[];
  has_laws: BooleanLike;
};

type Law = {
  index: number;
  law: string;
};

export const AICard = (props, context) => {
  const { act, data } = useBackend<AIData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="AI Status">
          {data.has_ai ? <AIWindow /> : <b>No AI detected.</b>}
        </Section>
      </Window.Content>
    </Window>
  );
};

export const AIWindow = (props, context) => {
  const { act, data } = useBackend<AIData>(context);

  return (
    <>
      <Section>
        <LabeledList>
          <LabeledList.Item label="Hardware Integrity">
            {data.hardware_integrity}%
          </LabeledList.Item>
          <LabeledList.Item label="Backup Capacitor">
            {data.backup_capacitor}%
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Laws">
        {data.has_laws ? <LawWindow /> : <b>No laws detected.</b>}
      </Section>
      <CommandWindow />
    </>
  );
};

export const LawWindow = (props, context) => {
  const { act, data } = useBackend<AIData>(context);
  const { laws } = data;

  return (
    <Table>
      <Table.Row header>
        <Table.Cell>Index</Table.Cell>
        <Table.Cell>Law</Table.Cell>
      </Table.Row>
      {laws.map((law) => (
        <Table.Row key={law.law}>
          <Table.Cell>{law.index}</Table.Cell>
          <Table.Cell>{law.law}</Table.Cell>
        </Table.Row>
      ))}
    </Table>
  );
};

export const CommandWindow = (props, context) => {
  const { act, data } = useBackend<AIData>(context);
  const { laws } = data;

  return (
    <Section title="Commands">
      <LabeledList>
        <LabeledList.Item label="Radio Subspace Transmission">
          <Button
            content={data.radio ? 'Enabled' : 'Disabled'}
            icon="info"
            color={data.radio ? 'good' : 'danger'}
            onClick={() => act('radio', { radio: data.radio ? 1 : 0 })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Wireless Interface">
          <Button
            content={data.wireless ? 'Enabled' : 'Disabled'}
            icon="wifi"
            color={data.wireless ? 'good' : 'danger'}
            onClick={() => act('wireless', { wireless: data.wireless ? 1 : 0 })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Wipe AI">
          <Button
            content={data.flushing ? 'WIPING...' : 'Wipe'}
            icon="exclamation"
            color={data.flushing ? 'danger' : 'orange'}
            disabled={data.flushing}
            onClick={() => act('wipe')}
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
