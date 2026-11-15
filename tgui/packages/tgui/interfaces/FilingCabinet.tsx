import {
  Box,
  Button,
  Icon,
  Section,
  Stack,
  Tabs,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

type StoredItem = {
  name: string;
  ref: string;
  can_archive: BooleanLike;
};

type FilingCabinetData = {
  general: StoredItem[];
  long_term: StoredItem[];
  supports_persistence: BooleanLike;
  persistence_days: number;
};

export const FilingCabinet = (props) => {
  const { act, data } = useBackend<FilingCabinetData>();
  const [tab, setTab] = useLocalState<'general' | 'long_term'>(
    'tab',
    'general',
  );
  const activeTab = data.supports_persistence ? tab : 'general';
  const persistenceDuration = `${data.persistence_days} ${
    data.persistence_days === 1 ? 'day' : 'days'
  }`;

  const items = activeTab === 'general' ? data.general : data.long_term;

  return (
    <Window width={480} height={430}>
      <Window.Content scrollable>
        <Tabs fluid>
          <Tabs.Tab
            icon="folder-open"
            selected={activeTab === 'general'}
            onClick={() => setTab('general')}
          >
            Short-Term ({data.general.length})
          </Tabs.Tab>
          {!!data.supports_persistence && (
            <Tabs.Tab
              icon="archive"
              selected={activeTab === 'long_term'}
              onClick={() => setTab('long_term')}
            >
              Long-Term ({data.long_term.length})
              <Tooltip
                content={`This is a persistence mechanic. Paperwork stored here remains available between rounds and expires after ${persistenceDuration}. Use it only for documents intended to remain part of the setting.`}
              >
                <Box inline ml={1} color="label">
                  <Icon name="calendar-days" mr={0.5} />
                  {persistenceDuration}
                </Box>
              </Tooltip>
            </Tabs.Tab>
          )}
        </Tabs>

        <Section
          title={
            activeTab === 'general'
              ? 'Short-Term Storage'
              : 'Long-Term Storage'
          }
        >
          {items.length === 0 ? (
            <Box color="label">This drawer is empty.</Box>
          ) : (
            <Stack vertical>
              {items.map((item) => (
                <Stack.Item key={item.ref}>
                  <Stack align="center">
                    <Stack.Item grow>{item.name}</Stack.Item>
                    {activeTab === 'general' ? (
                      <Stack.Item>
                        {!!data.supports_persistence && (
                          <Button
                            icon="archive"
                            content="Store Long-Term"
                            disabled={!item.can_archive}
                            tooltip={
                              item.can_archive
                                ? 'Preserve this paperwork between rounds.'
                                : 'Long-term storage accepts nonblank papers, paper bundles, and folders containing only supported paperwork.'
                            }
                            onClick={() => act('archive', { ref: item.ref })}
                          />
                        )}
                      </Stack.Item>
                    ) : (
                      <Stack.Item>
                        <Button
                          icon="folder-open"
                          content="Move to Short-Term"
                          onClick={() => act('unarchive', { ref: item.ref })}
                        />
                      </Stack.Item>
                    )}
                    <Stack.Item>
                      <Button
                        icon="eject"
                        content="Retrieve"
                        onClick={() => act('retrieve', { ref: item.ref })}
                      />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              ))}
            </Stack>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
