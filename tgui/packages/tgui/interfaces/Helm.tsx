import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export type HelmData = {
  sector: string;
  sector_info: string;
  landed: string;
  ship_coord_x: number;
  ship_coord_y: number;
  dest: BooleanLike;
  autopilot_x: number;
  autopilot_y: number;
  speedlimit: string;
  accel: number;
  heading: number;
  direction: number;
  autopilot: BooleanLike;
  manual_control: BooleanLike;
  canburn: BooleanLike;
  cancombatroll: BooleanLike;
  cancombatturn: BooleanLike;
  accellimit: number;
  speed: number;
  ship_speed_x: number;
  ship_speed_y: number;
  ETAnext: number;
  locations: Location[];
};

type Location = {
  name: string;
  x: number;
  y: number;
  reference: string;
};

const bearing_unbounded = function (x, y) {
  let res = 0;
  res = Math.atan2(x, y); // radians
  res = (res * 180) / 3.14; // convert to degrees
  res = (res + 360.0) % 360.0;
  res = Math.round(res);
  return res;
};

const FlightSection = function (act, data) {
  return (
    <Section title="Flight Data">
      <Table>
        <Table.Row>
          <Table.Cell>ETA to next grid:</Table.Cell>
          <Table.Cell>{data.ETAnext}</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Speed:</Table.Cell>
          <Table.Cell>{data.speed} Gm/h</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Acceleration:</Table.Cell>
          <Table.Cell>{data.accel} Gm/h</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Heading:</Table.Cell>
          <Table.Cell>
            {bearing_unbounded(data.ship_speed_x, data.ship_speed_y)}°
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Direction:</Table.Cell>
          <Table.Cell>{data.direction}°</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Acceleration limiter:</Table.Cell>
          <Table.Cell>
            <Button
              content={data.accellimit + ' Gm/h'}
              onClick={() => act('accellimit', { accellimit: 9 })}
            />
          </Table.Cell>
        </Table.Row>
      </Table>
    </Section>
  );
};

const BearingsSection = function (act, data) {
  return (
    <Section title="Heading and Direction">
      <Box textAlign="center">
        <svg height={100} width={100} viewBox="0 0 100 100">
          <rect width="100" height="100" />
          {data.speed ? (
            <polygon
              points="50,25 70,70 30,70"
              fill="#3e6189"
              transform={
                'rotate(' +
                bearing_unbounded(data.ship_speed_x, data.ship_speed_y) +
                ' 50 50)'
              }
            />
          ) : (
            ''
          )}
          <polygon
            points="50,35 60,60 40,60"
            fill="#5c83b0"
            stroke="white"
            stroke-width="1"
            transform={'rotate(' + data.direction + ' 50 50)'}
          />
          <text
            x="50"
            y="10"
            text-anchor="middle"
            fill="white"
            transform={'rotate(0 50 50)'}>
            0
          </text>
          <text
            x="50"
            y="5"
            text-anchor="middle"
            fill="white"
            transform={'rotate(45 50 50)'}>
            45
          </text>
          <text
            x="50"
            y="10"
            text-anchor="middle"
            fill="white"
            transform={'rotate(90 50 50)'}>
            90
          </text>
          <text
            x="50"
            y="5"
            text-anchor="middle"
            fill="white"
            transform={'rotate(135 50 50)'}>
            135
          </text>
          <text
            x="50"
            y="10"
            text-anchor="middle"
            fill="white"
            transform={'rotate(180 50 50)'}>
            180
          </text>
          <text
            x="50"
            y="5"
            text-anchor="middle"
            fill="white"
            transform={'rotate(225 50 50)'}>
            225
          </text>
          <text
            x="50"
            y="10"
            text-anchor="middle"
            fill="white"
            transform={'rotate(270 50 50)'}>
            270
          </text>
          <text
            x="50"
            y="5"
            text-anchor="middle"
            fill="white"
            transform={'rotate(315 50 50)'}>
            315
          </text>
        </svg>
        <svg height={20} width={20} />
        <svg height={100} width={100} viewBox="0 0 100 100">
          <rect width="100" height="100" />
          <text x="50" y="10" text-anchor="middle" fill="white">
            N
          </text>
          <text x="50" y="25" text-anchor="middle" fill="white">
            {data.ship_speed_y}
          </text>
          <text x="95" y="43" text-anchor="end" fill="white">
            {data.ship_speed_x} E
          </text>
          <text x="50" y="95" text-anchor="middle" fill="white">
            S
          </text>
          <text x="50" y="80" text-anchor="middle" fill="white">
            {-data.ship_speed_y}
          </text>
          <text x="5" y="57" text-anchor="start" fill="white">
            W {-data.ship_speed_x}
          </text>
        </svg>
      </Box>
    </Section>
  );
};

