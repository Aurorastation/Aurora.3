import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Table } from '../components';
import { Window } from '../layouts';

type StackingMachineData = {
  stack_amt: number;
  contents: ContentEntry[];
};

type ContentEntry = {
  path: string;
  name: string;
  amount: number;
};

export const StackingMachine = (props, context) => {
  const { act, data } = useBackend<StackingMachineData>(context);
  return (
    <Window title="Stacking Machine" width={400} height={350} theme="ntos">
      <Window.Content>
        <Section title="Settings">
          <LabeledList>
            <LabeledList.Item label="Stack Size">
              <Button
                content={`${data.stack_amt} sheets`}
                onClick={() => act('change_stack')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Contents">
          {data.contents.length === 0 ? (
            <NoticeBox>No stacks stored.</NoticeBox>
          ) : (
            <Table>
              <Table.Row header>
                <Table.Cell>Material</Table.Cell>
                <Table.Cell textAlign="center">Amount</Table.Cell>
                <Table.Cell textAlign="center">Release</Table.Cell>
              </Table.Row>
              {data.contents.map((entry) => (
                <Table.Row key={entry.path}>
                  <Table.Cell>{entry.name}</Table.Cell>
                  <Table.Cell textAlign="center">{entry.amount}</Table.Cell>
                  <Table.Cell textAlign="center">
                    <Button
                      icon="eject"
                      onClick={() => act('release_stack', { path: entry.path })}
                    />
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
