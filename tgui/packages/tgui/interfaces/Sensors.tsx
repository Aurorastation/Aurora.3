import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, Section, Table, ProgressBar, Slider } from '../components';
import { NtosWindow } from '../layouts';
import { round, clamp } from 'common/math';
import { Color } from 'common/color';

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
  desired_range: number;
  range_choices: number[];
  contacts: ContactData[];

  id_on: BooleanLike;
  id_status: string;
  id_class: string;
  id_name: string;
  can_change_class: BooleanLike;
  can_change_name: BooleanLike;
  contact_details: string;

  distress_beacons: DistressBeaconData[];
  distress_range: number;

  datalink_requests: { name: string; ref: string }[];
  datalinked: { name: string; ref: string }[];
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
  const range_choice_max = data.range_choices[data.range_choices.length - 1];

  return (
    <Section
      title="Sensor Array Control"
      buttons={
        <Button
          content={
            'Sector Map View ' + (data.viewing ? 'Engaged' : 'Disengaged')
          }
          onClick={() => act('viewing')}
        />
      }>
      <Table>
        <Table.Row>
          <Table.Cell>State:</Table.Cell>
          <Table.Cell>
            {data.on ? 'Active' : 'Inactive'}
            {', '}
            <Button content="on/off" onClick={() => act('toggle')} />
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Status:</Table.Cell>
          <Table.Cell>{data.status}</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Range:</Table.Cell>
          <Table.Cell>
            <Slider
              animated
              step={1}
              stepPixelSize={16}
              value={data.desired_range}
              minValue={1}
              maxValue={range_choice_max}
              onChange={(e, value) =>
                act('range_choice', { range_choice: value })
              }>
              Desired Range: {data.desired_range} / {range_choice_max}
            </Slider>
            <ProgressBar
              animated
              backgroundColor={Color.lerp(
                new Color(62, 97, 137, 0),
                new Color(189, 32, 32),
                data.range / range_choice_max
              )}
              minValue={1}
              maxValue={range_choice_max}
              value={data.range}>
              Current Range: {data.range} / {range_choice_max}
            </ProgressBar>
          </Table.Cell>
        </Table.Row>
        {data.deep_scan_range > 0 ? (
          <Table.Row>
            <Table.Cell>{data.deep_scan_name}:</Table.Cell>
            <Table.Cell>
              Effective Range: {data.deep_scan_range}
              {', '}
              {data.deep_scan_toggled ? 'Active' : 'Inactive'}
              {', '}
              <Button
                content={'on/off'}
                onClick={() =>
                  act('deep_scan_toggle', { deep_scan_toggle: true })
                }
              />
            </Table.Cell>
          </Table.Row>
        ) : (
          ''
        )}
        <Table.Row>
          <Table.Cell>Integrity:</Table.Cell>
          <Table.Cell>
            <ProgressBar
              animated
              backgroundColor={Color.lerp(
                Color.fromHex('#20b142'),
                Color.fromHex('#db2828'),
                data.health / data.max_health
              )}
              color={(() => {
                if (data.health > (data.max_health / 3) * 2) {
                  return 'green';
                } else if (data.health > (data.max_health / 3) * 1) {
                  return 'yellow';
                } else {
                  return 'red';
                }
              })()}
              minValue={0}
              maxValue={data.max_health}
              value={data.health}>
              {data.health} / {data.max_health}
            </ProgressBar>
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Temperature:</Table.Cell>
          <Table.Cell>
            <ProgressBar
              animated
              backgroundColor={Color.lerp(
                Color.fromHex('#20b142'),
                Color.fromHex('#db2828'),
                data.heat / data.critical_heat
              )}
              color={(() => {
                if (data.heat > (data.critical_heat / 3) * 2) {
                  return 'red';
                } else if (data.heat > (data.critical_heat / 3) * 1) {
                  return 'yellow';
                } else {
                  return 'green';
                }
              })()}
              minValue={0}
              maxValue={data.critical_heat}
              value={data.heat}>
              {data.heat} / {data.critical_heat}
            </ProgressBar>
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
            <Table.Cell />
            <Table.Cell title="Designation">Designation</Table.Cell>
            <Table.Cell title="Bearing">B</Table.Cell>
            <Table.Cell title="X Grid Coordinate">X</Table.Cell>
            <Table.Cell title="Y Grid Coordinate">Y</Table.Cell>
            <Table.Cell title="Distance">D</Table.Cell>
            <Table.Cell title="Color">C</Table.Cell>
          </Table.Row>
          {data.contacts.map((contact: ContactData, i) => (
            <Table.Row key={contact.name}>
              <Table.Cell title="Scan">
                <Button
                  content={'Scan'}
                  onClick={() => act('scan', { scan: contact.ref })}
                />
              </Table.Cell>
              <Table.Cell title="Designation">{contact.name}</Table.Cell>
              {contact.landed ? (
                ''
              ) : (
                <>
                  <Table.Cell title="Bearing">{contact.bearing}</Table.Cell>
                  <Table.Cell title="X Grid Coordinate">{contact.x}</Table.Cell>
                  <Table.Cell title="Y Grid Coordinate">{contact.y}</Table.Cell>
                  <Table.Cell title="Distance">
                    {new String(round(contact.distance, 2)).padStart(6, '0')}
                  </Table.Cell>
                  <Table.Cell title="Color" color={contact.color}>
                    ██
                  </Table.Cell>
                </>
              )}
            </Table.Row>
          ))}
        </Table>
      ) : (
        ''
      )}
    </Section>
  );
};

