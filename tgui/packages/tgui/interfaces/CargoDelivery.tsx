import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, LabeledList, Section, Table } from '../components';
import { NtosWindow, Window } from '../layouts';

export type CargoData = {
  have_id_slot: BooleanLike;
  have_printer: BooleanLike;
  authenticated: BooleanLike;
  has_id: BooleanLike;
  id_account_number: number;
  id_owner: string;
  id_name: string;
  order_list: Order[];
  order_details: string;
  page: string;
  status_message: string;
}

type Order = {
  
}

export const CargoDelivery = (props, context) => {
  const { act, data } = useBackend<CargoData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section title="Order Overview">
          <Table>
            <Table.Row>
              <Table.Cell>
                Order ID
              </Table.Cell>
              <Table.Cell>
                Customer
              </Table.Cell>
              <Table.Cell>
                Price
              </Table.Cell>
              <Table.Cell>
                Actions
              </Table.Cell>
            </Table.Row>
          </Table>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
