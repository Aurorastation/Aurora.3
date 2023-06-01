import { useBackend } from '../backend';
import { Button, NumberInput, Section, LabeledList } from '../components';
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
        {data.dos_crashed ?(
          <Section title="NETWORK ERROR">
            <h2>NETWORK BUFFERS OVERLOADED</h2>
            <h3>Overload Recovery Mode</h3>
            <i>This system is suffering temporary outage due to overflow of traffic buffers. Until buffered traffic is processed, all further requests will be dropped. Frequent occurences of this error may indicate insufficient hardware capacity of your network. Please contact your network planning department for instructions on how to resolve this issue.</i>
            <h3>ADMINISTRATIVE OVERRIDE</h3>
            <b> CAUTION - Data loss may occur </b>
            <Button
                content="Purge buffered traffic"
                onClick={() => act('restart')} />
          </Section>
        ) : (
          <Section title="NTNet Server Status">
            <LabeledList>
              <LabeledList.Item label="Network buffer status">
                  {data.dos_overload} / {data.dos_capacity} GQ
              </LabeledList.Item>
              <LabeledList.Item label="Toggle Status">
              <Button
                content={data.enabled?("ENABLED"):("DISABLED")}
                onClick={() => act('toggle')} />
            </LabeledList.Item>
            </LabeledList>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};

