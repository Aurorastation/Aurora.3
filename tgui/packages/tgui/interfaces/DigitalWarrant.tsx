import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export type WarrantData = {
  allwarrants: Warrant[];
  active_warrant: Warrant;
};

type Warrant = {
  name: string;
  charges: string;
  authorisation: string;
  id: number;
  wtype: string;
};

export const DigitalWarrant = (props, context) => {
  const { act, data } = useBackend<WarrantData>(context);

  return (
    <NtosWindow resizable width={900} height={600}>
      <NtosWindow.Content scrollable>
        {data.active_warrant ? <ActiveWarrantEdit /> : <AllWarrants />}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const ActiveWarrantEdit = (props, context) => {
  const { act, data } = useBackend<WarrantData>(context);

  return (
    <Section
      title="Edit Warrant"
      buttons={
        <>
          <Button content="Back" onClick={() => act('sw_menu')} />
          <Button
            content="Save"
            color="green"
            onClick={() => act('savewarrant')}
          />
          <Button
            content="Delete"
            color="red"
            onClick={() => act('deletewarrant')}
          />
        </>
      }>
      <LabeledList>
        <LabeledList.Item label="Name">
          {data.active_warrant.name}&nbsp;
          <Button
            icon="user"
            tooltip="Use a name found in the records."
            onClick={() => act('editwarrantname')}
          />
          <Button
            tooltip="Use a custom name."
            icon="question"
            onClick={() => act('editwarrantnamecustom')}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Charges">
          {data.active_warrant.charges}&nbsp;
          <Button
            icon="sticky-note"
            tooltip="Edit charges."
            onClick={() => act('editwarrantcharges')}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Authorised By">
          <Button
            content={data.active_warrant.authorisation}
            icon="exclamation"
            onClick={() => act('editwarrantauth')}
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

export const AllWarrants = (props, context) => {
  const { act, data } = useBackend<WarrantData>(context);

  return (
    <>
      <Section
        title="Arrest Warrants"
        buttons={
          <Button content="Add Warrant" onClick={() => act('addwarrant')} />
        }>
        {data.allwarrants && data.allwarrants.length ? (
          <Table>
            <Table.Row header>
              <Table.Cell>Name</Table.Cell>
              <Table.Cell>Charges</Table.Cell>
              <Table.Cell>Authorised By</Table.Cell>
            </Table.Row>
            {data.allwarrants
              .filter((w) => w.wtype === 'arrest')
              .map((warrant) => (
                <Table.Row key={warrant.id}>
                  <Table.Cell>
                    <Button
                      content={warrant.name}
                      onClick={() =>
                        act('editwarrant', { editwarrant: warrant.id })
                      }
                    />
                  </Table.Cell>
                  <Table.Cell>{warrant.charges}</Table.Cell>
                  <Table.Cell>{warrant.authorisation}</Table.Cell>
                </Table.Row>
              ))}
          </Table>
        ) : (
          <NoticeBox>No warrants detected.</NoticeBox>
        )}
      </Section>
      <Section title="Search Warrants">
        {data.allwarrants && data.allwarrants.length ? (
          <Table>
            <Table.Row header>
              <Table.Cell>Name</Table.Cell>
              <Table.Cell>Charges</Table.Cell>
              <Table.Cell>Authorised By</Table.Cell>
            </Table.Row>
            {data.allwarrants
              .filter((w) => w.wtype === 'search')
              .map((warrant) => (
                <Table.Row key={warrant.id}>
                  <Table.Cell>
                    <Button
                      content={warrant.name}
                      onClick={() =>
                        act('editwarrant', { editwarrant: warrant.id })
                      }
                    />
                  </Table.Cell>
                  <Table.Cell>{warrant.charges}</Table.Cell>
                  <Table.Cell>{warrant.authorisation}</Table.Cell>
                </Table.Row>
              ))}
          </Table>
        ) : (
          <NoticeBox>No warrants detected.</NoticeBox>
        )}
      </Section>
    </>
  );
};
