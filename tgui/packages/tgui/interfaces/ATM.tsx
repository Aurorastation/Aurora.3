import {
  Box,
  Button,
  Divider,
  Input,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useLocalState, useSharedState } from '../backend';
import { Window } from '../layouts';

export type ATMData = {
  machine_id: string;
  screen: number;
  card: string;
  ticks_left_locked_down: number;
  authenticated_account: BooleanLike;
  security_level: number;
  suspended: BooleanLike;
  money: number;
  owner_name: string;
  number_incorrect_tries: number;
  emagged: BooleanLike;
  transactions: Transaction[];
};

type Transaction = {
  target_name: string;
  purpose: string;
  amount: number;
  date: string;
  time: string;
  source_terminal: string;
};

export const ATM = (props) => {
  const { act, data } = useBackend<ATMData>();

  return (
    <Window theme="idris">
      <Window.Content scrollable>
        <Section
          title={
            data.emagged ? 'Idris SeSeSelfERR#1#@2' : 'Idris Banking Interface'
          }
          buttons={
            data.authenticated_account && (
              <Button
                content="Logout"
                icon="times"
                color="red"
                onClick={() => act('logout')}
              />
            )
          }
        >
          {data.ticks_left_locked_down ? (
            <NoticeBox color="red">
              This machine is locked down! Please contact Idris technical
              support.
            </NoticeBox>
          ) : !data.authenticated_account ? (
            <LoginWindow />
          ) : (
            <AuthenticatedWindow />
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

export const LoginWindow = (props) => {
  const { act, data } = useBackend<ATMData>();
  const [acc, setAcc] = useSharedState<string>('acc', '');
  const [pin, setPin] = useLocalState<string>('pin', '');

  return (
    <Section>
      <Box>
        For all your monetary needs! Astronomical figures, unlimited power!
      </Box>
      <Divider />
      <LabeledList>
        <LabeledList.Item label="Account">
          <Input
            value={acc}
            placeholder="Account"
            onChange={(value) => setAcc(value)}
          />
        </LabeledList.Item>
        <LabeledList.Item label="PIN">
          <Input
            value={pin}
            placeholder="PIN"
            onChange={(value) => setPin(value)}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Card">
          <Button
            content={data.card ? data.card : '-----'}
            icon="credit-card"
            onClick={() => act('insert_card')}
          />
        </LabeledList.Item>
      </LabeledList>
      <Button
        content="Login"
        icon="check"
        onClick={() =>
          act('attempt_auth', { account_num: acc, account_pin: pin })
        }
      />
    </Section>
  );
};

export const AuthenticatedWindow = (props) => {
  const { act, data } = useBackend<ATMData>();
  const [withdraw, setWithdraw] = useLocalState<number>('withdraw', 0);
  const [security, setSecurity] = useLocalState<boolean>('security', false);
  const [transfer, setTransfer] = useLocalState<boolean>('transfer', false);
  const [target, setTarget] = useLocalState<string>('target', '');
  const [funds, setFunds] = useLocalState<number>('funds', 0);
  const [purpose, setPurpose] = useLocalState<string>(
    'purpose',
    'Funds transfer',
  );
  const [logs, setLogs] = useLocalState<boolean>('logs', false);

  return (
    <Section>
      <Box fontSize={1.2} bold>
        Welcome, dear customer {data.owner_name}!
      </Box>
      Your account balance is{' '}
      <Box as="span" bold>
        {data.money.toFixed(2)}
      </Box>
      电.
      <LabeledList>
        <LabeledList.Item label="Withdraw">
          <NumberInput
            value={withdraw}
            minValue={1}
            width={3}
            maxValue={data.money}
            animated
            unit="电"
            step={5}
            stepPixelSize={5}
            onChange={(value) => setWithdraw(value)}
          />
          &nbsp;
          <Button
            tooltip="Cash"
            icon="check"
            onClick={() => act('withdrawal', { funds_amount: withdraw })}
          />
          <Button
            tooltip="Charge Card"
            icon="credit-card"
            onClick={() => act('e_withdrawal', { funds_amount: withdraw })}
          />
        </LabeledList.Item>
      </LabeledList>
      <Divider />
      <Stack vertical>
        <Stack.Item>
          <Button
            content="Change Security Level"
            icon="exclamation"
            selected={security}
            onClick={() => setSecurity(!security)}
          />
          {security && (
            <>
              &nbsp;
              <Button
                content="Low"
                color="green"
                selected={data.security_level === 0}
                tooltip="Either the account number or card is required to access this account. EFTPOS transactions will require a card and ask for a pin, but not verify the pin is correct."
                onClick={() =>
                  act('change_security_level', { new_security_level: 0 })
                }
              />
              <Button
                content="Medium"
                color="average"
                selected={data.security_level === 1}
                tooltip="An account number and pin must be manually entered to access this account and process transactions."
                onClick={() =>
                  act('change_security_level', { new_security_level: 1 })
                }
              />
              <Button
                content="High"
                color="red"
                selected={data.security_level === 2}
                tooltip="In addition to account number and pin, a card is required to access this account and process transactions."
                onClick={() =>
                  act('change_security_level', { new_security_level: 2 })
                }
              />
            </>
          )}
        </Stack.Item>
        <Stack.Item>
          <Button
            content="Transfer Funds"
            icon="credit-card"
            selected={transfer}
            onClick={() => setTransfer(!transfer)}
          />
          {transfer && (
            <Stack.Item>
              &nbsp;
              <LabeledList>
                <LabeledList.Item label="Account">
                  <Input
                    value={target}
                    placeholder="Account number"
                    onChange={(value) => setTarget(value)}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Funds">
                  <NumberInput
                    value={funds}
                    minValue={0}
                    width={3}
                    maxValue={data.money}
                    animated
                    unit="电"
                    step={5}
                    stepPixelSize={5}
                    onChange={(value) => setFunds(value)}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Purpose">
                  <Input
                    value={purpose}
                    placeholder="Transaction"
                    onChange={(value) => setPurpose(value)}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Confirm">
                  <Button
                    icon="check"
                    color="green"
                    onClick={() =>
                      act('transfer', {
                        funds_amount: funds,
                        target_acc_number: target,
                        purpose: purpose,
                      })
                    }
                  />
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
          )}
        </Stack.Item>
        <Stack.Item>
          <Button
            content="View Transaction Logs"
            icon="newspaper"
            onClick={() => setLogs(!logs)}
            selected={logs}
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            content="Print Balance Statement"
            icon="print"
            onClick={() => act('balance_statement')}
          />
        </Stack.Item>
      </Stack>
      {logs && (
        <Section
          title="Transaction Logs"
          buttons={
            <Button
              content="Print"
              icon="print"
              onClick={() => act('print_transaction')}
            />
          }
        >
          <Table>
            <Table.Row header>
              <Table.Cell>Date</Table.Cell>
              <Table.Cell>Time</Table.Cell>
              <Table.Cell>Target</Table.Cell>
              <Table.Cell>Purpose</Table.Cell>
              <Table.Cell>Value</Table.Cell>
              <Table.Cell>Source</Table.Cell>
            </Table.Row>
            {data.transactions.map((transaction) => (
              <Table.Row key={transaction.time}>
                <Table.Cell>{transaction.date}</Table.Cell>
                <Table.Cell>{transaction.time}</Table.Cell>
                <Table.Cell>{transaction.target_name}</Table.Cell>
                <Table.Cell>{transaction.purpose}</Table.Cell>
                <Table.Cell>{transaction.amount}</Table.Cell>
                <Table.Cell>{transaction.source_terminal}</Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      )}
    </Section>
  );
};
