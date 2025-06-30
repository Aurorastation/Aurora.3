import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Input, LabeledList, NumberInput, Section, Table, Tabs } from '../components';
import { NtosWindow } from '../layouts';

export type DatabaseData = {
  has_printer: BooleanLike;
  id_card: string;
  access_level: number;
  machine_id: string;
  station_account_number: string; // isn't that funny
  station_account_money: number;
  accounts: Account[];
};

type Account = {
  account_number: string;
  owner: string;
  suspended: BooleanLike;
  money: number;
  transactions: Transaction[];
};

type Transaction = {
  ref: string;
  date: string;
  time: string;
  target_name: string;
  purpose: string;
  amount: number;
  source_terminal: string;
};

export const AccountDatabase = (props, context) => {
  const { act, data } = useBackend<DatabaseData>(context);
  const [active, setActive] = useLocalState(context, 'active', '');

  return (
    <NtosWindow resizable width={900}>
      <NtosWindow.Content scrollable>
        <Section title="Information">
          <LabeledList>
            <LabeledList.Item label="Machine">
              {data.machine_id}
            </LabeledList.Item>
            <LabeledList.Item label="Identification">
              {data.id_card ? data.id_card : 'Not Inserted'}
            </LabeledList.Item>
            {data.access_level ? (
              <LabeledList.Item label="Assigned Conglomerate Funds">
                {data.station_account_money.toFixed(2)}电
              </LabeledList.Item>
            ) : (
              ''
            )}
          </LabeledList>
        </Section>
        {data.id_card ? <AccountWindow /> : ''}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const AccountWindow = (props, context) => {
  const { act, data } = useBackend<DatabaseData>(context);
  const [active, setActive] = useLocalState(context, 'active', 'none');
  const [tab, setTab] = useLocalState(context, 'tab', 'All Accounts');
  const [make_new_acc, setMakeNewAcc] = useLocalState(
    context,
    'make_new_acc',
    0
  );
  const [new_name, setNewName] = useLocalState(context, 'new_name', '');
  const [new_funds, setNewFunds] = useLocalState(context, 'new_funds', 0);

  return (
    <Section
      title="Idris Account Database"
      buttons={
        <Button
          content="Print All Data"
          icon="print"
          onClick={() => act('print')}
        />
      }>
      {active ? (
        <Tabs>
          <Tabs.Tab onClick={() => setTab('All Accounts')}>
            All Accounts
          </Tabs.Tab>
          {active !== 'none' ? (
            <Tabs.Tab onClick={() => setTab(active)}>View #{active}</Tabs.Tab>
          ) : (
            ''
          )}
        </Tabs>
      ) : (
        ''
      )}
      {tab === 'All Accounts' ? (
        <>
          <Table>
            <Table.Row header>
              <Table.Cell>Number</Table.Cell>
              <Table.Cell>Name</Table.Cell>
            </Table.Row>
            {data.accounts.map((account) => (
              <Table.Row key={account.account_number}>
                <Table.Cell>
                  <Button
                    content={'#' + account.account_number}
                    onClick={() => setActive(account.account_number)}
                  />
                </Table.Cell>
                <Table.Cell>{account.owner}</Table.Cell>
              </Table.Row>
            ))}
          </Table>
          <Section
            title="New Account Creation"
            buttons={
              <Button content="Begin" onClick={() => setMakeNewAcc(1)} />
            }>
            {make_new_acc ? (
              <>
                <Input
                  placeholder="Insert name"
                  value={new_name}
                  onInput={(e, value) => setNewName(value)}
                />
                <NumberInput
                  value={new_funds}
                  unit="电"
                  minValue={0}
                  maxValue={data.station_account_money}
                  step={50}
                  stepPixelSize={10}
                  onDrag={(e, value) => setNewFunds(value)}
                />
                <Button
                  content="Create"
                  color="good"
                  icon="plus"
                  onClick={() =>
                    act('create_account', { name: new_name, funds: new_funds })
                  }
                />
              </>
            ) : (
              ''
            )}
          </Section>
        </>
      ) : (
        <SpecificAccountData />
      )}
    </Section>
  );
};

export const SpecificAccountData = (props, context) => {
  const { act, data } = useBackend<DatabaseData>(context);
  const [active, setActive] = useLocalState(context, 'active', 'none');
  const [tab, setTab] = useLocalState(context, 'tab', 'All Accounts');
  const [adding_funds, setAdding] = useLocalState(context, 'adding_funds', 0);
  const [removing_funds, setRemoving] = useLocalState(
    context,
    'removing_funds',
    0
  );
  const [funds_to_add, setFundsToAdd] = useLocalState(
    context,
    'funds_to_add',
    0
  );
  const [funds_to_remove, setFundsToRemove] = useLocalState(
    context,
    'funds_to_remove',
    0
  );

  return (
    <Section>
      {data.accounts.map((account) =>
        account.account_number === active ? (
          <Section
            title="Account Details"
            buttons={
              <>
                <Button
                  content={account.suspended ? 'Unsuspend' : 'Suspend'}
                  icon="exclamation-circle"
                  color="red"
                  onClick={() =>
                    act('suspend', { account: account.account_number })
                  }
                />
                <Button
                  content="Revoke Payroll"
                  disabled={
                    account.account_number === data.station_account_number
                  }
                  icon="minus"
                  color="average"
                  onClick={() =>
                    act('revoke_payroll', { account: account.account_number })
                  }
                />
                <Button
                  content="Print"
                  icon="print"
                  onClick={() =>
                    act('print', { print: account.account_number })
                  }
                />
              </>
            }>
            <LabeledList>
              <LabeledList.Item label="Number">
                {account.account_number}
              </LabeledList.Item>
              <LabeledList.Item label="Holder">
                {account.owner}
              </LabeledList.Item>
              <LabeledList.Item label="Balance">
                {account.money.toFixed(2)}电
              </LabeledList.Item>
              <LabeledList.Item label="Status">
                <Box as="span" color={account.suspended ? 'red' : 'good'}>
                  {account.suspended ? 'Suspended' : 'Active'}
                </Box>
              </LabeledList.Item>
              {data.access_level === 2 ? (
                <LabeledList.Item label="Fund Adjustment">
                  {!adding_funds ? (
                    <Button
                      content="Add"
                      color="good"
                      icon="plus"
                      onClick={() => setAdding(1)}
                    />
                  ) : (
                    <>
                      <NumberInput
                        value={funds_to_add}
                        unit="电"
                        minValue={0}
                        maxValue={10000}
                        onDrag={(e, value) => setFundsToAdd(value)}
                      />
                      <Button
                        content="Add"
                        color="good"
                        icon="plus"
                        onClick={() =>
                          act('add_funds', {
                            account: account.account_number,
                            amount: funds_to_add,
                          })
                        }
                      />
                    </>
                  )}
                  &nbsp;
                  {!adding_funds ? (
                    <Button
                      content="Remove"
                      color="bad"
                      icon="minus"
                      onClick={() => setRemoving(1)}
                    />
                  ) : (
                    <>
                      <NumberInput
                        value={funds_to_remove}
                        unit="电"
                        minValue={0}
                        maxValue={10000}
                        onDrag={(e, value) => setFundsToRemove(value)}
                      />
                      <Button
                        content="Remove"
                        color="bad"
                        icon="minus"
                        onClick={() =>
                          act('remove_funds', {
                            account: account.account_number,
                            amount: funds_to_add,
                          })
                        }
                      />
                    </>
                  )}
                </LabeledList.Item>
              ) : (
                ''
              )}
            </LabeledList>
            <Section title="Transactions">
              <Table>
                <Table.Row header>
                  <Table.Cell>Timestamp</Table.Cell>
                  <Table.Cell>Target</Table.Cell>
                  <Table.Cell>Reason</Table.Cell>
                  <Table.Cell>Value</Table.Cell>
                  <Table.Cell>Terminal</Table.Cell>
                </Table.Row>
                {account.transactions.map((transaction) => (
                  <Table.Row key={transaction.ref}>
                    <Table.Cell>
                      {transaction.date + ', ' + transaction.time}
                    </Table.Cell>
                    <Table.Cell>{transaction.target_name}</Table.Cell>
                    <Table.Cell>{transaction.purpose}</Table.Cell>
                    <Table.Cell>{transaction.amount.toFixed(2)}电</Table.Cell>
                    <Table.Cell>{transaction.source_terminal}</Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </Section>
          </Section>
        ) : (
          ''
        )
      )}
    </Section>
  );
};
