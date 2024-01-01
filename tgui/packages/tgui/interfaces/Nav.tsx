import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export type NavData = {
  sector: string;
  sector_info: string;
  ship_coord_x: number;
  ship_coord_y: number;
  accel: number;
  heading: number;
  direction: number;
  speed: number;
  ETAnext: number;
  viewing: BooleanLike;
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
    <Section
      title="Flight Data"
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
          <Table.Cell>ETA to Next Grid:</Table.Cell>
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
      </Table>
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
          <Table.Cell>Scan Data:</Table.Cell>
          <Table.Cell>{data.sector_info}</Table.Cell>
        </Table.Row>
      </Table>
    </Section>
  );
};
export const Nav = (props, context) => {
  const { act, data } = useBackend<NavData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        {FlightSection(act, data)}
        {NavSection(act, data)}
      </NtosWindow.Content>
    </NtosWindow>
  );
};