const ContactDetailsSection = function (act, data: SensorsData) {
  if (data.contact_details && data.contact_details !== '') {
    /* eslint-disable react/no-danger */
    const contact_details = (
      <div dangerouslySetInnerHTML={{ __html: data.contact_details }} />
    );
    /* eslint-enable */
    return (
      <Section title="Sensor Contact Details">
        <Box textAlign="center">
          {contact_details}
          <Button
            content={'Print'}
            onClick={() => act('scan_action', { scan_action: 'print' })}
          />
          <Button
            content={'Clear'}
            onClick={() => {
              act('scan_action', { scan_action: 'clear' });
              data.contact_details = '';
            }}
          />
        </Box>
      </Section>
    );
  } else {
    return '';
  }
};

const CompassSection = function (context, act, data: SensorsData) {
  return (
    <Section title="Sensor Contacts Compass">
      <Box textAlign="center">
        <svg height={200} width={200} viewBox="0 0 100 100">
          <rect width="100" height="100" />
          <g>
            {[8, 16, 24, 32, 40, 48].map((r) => (
              <circle
                key={r}
                r={r}
                cx={50}
                cy={50}
                fill="none"
                stroke="#3e6189"
                stroke-width="0.5"
              />
            ))}
            <polygon // ship direction triangle
              points="50,45 55,55 45,55"
              fill="#5c83b0"
              stroke="white"
              stroke-width="0.5"
              transform={'rotate(' + data.direction + ' 50 50)'}
            />
            {[0, 45, 90, 135, 180, 225, 270, 315].map((b) => (
              <rect // compass bearings
                key={b}
                width="0.5"
                height={32}
                x="50"
                y="58"
                fill="#3e6189"
                transform={'rotate(' + b + ' 50 50)'}
              />
            ))}
            {data.contacts
              ?.filter((c) => !c.landed)
              .map((contact: ContactData, i) => (
                <rect // contact lines
                  key={i}
                  width="1.0"
                  height={32}
                  x="49.5"
                  y="58"
                  fill={contact.color}
                  transform={'rotate(' + (contact.bearing + 180) + ' 50 50)'}
                />
              ))}
            {data.contacts
              ?.filter((c) => !c.landed)
              .map((contact: ContactData, i) => (
                <>
                  <rect
                    width="4"
                    height="4"
                    x={50 - 2}
                    y={50 - 2 - clamp((contact.distance / 2) * 8, 0, 40)}
                    fill={contact.color}
                    transform={'rotate(' + contact.bearing + ' 50 50)'}
                  />
                  <text // contact bearing on edge of compass
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
              <text // compass bearings on edge of compass
                key={b}
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
      </Box>
    </Section>
  );
};

const DatalinksSection = function (act, data: SensorsData) {
  return (
    <Section title="Datalinks">
      {data.datalink_requests && data.datalink_requests.length ? (
        <Table>
          <Table.Row header>
            <Table.Cell>Datalink Requests:</Table.Cell>
          </Table.Row>
          {data.datalink_requests.map((request) => (
            <Table.Row key={request.name}>
              <Table.Cell>
                <Button
                  content={'Accept'}
                  onClick={() =>
                    act('accept_datalink_requests', {
                      accept_datalink_requests: request.ref,
                    })
                  }
                />
              </Table.Cell>
              <Table.Cell>
                <Button
                  content={'Decline'}
                  onClick={() =>
                    act('decline_datalink_requests', {
                      decline_datalink_requests: request.ref,
                    })
                  }
                />
              </Table.Cell>
              <Table.Cell>{request.name}</Table.Cell>
            </Table.Row>
          ))}
        </Table>
      ) : (
        ''
      )}
      {data.datalinked && data.datalinked.length ? (
        <Table>
          <Table.Row header>
            <Table.Cell>Active Datalinks:</Table.Cell>
          </Table.Row>
          {data.datalinked.map((datalinked) => (
            <Table.Row key={datalinked.name}>
              <Table.Cell>{datalinked.name}</Table.Cell>
              <Table.Cell>
                <Button
                  content={'Rescind'}
                  onClick={() =>
                    act('remove_datalink', {
                      remove_datalink: datalinked.ref,
                    })
                  }
                />
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      ) : (
        ''
      )}
      {data.contacts &&
      data.contacts.length &&
      data.contacts.some((contact) => contact.can_datalink) ? (
        <Table>
          <Table.Row header>
            <Table.Cell>Potential Datalinks:</Table.Cell>
          </Table.Row>
          {data.contacts
            .filter((contact) => contact.can_datalink)
            .map((contact) => (
              <Table.Row key={contact.name}>
                <Table.Cell>{contact.name}</Table.Cell>
                <Table.Cell>
                  <Button
                    content={'Request'}
                    onClick={() =>
                      act('request_datalink', {
                        request_datalink: contact.ref,
                      })
                    }
                  />
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

const IFFSection = function (act, data: SensorsData) {
  return (
    <Section title="IFF Management">
      <Table>
        <Table.Row>
          <Table.Cell>State:</Table.Cell>
          <Table.Cell>
            {data.id_on ? 'Active' : 'Inactive'}
            {', '}
            <Button content="on/off" onClick={() => act('toggle_id')} />
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Status:</Table.Cell>
          <Table.Cell>{data.id_status}</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Class:</Table.Cell>
          <Table.Cell>{data.id_class}</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Designation:</Table.Cell>
          <Table.Cell>{data.id_name}</Table.Cell>
        </Table.Row>
        {data.can_change_class || data.can_change_name ? (
          <Table.Row>
            <Table.Cell />
            <Table.Cell>
              {data.can_change_class ? (
                <Button
                  content={'Change Class'}
                  onClick={() => act('change_ship_class')}
                />
              ) : (
                ''
              )}
              {data.can_change_name ? (
                <Button
                  content={'Change Designation'}
                  onClick={() => act('change_ship_name')}
                />
              ) : (
                ''
              )}
            </Table.Cell>
          </Table.Row>
        ) : (
          ''
        )}
      </Table>
    </Section>
  );
};

const DistressSection = function (act, data: SensorsData) {
  return (
    <Section title="Distress Beacons">
      {data.distress_beacons && data.distress_beacons.length ? (
        <Table>
          <Table.Row header>
            <Table.Cell />
            <Table.Cell>Vessel</Table.Cell>
            <Table.Cell>Bearing</Table.Cell>
            <Table.Cell>Sender</Table.Cell>
          </Table.Row>
          {data.distress_beacons.map((beacon: DistressBeaconData) => (
            <Table.Row key={beacon.caller}>
              <Table.Cell>
                <Button
                  content={'Listen'}
                  onClick={() =>
                    act('play_message', { play_message: beacon.caller })
                  }
                />
              </Table.Cell>
              <Table.Cell>{beacon.caller}</Table.Cell>
              <Table.Cell>{beacon.bearing}</Table.Cell>
              <Table.Cell>{beacon.sender}</Table.Cell>
            </Table.Row>
          ))}
        </Table>
      ) : (
        'None received.'
      )}
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
      'yellow',
      'maroon',
      'olive',
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
        {data.status === 'MISSING' ? (
          <Button
            content={'Link up with the sensor suite'}
            onClick={() => act('link')}
          />
        ) : (
          ''
        )}
        {SensorSection(act, data)}
        {CompassSection(context, act, data)}
        {ContactsSection(act, data)}
        {ContactDetailsSection(act, data)}
        {DatalinksSection(act, data)}
        {IFFSection(act, data)}
        {DistressSection(act, data)}
      </NtosWindow.Content>
    </NtosWindow>
  );
};
