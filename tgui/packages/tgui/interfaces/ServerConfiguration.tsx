import { Box, Button, LabeledList, Section, Tabs } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type ServerConfigurationData = {
  sector_name: string;
  sector_description: string;
  read_only: BooleanLike;
  unsaved_changes: BooleanLike;
};

export const ServerConfiguration = (props) => {
  const { act, data } = useBackend<ServerConfigurationData>();

  return (
    <Window theme="admin" width={600} height={500}>
      <Window.Content scrollable>
        <Box style={{ position: 'relative' }}>
          <Tabs>
            <Tabs.Tab selected>Sector and lore</Tabs.Tab>
          </Tabs>
          <Box
            style={{
              position: 'absolute',
              right: '4px',
              top: '4px',
            }}
          >
            <Button
              color="red"
              content="Commit changes"
              disabled={data.read_only || !data.unsaved_changes}
              onClick={() => act('commit_changes')}
            />
          </Box>
        </Box>
        <Section title="Sector">
          <LabeledList>
            <LabeledList.Item label="Sector to load">
              <Button
                content={data.sector_name}
                disabled={data.read_only}
                icon="map"
                onClick={() => act('select_sector')}
              />
              {data.unsaved_changes ? (
                <Button
                  color="yellow"
                  icon="arrow-rotate-left"
                  tooltip="Reset sector selection"
                  onClick={() => act('reset_sector_selection')}
                />
              ) : null}
            </LabeledList.Item>
          </LabeledList>
          <Box mt={1}>{data.sector_description}</Box>
        </Section>
        <Section title="Port of call" />
        <Section title="Message of the day" />
        <Section title="Lore summary" />
      </Window.Content>
    </Window>
  );
};
