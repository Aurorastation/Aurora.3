import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';
import { SearchBar } from './common/SearchBar';
import {
  ResearchFabricator,
  type ResearchFabricatorData,
} from './ResearchFabricator';

type ResearchConsoleData = {
  manufacturer: string;
  screen: string;
  authorized: BooleanLike;
  emagged: BooleanLike;
  network_sync: BooleanLike;
  busy_message: string;
  devices: {
    analyzer: number;
    protolathe: number;
    imprinter: number;
    mechfab: number;
    silo: number;
  };
  loaded_disk: LoadedDisk | null;
  technologies?: Technology[];
  designs?: Design[];
  analyzer?: AnalyzerData;
  fabricator?: ResearchFabricatorData;
  queue_amount: number;
};

type LoadedDisk = {
  type: 'technology' | 'design';
  name: string;
  stored_name?: string;
  stored_description?: string;
  stored_level?: number;
};

type Technology = {
  id: string;
  name: string;
  description: string;
  level: number;
  progress: number;
  threshold: number;
  complete: BooleanLike;
};

type Design = {
  path: string;
  name: string;
  description: string;
  category: string;
};

type AnalyzerData = {
  linked: BooleanLike;
  busy?: BooleanLike;
  item?: {
    name: string;
    stack: BooleanLike;
    technologies: AnalyzerTechnology[];
  };
};

type AnalyzerTechnology = {
  name: string;
  item_level: number;
  current_level: number;
  progress: number;
  threshold: number;
};

export const ResearchConsole = () => {
  const { data } = useBackend<ResearchConsoleData>();

  return (
    <Window width={1200} height={800} theme={data.manufacturer}>
      <Window.Content scrollable>
        {data.screen === 'main' && <MainMenu />}
        {data.screen === 'busy' && (
          <Section title="Research Console">
            <NoticeBox info>{data.busy_message}</NoticeBox>
            <ProgressBar value={1} maxValue={1}>
              Please wait...
            </ProgressBar>
          </Section>
        )}
        {data.screen === 'levels' && (
          <TechnologyList technologies={data.technologies ?? []} />
        )}
        {data.screen === 'designs' && (
          <DesignList designs={data.designs ?? []} />
        )}
        {data.screen === 'tech_disk' && (
          <DiskMenu technologies={data.technologies ?? []} />
        )}
        {data.screen === 'design_disk' && (
          <DiskMenu designs={data.designs ?? []} />
        )}
        {data.screen === 'analyzer' && <Analyzer analyzer={data.analyzer} />}
        {data.screen === 'protolathe' && data.fabricator && (
          <ResearchFabricator
            fabricator={data.fabricator}
            queueAmount={data.queue_amount}
            title="Protolathe"
          />
        )}
        {data.screen === 'imprinter' && data.fabricator && (
          <ResearchFabricator
            fabricator={data.fabricator}
            queueAmount={data.queue_amount}
            title="Circuit Imprinter"
          />
        )}
        {data.screen === 'mechfab' && data.fabricator && (
          <ResearchFabricator
            fabricator={data.fabricator}
            queueAmount={data.queue_amount}
            title="Synthetic Fabricator"
          />
        )}
        {data.screen === 'settings' && <Settings />}
      </Window.Content>
    </Window>
  );
};

const BackButton = () => {
  const { act } = useBackend();
  return (
    <Button icon="arrow-left" content="Back" onClick={() => act('back')} />
  );
};

