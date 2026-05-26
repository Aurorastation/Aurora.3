import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, Section, Table } from '../components';
import { Window } from '../layouts';

type EchoEditorData = {
  echo_params: EchoParam[];
};

type EchoParam = {
  index: number;
  name: string;
  value: number;
  real: BooleanLike;
};

export const EchoEditor = (props, context) => {
  const { act, data } = useBackend<EchoEditorData>(context);

  return (
    <Window title="Echo Editor" width={380} height={560} theme="ntos">
      <Window.Content scrollable>
        <Section
          title="Echo Parameters"
          buttons={
            <Button
              icon="undo"
              content="Reset All"
              color="bad"
              onClick={() => act('reset_all', { index: 1 })}
            />
          }
        >
          <Table>
            <Table.Row header>
              <Table.Cell>Parameter</Table.Cell>
              <Table.Cell textAlign="center">Value</Table.Cell>
              <Table.Cell textAlign="center">Actions</Table.Cell>
            </Table.Row>
            {data.echo_params.map((param) => (
              <Table.Row key={param.index}>
                <Table.Cell>{param.name}</Table.Cell>
                <Table.Cell textAlign="center">
                  {param.real ? param.value.toFixed(2) : param.value}
                </Table.Cell>
                <Table.Cell textAlign="center">
                  <Button
                    icon="edit"
                    tooltip="Set value"
                    onClick={() => act('set', { index: param.index })}
                  />
                  <Button
                    icon="undo"
                    tooltip="Reset to default"
                    onClick={() => act('reset', { index: param.index })}
                  />
                  <Button
                    icon="info-circle"
                    tooltip="Show description"
                    onClick={() => act('desc', { index: param.index })}
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
