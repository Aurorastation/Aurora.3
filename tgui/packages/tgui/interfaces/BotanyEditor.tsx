// botany_editor.tsx
import { Window } from '../layouts';
import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section } from '../components';

type Data = {
  activity: BooleanLike;
  degradation: number;
  disk: BooleanLike;
  sourceName: string;
  locus: string;
  loadedseed: string;
};

export const BotanyEditor = (_props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { activity, degradation, disk, sourceName, locus, loadedseed } = data;

  const hasLoadedSeed = !!loadedseed;
  const viable = degradation <= 100;

  return (
    <Window width={470} height={450} title="Bioballistic Delivery System">
      <Window.Content scrollable>
        {activity ? (
          <NoticeBox>Bioballistics systems engaged...</NoticeBox>
        ) : (
          <Box>
            <Section title="Buffered Genetic Data">
              {disk ? (
                <Box>
                  <LabeledList>
                    <LabeledList.Item label="Source">
                      {String(sourceName)}
                    </LabeledList.Item>
                    <LabeledList.Item label="Gene decay">
                      {viable ? (
                        `${degradation}%`
                      ) : (
                        <Box color="bad">
                          <b>FURTHER AMENDMENTS NONVIABLE</b>
                        </Box>
                      )}
                    </LabeledList.Item>
                    <LabeledList.Item label="Locus">
                      {String(locus)}
                    </LabeledList.Item>
                  </LabeledList>

                  <Button
                    icon="eject"
                    content="Eject Disk"
                    onClick={() => act('eject_disk')}
                  />
                </Box>
              ) : (
                <NoticeBox>No disk loaded.</NoticeBox>
              )}
            </Section>

            <Section title="Loaded Material">
              {hasLoadedSeed ? (
                <Box>
                  <LabeledList>
                    <LabeledList.Item label="Target">
                      {loadedseed}
                    </LabeledList.Item>
                  </LabeledList>

                  {viable && (
                    <Button
                      icon="cog"
                      content="Apply Gene Mods"
                      mr={1}
                      onClick={() => act('apply_gene')}
                    />
                  )}

                  <Button
                    icon="eject"
                    disable={!hasLoadedSeed}
                    content="Eject Target"
                    onClick={() => act('eject_packet')}
                  />
                </Box>
              ) : (
                <NoticeBox>No target seed packet loaded.</NoticeBox>
              )}
            </Section>
          </Box>
        )}
      </Window.Content>
    </Window>
  );
};

export default BotanyEditor;
