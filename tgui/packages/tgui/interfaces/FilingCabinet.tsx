import {
  Box,
  Button,
  NoticeBox,
  Section,
  Stack,
  Tabs,
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
};

export const FilingCabinet = (props) => {
  const { act, data } = useBackend<FilingCabinetData>();
  const [tab, setTab] = useLocalState<'general' | 'long_term'>(
    'tab',
    'general',
  );
  const activeTab = data.supports_persistence ? tab : 'general';

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
            </Tabs.Tab>
          )}
        </Tabs>

        {activeTab === 'long_term' && (
          <NoticeBox info>
            Papers stored here persist between rounds. Use this storage only for
            documents intended to remain part of the setting.
          </NoticeBox>
        )}

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
                                ? 'Preserve this paper between rounds.'
                                : 'Only individual papers can be stored long-term.'
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
