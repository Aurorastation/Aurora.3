import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, LabeledList, Section, Table } from '../components';
import { NtosWindow } from '../layouts';

export type TeleporterData = {
  has_linked_pad: BooleanLike;
  nearby_pads: Pad[];
  selected_target: string; // ref
  selected_target_name: string;
  calibration: number;

  teleport_beacons: Beacon[];
  teleport_implants: Implant[];
};

type Pad = {
  name: string;
  ref: string;
};

type Beacon = {
  name: string;
  ref: string;
};

type Implant = {
  name: string;
  ref: string;
};

export const Teleporter = (props, context) => {
  const { act, data } = useBackend<TeleporterData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        {data.has_linked_pad ? <TeleporterPad /> : <FindPad />}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const TeleporterPad = (props, context) => {
  const { act, data } = useBackend<TeleporterData>(context);

  return (
    <>
      <Section title="Linked Pad Info">
        <LabeledList>
          <LabeledList.Item label="Target">
            {data.selected_target ? data.selected_target_name : 'Not Locked In'}
          </LabeledList.Item>
          <LabeledList.Item label="Calibration">
            {data.calibration}% &nbsp;{' '}
            <Button content="Recalibrate" onClick={() => act('recalibrate')} />
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Teleporter Beacons">
        <Table>
          <Table.Row header>
            <Table.Cell>Name</Table.Cell>
            <Table.Cell>Action</Table.Cell>
          </Table.Row>
          {data.teleport_beacons.map((beacon) => (
            <Table.Row key={beacon.ref}>
              <Table.Cell>{beacon.name}</Table.Cell>
              <Table.Cell>
                <Button
                  content={
                    data.selected_target === beacon.ref ? 'Unset' : 'Lock On'
                  }
                  color={data.selected_target === beacon.ref ? 'danger' : ''}
                  onClick={() =>
                    act('beacon', { beacon: beacon.ref, name: beacon.name })
                  }
                />
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Section>
      <Section title="Tracking Implants">
        <Table>
          <Table.Row header>
            <Table.Cell>Name</Table.Cell>
            <Table.Cell>Action</Table.Cell>
          </Table.Row>
          {data.teleport_implants.map((implant) => (
            <Table.Row key={implant.ref}>
              <Table.Cell>{implant.name}</Table.Cell>
              <Table.Cell>
                <Button
                  content={
                    data.selected_target === implant.ref ? 'Unset' : 'Lock On'
                  }
                  color={data.selected_target === implant.ref ? 'danger' : ''}
                  onClick={() =>
                    act('implant', { implant: implant.ref, name: implant.name })
                  }
                />
              </Table.Cell>
            </Table.Row>
          ))}
        </Table>
      </Section>
    </>
  );
};

export const FindPad = (props, context) => {
  const { act, data } = useBackend<TeleporterData>(context);

  return (
    <Section title="Nearby Teleporter Pads">
      <Table>
        <Table.Row header>
          <Table.Cell>Pad</Table.Cell>
          <Table.Cell>Action</Table.Cell>
        </Table.Row>
        {data.nearby_pads.map((pad) => (
          <Table.Row key={pad.ref}>
            <Table.Cell>{pad.name}</Table.Cell>
            <Table.Cell>
              <Button
                content="Link"
                onClick={() => act('pad', { pad: pad.ref })}
              />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};
