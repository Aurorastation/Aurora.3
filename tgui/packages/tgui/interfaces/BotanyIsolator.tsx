// botany_isolator.tsx
import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section } from '../components';
import { Window } from '../layouts';
import { BooleanLike } from '../../common/react';

type GeneMask = {
  mask: string;
  tag: string;
};

type Data = {
  activity: BooleanLike;
  degradation: number;
  disk: BooleanLike;
  loadedSeed: string;
  sourceName: string;
  HasGeneticsData: BooleanLike;
  geneMasks: GeneMask[] | null;
};

export const BotanyIsolator = (_props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { activity, degradation, disk, loadedSeed, sourceName, geneMasks } =
    data;

  const hasDisk = !!disk;
  const hasLoadedSeed = !!loadedSeed;
  const masks = Array.isArray(geneMasks) ? geneMasks : [];

  return (
    <Window width={470} height={450} title="Lysis-Isolation Centrifuge">
      <Window.Content scrollable>
        {activity ? (
          <NoticeBox>Scanning...</NoticeBox>
        ) : (
          <Box>
            <Section title="Buffered Genetic Data">
              {hasLoadedSeed ? (
                <Box>
                  <LabeledList>
                    <LabeledList.Item label="Source">
                      {String(sourceName)}
                    </LabeledList.Item>
                    <LabeledList.Item label="Gene decay">
                      {degradation}%
                    </LabeledList.Item>
                  </LabeledList>

                  {hasDisk ? (
                    <Box mt={1}>
                      {masks.length > 0 ? (
                        <Box>
                          {masks.map((entry) => (
                            <Box key={entry.tag} mb={0.5}>
                              <Button
                                content={`Extract ${entry.mask}`}
                                icon="arrow-down"
                                onClick={() =>
                                  act('get_gene', { gene: entry.tag })
                                }
                              />
                            </Box>
                          ))}
                        </Box>
                      ) : (
                        <NoticeBox>
                          Data error. Genetic record corrupt.
                        </NoticeBox>
                      )}

                      <Box mt={1}>
                        <Button
                          icon="eject"
                          content="Eject Loaded Disk"
                          mr={1}
                          onClick={() => act('eject_disk')}
                        />
                        <Button
                          icon="trash"
                          content="Clear Genetic Buffer"
                          onClick={() => act('clear_buffer')}
                        />
                      </Box>
                    </Box>
                  ) : (
                    <NoticeBox>No disk inserted.</NoticeBox>
                  )}
                </Box>
              ) : (
                <Box>
                  <NoticeBox>No data buffered.</NoticeBox>
                  {hasDisk && (
                    <Box mt={1}>
                      <Button
                        icon="eject"
                        content="Eject Loaded Disk"
                        onClick={() => act('eject_disk')}
                      />
                    </Box>
                  )}
                </Box>
              )}
            </Section>

            <Section title="Loaded Material">
              {hasLoadedSeed ? (
                <Box>
                  <LabeledList>
                    <LabeledList.Item label="Target">
                      {loadedSeed}
                    </LabeledList.Item>
                  </LabeledList>

                  <Button
                    icon="search"
                    content="Buffer Genome"
                    mr={1}
                    onClick={() => act('scan_genome')}
                  />
                  <Button
                    icon="eject"
                    content="Eject Target"
                    onClick={() => act('eject_packet')}
                  />
                </Box>
              ) : (
                <NoticeBox>No seed packet loaded.</NoticeBox>
              )}
            </Section>
          </Box>
        )}
      </Window.Content>
    </Window>
  );
};

export default BotanyIsolator;
