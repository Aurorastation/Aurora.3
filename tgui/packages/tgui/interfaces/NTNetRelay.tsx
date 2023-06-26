import { useBackend } from '../backend';
import { Button, Section, LabeledList, Box } from '../components';
import { Window } from '../layouts';
import { BooleanLike } from '../../common/react';

export type NTNetData = {
  enabled: BooleanLike;
  dos_capacity: number;
  dos_overload: number;
  dos_crashed: BooleanLike;
};

export const NTNetRelay = (props, context) => {
  const { act, data } = useBackend<NTNetData>(context);

  return (
    <Window resizable>
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
