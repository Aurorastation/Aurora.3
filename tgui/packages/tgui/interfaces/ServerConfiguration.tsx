import { Box, Button, LabeledList, Section, Tabs, TextArea } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type ServerConfigurationData = {
  sector_name: string;
  sector_description: string;
  sector_changed: BooleanLike;
  message_of_the_day: string;
  message_of_the_day_changed: BooleanLike;
  lore_summary: string;
  lore_summary_changed: BooleanLike;
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
                onClick={() => act('set_selected_sector')}
              />
              {data.sector_changed ? (
                <Button
                  color="yellow"
                  icon="arrow-rotate-left"
                  content="Revert"
                  tooltip="Reset sector selection"
                  onClick={() => act('reset_selected_sector')}
                />
              ) : null}
            </LabeledList.Item>
          </LabeledList>
          <Box mt={1}>
            <div>- Takes affect after round restart.</div>
            <div>- If unavailable, reverts to sector from config file.</div>
            <div>- Available sectors are based off SSatlas.possible_sectors.</div>
          </Box>
          <Box mt={1}>Description: {data.sector_description}</Box>
        </Section>
        <Section title="Message of the day">
          <TextArea
            disabled={!!data.read_only}
            fluid
            height="10rem"
            value={data.message_of_the_day}
            onChange={(value) => act('set_message_of_the_day', { value })}
          />
          {data.message_of_the_day_changed ? (
            <Button
              color="yellow"
              icon="arrow-rotate-left"
              content="Revert"
              tooltip="Reset MOTD"
              onClick={() => act('reset_message_of_the_day')}
            />
            ) : null}
          <Box mt={1}>
            <div>- Displayed when server init completes and on client-connect.</div>
            <div>- Supports HTML formatting.</div>
            <div>- Should include information about current Port of Call.</div>
            <div>- If empty, reverts to MOTD from config file.</div>
          </Box>
        </Section>
        <Section title="Lore summary">
          <TextArea
            disabled={!!data.read_only}
            fluid
            height="10rem"
            value={data.lore_summary}
            onChange={(value) => act('set_lore_summary', { value })}
          />
          {data.lore_summary_changed ? (
            <Button
              color="yellow"
              icon="arrow-rotate-left"
              content="Revert"
              tooltip="Reset lore summary"
              onClick={() => act('reset_lore_summary')}
            />
          ) : null}
          <Box mt={1}>
            <div>- Displayed when user clicks on lore button in lobby menu.</div>
            <div>- Supports HTML formatting.</div>
            <div>- If empty, reverts to lore summary from config file.</div>
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
