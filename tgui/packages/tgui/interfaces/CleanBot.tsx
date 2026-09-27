import { Button, Collapsible, Section, Stack } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type CleanBotConfig = {
  cleanable_types: string[];
  status: boolean;
  locked: boolean;
  maintenance_panel: boolean;
  cleans_blood: boolean;
  should_patrol: boolean;
  screw_loose: boolean;
  odd_button: boolean;
  beacon_freq: number;
  current_patrol_number: number;
  target_patrol_number: number;
};

export const CleanBot = (props) => {
  const { act, data } = useBackend<CleanBotConfig>();

  return (
    <Window title="CleanBot" theme="idris">
      <Window.Content scrollable fitted>
        <Section
          title="Basic Settings"
          buttons={
            <Stack fill>
              <Stack.Item>
                <Button
                  content={data.status ? 'On' : 'Off'}
                  onClick={() => act('toggle_status')}
                  disabled={data.locked}
                />
              </Stack.Item>
            </Stack>
          }
        />
        <Stack fill vertical>
          <Stack.Item>
            <Section title="Blood Behaviour">
              <Button
                content={data.cleans_blood ? 'Clean' : 'Ignore'}
                onClick={() => act('toggle_cleans_blood')}
                disabled={data.locked}
              />
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section title="Patrol Routine">
              <Stack>
                <Stack.Item>
                  <Button
                    content={data.should_patrol ? 'Engaged' : 'Idle'}
                    onClick={() => act('toggle_patrol_mode')}
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    content={
                      data.target_patrol_number
                        ? `Go to Waypoint ${data.target_patrol_number}`
                        : 'Go to Next Waypoint'
                    }
                    disabled={!data.status || !data.should_patrol}
                    onClick={() => act('go_to_patrol_waypoint')}
                    tooltip={`Current waypoint: ${data.current_patrol_number || 'not set'}`}
                  />
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section title="Old Screw">
              <Button
                content={data.screw_loose ? 'Loose' : 'Tight'}
                onClick={() => act('toggle_screw')}
                disabled={!data.maintenance_panel}
              />
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section title="Odd Button">
              <Button
                content={data.odd_button ? 'Up' : 'Down'}
                onClick={() => act('toggle_odd_button')}
                disabled={!data.maintenance_panel}
              />
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section title="Beacon Frequency">
              <Button
                content={data.beacon_freq / 10}
                onClick={() => act('set_frequency')}
                disabled={data.locked}
              />
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Collapsible title="This bot can clean:">
              <ul>
                {data.cleanable_types?.map((a_cleanable_type) => (
                  <li key={a_cleanable_type}>{a_cleanable_type}</li>
                ))}
              </ul>
            </Collapsible>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