const ManualSection = function (act, data) {
  return (
    <Section title="Manual control">
      <Table>
        <Table.Row>
          <Table.Cell width="50%">
            <Table width={0} title="Control" align="center">
              <Table.Row>
                <Table.Cell title="Roll Left / Port">
                  <Button
                    icon="angle-double-left"
                    color="red"
                    disabled={!data.cancombatroll}
                    onClick={() => act('roll', { roll: 8 })}
                  />
                </Table.Cell>
                <Table.Cell title="Burn / Forward">
                  <Button
                    icon="arrow-up"
                    disabled={!data.canburn}
                    onClick={() => act('move', { move: 1 })}
                  />
                </Table.Cell>
                <Table.Cell title="Roll Right / Starboard">
                  <Button
                    icon="angle-double-right"
                    color="red"
                    disabled={!data.cancombatroll}
                    onClick={() => act('roll', { roll: 4 })}
                  />
                </Table.Cell>
              </Table.Row>
              <Table.Row>
                <Table.Cell title="Turn Left / Counterclockwise">
                  <Button
                    icon="undo"
                    disabled={!data.canturn}
                    onClick={() => act('turn', { turn: 8 })}
                  />
                </Table.Cell>
                <Table.Cell title="Slow / Stop / Inertia Dampener">
                  <Button
                    icon="stop"
                    disabled={!data.canburn || data.speed === 0}
                    onClick={() => act('brake', { move: 1 })}
                  />
                </Table.Cell>
                <Table.Cell title="Turn Right / Clockwise">
                  <Button
                    icon="redo"
                    disabled={!data.canturn}
                    onClick={() => act('turn', { turn: 4 })}
                  />
                </Table.Cell>
              </Table.Row>
            </Table>
          </Table.Cell>
        </Table.Row>
      </Table>
      <Button
        content={
          'Manual Control ' + (data.manual_control ? 'Engaged' : 'Disengaged')
        }
        width="100%"
        icon="cog"
        iconSpin={data.manual_control ? '0.0' : null}
        onClick={() => act('manual', { manual: true })}
      />
    </Section>
  );
};

const AutopilotSection = function (act, data) {
  return (
    <Section title="Autopilot">
      <Table>
        <Table.Row>
          <Table.Cell>Target:</Table.Cell>
          <Table.Cell>
            {data.dest ? (
              <>
                <Button
                  width="25%"
                  content={data.autopilot_x}
                  onClick={() => act('setx', { setx: true })}
                />
                <Button
                  width="25%"
                  content={data.autopilot_y}
                  onClick={() => act('sety', { sety: true })}
                />
              </>
            ) : (
              <Button
                width="100%"
                content="None"
                onClick={() => {
                  act('setx', { setx: true });
                  act('sety', { sety: true });
                }}
              />
            )}
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Speed limit:</Table.Cell>
          <Table.Cell>
            <Button
              width="100%"
              content={data.speedlimit + ' Gm/h'}
              onClick={() => act('speedlimit', { speedlimit: true })}
            />
          </Table.Cell>
        </Table.Row>
      </Table>
      <Button
        content={'Autopilot ' + (data.autopilot ? 'Engaged' : 'Disengaged')}
        width="100%"
        icon="cog"
        iconSpin={data.autopilot ? '0.0' : null}
        disabled={!data.dest}
        onClick={() => act('apilot', { apilot: true })}
      />
    </Section>
  );
};

const NavSection = function (act, data) {
  return (
    <Section title="Navigation Data">
      <Table>
        <Table.Row>
          <Table.Cell>Location:</Table.Cell>
          <Table.Cell>{data.sector}</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Coordinates:</Table.Cell>
          <Table.Cell>
            {data.ship_coord_x} : {data.ship_coord_y}
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Scan data:</Table.Cell>
          <Table.Cell>{data.sector_info}</Table.Cell>
        </Table.Row>
        <Table.Row>
          <Table.Cell>Status:</Table.Cell>
          <Table.Cell>{data.landed}</Table.Cell>
        </Table.Row>{' '}
      </Table>
    </Section>
  );
};

const PosSection = function (act, data) {
  return (
    <Section title="Saved Positions">
      <Table>
        {data.locations && data.locations.length ? (
          <>
            <Table.Row header>
              <Table.Cell>Name</Table.Cell>
              <Table.Cell>Coordinates</Table.Cell>
              <Table.Cell>Actions</Table.Cell>
            </Table.Row>
            {data.locations.map((location) => (
              <Table.Row key={location.name}>
                <Table.Cell>{location.name}</Table.Cell>
                <Table.Cell>
                  {location.x} : {location.y}
                </Table.Cell>
                <Table.Cell>
                  <Button
                    icon="eraser"
                    content="Remove"
                    onClick={() =>
                      act('remove', { remove: location.reference })
                    }
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </>
        ) : (
          ''
        )}
      </Table>
      <Table width={0}>
        <Table.Row>
          <Table.Cell>
            <Button
              icon="save"
              content="Save current position"
              disabled={!data.canburn}
              onClick={() => act('add', { add: 'current' })}
            />
          </Table.Cell>
          <Table.Cell>
            <Button
              icon="file"
              content="Add new entry"
              disabled={!data.canburn}
              onClick={() => act('add', { add: 'new' })}
            />
          </Table.Cell>
        </Table.Row>
      </Table>
    </Section>
  );
};

export const Helm = (props, context) => {
  const { act, data } = useBackend<HelmData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Table>
          <Table.Row>
            <Table.Cell width="50%">{FlightSection(act, data)}</Table.Cell>
            <Table.Cell width="50%">{BearingsSection(act, data)}</Table.Cell>
          </Table.Row>
          <Table.Row>
            <Table.Cell width="50%">{ManualSection(act, data)}</Table.Cell>
            <Table.Cell width="50%">{AutopilotSection(act, data)}</Table.Cell>
          </Table.Row>
        </Table>
        {NavSection(act, data)}
        {PosSection(act, data)}
      </NtosWindow.Content>
    </NtosWindow>
  );
};
