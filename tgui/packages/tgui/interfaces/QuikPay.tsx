import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { LabeledList, Button, Input, NumberInput, Section } from '../components';
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
};

export const QuikPay = (props, context) => {
  const { act, data } = useBackend<PayData>(context);

  return (
    <Window resizable theme="idris">
      <Window.Content scrollable>
        <Section
          title="Ordering"
          buttons={
            <Button
              content={data.editmode ? 'Unlocked' : 'Locked'}
              color={data.editmode ? 'bad' : ''}
              icon={data.editmode ? 'lock-open' : 'lock'}
              onClick={() => act('locking')}
            />
          }>
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
      <LabeledList>
        {data.items.map((item) => (
          <LabeledList.Item key={item.name} label={item.name}>
            {item.price.toFixed(2)}电 &nbsp;
            <Button
              content="Buy"
              icon="calendar"
              onClick={(e, value) =>
                act('buy', { buying: item.name, amount: 1 })
              }
            />
          </LabeledList.Item>
        ))}
      </LabeledList>
      <Section
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
        }>
        {data.buying.length < 1 ? (
          'Your shopping cart is empty.'
        ) : (
          <CartWindow />
        )}
      </Section>
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
          <LabeledList.Item key={item.name} label={item.name}>
            x{item.amount}&nbsp;
            <Button
              content="Remove"
              icon="times"
              onClick={() => act('removal', { removal: item.name })}
            />
          </LabeledList.Item>
        ))}
      </LabeledList>
      {data.sum ? 'Please swipe your ID to pay.' : ''}
    </Section>
  );
};
