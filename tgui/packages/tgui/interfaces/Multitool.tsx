import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export type MultitoolData = {
  tracking_apc: BooleanLike;
  selected_io: SelectedIo;
};

type SelectedIo = {
  name: string;
  type: string;
};

export const Multitool = (props, context) => {
  const { act, data } = useBackend<MultitoolData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Smart Track">
          <Button
            disabled={data.selected_io}
            color={data.tracking_apc ? 'good' : ''}
            content={
              data.selected_io
                ? 'Toggle APC Smart Tracking (I/O in Buffer)'
                : 'Toggle APC Smart Tracking'
            }
            tooltip="Enabling this will update the multitool's icon to point in the direction of the nearest APC within your area."
            onClick={() => act('track_apc')}
          />
        </Section>
        {data.selected_io ? <IoWindow /> : ''}
      </Window.Content>
    </Window>
  );
};

export const IoWindow = (props, context) => {
  const { act, data } = useBackend<MultitoolData>(context);
  return (
    <Section title="Circuit I/O">
      <LabeledList>
        <LabeledList.Item label="I/O Name">
          {data.selected_io.name}
        </LabeledList.Item>
        <LabeledList.Item label="I/O Type">
          {data.selected_io.type}
        </LabeledList.Item>
      </LabeledList>
      <Button
        content="Clear I/O"
        icon="stop"
        tooltip="The I/O Buffer refers to the input/output wires of integrated circuits, which can be wired up using a multitool."
        onClick={() => act('clear_io')}
      />
    </Section>
  );
};
