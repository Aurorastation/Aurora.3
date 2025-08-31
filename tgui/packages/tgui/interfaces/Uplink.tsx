import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Input, Section, LabeledList, Table } from '../components';
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

  contracts_found: Number;
  contracts_view: Number;
  contracts: ContractData[];
  contracts_pages: Number[];
  contract: ContractData;
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
  tgui_exploit_record: string;
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

type ContractData = {
  id: number;
  contractee: String;
  title: String;
  status: BooleanLike;
  description: String;
  reward_other: String;
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
              <LabeledList.Item key={text}>
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
        {data.menu === 0 ? ItemCategoriesSection(context, act, data) : ''}
        {data.menu === 1 ? ItemSection(context, act, data) : ''}
        {data.menu === 2 ? ExploitSection(act, data) : ''}
        {data.menu === 21 ? ExploitRecordSection(act, data) : ''}
        {data.menu === 3 ? ContractsSection(act, data) : ''}
        {data.menu === 31 ? ContractDetailsSection(act, data) : ''}
      </Window.Content>
    </Window>
  );
};

const ItemCategoriesSection = function (
  context: any,
  act: any,
  data: UplinkData
) {
  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    `searchTerm`,
    ``
  );

  return (
    <Section
      title={'Gear ' + (!searchTerm ? 'categories' : 'search')}
      buttons={ItemSearch(context)}>
      {!searchTerm
        ? CategoriesList(act, data)
        : ItemSection(context, act, data)}
    </Section>
  );
};

const ItemSearch = function (context: any) {
  const [searchTerm, setSearchTerm] = useLocalState<string>(
    context,
    `searchTerm`,
    ``
  );
  return (
    <Input
      value={searchTerm}
      placeholder="Search"
      onInput={(e, value) => {
        setSearchTerm(value);
      }}
    />
  );
};

const CategoriesList = function (act: any, data: UplinkData) {
  return (
    <LabeledList>
      {data.categories?.map((category) => (
        <LabeledList.Item key={category.name}>
          <Button
            content={category.name}
            color={'purple'}
            onClick={() => act('menu', { menu: 1, category: category.ref })}
          />
        </LabeledList.Item>
      ))}
    </LabeledList>
  );
};

const ItemSection = function (context: any, act: any, data: UplinkData) {
  const [sortDesc, setSortDesc] = useLocalState<boolean>(
    context,
    `sortDesc`,
    true
  );

  const [searchTerm] = useLocalState<string>(context, `searchTerm`, ``);

  if (searchTerm) {
    if (data.menu === 0 && searchTerm.length <= 2) {
      return (
        <span class="white">
          <i>Three characters required for all search.</i>
        </span>
      );
    }
    data.items = data.items?.filter(
      (i) =>
        i.name.toLowerCase().indexOf(searchTerm.toLowerCase()) > -1 ||
        i.description.toLowerCase().indexOf(searchTerm.toLowerCase()) > -1
    );
  }
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
    <Section
      title="Request Gear"
      buttons={data.menu === 1 ? ItemSearch(context) : ''}>
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
          }}
        />
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
          <LabeledList.Item label="Acquired Information" />
        </LabeledList>
        <span
          style={{
            'white-space': 'pre-line',
          }}>
          {exploit.tgui_exploit_record
            ? exploit.tgui_exploit_record
            : 'No additional information acquired.'}
        </span>
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
    <Section title="Available Contracts">
      {!data.contracts_found ? (
        <Box>No Contracts Available.</Box>
      ) : (
        <Box>
          <Table>
            <Table.Row>
              <Table.Cell>ID</Table.Cell>
              <Table.Cell>Contractor</Table.Cell>
              <Table.Cell>Title</Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell colspan={999} textAlign="center">
                <Box
                  backgroundColor={data.contracts_view === 1 ? 'good' : 'bad'}>
                  {data.contracts_view === 1
                    ? 'Available Contracts'
                    : 'Closed Contracts'}
                </Box>
              </Table.Cell>
            </Table.Row>
            {data.contracts.map((contract: ContractData) => (
              <Table.Row key={contract.id}>
                <Table.Cell>{contract.id}</Table.Cell>
                <Table.Cell>{contract.contractee}</Table.Cell>
                <Table.Cell>{contract.title}</Table.Cell>
                <Table.Cell>
                  <Button
                    content="View"
                    color={'purple'}
                    onClick={() => act('menu', { menu: 31, id: contract.id })}
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
          <Box>
            {data.contracts_pages.map((page_n: Number) => (
              <Button
                key={page_n}
                content={page_n}
                color={'purple'}
                onClick={() => act('contract_page', { contract_page: page_n })}
              />
            ))}
          </Box>
        </Box>
      )}
      <Box>
        {data.contracts_view === 1 ? (
          <Button
            content="View Expired Contracts"
            color={'purple'}
            onClick={() => act('contract_view', { contract_view: 2 })}
          />
        ) : (
          <Button
            content="View Open Contracts"
            color={'purple'}
            onClick={() => act('contract_view', { contract_view: 1 })}
          />
        )}
      </Box>
    </Section>
  );
};

const ContractDetailsSection = function (act: any, data: UplinkData) {
  return (
    <Section title="Viewing Contract">
      {data.contracts_found === 1 ? (
        <LabeledList>
          <LabeledList.Item label="ID">{data.contract.id}</LabeledList.Item>
          <LabeledList.Item label="Contractee">
            {data.contract.contractee}
          </LabeledList.Item>
          <LabeledList.Item label="Status">
            <Box
              backgroundColor={data.contract.status === true ? 'good' : 'bad'}>
              {data.contract.status === true ? 'Open' : 'Closed'}
            </Box>
          </LabeledList.Item>
          <LabeledList.Item label="Title">
            {data.contract.title}
          </LabeledList.Item>
          <LabeledList.Item label="Description">
            {data.contract.description}
          </LabeledList.Item>
          <LabeledList.Item label="Reward">
            {data.contract.reward_other}
          </LabeledList.Item>
        </LabeledList>
      ) : (
        <Box>{'Failed to retrieve contract information!'}</Box>
      )}
      <br />
      {data.contracts_found === 1 ? (
        <Button
          content="View Reports And Updates"
          color={'purple'}
          onClick={() =>
            act('contract_interact', { contract_interact: data.contract.id })
          }
        />
      ) : (
        ''
      )}
    </Section>
  );
};
