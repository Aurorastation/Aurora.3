import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, LabeledList, Section, Table, Tabs } from '../components';
import { NtosWindow } from '../layouts';

export type CargoData = {
  have_id_slot: BooleanLike;
  have_printer: BooleanLike;
  authenticated: BooleanLike;
  has_id: BooleanLike;
  id_account_number: number;
  id_owner: string;
  id_name: string;
  order_list: Order[];
  order_details: Order;
  page: string;
  status_message: string;
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

type Item = {
  name: string;
  description: string;
  amount: number;
  price: number;
  price_adjusted: number;
  id: number;
  supplier_name: string;
};

export const CargoDelivery = (props, context) => {
  const { act, data } = useBackend<CargoData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section>
          <Tabs>
            <Tabs.Tab onClick={() => act('page', { page: 'overview_main' })}>
              Main
            </Tabs.Tab>
            {data.order_details && (
              <>
                {' '}
                <Tabs.Tab
                  onClick={() =>
                    act('page', {
                      page: 'order_overview',
                      order_overview: data.order_details.order_id.toString(),
                    })
                  }>
                  Overview
                </Tabs.Tab>
                <Tabs.Tab
                  onClick={() =>
                    act('page', {
                      page: 'order_payment',
                      order_payment: data.order_details.order_id.toString(),
                    })
                  }>
                  Payment
                </Tabs.Tab>
              </>
            )}
          </Tabs>
        </Section>
        {data.page === 'overview_main' ? (
          <MainView />
        ) : data.page === 'order_overview' ? (
          <Overview />
        ) : (
          <Payment />
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const MainView = (props, context) => {
  const { act, data } = useBackend<CargoData>(context);

  return (
    <Section>
      <Table>
        <Table.Row header>
          <Table.Cell>Order ID</Table.Cell>
          <Table.Cell>Customer</Table.Cell>
          <Table.Cell>Price</Table.Cell>
          <Table.Cell>Actions</Table.Cell>
        </Table.Row>
        {data.order_list.map((order) => (
          <Table.Row key={order.order_id}>
            <Table.Cell>{order.order_id}</Table.Cell>
            <Table.Cell>{order.ordered_by}</Table.Cell>
            <Table.Cell>{order.price}</Table.Cell>
            <Table.Cell>
              <Button
                content="Details"
                onClick={() =>
                  act('page', {
                    page: 'order_overview',
                    order_overview: order.order_id.toString(),
                  })
                }
              />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

export const Overview = (props, context) => {
  const { act, data } = useBackend<CargoData>(context);

  return (
    <Section title="Overview">
      <LabeledList>
        <LabeledList.Item label="ID">
          {data.order_details.order_id}
        </LabeledList.Item>
        <LabeledList.Item label="Tracking Code">
          {data.order_details.tracking_code}
        </LabeledList.Item>
        <LabeledList.Item label="Ordered By">
          {data.order_details.ordered_by}
        </LabeledList.Item>
        <LabeledList.Item label="Reason">
          {data.order_details.reason}
        </LabeledList.Item>
        <LabeledList.Item label="Authorised By">
          {data.order_details.authorized_by
            ? data.order_details.authorized_by
            : 'Unauthorised'}
        </LabeledList.Item>
        <LabeledList.Item label="Price">
          {data.order_details.price}.toFixed(2) 电
        </LabeledList.Item>
        <LabeledList.Item label="Operations Expense">
          {data.order_details.price_cargo.toFixed(2)} 电
        </LabeledList.Item>
        <LabeledList.Item label="Personal Expense">
          {data.order_details.price_customer.toFixed(2)} 电
        </LabeledList.Item>
        <LabeledList.Item label="Personal Expense">
          {data.order_details.price_customer.toFixed(2)} 电
        </LabeledList.Item>
        <LabeledList.Item label="Ordered At">
          {data.order_details.time_submitted}
        </LabeledList.Item>
        <LabeledList.Item label="Approved At">
          {data.order_details.time_approved
            ? data.order_details.time_approved
            : 'Unapproved'}
        </LabeledList.Item>
        <LabeledList.Item label="Paid At">
          {data.order_details.time_paid
            ? data.order_details.time_paid
            : 'Unpaid'}
        </LabeledList.Item>
        <LabeledList.Item label="Shipped At">
          {data.order_details.time_shipped
            ? data.order_details.time_shipped
            : 'Unshipped'}
        </LabeledList.Item>
        <LabeledList.Item label="Payment Status">
          {data.order_details.status_payment}
        </LabeledList.Item>
        <LabeledList.Item label="Shipment Status">
          {data.order_details.status_pretty}
        </LabeledList.Item>
      </LabeledList>
      <Section title="Items">
        <Table>
          <Table.Row header>
            <Table.Cell>Name</Table.Cell>
            <Table.Cell>Supplier</Table.Cell>
            <Table.Cell>Price</Table.Cell>
          </Table.Row>
          {data.order_details.items.map((item) => (
            <Table.Row key={item.name}>
              <Table.Cell>{item.name}</Table.Cell>
              <Table.Cell>{item.supplier_name}</Table.Cell>
              <Table.Cell>{item.price} 电</Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Section>
    </Section>
  );
};

export const Payment = (props, context) => {
  const { act, data } = useBackend<CargoData>(context);

  return (
    <Section
      title={'Payment: Order No. ' + data.order_details.order_id}
      buttons={
        <Button
          content={
            data.order_details.status === 'shipped'
              ? 'Confirm Delivery and Pay'
              : data.order_details.status === 'delivered'
                ? 'Delivered Already'
                : data.order_details.needs_payment
                  ? 'Pay'
                  : 'Paid but not Shipped'
          }
          disabled={
            !data.order_details.needs_payment ||
            data.order_details.status === 'delivered'
          }
          icon="check"
          color="green"
          onClick={() => act('deliver', { deliver: 'true' })}
        />
      }>
      <LabeledList>
        <LabeledList.Item label="Price">
          {data.order_details.price.toFixed(2)} 电
        </LabeledList.Item>
        <LabeledList.Item label="Customer">
          {data.order_details.ordered_by}
        </LabeledList.Item>
        <LabeledList.Item label="Cardholder">{data.id_owner}</LabeledList.Item>
        <LabeledList.Item label="Status">
          {data.status_message ? data.status_message : 'No issues.'}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
