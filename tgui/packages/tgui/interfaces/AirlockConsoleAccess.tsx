import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';
import { BooleanLike } from '../../common/react';

export type AccessAirlockConsoleData = {
  exterior_secured: BooleanLike;
  interior_secured: BooleanLike;
  processing: boolean;
};

export const AirlockConsoleAccess = (props, context) => {
  const { act, data } = useBackend<AccessAirlockConsoleData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Status">
          <Box>
            <LabeledList>
              <LabeledList.Item
                label="Exterior Door Status"
                color={data.exterior_secured ? 'green' : 'red'}
              >
                {data.exterior_secured ? (
                  <Box>Secured</Box>
                ) : (
                  <Box>Unsecured</Box>
                )}
              </LabeledList.Item>
              <LabeledList.Item
                label="Interior Door Status"
                color={data.interior_secured ? 'green' : 'red'}
              >
                {data.interior_secured ? (
                  <Box>Secured</Box>
                ) : (
                  <Box>Unsecured</Box>
                )}
              </LabeledList.Item>
            </LabeledList>
          </Box>
        </Section>
        <Section title="Controls">
          <Box>
            <Button
              content="Cycle to Exterior"
              icon="arrow-right-from-bracket"
              onClick={() => act('command', { command: 'cycle_ext_door' })}
            />
            <Button
              content="Cycle to Interior"
              icon="arrow-right-to-bracket"
              onClick={() => act('command', { command: 'cycle_int_door' })}
            />
          </Box>
          <Box>
            <Button
              content="Lock Exterior Door"
              disabled={data.exterior_secured}
              icon="lock"
              onClick={() => act('command', { command: 'force_ext' })}
            />
            <Button
              content="Lock Interior Door"
              disabled={data.interior_secured}
              icon="lock"
              onClick={() => act('command', { command: 'force_int' })}
            />
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
