import { toFixed } from 'common/math';
import { useBackend } from '../backend';
import { Box, BlockQuote, Button, Collapsible, Section, Stack, ProgressBar, Divider } from '../components';
import { NtosWindow } from '../layouts';

type NTOSProgram = {
  name: string;
  filename: string;
  size: number;
};

type NTOSDownloadable = NTOSProgram & {
  desc: string;
  stat: number;
};

type NTOSDownload = NTOSProgram & {
  progress: number;
};

type NTOSDownloaderData = {
  available: NTOSDownloadable[];
  disk_size: number;
  disk_used: number;
  queue_size: number;
  speed: number;
  active_download: string;
  queue: NTOSDownload[];
};

const AvailableDownloads = (props, context) => {
  const { act, data } = useBackend<NTOSDownloaderData>(context);
  const { available = [], disk_size, disk_used, queue_size } = data;
  const remainingSpace = disk_size - (disk_used + queue_size);
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
                  tooltip={
                    prg.size > remainingSpace
                      ? 'Insufficient space'
                      : 'Download'
                  }
                  onClick={() => act('download', prg)}
                  disabled={prg.size > remainingSpace}
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

const DownloadQueue = (props, context) => {
  const { act, data } = useBackend<NTOSDownloaderData>(context);
  const { queue_size, speed, queue, active_download } = data;
  return (
    <Stack fill vertical>
      <Section
        title="Downloads"
        mx={4}
        mb={2}
        mt={1}
        style={{ 'border': '2px solid #4972a1' }}
        backgroundColor={'#111'}
        fitted>
        {queue.map((prg) => {
          return (
            <Section
              title={prg.name}
              key={prg.filename}
              mx={4}
              mt={1}
              mb={0}
              fitted
              buttons={
                <Button icon="times" onClick={() => act('cancel', prg)}>
                  Cancel
                </Button>
              }>
              <ProgressBar
                mb={2}
                mt={1}
                value={prg.progress / prg.size}
                color={prg.filename === active_download ? 'good' : 'label'}>
                {prg.progress} GQ of {prg.size} GQ ({speed} GQps)
              </ProgressBar>
            </Section>
          );
        })}
      </Section>
    </Stack>
  );
};

export const NTOSDownloader = (props, context) => {
  const { act, data } = useBackend<NTOSDownloaderData>(context);
  const {
    available,
    disk_size,
    disk_used,
    queue_size,
    speed,
    queue = [],
  } = data;
  const remainingSpace = disk_size - disk_used;
  return (
    <NtosWindow>
      <NtosWindow.Content scrollable>
        <Section title="Disk Usage" fitted px={2}>
          <ProgressBar
            mt={1}
            value={disk_used / disk_size}
            ranges={{ average: [0.75, 0.9], bad: [0.9, Infinity] }}>
            {remainingSpace} GQ free of {disk_size} GQ (
            {toFixed((disk_used / disk_size) * 100)}%)
          </ProgressBar>
          <Divider />
          {!!queue.length && <DownloadQueue />}
          <AvailableDownloads />
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
