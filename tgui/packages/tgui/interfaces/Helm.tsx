import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export type HelmData = {
  sector: string;
  sector_info: string;
  landed: string;
  s_x: number;
  s_y: number;
  dest: BooleanLike;
  d_x: number;
  d_y: number;
  speedlimit: string;
  accel: number;
  heading: number;
  autopilot: BooleanLike;
  manual_control: BooleanLike;
  canburn: BooleanLike;
  cancombatroll: BooleanLike;
  cancombatturn: BooleanLike;
  accellimit: number;
  speed: number;
  ETAnext: number;
  locations: Location[];
};

type Location = {
  name: string;
  x: number;
  y: number;
  reference: string;
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
          <Table.Cell>{data.heading}°</Table.Cell>
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

const ManualSection = function (act, data) {
  return (
    <Section title="Manual control">
      <Table>
        <Table.Row>
          <Table.Cell width="50%">
            <Table width={0} title="Control">
              <Table.Row>
                <Table.Cell>
                  <Button
                    icon="arrow-left"
                    iconRotation={45}
                    disabled={!data.canburn}
                    onClick={() => act('move', { move: 9 })}
                  />
                </Table.Cell>
                <Table.Cell>
                  <Button
                    icon="arrow-up"
                    disabled={!data.canburn}
                    onClick={() => act('move', { move: 1 })}
                  />
                </Table.Cell>
                <Table.Cell>
                  <Button
                    icon="arrow-right"
                    iconRotation={-45}
                    disabled={!data.canburn}
                    onClick={() => act('move', { move: 5 })}
                  />
                </Table.Cell>
              </Table.Row>
              <Table.Row>
                <Table.Cell>
                  <Button
                    icon="arrow-left"
                    disabled={!data.canburn}
                    onClick={() => act('move', { move: 8 })}
                  />
                </Table.Cell>
                <Table.Cell title="Interial Dampener">
                  <Button
                    icon="stop"
                    disabled={!data.canburn}
                    onClick={() => act('brake', { move: 1 })}
                  />
                </Table.Cell>
                <Table.Cell>
                  <Button
                    icon="arrow-right"
                    disabled={!data.canburn}
                    onClick={() => act('move', { move: 4 })}
                  />
                </Table.Cell>
              </Table.Row>
              <Table.Row>
                <Table.Cell>
                  <Button
                    icon="arrow-left"
                    iconRotation={-45}
                    disabled={!data.canburn}
                    onClick={() => act('move', { move: 10 })}
                  />
                </Table.Cell>
                <Table.Cell>
                  <Button
                    icon="arrow-down"
                    disabled={!data.canburn}
                    onClick={() => act('move', { move: 2 })}
                  />
                </Table.Cell>
                <Table.Cell>
                  <Button
                    icon="arrow-right"
                    iconRotation={45}
                    disabled={!data.canburn}
                    onClick={() => act('move', { move: 6 })}
                  />
                </Table.Cell>
              </Table.Row>
            </Table>
          </Table.Cell>
          <Table.Cell>
            <Table width={0} title="Maneuvers">
              <Table.Row title="Combat Turn">
                <Table.Cell>
                  <Button
                    icon="undo"
                    disabled={!data.cancombatturn}
                    onClick={() => act('turn', { turn: 8 })}
                  />
                </Table.Cell>
                <Table.Cell>
                  <Button
                    icon="redo"
                    disabled={!data.cancombatturn}
                    onClick={() => act('turn', { turn: 4 })}
                  />
                </Table.Cell>
              </Table.Row>
              <Table.Row title="Combat Roll">
                <Table.Cell>
                  <Button
                    icon="angle-double-left"
                    disabled={!data.cancombatroll}
                    onClick={() => act('roll', { roll: 8 })}
                  />
                </Table.Cell>
                <Table.Cell>
                  <Button
                    icon="angle-double-right"
                    disabled={!data.cancombatroll}
                    onClick={() => act('roll', { roll: 4 })}
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
                  content={data.d_x}
                  onClick={() => act('setx', { setx: true })}
                />
                <Button
                  content={data.d_y}
                  onClick={() => act('sety', { sety: true })}
                />
              </>
            ) : (
              <Button
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
              content={data.speedlimit + ' Gm/h'}
              onClick={() => act('speedlimit', { speedlimit: true })}
            />
          </Table.Cell>
        </Table.Row>
        <Table.Row>
          <Button
            content={'Autopilot ' + (data.autopilot ? 'Engaged' : 'Disengaged')}
            icon="cog"
            iconSpin={data.autopilot ? '0.0' : null}
            disabled={!data.dest}
            onClick={() => act('apilot', { apilot: true })}
          />
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
            {data.s_x} : {data.s_y}
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
        {data.locations.length ? (
          <Table.Row header>
            <Table.Cell>Name</Table.Cell>
            <Table.Cell>Coordinates</Table.Cell>
            <Table.Cell>Actions</Table.Cell>
          </Table.Row>
        ) : (
          ''
        )}
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
                onClick={() => act('remove', { remove: location.reference })}
              />
            </Table.Cell>
          </Table.Row>
        ))}
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
        {FlightSection(act, data)}
        <Table>
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
