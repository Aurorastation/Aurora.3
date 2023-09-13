import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, NumberInput, Section, LabeledList, Table } from '../components';
import { Window } from '../layouts';

export type UplinkData = {
  welcome: String;
  telecrystals: Number;
  bluecrystals: Number;
};

export const Uplink = (props, context) => {
  const { act, data } = useBackend<UplinkData>(context);

  return (
    <Window resizable theme="syndicate">
      <Window.Content scrollable>
        <Section title={data.welcome}>
          Functions:
          <LabeledList>
            {[
              ['Request Gear', () => act('menu', { menu: 0 })],
              ['Exploitable Information', () => act('menu', { menu: 2 })],
              ['Extranet Contract Database', () => act('menu', { menu: 3 })],
              ['Return', () => act('return')],
              ['Close', () => act('lock')],
            ].map(([text, action]: [String, any]) => (
              <LabeledList.Item>
                <Button content={text} onClick={action} />
              </LabeledList.Item>
            ))}
          </LabeledList>
          <Table>
            <Table.Row>
              <Table.Cell>Telecrystals</Table.Cell>
              <Table.Cell>{data.telecrystals}</Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell>Bluecrystals</Table.Cell>
              <Table.Cell>{data.bluecrystals}</Table.Cell>
            </Table.Row>
          </Table>
        </Section>
        <Section title="Gear categories:"></Section>
        <Section title="Request Gear:">
          <span class="white">
            <i>
              Each item costs a number of telecrystals or bluecrystals as
              indicated by the numbers following their name.
            </i>
          </span>
          <br />
          <span class="white">
            <b>
              Note that when buying items, bluecrystals are prioritised over
              telecrystals.
            </b>
          </span>
        </Section>
      </Window.Content>
    </Window>
  );
};
