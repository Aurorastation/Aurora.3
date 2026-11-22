import { Box, Button, LabeledList, Section, Tabs, TextArea } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

type ServerConfigurationData = {
  sector_name: string;
  sector_description: string;
  sector_changed: BooleanLike;
  message_of_the_day: string;
  message_of_the_day_changed: BooleanLike;
  lore_summary: string;
  lore_summary_changed: BooleanLike;
  pinned_round_time: string;
  pinned_round_time_changed: BooleanLike;
  pinned_round_time_configured: BooleanLike;
  read_only: BooleanLike;
  unsaved_changes: BooleanLike;
};

export const ServerConfiguration = (props) => {
  const { act, data } = useBackend<ServerConfigurationData>();
  const [tab, setTab] = useLocalState('tab', 'Sector and lore');

  const changeTab = (nextTab: string) => {
    if (tab === nextTab) {
      return;
    }
    if (data.unsaved_changes) {
      act('warn_unsaved_changes');
      return;
    }
    setTab(nextTab);
  };

  return (
    <Window theme="admin" width={600} height={500}>
      <Window.Content scrollable>
        <Box style={{ position: 'relative' }}>
          <Tabs>
            <Tabs.Tab
              selected={tab === 'Sector and lore'}
              onClick={() => changeTab('Sector and lore')}
            >
              Sector and lore
            </Tabs.Tab>
            <Tabs.Tab
              selected={tab === 'Round configuration'}
              onClick={() => changeTab('Round configuration')}
            >
              Round configuration
            </Tabs.Tab>
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
        {tab === 'Sector and lore' && (
          <>
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
          </>
        )}
        {tab === 'Round configuration' && (
          <Section title="Pinned rounds">
            <LabeledList>
              <LabeledList.Item label="Pinned round time">
                <Button
                  content={data.pinned_round_time || 'Unconfigured'}
                  disabled={data.read_only}
                  onClick={() => act('set_pinned_round_time')}
                />
                {data.pinned_round_time_changed ? (
                  <Button
                    color="yellow"
                    icon="arrow-rotate-left"
                    content="Revert"
                    tooltip="Reset pinned round time"
                    onClick={() => act('reset_pinned_round_time')}
                  />
                ) : null}
                {data.pinned_round_time_configured && data.pinned_round_time ? (
                  <Button
                    color="red"
                    icon="trash"
                    tooltip="Remove pinned round time"
                    disabled={data.read_only}
                    onClick={() => act('clear_pinned_round_time')}
                  />
                ) : null}
              </LabeledList.Item>
            </LabeledList>
            <Box mt={1} color="yellow">
              The selected time uses server time, not your time zone.
              Changes take effect immediately when committed and may trigger a transfer vote or block votes until the next round.
            </Box>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
