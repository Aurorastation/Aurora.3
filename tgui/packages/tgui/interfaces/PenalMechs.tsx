import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export type MechsData = {
  mechs: Mech[];
  robots: Robot[];
  current_cam_loc: string;
};

type Mech = {
  name: string;
  pilot: string;
  location: string;
  camera_status: BooleanLike;
  lockdown: BooleanLike;
  ref: string;
};

type Robot = {
  name: string;
  pilot: string;
  location: string;
  ref: string;
};

export const PenalMechs = (props, context) => {
  const { act, data } = useBackend<MechsData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section title="Remote Penal Mechs">
          <Table>
            <Table.Row header>
              <Table.Cell>Pilot</Table.Cell>
              <Table.Cell>Mech Type</Table.Cell>
              <Table.Cell>Location</Table.Cell>
              <Table.Cell>Camera</Table.Cell>
              <Table.Cell>Lockdown</Table.Cell>
              <Table.Cell>End Connection</Table.Cell>
            </Table.Row>
            {data.mechs.map((mech) => (
              <Table.Row key={mech.ref}>
                <Table.Cell>
                  {mech.pilot ? (
                    <Button
                      content={mech.pilot}
                      onClick={() =>
                        act('message_pilot', { message_pilot: mech.ref })
                      }
                    />
                  ) : (
                    'No Pilot'
                  )}
                </Table.Cell>
                <Table.Cell>{mech.name}</Table.Cell>
                <Table.Cell>{mech.location}</Table.Cell>
                <Table.Cell>
                  <Button
                    content="Track"
                    selected={data.current_cam_loc === mech.ref}
                    onClick={() => act('track_mech', { track_mech: mech.ref })}
                    disabled={!mech.camera_status}
                  />
                </Table.Cell>
                <Table.Cell>
                  <Button
                    content="Lockdown"
                    color={mech.lockdown ? 'red' : ''}
                    onClick={() =>
                      act('lockdown_mech', { lockdown_mech: mech.ref })
                    }
                  />
                </Table.Cell>
                <Table.Cell>
                  <Button
                    content="Terminate"
                    icon="eject"
                    color="red"
                    onClick={() => act('terminate', { terminate: mech.ref })}
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
        <Section title="Remote Penal Cyborgs">
          <Table>
            <Table.Row header>
              <Table.Cell>Pilot</Table.Cell>
              <Table.Cell>Robot Type</Table.Cell>
              <Table.Cell>Location</Table.Cell>
              <Table.Cell>End Connection</Table.Cell>
            </Table.Row>
            {data.robots.map((robot) => (
              <Table.Row key={robot.ref}>
                <Table.Cell>
                  {robot.pilot ? (
                    <Button
                      content={robot.pilot}
                      onClick={() =>
                        act('message_pilot', { message_pilot: robot.ref })
                      }
                    />
                  ) : (
                    'No Pilot'
                  )}
                </Table.Cell>
                <Table.Cell>{robot.name}</Table.Cell>
                <Table.Cell>{robot.location}</Table.Cell>
                <Table.Cell>
                  <Button
                    content="Terminate"
                    icon="eject"
                    color="red"
                    onClick={() => act('terminate', { terminate: robot.ref })}
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
