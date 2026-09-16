import {
  Box,
  Divider,
  NoticeBox,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type ArmorValuesData = {
  armor_values: string[];
  cold_protection?: string;
};

export const ArmorValues = (props) => {
  const { act, data } = useBackend<ArmorValuesData>();

  return (
    <Window>
      <Window.Content scrollable>
        <Section>
          <NoticeBox>
            The protection information below is out of character. You can use
            it as a mechanical reference, but do not state exact armor
            percentages in character.
          </NoticeBox>
          <Divider />
          {Object.keys(data.armor_values).map((line) =>
            line ? (
              <Box key={data.armor_values[line]}>
                <Box pb={1}>{capitalize(line)}</Box>
                <ProgressBar
                  ranges={{
                    good: [50, 100],
                    average: [30, 50],
                    bad: [0, 30],
                  }}
                  value={data.armor_values[line]}
                  minValue={0}
                  maxValue={100}
                />
                <Divider />
              </Box>
            ) : null,
          )}
          {!!data.cold_protection && (
            <Box>
              <Box bold>Cold protection</Box>
              <Box>{data.cold_protection}</Box>
            </Box>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
