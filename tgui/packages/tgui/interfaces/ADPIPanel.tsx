import {
  Box,
  Button,
  Divider,
  NoticeBox,
  Section,
  Stack,
  TextArea,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';
import { SearchBar } from './common/SearchBar';

type ADPIPanelData = {
  targets: ADPITarget[];
};

type ADPITarget = {
  name: string;
  ref: string;
  key: string;
  job: string;
  can_random: BooleanLike;
};

export const ADPIPanel = (props) => {
  const { act, data } = useBackend<ADPIPanelData>();
  const [message, setMessage] = useLocalState<string>('message', '');
  const [searchTerm, setSearchTerm] = useLocalState<string>('searchTerm', '');

  const customMessage = message.trim();
  const canSendCustom = customMessage.length > 0;
  const targets = data.targets || [];
  const visibleTargets = targets
    .filter((target) =>
      [target.name, target.key, target.job]
        .join(' ')
        .toLowerCase()
        .includes(searchTerm.toLowerCase()),
    )
    .sort((a, b) => a.name.localeCompare(b.name));

  return (
    <Window theme="admin" width={700} height={520}>
      <Window.Content scrollable>
        <Section
          title="ADPI Panel"
          buttons={
            <Stack align="center">
              <Stack.Item>
                <Button
                  content="Refresh"
                  icon="sync"
                  onClick={() => act('refresh')}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  color="good"
                  content="All Characters"
                  disabled={!targets.length}
                  icon="users"
                  onClick={() => act('send_all', { message })}
                />
              </Stack.Item>
            </Stack>
          }
        >
          <TextArea
            fluid
            height="5rem"
            maxLength={1024}
            onChange={(value) => setMessage(value)}
            placeholder="Optional custom ADPI message. Leave blank for random pool text."
            value={message}
          />
          <Box color="label" mt={1}>
            {canSendCustom
              ? `${customMessage.length}/1024`
              : 'Blank messages use random ADPI pool text.'}
          </Box>
        </Section>

        <Section
          title="Characters"
          buttons={
            <SearchBar
              placeholder="Search by name, key, or job"
              query={searchTerm}
              onSearch={(value) => setSearchTerm(value)}
              style={{ width: '18rem' }}
            />
          }
        >
          {!targets.length && <NoticeBox>No living characters found.</NoticeBox>}
          {!!targets.length && !visibleTargets.length && (
            <NoticeBox>No matching characters found.</NoticeBox>
          )}
          <Stack wrap>
            {visibleTargets.map((target) => {
              const canSend = canSendCustom || target.can_random;
              return (
                <Stack.Item key={target.ref} basis="32%">
                  <Button
                    fluid
                    color={canSend ? undefined : 'bad'}
                    content={target.name}
                    disabled={!canSend}
                    icon="comment"
                    tooltip={
                      target.job
                        ? `${target.key} - ${target.job}`
                        : target.key || undefined
                    }
                    onClick={() =>
                      act('send_target', {
                        target: target.ref,
                        message,
                      })
                    }
                  />
                </Stack.Item>
              );
            })}
          </Stack>
          <Divider />
          <Box color="label">
            {visibleTargets.length}/{targets.length}
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
