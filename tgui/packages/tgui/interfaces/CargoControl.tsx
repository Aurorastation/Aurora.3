import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section, Table, Tabs } from '../components';
import { NtosWindow } from '../layouts';

export type CargoData = {
  page: string;
  status_message: string;
  username: string;

  order_list: Order[];
  order_details: OrderDetails;

  order_submitted_number: number;
  order_submitted_value: number;
  order_submitted_suppliers: string[];
  order_submitted_shuttle_time: number;
  order_submitted_shuttle_price: number;

  order_approved_number: number;
  order_approved_value: number;
  order_approved_suppliers: string[];
  order_approved_shuttle_time: number;
  order_approved_shuttle_price: number;

  order_shipped_number: number;
  order_shipped_value: number;

  order_delivered_number: number;
  order_delivered_value: number;

  shipment_list: Shipment[];

  cargo_money: number;
  handling_fee: number;

  bounties: Bounty[];

  have_printer: BooleanLike;
  shuttle_available: BooleanLike;
  shuttle_has_arrive_time: BooleanLike;
  shuttle_eta_minutes: number;
  shuttle_can_launch: BooleanLike;
  shuttle_can_cancel: BooleanLike;
  shuttle_can_force: BooleanLike;
  shuttle_at_station: BooleanLike;
  shuttle_docking_status: string;
};

type Order = {
  order_id: number;
  ordered_by: string;
  price_cargo: number;
};

type OrderDetails = {
  order_id: number;
  tracking_code: number;
  price: number;
  price_customer: number;
  price_cargo: number;
  reason: string;
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
};

type Item = {
  name: string;
  supplier_name: string;
  amount: number;
  price: number;
  item_id: number;
  shipment_cost: number;
  reason: string;
};

type Shipment = {
  shipment_num: number;
  shipment_cost_purchase: number;
  shipment_cost_sell: number;
};

type Bounty = {
  name: string;
  description: string;
  reward_string: string;
  completion_string: string;
  can_claim: BooleanLike;
  claimed: BooleanLike;
  high_priority: BooleanLike;
  background: string;
};

