import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Section, LabeledList } from '../components';
import { Window } from '../layouts';
import { AtmosControl } from './AtmosControl';

export type InjectorData = {
  device: Device;
};

type Device = {
  power: BooleanLike;
  rate: number;
  automation: BooleanLike;
}

export const AtmosControlInjector = (props, context) => {
  const { act, data } = useBackend<InjectorData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section>
          <AtmosControl />
        </Section>
        <Section title="Fuel Injection System">
          <LabeledList>
            <LabeledList.Item label="Input">
              <Button
                content={data.}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
