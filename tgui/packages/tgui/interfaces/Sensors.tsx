import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export type SensorsData = {
  viewing: BooleanLike;
  muted: BooleanLike;
  grid_x: number;
  grid_y: number;
  x: number;
  y: number;
  direction: number;
  is_ship: BooleanLike;
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
  landed: BooleanLike;
  distance: number;
  x: number;
  y: number;
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
            {data.range_choices?.map((range: number) => (
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
            <Table.Cell>B</Table.Cell>
            <Table.Cell>X</Table.Cell>
            <Table.Cell>Y</Table.Cell>
            <Table.Cell>D</Table.Cell>
            <Table.Cell>Color</Table.Cell>
          </Table.Row>
          {data.contacts.map((contact: ContactData, i) => (
            <Table.Row>
              <Table.Cell>{contact.name}</Table.Cell>
              <Table.Cell>{contact.bearing}</Table.Cell>
              <Table.Cell>{contact.x}</Table.Cell>
              <Table.Cell>{contact.y}</Table.Cell>
              <Table.Cell>
                {contact.landed
                  ? ''
                  : contact.distance >= 5
                    ? '≥' + contact.distance
                    : contact.distance}
              </Table.Cell>
              <Table.Cell color={contact.color}>{contact.color}</Table.Cell>
            </Table.Row>
          ))}
        </Table>
      ) : (
        ''
      )}
    </Section>
  );
};

const CompassSection = function (context, act, data: SensorsData) {
  const [relativeDirection, setRelativeDirection] = useLocalState(
    context,
    'relativeDirection',
    false
  );

  return (
    <Section title="Sensor Contacts Compass">
      <Box textAlign="center">
        Dir: {data.direction}
        <svg height={200} width={200} viewBox="0 0 100 100">
          <rect width="100" height="100" />
          <g
            transform={
              'rotate(' +
              (relativeDirection ? -data.direction : '0') +
              ' 50 50)'
            }>
            {[8, 16, 24, 32, 40, 48].map((r) => (
              <circle
                r={r}
                cx={50}
                cy={50}
                fill="none"
                stroke="#3e6189"
                stroke-width="0.5"
              />
            ))}
            <polygon
              points="50,45 55,55 45,55"
              fill="#5c83b0"
              stroke="white"
              stroke-width="0.5"
              transform={
                'rotate(' +
                (relativeDirection ? data.direction : data.direction) +
                ' 50 50)'
              }
            />
            <circle
              r={40}
              cx={50}
              cy={50}
              fill="none"
              stroke="#3e6189"
              stroke-width="0.5">
              {/* <animate
                attributeName="r"
                // begin="0s"
                dur="4s"
                repeatCount="indefinite"
                // from="20%"
                // to="100%"
                values="4;44"
              /> */}
            </circle>
            {[0, 45, 90, 135, 180, 225, 270, 315].map((b) => (
              <rect
                width="0.5"
                height={32}
                x="50"
                y="58"
                fill="#3e6189"
                transform={'rotate(' + b + ' 50 50)'}
              />
            ))}
            {data.contacts
              ?.filter((c) => c.distance)
              .map((contact: ContactData, i) => (
                <rect
                  width="1"
                  height={30}
                  x="49"
                  y="60"
                  fill={contact.color}
                  transform={'rotate(' + (contact.bearing + 180) + ' 50 50)'}
                />
              ))}
            {data.contacts?.map((contact: ContactData, i) => (
              <>
                <circle
                  r={3}
                  cx={50}
                  cy={50 - contact.distance * 8}
                  fill={contact.color}
                  transform={'rotate(' + contact.bearing + ' 50 50)'}
                />
                {/* <polygon
                points="49,45 51,45 55,55 45,55"
                fill={contact.color}
                transform={
                  ' rotate(' +
                  contact.bearing +
                  ' 50 50)' +
                  'translate(0 ' +
                  contact.distance * -8 +
                  ') '
                }
              /> */}
                <text
                  x="50"
                  y="2"
                  text-anchor="middle"
                  fill="white"
                  font-size="5"
                  transform={'rotate(' + contact.bearing + ' 50 50)'}>
                  {contact.bearing}
                </text>
              </>
            ))}
            {[0, 45, 90, 135, 180, 225, 270, 315].map((b) => (
              <text
                x="50"
                y="8"
                text-anchor="middle"
                fill="white"
                font-size="8"
                transform={'rotate(' + b + ' 50 50)'}>
                {b}
              </text>
            ))}
          </g>
        </svg>
        <Button.Checkbox
          content="Relative Direction"
          checked={relativeDirection}
          onClick={() => setRelativeDirection(!relativeDirection)}
        />
      </Box>
    </Section>
  );
};

export const Sensors = (props, context) => {
  const { act, data } = useBackend<SensorsData>(context);

  {
    let color_i = 0;
    const colors = [
      'red',
      'green',
      'purple',
      'orange',
      'cyan',
      'blue',
      'white',
    ];

    let bearing_color_map: Map<number, string> = new Map();

    data.contacts?.forEach((contact, i) => {
      if (!bearing_color_map[contact.bearing]) {
        bearing_color_map[contact.bearing] = colors[color_i];
        color_i++;
        if (color_i >= colors.length) {
          color_i = 0;
        }
      }
      contact.color = bearing_color_map[contact.bearing];
    });
  }

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        {SensorSection(act, data)}
        {ContactsSection(act, data)}
        {CompassSection(context, act, data)}
      </NtosWindow.Content>
    </NtosWindow>
  );
};
