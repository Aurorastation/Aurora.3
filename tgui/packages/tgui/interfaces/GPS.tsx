import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, Input, LabeledControls, Section, Table } from '../components';
import { Window } from '../layouts';

export type GPSData = {
  own_tag: string;
  tracking_list: Tracking[];
  compass_list: string[];
};

type Tracking = {
  tag: string;
  gps: GPSDevice;
};

type GPSDevice = {
  tag: string;
  pos_x: number;
  pos_y: number;
  pos_z: number;
  area: string;
  emped: BooleanLike;
  compass_color: string;
};

export const GPS = (props, context) => {
  const { act, data } = useBackend<GPSData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section
          title="Controls"
          buttons={
            <>
              <Button content="Track All" onClick={() => act('add_all')} />
              <Button content="Untrack All" onClick={() => act('clear_all')} />
            </>
          }>
          <LabeledControls>
            <LabeledControls.Item label="Set New Tag">
              <Input
                placeholder={data.own_tag}
                onChange={(e, value) => act('tag', { tag: value })}
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="Track New Tag">
              <Input
                onChange={(e, value) => act('add_tag', { add_tag: value })}
              />
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
        <Section title="Tracking">
          <Table>
            <Table.Row header>
              <Table.Cell>Tag</Table.Cell>
              <Table.Cell>Location</Table.Cell>
              <Table.Cell>Area</Table.Cell>
              <Table.Cell>Remove</Table.Cell>
              <Table.Cell>C-Track</Table.Cell>
            </Table.Row>
            {data.tracking_list.map((track) => (
              <Table.Row key={track.tag}>
                <Table.Cell>{track.gps.tag}</Table.Cell>
                <Table.Cell>
                  {track.gps.pos_x}, {track.gps.pos_y}, {track.gps.pos_z}
                </Table.Cell>
                <Table.Cell>{track.gps.area}</Table.Cell>
                <Table.Cell>
                  <Button
                    content="Untrack"
                    disabled={data.own_tag === track.gps.tag}
                    onClick={() =>
                      act('remove_tag', { remove_tag: track.gps.tag })
                    }
                  />
                </Table.Cell>
                <Table.Cell>
                  <Button
                    content="Compass"
                    disabled={data.own_tag === track.gps.tag}
                    selected={
                      data.compass_list &&
                      data.compass_list.includes(track.gps.tag)
                    }
                    onClick={() => act('compass', { compass: track.gps.tag })}
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