const MainMenu = () => {
  const { act, data } = useBackend<ResearchConsoleData>();

  return (
    <Stack vertical>
      <Stack.Item>
        <Section title="Research Database">
          <Button
            icon="microscope"
            content="Current Research Levels"
            onClick={() => act('set_screen', { screen: 'levels' })}
          />
          <Button
            icon="book"
            content="Researched Designs"
            onClick={() => act('set_screen', { screen: 'designs' })}
          />
          <Button
            icon="print"
            content="Print Summary"
            onClick={() => act('print_research', { detailed: false })}
          />
          <Button
            icon="print"
            content="Print Detailed Report"
            onClick={() => act('print_research', { detailed: true })}
          />
        </Section>
      </Stack.Item>

      <Stack.Item>
        <Section title="Loaded Disk">
          {data.loaded_disk ? (
            <Stack align="center">
              <Stack.Item grow>
                <Box bold>{data.loaded_disk.name}</Box>
                <Box>{data.loaded_disk.stored_name ?? 'Empty'}</Box>
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="floppy-disk"
                  content="Disk Operations"
                  onClick={() =>
                    act('set_screen', {
                      screen:
                        data.loaded_disk?.type === 'technology'
                          ? 'tech_disk'
                          : 'design_disk',
                    })
                  }
                />
              </Stack.Item>
            </Stack>
          ) : (
            <NoticeBox>No disk loaded.</NoticeBox>
          )}
        </Section>
      </Stack.Item>

      <Stack.Item>
        <Section title="Connected Machinery">
          {data.devices.silo ? (
            <NoticeBox success>Shared material silo connected.</NoticeBox>
          ) : (
            <NoticeBox danger>
              No shared material silo connected. Fabrication is unavailable.
            </NoticeBox>
          )}
          <Button
            icon="recycle"
            content="Destructive Analyzer"
            disabled={!data.devices.analyzer}
            onClick={() => act('set_screen', { screen: 'analyzer' })}
          />
          <Button
            icon="industry"
            content="Protolathe"
            disabled={!data.devices.protolathe}
            onClick={() => act('set_screen', { screen: 'protolathe' })}
          />
          <Button
            icon="microchip"
            content="Circuit Imprinter"
            disabled={!data.devices.imprinter}
            onClick={() => act('set_screen', { screen: 'imprinter' })}
          />
          <Button
            icon="robot"
            content="Synthetic Fabricator"
            disabled={!data.devices.mechfab}
            onClick={() => act('set_screen', { screen: 'mechfab' })}
          />
        </Section>
      </Stack.Item>

      <Stack.Item>
        <Section title="Console">
          <Button
            icon="gear"
            content="Settings"
            disabled={!data.authorized}
            onClick={() => act('set_screen', { screen: 'settings' })}
          />
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const TechnologyList = ({ technologies }: { technologies: Technology[] }) => {
  const { act } = useBackend();
  const [searchTerm, setSearchTerm] = useLocalState('research-tech-search', '');
  const search = searchTerm.trim().toLowerCase();
  const visible = technologies.filter(
    (technology) => !search || technology.name.toLowerCase().includes(search),
  );

  return (
    <Section
      fill
      scrollable
      title="Current Research Levels"
      buttons={
        <Stack>
          <Stack.Item>
            <SearchBar
              query={searchTerm}
              onSearch={setSearchTerm}
              placeholder="Search technologies"
            />
          </Stack.Item>
          <Stack.Item>
            <BackButton />
          </Stack.Item>
        </Stack>
      }
    >
      <LabeledList>
        {visible.map((technology) => (
          <LabeledList.Item key={technology.id} label={technology.name}>
            <Box>{technology.description}</Box>
            {technology.complete ? (
              <NoticeBox success>Level {technology.level}: Complete</NoticeBox>
            ) : (
              <ProgressBar
                value={technology.progress}
                maxValue={technology.threshold}
              >
                Level {technology.level}: {technology.progress} /{' '}
                {technology.threshold}
              </ProgressBar>
            )}
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

const DesignList = ({ designs }: { designs: Design[] }) => {
  const [searchTerm, setSearchTerm] = useLocalState(
    'research-design-search',
    '',
  );
  const search = searchTerm.trim().toLowerCase();
  const visible = designs.filter(
    (design) => !search || design.name.toLowerCase().includes(search),
  );

  return (
    <Section
      fill
      scrollable
      title="Researched Designs"
      buttons={
        <Stack>
          <Stack.Item>
            <SearchBar
              query={searchTerm}
              onSearch={setSearchTerm}
              placeholder="Search designs"
            />
          </Stack.Item>
          <Stack.Item>
            <BackButton />
          </Stack.Item>
        </Stack>
      }
    >
      <Table>
        <Table.Row header>
          <Table.Cell>Name</Table.Cell>
          <Table.Cell>Category</Table.Cell>
          <Table.Cell>Description</Table.Cell>
        </Table.Row>
        {visible.map((design) => (
          <Table.Row key={design.path}>
            <Table.Cell>{design.name}</Table.Cell>
            <Table.Cell>{design.category}</Table.Cell>
            <Table.Cell>{design.description}</Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

const DiskMenu = ({
  technologies,
  designs,
}: {
  technologies?: Technology[];
  designs?: Design[];
}) => {
  const { act, data } = useBackend<ResearchConsoleData>();
  const disk = data.loaded_disk;

  if (!disk) {
    return (
      <Section title="Disk Operations" buttons={<BackButton />}>
        <NoticeBox>No disk loaded.</NoticeBox>
      </Section>
    );
  }

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section title="Disk Operations" buttons={<BackButton />}>
          <LabeledList>
            <LabeledList.Item label="Disk">{disk.name}</LabeledList.Item>
            <LabeledList.Item label="Stored data">
              {disk.stored_name ?? 'Empty'}
            </LabeledList.Item>
            {!!disk.stored_description && (
              <LabeledList.Item label="Description">
                {disk.stored_description}
              </LabeledList.Item>
            )}
          </LabeledList>
          <Button
            icon="upload"
            content="Upload to Database"
            disabled={!disk.stored_name}
            onClick={() => act('upload_disk')}
          />
          <Button.Confirm
            icon="eraser"
            content="Erase Disk"
            disabled={!disk.stored_name}
            onClick={() => act('clear_disk')}
          />
          <Button
            icon="eject"
            content="Eject Disk"
            onClick={() => act('eject_disk')}
          />
        </Section>
      </Stack.Item>

      <Stack.Item grow>
        {disk.type === 'technology' ? (
          <Section fill scrollable title="Copy Technology to Disk">
            <LabeledList>
              {technologies?.map((technology) => (
                <LabeledList.Item
                  key={technology.id}
                  label={technology.name}
                  buttons={
                    <Button
                      icon="copy"
                      content="Copy"
                      onClick={() => act('copy_tech', { id: technology.id })}
                    />
                  }
                >
                  Level {technology.level}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        ) : (
          <Section fill scrollable title="Copy Design to Disk">
            <LabeledList>
              {designs?.map((design) => (
                <LabeledList.Item
                  key={design.path}
                  label={design.name}
                  buttons={
                    <Button
                      icon="copy"
                      content="Copy"
                      onClick={() =>
                        act('copy_design', { design: design.path })
                      }
                    />
                  }
                >
                  {design.category}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        )}
      </Stack.Item>
    </Stack>
  );
};

const Analyzer = ({ analyzer }: { analyzer?: AnalyzerData }) => {
  const { act } = useBackend();

  return (
    <Section title="Destructive Analyzer" buttons={<BackButton />}>
      {!analyzer?.linked ? (
        <NoticeBox danger>No destructive analyzer linked.</NoticeBox>
      ) : analyzer.busy ? (
        <NoticeBox info>The analyzer is currently processing.</NoticeBox>
      ) : !analyzer.item ? (
        <NoticeBox>No item loaded.</NoticeBox>
      ) : (
        <>
          <Box bold fontSize={1.3} mb={1}>
            {analyzer.item.name}
          </Box>
          <Table>
            <Table.Row header>
              <Table.Cell>Technology</Table.Cell>
              <Table.Cell>Item Level</Table.Cell>
              <Table.Cell>Current Level</Table.Cell>
              <Table.Cell>Progress</Table.Cell>
            </Table.Row>
            {analyzer.item.technologies.map((technology) => (
              <Table.Row key={technology.name}>
                <Table.Cell>{technology.name}</Table.Cell>
                <Table.Cell>{technology.item_level}</Table.Cell>
                <Table.Cell>{technology.current_level}</Table.Cell>
                <Table.Cell>
                  {technology.progress} / {technology.threshold}
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
          <Button.Confirm
            icon="recycle"
            color="bad"
            content={
              analyzer.item.stack ? 'Deconstruct One Item' : 'Deconstruct Item'
            }
            onClick={() => act('analyzer_deconstruct')}
          />
          <Button
            icon="eject"
            content="Eject Item"
            onClick={() => act('analyzer_eject')}
          />
        </>
      )}
    </Section>
  );
};

const Settings = () => {
  const { act, data } = useBackend<ResearchConsoleData>();

  return (
    <Stack vertical>
      <Stack.Item>
        <Section title="Console Settings" buttons={<BackButton />}>
          <Button
            icon="network-wired"
            selected={!!data.network_sync}
            content={
              data.network_sync
                ? 'Network Connection Enabled'
                : 'Network Connection Disabled'
            }
            onClick={() => act('toggle_sync')}
          />
          <Button
            icon="sync"
            content="Sync Database with Network"
            disabled={!data.network_sync}
            onClick={() => act('sync_network')}
          />
          <Button
            icon="search"
            content="Find Nearby Devices"
            onClick={() => act('find_devices')}
          />
          <Button.Confirm
            icon="trash"
            color="bad"
            content="Reset Research Database"
            onClick={() => act('reset_database')}
          />
        </Section>
      </Stack.Item>

      <Stack.Item>
        <Section title="Linked Devices">
          {Object.entries(data.devices).map(([device, count]) => (
            <Button.Confirm
              key={device}
              icon="unlink"
              content={`Disconnect ${formatDeviceName(device)} (${count})`}
              disabled={!count}
              onClick={() => act('disconnect', { device })}
            />
          ))}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const formatDeviceName = (device: string) => {
  switch (device) {
    case 'analyzer':
      return 'Destructive Analyzer';
    case 'protolathe':
      return 'Protolathe';
    case 'imprinter':
      return 'Circuit Imprinter';
    case 'mechfab':
      return 'Synthetic Fabricator';
    case 'silo':
      return 'Material Silo';
    default:
      return device;
  }
};
