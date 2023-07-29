import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export type SensorsData = {
  viewing: BooleanLike;
  on: BooleanLike;
  range: number;
  health: number;
  max_health: number;
  deep_scan_name: string;
  deep_scan_range: number;
  deep_scan_toggled: BooleanLike;
  heat: number;
  critical_heat: number;
  status: string;
  distress_beacons: DistressBeaconData[];
  distress_range: number;
  desired_range: number;
  range_choices: number[];
  contacts: ContactData[];
};

type ContactData = {
  name: string;
  ref: string;
  bearing: number;
  can_datalink: BooleanLike;
  color: string; // assigned in ts
};

type DistressBeaconData = {
  caller: string;
  sender: string;
  bearing: number;
};

const SensorSection = function (act, data: SensorsData) {
  return (
    <Section
      title="Sensor Array Control"
      buttons={
        <Button
          content={data.viewing ? 'Engaged' : 'Disengaged'}
          onClick={() => act('viewing')}
        />
      }>
      <Table>
        <Table.Row>
          <Table.Cell>State:</Table.Cell>
          <Table.Cell>
            {data.on} <Button content="on/off" onClick={() => act('toggle')} />
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Status:</Table.Cell>
          <Table.Cell>{data.status}</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Range:</Table.Cell>
          <Table.Cell>
            {data.range_choices.map((range: number) => (
              <Button
                content={range}
                disabled={range == data.desired_range}
                color={range <= data.range ? 'green' : null}
                onClick={() => act('range_choice', { range_choice: range })}
              />
            ))}
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Range:</Table.Cell>
          <Table.Cell>{data.range}</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>{data.deep_scan_name}</Table.Cell>
          <Table.Cell>
            Effective Range: {data.deep_scan_range}{' '}
            <Button
              content={data.deep_scan_toggled ? 'Active' : 'Inactive'}
              onClick={() =>
                act('deep_scan_toggle', { deep_scan_toggle: true })
              }
            />
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Integrity:</Table.Cell>
          <Table.Cell>
            {data.health} / {data.max_health}
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Temperature:</Table.Cell>
          <Table.Cell>
            {data.heat} / {data.critical_heat}
          </Table.Cell>
        </Table.Row>
      </Table>
    </Section>
  );
};

const ContactsSection = function (act, data: SensorsData) {
  return (
    <Section title="Sensor Contacts">
      {data.contacts && data.contacts.length ? (
        <Table>
          <Table.Row header>
            <Table.Cell>Designation</Table.Cell>
            <Table.Cell>Bearing</Table.Cell>
          </Table.Row>
          {data.contacts.map((contact: ContactData, i) => (
            <Table.Row>
              <Table.Cell>{contact.name}</Table.Cell>
              <Table.Cell>{contact.bearing}</Table.Cell>
              <Table.Cell color={contact.color}>
                {contact.color} + {i}
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      ) : (
        ''
      )}
    </Section>
  );
};

const CompassSection = function (act, data: SensorsData) {
  return (
    <Section title="Sensor Contacts Compass">
      <Box textAlign="center">
        <svg height={200} width={200} viewBox="0 0 100 100">
          <rect width="100" height="100" />
          {data.contacts.map((contact: ContactData, i) => (
            <>
              <rect
                width="1"
                height={40}
                x="49"
                y="50"
                fill={contact.color}
                transform={'rotate(' + (contact.bearing + 180) + ' 50 50)'}
              />
            </>
          ))}
          {data.contacts.map((contact: ContactData, i) => (
            <>
              <circle
                r={3}
                cx={50}
                cy={10 + (i + 1) * 6}
                fill={contact.color}
                transform={'rotate(' + contact.bearing + ' 50 50)'}
              />
            </>
          ))}
          {[0, 45, 90, 135, 180, 225, 270, 315].map((b) => (
            <text
              x="50"
              y="10"
              text-anchor="middle"
              fill="white"
              font-size="10"
              transform={'rotate(' + b + ' 50 50)'}>
              {b}
            </text>
          ))}
        </svg>
      </Box>
    </Section>
  );
};

export const Sensors = (props, context) => {
  const { act, data } = useBackend<SensorsData>(context);

  {
    const colors = [
      'red',
      'blue',
      'green',
      'purple',
      'orange',
      'white',
      'cyan',
    ];

    data.contacts.forEach((contact, i) => {
      contact.color = colors[i];
    });

    // let bearing_color_map: Map<number, string> = new Map();

    // data.contacts.forEach((contact) => {
    //   bearing_color_map[contact.bearing] = '';
    // });

    // let i = 0;
    // bearing_color_map.forEach((color, bearing) => {
    //   bearing_color_map[bearing] = colors[i];
    //   i++;
    // });

    // data.contacts.forEach((contact) => {
    //   contact.color = bearing_color_map[contact.bearing];
    // });

    // let bearing_contact_map: Map<number, ContactData[]> = new Map();
    // data.contacts.forEach((contact) => {
    //   if (!bearing_contact_map[contact.bearing]) {
    //     bearing_contact_map[contact.bearing] = [];
    //   }
    //   bearing_contact_map[contact.bearing] += contact;
    // });

    // bearing_contact_map.forEach((contacts, bearing) => {
    //   contacts.forEach((contact) => {
    //     contact.color = 'red';
    //   });
    // });
  }
  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        {SensorSection(act, data)}
        {ContactsSection(act, data)}
        {CompassSection(act, data)}
      </NtosWindow.Content>
    </NtosWindow>
  );
};
