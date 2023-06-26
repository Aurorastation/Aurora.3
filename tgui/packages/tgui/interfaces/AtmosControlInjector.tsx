import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Section, LabeledList, Button } from '../components';
import { Window } from '../layouts';
import { AtmosControl } from './AtmosControl';

export type InjectorData = {
  device: Device;
};

type Device = {
  power: BooleanLike;
  rate: number;
  automation: BooleanLike;
};

export const AtmosControlInjector = (props, context) => {
  const { act, data } = useBackend<InjectorData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section>
          <AtmosControl />
        </Section>
        {data.device ? (
          <InjectorWindow />
        ) : (
          <Button
            content="Search Device"
            onClick={() => act('in_refresh_status')}
          />
        )}
      </Window.Content>
    </Window>
  );
};

export const InjectorWindow = (props, context) => {
  const { act, data } = useBackend<InjectorData>(context);

  return (
    <Section title="Fuel Injection System">
      <LabeledList>
        <LabeledList.Item label="Input">
          <Button
            content={data.device.power ? 'Injecting' : 'On Hold'}
            color={data.device.power ? 'good' : ''}
            icon="power-off"
            onClick={() => act('in_toggle_injector')}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Rate">{data.device.rate} L/s</LabeledList.Item>
        <LabeledList.Item label="Automated Injection">
          <Button
            content={data.device.automation ? 'Engaged' : 'Disengaged'}
            color={data.device.automation ? 'good' : ''}
            icon="calendar"
            onClick={() => act('toggle_automation')}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Injection">
          <Button
            content="Toggle Power"
            icon="power-off"
            disabled={data.device.automation}
            onClick={() => act('toggle_injector')}
          />
          <Button
            content="Inject (1 Cycle)"
            icon="refresh"
            disabled={data.device.automation}
            onClick={() => act('toggle_injector')}
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
