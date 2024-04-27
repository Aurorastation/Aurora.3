import { useBackend } from '../backend';
import { BlockQuote, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export type PodData = {
  status: number;
};

export const DropPod = (props, context) => {
  const { act, data } = useBackend<PodData>(context);

  return (
    <Window resizable theme="zavodskoi">
      <Window.Content scrollable>
        {data.status === 0 ? (
          <Section title="Select Launch Target">
            <BlockQuote>Drop pod operational.</BlockQuote>
            <LabeledList>
              <LabeledList.Item label="Recreational Areas">
                <Button
                  content="FIRE"
                  color="bad"
                  icon="radiation"
                  onClick={() => act('fire', { fire: 'recreational_areas' })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Operations">
                <Button
                  content="FIRE"
                  color="bad"
                  icon="radiation"
                  onClick={() => act('fire', { fire: 'operations' })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Starboard Wing Frame Interior">
                <Button
                  content="FIRE"
                  color="bad"
                  icon="radiation"
                  onClick={() => act('fire', { fire: 'starboard_wing' })}
                />
              </LabeledList.Item>
            </LabeledList>
          </Section>
        ) : (
          <BlockQuote>Drop pod not operational.</BlockQuote>
        )}
      </Window.Content>
    </Window>
  );
};
