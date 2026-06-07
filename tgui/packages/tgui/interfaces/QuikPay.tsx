import {
  Box,
  Button,
  Flex,
  Input,
  LabeledList,
  NumberInput,
  Section,
  Table,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

export type PayData = {
  items: Item[];
  buying: ItemBuy[];
  new_item: string;
  new_price: number;
  new_category: string;
  sum: number;
  editmode: BooleanLike;
  destinationact: number;
};

type Item = {
  name: string;
  price: number;
  category: string;
};

type ItemBuy = {
  name: string;
  amount: number;
  price: number;
};

export const QuikPay = (props) => {
  const { act, data } = useBackend<PayData>();

  return (
    <Window theme="idris">
      <Window.Content scrollable>
        <Section
          title="Ordering"
          buttons={
            <>
              {data.editmode ? (
                <>
                  <Button
                    content="Select Account"
                    icon="check"
                    color={data.sum ? 'good' : ''}
                    onClick={() => act('accountselect')}
                  />
                  <Button
                    content="Print DSV price list"
                    icon="print"
                    disabled={data.items.length < 1}
                    onClick={() => act('print_dsv')}
                  />
                </>
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

export const ItemWindow = (props) => {
  const { act, data } = useBackend<PayData>();
  const [searchTerm, setSearchTerm] = useLocalState<string>(`searchTerm`, ``);
  const normalizedSearchTerm = searchTerm.toLowerCase();

  const groupedItems = data.items.reduce((groups, item) => {
    const category = item.category || 'Uncategorized';
    if (!groups[category]) {
      groups[category] = [];
    }
    groups[category].push(item);
    return groups;
  }, {});

  const sortedCategories = Object.keys(groupedItems).sort();
  const filteredCategories = sortedCategories
    .map((category) => {
      const categoryMatches =
        category.toLowerCase().indexOf(normalizedSearchTerm) > -1;
      const items = categoryMatches
        ? groupedItems[category]
        : groupedItems[category].filter(
            (item) =>
              item.name?.toLowerCase().indexOf(normalizedSearchTerm) > -1,
          );

      return { category, items };
    })
    .filter((group) => group.items.length > 0);

  return (
    <Section
      title="Items"
      buttons={
        <Input
          autoFocus
          autoSelect
          placeholder="Search categories or items"
          maxLength={512}
          onChange={(value) => {
            setSearchTerm(value);
          }}
          value={searchTerm}
        />
      }
    >
      <Flex direction="row">
        <Flex.Item grow={1}>
          {filteredCategories.length < 1 ? (
            <Section>No items found.</Section>
          ) : (
            filteredCategories.map(({ category, items }) => (
              <Section key={category} title={category}>
                <Table>
                  {items.map((item) => (
                    <Table.Row key={`${category}-${item.name}`}>
                      <Table.Cell>{item.name}</Table.Cell>
                      <Table.Cell align="right">
                        {item.price.toFixed(2)}电 &nbsp;
                      </Table.Cell>
                      <Table.Cell>
                        {!data.editmode ? (
                          <Button
                            content="Buy"
                            icon="calendar"
                            onClick={() =>
                              act('buy', {
                                buying: item.name,
                                amount: 1,
                                price: item.price,
                              })
                            }
                          />
                        ) : (
                          <>
                            &nbsp;
                            <Button
                              content="Delete"
                              icon="trash"
                              color="bad"
                              onClick={() =>
                                act('remove', { removing: item.name })
                              }
                            />
                          </>
                        )}
                      </Table.Cell>
                    </Table.Row>
                  ))}
                </Table>
              </Section>
            ))
          )}
        </Flex.Item>

        <Box width="1px" backgroundColor="rgba(255, 255, 255, 0.15)" mx={2} />

        <Flex.Item grow={1}>
          <Section
            fill
            title="Cart"
            buttons={
              <>
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

export const AddItems = (props) => {
  const { act, data } = useBackend<PayData>();
  return (
    <Section title="Add Item">
      <Input
        placeholder="Item name"
        value={data.new_item}
        onChange={(value) => act('set_new_item', { set_new_item: value })}
      />
      <Input
        placeholder="Category"
        value={data.new_category}
        onChange={(value) =>
          act('set_new_category', { set_new_category: value })
        }
      />
      <NumberInput
        value={data.new_price}
        minValue={0}
        maxValue={100}
        stepPixelSize={5}
        onChange={(value) => act('set_new_price', { set_new_price: value })}
      />
      <Button content="Add" onClick={() => act('add')} />
    </Section>
  );
};

export const CartWindow = (props) => {
  const { act, data } = useBackend<PayData>();
  return (
    <Section>
      <LabeledList>
        {data.buying.map((item) => (
          <Table.Row key={item.name}>
            <Table.Cell>&nbsp;{item.name}</Table.Cell>
            <Table.Cell>x{item.amount}</Table.Cell>
            <Table.Cell align="right">
              <Flex justify="flex-end">
                <Flex.Item>{(item.price * item.amount).toFixed(2)}电</Flex.Item>
                <Flex.Item>
                  &nbsp;
                  <Button
                    icon="trash"
                    onClick={() => act('removal', { removal: item.name })}
                  />
                  &nbsp;
                </Flex.Item>
              </Flex>
            </Table.Cell>
          </Table.Row>
        ))}
      </LabeledList>
      {data.sum ? (
        <Section color="average">
          The total is {data.sum.toFixed(2)}电.
          <br />
          Please swipe your id to pay.
        </Section>
      ) : null}
    </Section>
  );
};
