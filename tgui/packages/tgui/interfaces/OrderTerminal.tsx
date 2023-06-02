import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { LabeledList, Button, Input, NumberInput, Section } from '../components';
import { Window } from '../layouts';

export type TerminalData = {
  items: Item[];
  buying: Item[];
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

export const OrderTerminal = (props, context) => {
  const { act, data } = useBackend<TerminalData>(context);

  return (
    <Window resizable>
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
          {data.items.length < 1 ? 'No items available.' : <ItemWindow />}
          {data.editmode ? <AddItems /> : ''}
        </Section>
      </Window.Content>
    </Window>
  );
};

export const ItemWindow = (props, context) => {
  const { act, data } = useBackend<TerminalData>(context);

  return (
    <Section>
      <LabeledList>
        {data.items.map((item) => (
          <LabeledList.Item key={item.name} label={item.name}>
            {item.price}cr &nbsp;
            <Button
              as="span"
              content="Buy"
              onClick={(e, value) =>
                act('buy', { buying: item.name, amount: 1 })
              }
            />
          </LabeledList.Item>
        ))}
      </LabeledList>
      <Section title="Cart">
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
  const { act, data } = useBackend<TerminalData>(context);
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
  const { act, data } = useBackend<TerminalData>(context);
  return (
    <Section>
      <LabeledList>
        {data.buying.map((item) => (
          <LabeledList.Item key={item.name} label={item.name}>
            {item.price}
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};
