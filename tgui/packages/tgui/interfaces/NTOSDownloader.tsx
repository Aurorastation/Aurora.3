import { toFixed } from 'common/math';
import { useBackend } from '../backend';
import { Box, BlockQuote, Button, Collapsible, Section, Stack, ProgressBar } from '../components';
import { NtosWindow } from '../layouts';

type NTOSDownloadable = {
  name: string;
  filename: string;
  size: number;
  desc: string;
  stat: number;
};

type NTOSDownload = {
  name: string;
  progress: number;
};

type NTOSDownloaderData = {
  available: NTOSDownloadable[];
  disk_size: number;
  disk_used: number;
  queue_size: number;
  speed: number;
  queue: NTOSDownload[];
};

const DownloadListing = (props, context) => {
  const { act, data } = useBackend<NTOSDownloaderData>(context);
  const { available } = data;
  const filteredAvailable = available.filter((prg) => !prg.stat);
  return (
    <Stack fill vertical>
      {filteredAvailable.map((prg) => {
        return (
          <Stack.Item key={prg.filename} my={0}>
            <Collapsible
              color="transparent"
              title={prg.name}
              buttons={
                <Button
                  icon="download"
                  color="blue"
                  tooltip="Download"
                  onClick={() => act('download', prg)}
                />
              }>
              <Stack>
                <Stack.Item grow>
                  <BlockQuote ml={2}>{prg.desc}</BlockQuote>
                </Stack.Item>
                <Stack.Item>
                  <Box mr={1} color="label">
                    {prg.size} GQ
                  </Box>
                </Stack.Item>
              </Stack>
            </Collapsible>
          </Stack.Item>
        );
      })}
    </Stack>
  );
};

export const NTOSDownloader = (props, context) => {
  const { act, data } = useBackend<NTOSDownloaderData>(context);
  const { available, disk_size, disk_used, queue_size, speed, queue } = data;
  return (
    <NtosWindow>
      <NtosWindow.Content scrollable>
        <Section title="NtOS Software Download Utility">
          <ProgressBar
            mb={2}
            mt={1}
            value={disk_used / disk_size}
            ranges={{ average: [0.75, 0.9], bad: [0.9, Infinity] }}>
            {disk_used} / {disk_size} GQ ({toFixed(disk_used / disk_size)}%)
          </ProgressBar>
          <DownloadListing />
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
