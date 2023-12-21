import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export type JammerData = {
  active: number;
};

export const Jammer = (props, context) => {
  const { act, data } = useBackend<JammerData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Jammer Level">
          <LabeledList>
            <LabeledList.Item label="Block Nothing">
              <Button
                content={data.active === -1 ? 'On' : 'Off'}
                icon="power-off"
                onClick={() => act('set_active', { set_active: -1 })}
                color={data.active === -1 ? 'bad' : ''}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Block Synthetics">
              <Button
                content={data.active === 2 ? 'On' : 'Off'}
                icon="power-off"
                onClick={() => act('set_active', { set_active: 2 })}
                color={data.active === 2 ? 'good' : ''}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Block All">
              <Button
                content={data.active === 1 ? 'On' : 'Off'}
                icon="power-off"
                onClick={() => act('set_active', { set_active: 1 })}
                color={data.active === 1 ? 'good' : ''}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
