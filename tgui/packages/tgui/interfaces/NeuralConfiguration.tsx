import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export type NeuralData = {
  neural_coherence: number;
  firewall: BooleanLike;
};

export const NeuralConfiguration = (props, context) => {
  const { act, data } = useBackend<NeuralData>(context);

  return (
    <Window resizable theme="ntos_lightmode">
      <Window.Content scrollable>
        <Section title="Neural Configuration">
          WORK IN PROGRESS
          <LabeledList>
            <LabeledList.Item label="Firewall">
              <Button
                content={data.firewall ? 'Enabled' : 'Disabled'}
                color={data.firewall ? 'good' : 'bad'}
                icon={data.firewall ? 'shield-virus' : 'warning'}
                onClick={() => act('toggle_firewall')}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
