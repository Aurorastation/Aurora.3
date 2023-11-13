import { useBackend } from '../backend';
import { Button, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export type TrackerData = {
  wireless_firing_pins: Pin[];
};

type Pin = {
  gun_name: string;
  registered_info: string;
  ref: string;
  lock_status: number; // 1 disabled, 2 auto, 3 stun, 4 lethal
};

export const GunTracker = (props, context) => {
  const { act, data } = useBackend<TrackerData>(context);

  return (
    <NtosWindow resizable width={800}>
      <NtosWindow.Content scrollable>
        <Section title="Detected Firearms">
          <Table>
            <Table.Row header>
              <Table.Cell>User</Table.Cell>
              <Table.Cell>Firearm</Table.Cell>
              <Table.Cell>Setting</Table.Cell>
            </Table.Row>
            {data.wireless_firing_pins.map((pin) => (
              <Table.Row key={pin.ref}>
                <Table.Cell>{pin.registered_info}</Table.Cell>
                <Table.Cell>{pin.gun_name}</Table.Cell>
                <Table.Cell>
                  <Button
                    content="Disabled"
                    selected={pin.lock_status === 1}
                    onClick={() => act('set_disable', { pin: pin.ref })}
                  />
                  <Button
                    content="Automatic"
                    selected={pin.lock_status === 2}
                    onClick={() => act('set_auto', { pin: pin.ref })}
                  />
                  <Button
                    content="Stun Only"
                    selected={pin.lock_status === 3}
                    onClick={() => act('set_stun', { pin: pin.ref })}
                  />
                  <Button
                    content="Unrestricted"
                    selected={pin.lock_status === 4}
                    onClick={() => act('set_lethal', { pin: pin.ref })}
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
