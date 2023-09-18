import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, NumberInput, Section, LabeledList, Table } from '../components';
import { Window } from '../layouts';

export type UplinkData = {
  menu: Number;
  welcome: string;
  telecrystals: Number;
  bluecrystals: Number;
  categories: { name: string; ref: string }[];
  items: ItemData[];
  exploit_records: ExploitData[];
  exploit: ExploitData;
  exploit_exists: BooleanLike;
};

type ItemData = {
  name: string;
  description: string;
  can_buy: BooleanLike;
  tc_cost: number;
  bc_cost: number;
  left: number;
  ref: string;
};

type ExploitData = {
  id: number;
  nanoui_exploit_record: string;
  name: string;
  sex: string;
  age: string;
  species: string;
  rank: string;
  citizenship: string;
  employer: string;
  religion: string;
  fingerprint: string;
  has_exploitables: BooleanLike;
};

export const Uplink = (props, context) => {
  const { act, data } = useBackend<UplinkData>(context);

  return (
    <Window resizable theme="syndicate">
      <Window.Content scrollable>
        <Section title="Functions">
          {data.welcome}
          <br />
          <br />
          <LabeledList>
            {[
              ['shopping-cart', 'Request Gear', () => act('menu', { menu: 0 })],
              [
                'file-lines',
                'Exploitable Information',
                () => act('menu', { menu: 2 }),
              ],
              [
                'network-wired',
                'Extranet Contract Database',
                () => act('menu', { menu: 3 }),
              ],
              ['arrow-left', 'Return', () => act('return')],
              ['close', 'Close', () => act('lock')],
            ].map(([icon, text, action]: [string, string, any]) => (
              <LabeledList.Item>
                <Button
                  content={text}
                  icon={icon}
                  color={'transparent'}
                  onClick={action}
                />
              </LabeledList.Item>
            ))}
          </LabeledList>
          <br />
          <Table width="50%">
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
        {data.menu == 1 ? ItemSection(context, act, data) : ''}
        {data.menu == 2 ? ExploitSection(act, data) : ''}
        {data.menu == 21 ? ExploitRecordSection(act, data) : ''}
        {data.menu == 3 ? ContractsSection(act, data) : ''}
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
              color={'purple'}
              onClick={() => act('menu', { menu: 1, category: category.ref })}
            />
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

const ItemSection = function (context: any, act: any, data: UplinkData) {
  const [sortDesc, setSortDesc] = useLocalState<boolean>(
    context,
    `sortDesc`,
    true
  );

  // sort by item cost first
  data.items?.sort((a, b) => {
    const a_cost = Math.max(a.bc_cost, a.tc_cost, 0);
    const b_cost = Math.max(b.bc_cost, b.tc_cost, 0);
    if (sortDesc) {
      return b_cost - a_cost;
    } else {
      return a_cost - b_cost;
    }
  });
  // and then sort to put unavailable items at the end
  data.items?.sort((a, b) => {
    if (!a.can_buy && b.can_buy) {
      return +1;
    } else if (a.can_buy && !b.can_buy) {
      return -1;
    } else {
      return 0;
    }
  });

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
      <Box textAlign="right">
        <Button
          icon={sortDesc ? 'sort-amount-asc' : 'sort-amount-desc'}
          color={'purple'}
          onClick={() => {
            setSortDesc(!sortDesc);
          }}></Button>
      </Box>
      <Table>
        {data.items?.map((item: ItemData) => (
          <>
            <Table.Row color={item.can_buy ? null : 'gray'}>
              <Table.Cell>
                <Button
                  content={item.name}
                  color={'purple'}
                  disabled={!item.can_buy}
                  onClick={() => act('buy_item', { buy_item: item.ref })}
                />
              </Table.Cell>
              <Table.Cell>
                {item.bc_cost ? item.bc_cost + ' BC' : ''}{' '}
              </Table.Cell>
              <Table.Cell>
                {item.tc_cost ? item.tc_cost + ' TC' : ''}{' '}
              </Table.Cell>
              <Table.Cell>
                {item.left < 42 ? item.left + ' LEFT' : ''}{' '}
              </Table.Cell>
            </Table.Row>
            <Table.Row color={item.can_buy ? null : 'gray'}>
              <Table.Cell colspan={4}>
                <Box width="75%">
                  {item.description}
                  <br />
                  <br />
                </Box>
              </Table.Cell>
            </Table.Row>
          </>
        ))}
      </Table>
    </Section>
  );
};

const ExploitSection = function (act: any, data: UplinkData) {
  const exploit_sort = (a: ExploitData, b: ExploitData) => {
    return a.name.localeCompare(b.name);
  };

  return (
    <Section title="Information Record List">
      Select a Record
      <br />
      <br />
      <Box>
        {data.exploit_records
          ?.sort(exploit_sort)
          .map((exploit: ExploitData) => (
            <>
              <Button
                content={exploit.name}
                color={'purple'}
                icon={exploit.has_exploitables ? 'warning' : null}
                onClick={() => act('menu', { menu: 21, id: exploit.id })}
              />
              <br />
            </>
          ))}
      </Box>
    </Section>
  );
};

const ExploitRecordSection = function (act: any, data: UplinkData) {
  if (data.exploit_exists && data.exploit) {
    const exploit = data.exploit;
    return (
      <Section title="Information Record">
        <LabeledList>
          <LabeledList.Item label="Name">{exploit.name}</LabeledList.Item>
          <LabeledList.Item label="Sex">{exploit.sex}</LabeledList.Item>
          <LabeledList.Item label="Species">{exploit.species}</LabeledList.Item>
          <LabeledList.Item label="Age">{exploit.age}</LabeledList.Item>
          <LabeledList.Item label="Rank">{exploit.rank}</LabeledList.Item>
          <LabeledList.Item label="Citizenship">
            {exploit.citizenship}
          </LabeledList.Item>
          <LabeledList.Item label="Faction">
            {exploit.employer}
          </LabeledList.Item>
          <LabeledList.Item label="Religion">
            {exploit.religion}
          </LabeledList.Item>
          <LabeledList.Item label="Fingerprint">
            {exploit.fingerprint}
          </LabeledList.Item>
          <LabeledList.Item label="Acquired Information"></LabeledList.Item>
        </LabeledList>
        {exploit.nanoui_exploit_record
          ? exploit.nanoui_exploit_record
          : 'No additional information acquired.'}
      </Section>
    );
  } else {
    return (
      <Section title="Information Record">
        No exploitative information acquired!
      </Section>
    );
  }
};

const ContractsSection = function (act: any, data: UplinkData) {
  return (
    <Section title="Information Record List">
      Select a Record
      <LabeledList>
        {data.exploit_records?.map((exploit) => (
          <LabeledList.Item>
            <Button
              content={exploit.name}
              color={'purple'}
              onClick={() => act('menu', { menu: 21, id: exploit.id })}
            />
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};
