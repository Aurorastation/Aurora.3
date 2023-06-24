import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Icon, LabeledList, Section, Table, Tabs } from '../components';
import { NtosWindow } from '../layouts';
import { sanitizeText } from '../sanitize';

export type CargoData = {
  username: string;
  order_items: Item[];
  order_value: number;
  order_item_count: number;
  cargo_categories: Category[];
  selected_category: string;
  category_items: Item[];

  tracking_id: number;
  tracking_code: number;
  tracking_status: string;
  tracked_order: Order;
  tracked_order_report: string;

  page: string;
  status_message: string;
  handling_fee: number;
  crate_fee: number;
};

type Item = {
  name: string;
  description: string;
  amount: number;
  price: number;
  price_adjusted: number;
  id: number;
  supplier: string;
  supplier_data: Supplier;
};

type Supplier = {
  short_name: string;
  name: string;
  description: string;
  tag_line: string;
  shuttle_time: number;
  shuttle_price: number;
  available: BooleanLike;
  price_modifier: number;
};

type Category = {
  name: string;
  display_name: string;
  description: string;
  icon: string;
  price_modifier: number;
};

type Order = {
  order_id: number;
  tracking_code: number;
  price: number;
  price_customer: number;
  price_cargo: number;
  status: string;
  status_pretty: string;
  status_payment: string;
  ordered_by: string;
  authorized_by: string;
  received_by: string;
  paid_by: string;
  needs_payment: BooleanLike;
  time_submitted: string;
  time_approved: string;
  time_shipped: string;
  time_delivered: string;
  time_paid: string;
  items: Item[];
  shipment_cost: number;
  reason: string;
};

export const CargoOrder = (props, context) => {
  const { act, data } = useBackend<CargoData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Tabs fitted>
          <Tabs.Tab
            onClick={() => act('page', { page: 'main' })}
            selected={data.page === 'main'}>
            Main
          </Tabs.Tab>
          <Tabs.Tab
            onClick={() => act('page', { page: 'tracking' })}
            selected={data.page === 'tracking'}>
            Tracking
          </Tabs.Tab>
        </Tabs>
        {data.page === 'main' ? <MainPage /> : <TrackingPage />}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const MainPage = (props, context) => {
  const { act, data } = useBackend<CargoData>(context);
  const [details, setDetails] = useLocalState<boolean>(
    context,
    'details',
    false
  );

  return (
    <Section>
      <Section title={'Welcome, ' + data.username}>
        <Box fontSize={1.3} bold>
          Order
        </Box>
        <LabeledList>
          <LabeledList.Item label="Items">
            {data.order_item_count}
          </LabeledList.Item>
          <LabeledList.Item label="Price">
            {data.order_value} 电
          </LabeledList.Item>
          {data.status_message && (
            <LabeledList.Item label="Status">
              {data.status_message}
            </LabeledList.Item>
          )}
        </LabeledList>
        <Box py={1}>
          <Button
            content="Details"
            icon="shopping-cart"
            onClick={() => setDetails(!details)}
          />
          <Button
            content="Clear"
            color="red"
            icon="stop"
            onClick={() => act('clear_order')}
          />
          <Button
            content="Submit Order"
            icon="check"
            onClick={() => act('submit_order')}
          />
        </Box>
        {details && <ShowDetails />}
      </Section>
      <Section title="Catalog">
        <Tabs>
          {data.cargo_categories.map((category) => (
            <Tabs.Tab
              key={category.name}
              selected={data.selected_category === category.name}
              onClick={() =>
                act('select_category', { select_category: category.name })
              }>
              <Icon name={category.icon} /> {category.display_name}
            </Tabs.Tab>
          ))}
        </Tabs>
        {data.category_items.map((item) => (
          <Section
            title={item.name}
            key={item.name}
            buttons={
              <Button
                content={item.price_adjusted + '电'}
                disabled={
                  !item.supplier_data.available && item.price_adjusted <= 0
                }
                icon="shopping-basket"
                onClick={
                  () => act('add_item', { add_item: item.id.toString() }) // don't ask why this is the way it is
                }
              />
            }>
            {item.description}
            <LabeledList>
              <LabeledList.Item label="Shipped By">
                {item.supplier_data.name}
              </LabeledList.Item>
            </LabeledList>
          </Section>
        ))}
      </Section>
    </Section>
  );
};

export const ShowDetails = (props, context) => {
  const { act, data } = useBackend<CargoData>(context);

  return (
    <Section title="Details">
      <Table>
        <Table.Row header>
          <Table.Cell>Name</Table.Cell>
          <Table.Cell>Supplier</Table.Cell>
          <Table.Cell>Price</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Handling Fee</Table.Cell>
          <Table.Cell>Operations</Table.Cell>
          <Table.Cell>{data.handling_fee} 电</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Crate Fee</Table.Cell>
          <Table.Cell>Operations</Table.Cell>
          <Table.Cell>{data.crate_fee} 电</Table.Cell>
        </Table.Row>
        {data.order_items.map((item) => (
          <Table.Row key={item.name}>
            <Table.Cell>{item.name}</Table.Cell>
            <Table.Cell>{item.supplier_data.name}</Table.Cell>
            <Table.Cell>{item.price} 电</Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

export const TrackingPage = (props, context) => {
  const { act, data } = useBackend<CargoData>(context);

  return (
    <Section title="Tracking">
      <LabeledList>
        {data.tracking_status && (
          <LabeledList.Item label="Tracking Status">
            {data.tracking_status}
          </LabeledList.Item>
        )}
        <LabeledList.Item label="Tracking Code">
          <Button
            content={data.tracking_code}
            icon="edit"
            onClick={() => act('trackingcode')}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Order ID">
          <Button
            content={data.tracking_id}
            icon="edit"
            onClick={() => act('trackingid')}
          />
        </LabeledList.Item>
      </LabeledList>
      {data.tracking_status === 'Success' && <ShowTrackingStatus />}
    </Section>
  );
};

export const ShowTrackingStatus = (props, context) => {
  const { act, data } = useBackend<CargoData>(context);
  const contentHtml = { __html: sanitizeText(data.tracked_order_report) };

  return (
    <Section title="Tracking Information">
      <Box dangerouslySetInnerHTML={contentHtml} />
    </Section>
  );
};