export const CargoControl = (props, context) => {
  const { act, data } = useBackend<CargoData>(context);
  // FUCK THE WAY THESE FUCKING TOPIC CALLS WERE MADE
  // THIS BULLSHIT GAVE ME ARTHRITIS
  return (
    <NtosWindow resizable width={1200} height={800}>
      <NtosWindow.Content scrollable>
        <Section
          title="Operations Management"
          buttons={
            <>
              <Button
                content="Send"
                disabled={!data.shuttle_can_launch}
                icon="play"
                onClick={() => act('shuttle_send')}
              />
              <Button
                content="Cancel"
                disabled={!data.shuttle_can_cancel}
                icon="stop"
                onClick={() => act('shuttle_cancel')}
              />
              <Button
                content="Force"
                disabled={!data.shuttle_can_force}
                icon="play-circle"
                onClick={() => act('shuttle_force')}
              />
            </>
          }>
          <Tabs>
            <Tabs.Tab
              onClick={() => act('page', { page: 'overview_main' })}
              selected={data.page === 'overview_main'}>
              Main
            </Tabs.Tab>
            <Tabs.Tab
              onClick={() => act('page', { page: 'overview_submitted' })}
              selected={data.page === 'overview_submitted'}>
              Submitted
            </Tabs.Tab>
            <Tabs.Tab
              onClick={() => act('page', { page: 'overview_approved' })}
              selected={data.page === 'overview_approved'}>
              Approved
            </Tabs.Tab>
            <Tabs.Tab
              onClick={() => act('page', { page: 'overview_shipped' })}
              selected={data.page === 'overview_shipped'}>
              Shipped
            </Tabs.Tab>
            <Tabs.Tab
              onClick={() => act('page', { page: 'overview_delivered' })}
              selected={data.page === 'overview_delivered'}>
              Delivered
            </Tabs.Tab>
            <Tabs.Tab
              onClick={() => act('page', { page: 'overview_shipments' })}
              selected={data.page === 'overview_shipments'}>
              Shipments
            </Tabs.Tab>
            <Tabs.Tab
              onClick={() => act('page', { page: 'bounties' })}
              selected={data.page === 'bounties'}>
              Bounties
            </Tabs.Tab>
            <Tabs.Tab
              onClick={() => act('page', { page: 'settings' })} // WHY IS IT DIFFERENT NOW? WHY AREN'T THEY ALL THE SAME FORMAT??
              selected={data.page === 'settings'}>
              Settings
            </Tabs.Tab>
          </Tabs>
          {showAppropriateWindow(data.page)}
        </Section>
        {data.order_details && (
          <Section title="Order Details">
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
                {data.order_details.price.toFixed(2)} 电
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
                    <Table.Cell>{item.price.toFixed(2)} 电</Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </Section>
          </Section>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

// I HATE EVERYTHING
const showAppropriateWindow = (page) => {
  switch (page) {
    case 'overview_main':
      return <MainWindow />;
    case 'overview_submitted':
      return <OverviewSubmitted />;
    case 'overview_approved':
      return <OverviewApproved />;
    case 'overview_shipped':
      return <OverviewShipped />;
    case 'overview_delivered':
      return <OverviewDelivered />;
    case 'overview_shipments':
      return <OverviewShipments />;
    case 'bounties':
      return <Bounties />;
    case 'settings':
      return <Settings />;
  }
};

export const MainWindow = (props, context) => {
  const { act, data } = useBackend<CargoData>(context);
  return (
    <Section title="Main Window">
      <Box bold>Welcome, {data.username}.</Box>
      <LabeledList>
        <LabeledList.Item label="Operations Fund">
          {data.cargo_money.toFixed(2)} 电
        </LabeledList.Item>
      </LabeledList>
      {data.shuttle_has_arrive_time ? (
        <Section title="Elevator Information">
          <LabeledList>
            <LabeledList.Item label="ETA">
              {data.shuttle_eta_minutes} minutes
            </LabeledList.Item>
          </LabeledList>
        </Section>
      ) : (
        'Elevator awaiting orders.'
      )}
    </Section>
  );
};

export const OverviewSubmitted = (props, context) => {
  const { act, data } = useBackend<CargoData>(context);
  return (
    <Section title="Submitted Orders">
      <LabeledList>
        <LabeledList.Item label="Submitted Orders">
          {data.order_submitted_number}
        </LabeledList.Item>
        <LabeledList.Item label="Submitted Orders Value">
          {data.order_submitted_value}
        </LabeledList.Item>
        <LabeledList.Item label="Estimated Elevator Time">
          {data.order_approved_shuttle_time / 10} seconds
        </LabeledList.Item>
        <LabeledList.Item label="Estimated Elevator Fee">
          {data.order_approved_shuttle_price.toFixed(2)} 电
        </LabeledList.Item>
      </LabeledList>
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
            <Table.Cell>{order.price_cargo.toFixed(2)} 电</Table.Cell>
            <Table.Cell>
              <Button
                content="Approve"
                color="green"
                onClick={() =>
                  act('order_approve', {
                    order_approve: order.order_id.toString(),
                  })
                }
              />
              <Button
                content="Reject"
                color="red"
                onClick={() =>
                  act('order_reject', {
                    order_reject: order.order_id.toString(),
                  })
                }
              />
              <Button
                content="Details"
                onClick={() =>
                  act('order_details', {
                    order_details: order.order_id.toString(),
                  })
                }
              />
              <Button
                content="Print"
                onClick={() =>
                  act('order_print', {
                    order_print: order.order_id.toString(),
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

export const OverviewApproved = (props, context) => {
  const { act, data } = useBackend<CargoData>(context);
  return (
    <Section title="Approved Orders">
      <LabeledList>
        <LabeledList.Item label="Approved Orders">
          {data.order_approved_number}
        </LabeledList.Item>
        <LabeledList.Item label="Approved Orders Value">
          {data.order_approved_shuttle_time}
        </LabeledList.Item>
        <LabeledList.Item label="Estimated Elevator Time">
          {data.order_approved_shuttle_time / 10} seconds
        </LabeledList.Item>
        <LabeledList.Item label="Estimated Elevator Fee">
          {data.order_approved_shuttle_price.toFixed(2)} 电
        </LabeledList.Item>
      </LabeledList>
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
            <Table.Cell>{order.price_cargo.toFixed(2)} 电</Table.Cell>
            <Table.Cell>
              <Button
                content="Details"
                onClick={() =>
                  act('order_details', {
                    order_details: order.order_id.toString(),
                  })
                }
              />
              <Button
                content="Print"
                onClick={() =>
                  act('order_print', {
                    order_print: order.order_id.toString(),
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

export const OverviewShipped = (props, context) => {
  const { act, data } = useBackend<CargoData>(context);
  return (
    <Section title="Shipped Orders">
      <LabeledList>
        <LabeledList.Item label="Shipped Orders">
          {data.order_shipped_number}
        </LabeledList.Item>
        <LabeledList.Item label="Shipped Orders Value">
          {data.order_shipped_value}
        </LabeledList.Item>
      </LabeledList>
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
            <Table.Cell>{order.price_cargo.toFixed(2)} 电</Table.Cell>
            <Table.Cell>
              <Button
                content="Details"
                onClick={() =>
                  act('order_details', {
                    order_details: order.order_id.toString(),
                  })
                }
              />
              <Button
                content="Print"
                onClick={() =>
                  act('order_print', {
                    order_print: order.order_id.toString(),
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

export const OverviewDelivered = (props, context) => {
  const { act, data } = useBackend<CargoData>(context);
  return (
    <Section title="Delivered Orders">
      <LabeledList>
        <LabeledList.Item label="Delivered Orders">
          {data.order_delivered_number}
        </LabeledList.Item>
        <LabeledList.Item label="Delivered Orders Value">
          {data.order_delivered_value}
        </LabeledList.Item>
      </LabeledList>
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
            <Table.Cell>{order.price_cargo.toFixed(2)} 电</Table.Cell>
            <Table.Cell>
              <Button
                content="Details"
                onClick={() =>
                  act('order_details', {
                    order_details: order.order_id.toString(),
                  })
                }
              />
              <Button
                content="Print"
                onClick={() =>
                  act('order_print', {
                    order_print: order.order_id.toString(),
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

export const OverviewShipments = (props, context) => {
  const { act, data } = useBackend<CargoData>(context);
  return (
    <Section title="Shipments Overview">
      <Table>
        <Table.Row header>
          <Table.Cell>Number</Table.Cell>
          <Table.Cell>Expense</Table.Cell>
          <Table.Cell>Income</Table.Cell>
          <Table.Cell>Action</Table.Cell>
        </Table.Row>
        {data.shipment_list.map((shipment) => (
          <Table.Row key={shipment.shipment_num}>
            <Table.Cell>{shipment.shipment_num}</Table.Cell>
            <Table.Cell>{shipment.shipment_cost_purchase}</Table.Cell>
            <Table.Cell>{shipment.shipment_cost_sell}</Table.Cell>
            <Table.Cell>
              <Button
                content="Print"
                onClick={() =>
                  act('shipment_print', {
                    shipment_print: shipment.shipment_num.toString(),
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

export const Bounties = (props, context) => {
  const { act, data } = useBackend<CargoData>(context);
  return (
    <Section
      title="Operations Bounties"
      buttons={
        <Button
          content="Print"
          icon="print"
          onClick={() => act('bounty_print')}
        />
      }>
      <Table>
        <Table.Row header>
          <Table.Cell>Name</Table.Cell>
          <Table.Cell>Description</Table.Cell>
          <Table.Cell>Reward</Table.Cell>
          <Table.Cell>Completion</Table.Cell>
          <Table.Cell>Status</Table.Cell>
        </Table.Row>
        {data.bounties.map((bounty) => (
          <Table.Row key={bounty.name} m={5}>
            <Table.Cell textColor={bounty.claimed ? 'green' : 'red'}>
              {bounty.name}
            </Table.Cell>
            <Table.Cell>{bounty.description}</Table.Cell>
            <Table.Cell>{bounty.reward_string}</Table.Cell>
            <Table.Cell>{bounty.completion_string}</Table.Cell>
            <Table.Cell textColor={bounty.claimed ? 'green' : 'red'}>
              {bounty.claimed ? (
                'Claimed'
              ) : (
                <Button
                  content="Unclaimed"
                  icon="star"
                  onClick={() =>
                    act('claim_bounty', { claim_bounty: bounty.name })
                  }
                />
              )}
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

export const Settings = (props, context) => {
  const { act, data } = useBackend<CargoData>(context);
  return (
    <Section title="Settings">
      <LabeledList>
        <LabeledList.Item label="Handling Fee">
          <Button
            content={data.handling_fee}
            icon="edit"
            onClick={() => act('handling_fee')}
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
