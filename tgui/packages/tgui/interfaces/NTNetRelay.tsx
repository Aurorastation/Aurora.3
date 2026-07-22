import { Box, Button, LabeledList, Section } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type NTNetData = {
  enabled: BooleanLike;
  dos_capacity: number;
  dos_overload: number;
  dos_crashed: BooleanLike;
  relay_class: string;
  linked_sector: string;
  backhaul_range: number;
  backhaul_online: BooleanLike;
};

export const NTNetRelay = (props) => {
  const { act, data } = useBackend<NTNetData>();

  return (
    <Window>
      <Window.Content scrollable>
        {data.dos_crashed ? (
          <Section title="NETWORK ERROR">
            <Box fontSize={1.3} bold>
              NETWORK BUFFERS OVERLOADED
            </Box>
            <Box fontSize={1.2}>Overload Recovery Mode</Box>
            <Box italic>
              This system is suffering temporary outage due to overflow of
              traffic buffers. Until buffered traffic is processed, all further
              requests will be dropped. Frequent occurences of this error may
              indicate insufficient hardware capacity of your network. Please
              contact your network planning department for instructions on how
              to resolve this issue.
            </Box>
            <Box fontSize={1.3} bold>
              ADMINISTRATIVE OVERRIDE
            </Box>
            <Box bold> CAUTION - Data loss may occur </Box>
            <Button
              content="Purge buffered traffic"
              onClick={() => act('restart')}
            />
          </Section>
        ) : (
          <Section title="NTNet Server Status">
            <LabeledList>
              <LabeledList.Item label="Relay Class">
                {data.relay_class}
              </LabeledList.Item>
              <LabeledList.Item label="Linked Sector">
                {data.linked_sector}
              </LabeledList.Item>
              <LabeledList.Item label="Backhaul">
                {data.backhaul_online ? 'Online' : 'Offline'}
              </LabeledList.Item>
              <LabeledList.Item label="Backhaul Range">
                {data.backhaul_range}
              </LabeledList.Item>
              <LabeledList.Item label="Network buffer status">
                {data.dos_overload} / {data.dos_capacity} GQ
              </LabeledList.Item>
              <LabeledList.Item label="Toggle Status">
                <Button
                  content={data.enabled ? 'ENABLED' : 'DISABLED'}
                  onClick={() => act('toggle')}
                />
              </LabeledList.Item>
            </LabeledList>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
