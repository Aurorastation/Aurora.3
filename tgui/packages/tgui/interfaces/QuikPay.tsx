import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import {
  LabeledList,
  Button,
  Input,
  NumberInput,
  Section,
  Flex,
  Table,
} from '../components';
import { Window } from '../layouts';

export type PayData = {
  items: Item[];
  buying: ItemBuy[];
  new_item: string;
  new_price: number;
  sum: number;
  editmode: BooleanLike;
  destinationact: number;
};

type Item = {
  name: string;
  price: number;
};

type ItemBuy = {
  name: string;
  amount: number;
  price: number;
};

export const QuikPay = (props, context) => {
  const { act, data } = useBackend<PayData>(context);

  return (
    <Window resizable theme="idris">
      <Window.Content scrollable>
        <Section
          title="Ordering"
          buttons={
            <>
              {data.editmode ? (
                <Button
                  content="Select Account"
                  icon="check"
                  color={data.sum ? 'good' : ''}
                  onClick={() => act('accountselect')}
                />
              ) : null}
              <Button
                content={data.editmode ? 'Unlocked' : 'Locked'}
                color={data.editmode ? 'bad' : ''}
                icon={data.editmode ? 'lock-open' : 'lock'}
                onClick={() => act('locking')}
              />
            </>
          }
        >
          {data.editmode ? <AddItems /> : ''}
          {data.items.length < 1 ? 'No items available.' : <ItemWindow />}
        </Section>
      </Window.Content>
    </Window>
  );
};

export const ItemWindow = (props, context) => {
  const { act, data } = useBackend<PayData>(context);

  return (
    <Section>
      <Flex direction="row">
        <Flex.Item grow={1}>
          <Section title="For sale" fill>
            <Table>
              {data.items.map((item) => (
                <Table.Row key={item.name}>
                  <Table.Cell>{item.name}</Table.Cell>
                  <Table.Cell align="right">
                    {item.price.toFixed(2)}电 &nbsp;
                  </Table.Cell>
                  <Table.Cell>
                    <Button
                      content="Buy"
                      icon="calendar"
                      onClick={() =>
                        act('buy', { buying: item.name, amount: 1 })
                      }
                    />
                    {data.editmode ? (
                      <>
                        &nbsp;
                        <Button
                          content="Delete"
                          icon="trash"
                          color="bad"
                          onClick={() => act('remove', { removing: item.name })}
                        />
                      </>
                    ) : null}
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          </Section>
        </Flex.Item>
        <Flex.Item grow={1}>
          <Section
            fill
            title="Cart"
            buttons={
              <>
                {' '}
                <Button
                  content="Clear"
                  icon="trash"
                  color="bad"
                  onClick={() => act('clear')}
                />
                <Button
                  content="Confirm"
                  icon="check"
                  color={data.sum ? 'good' : ''}
                  onClick={() => act('confirm')}
                />
              </>
            }
          >
            {data.buying.length < 1 ? (
              'Your shopping cart is empty.'
            ) : (
              <CartWindow />
            )}
          </Section>
        </Flex.Item>
      </Flex>
    </Section>
  );
};

export const AddItems = (props, context) => {
  const { act, data } = useBackend<PayData>(context);
  return (
    <Section>
      <Input
        value={data.new_item}
        onChange={(e, value) => act('set_new_item', { set_new_item: value })}
      />
      <NumberInput
        value={data.new_price}
        minValue={0}
        maxValue={100}
        stepPixelSize={5}
        onDrag={(e, value) => act('set_new_price', { set_new_price: value })}
      />
      <Button content="Add" onClick={() => act('add')} />
    </Section>
  );
};

export const CartWindow = (props, context) => {
  const { act, data } = useBackend<PayData>(context);
  return (
    <Section>
      <LabeledList>
        {data.buying.map((item) => (
          <Table.Row key={item.name}>
            <Table.Cell color="label">{item.name}</Table.Cell>
            <Table.Cell color="average">x{item.amount}</Table.Cell>
            <Table.Cell align="right">
              <Flex justify="flex-end" align="center">
                <Flex.Item color="average">
                  {(item.price * item.amount).toFixed(2)}电
                </Flex.Item>
                <Flex.Item>
                  <Button
                    content="Remove"
                    icon="times"
                    onClick={() => act('removal', { removal: item.name })}
                  />
                </Flex.Item>
              </Flex>
            </Table.Cell>
          </Table.Row>
          // <LabeledList.Item key={item.name} label={item.name}>
          //   x{item.amount}

          // </LabeledList.Item>
        ))}
      </LabeledList>
      {data.sum ? (
        <>
          The total is {data.sum.toFixed(2)}电.
          <br />
          Please swipe your id to pay.
        </>
      ) : null}
    </Section>
  );
};

{
  /* <Table.Row key={item.name}>
  <Table.Cell color="label">
    {item.name}
  </Table.Cell>

  <Table.Cell align="right">
    <Flex justify="flex-end" align="center">
      <Flex.Item>
        <Text color="average">
          {item.price.toFixed(2)}电
        </Text>
      </Flex.Item>
      <Flex.Item>
        <Button
          content="Buy"
          icon="calendar"
          onClick={() =>
            act('buy', { buying: item.name, amount: 1 })
          }
        />
      </Flex.Item>
    </Flex>
  </Table.Cell>
</Table.Row> */
}
