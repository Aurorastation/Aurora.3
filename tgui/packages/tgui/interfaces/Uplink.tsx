import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, NumberInput, Section, LabeledList, Table } from '../components';
import { Window } from '../layouts';

export type UplinkData = {
  menu: Number;
  welcome: String;
  telecrystals: Number;
  bluecrystals: Number;
  categories: { name: String; ref: String }[];
  items: ItemData[];
};

type ItemData = {
  name: String;
  description: String;
  can_buy: BooleanLike;
  tc_cost: Number;
  bc_cost: Number;
  left: Number;
  ref: String;
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
        {data.menu == 0 ? ItemCategoriesSection(act, data) : ''}
        {data.menu == 1 ? ItemSection(act, data) : ''}
      </Window.Content>
    </Window>
  );
};

const ItemCategoriesSection = function (act: any, data: UplinkData) {
  return (
    <Section title="Gear categories">
      <LabeledList>
        {data.categories?.map((category) => (
          <LabeledList.Item>
            <Button
              content={category.name}
              onClick={() => act('menu', { menu: 1, category: category.ref })}
            />
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

const ItemSection = function (act: any, data: UplinkData) {
  return (
    <Section title="Request Gear">
      <span class="white">
        <i>
          Each item costs a number of telecrystals or bluecrystals as indicated
          by the numbers following their name.
        </i>
      </span>
      <br />
      <span class="white">
        <b>
          Note that when buying items, bluecrystals are prioritised over
          telecrystals.
        </b>
      </span>
      <br />
      Category:
      <LabeledList>
        {data.items?.map((item: ItemData) => (
          <LabeledList.Item>
            <>
              <Button
                content={item.name}
                // disabled={true}
                onClick={() => act('buy_item', { buy_item: item.ref })}
              />
              {item.bc_cost} BC
              {item.tc_cost} TC
            </>
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};
