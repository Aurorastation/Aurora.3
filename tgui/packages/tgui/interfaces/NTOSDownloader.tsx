import { useBackend } from '../backend';
import { BlockQuote, Button, Collapsible, Section, Stack } from '../components';
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

type NTOSDownload = {
  name: string;
  progress: number;
};

type NTOSDownloaderData = {
  installed: NTOSProgram[];
  available: NTOSDownloadable[];
  disk_size: number;
  disk_used: number;
  queue_size: number;
  speed: number;
  queue: NTOSDownload[];
};

export const NTOSDownloader = (props, context) => {
  const { act, data } = useBackend<NTOSDownloaderData>(context);
  const {
    installed,
    available,
    disk_size,
    disk_used,
    queue_size,
    speed,
    queue,
  } = data;
  const filteredAvailable = available.filter((prg) => !prg.stat);
  return (
    <NtosWindow>
      <NtosWindow.Content scrollable>
        <Section title="NtOS Software Download Utility">
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
                        color="transparent"
                        tooltip="Download"
                      />
                    }>
                    <BlockQuote ml={2}>{prg.desc}</BlockQuote>
                  </Collapsible>
                </Stack.Item>
              );
            })}
          </Stack>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
