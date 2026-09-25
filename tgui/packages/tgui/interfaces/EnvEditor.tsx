import { Button, Section, Table } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type EnvEditorData = {
  env_params: EnvParam[];
};

type EnvParam = {
  index: number;
  name: string;
  value: number;
  min: number;
  max: number;
  real: BooleanLike;
  default: number;
};

export const EnvEditor = (props) => {
  const { act, data } = useBackend<EnvEditorData>();

  return (
    <Window title="Environment Editor" width={460} height={620} theme="ntos">
      <Window.Content scrollable>
        <Section
          title="Environment Parameters"
          buttons={
            <Button
              icon="undo"
              content="Reset All"
              color="bad"
              onClick={() => act('reset_all')}
            />
          }
        >
          <Table>
            <Table.Row header>
              <Table.Cell>Parameter</Table.Cell>
              <Table.Cell textAlign="center">Value</Table.Cell>
              <Table.Cell textAlign="center">Range</Table.Cell>
              <Table.Cell textAlign="center">Actions</Table.Cell>
            </Table.Row>
            {data.env_params.map((param) => (
              <Table.Row key={param.index}>
                <Table.Cell>{param.name}</Table.Cell>
                <Table.Cell textAlign="center">
                  {param.real ? param.value : Math.round(param.value)}
                </Table.Cell>
                <Table.Cell textAlign="center" color="label">
                  {param.min} – {param.max}
                </Table.Cell>
                <Table.Cell textAlign="center" collapsing>
                  <Button
                    icon="edit"
                    tooltip="Set value"
                    onClick={() => act('set', { index: param.index })}
                  />
                  <Button
                    icon="undo"
                    tooltip={`Reset to default (${param.default})`}
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
