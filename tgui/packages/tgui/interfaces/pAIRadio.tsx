import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Button, LabeledList, Section, Slider } from '../components';
import { NtosWindow } from '../layouts';

export type RadioData = {
  listening: BooleanLike;
  frequency: number;
  radio_range: number;
  channels: Channel[];
};

type Channel = {
  name: string;
  listening: BooleanLike;
};

export const pAIRadio = (props, context) => {
  const { act, data } = useBackend<RadioData>(context);

  return (
    <NtosWindow resizable>
      <NtosWindow.Content scrollable>
        <Section title="Radio Configuration">
          <LabeledList>
            <LabeledList.Item label="Microphone">
              <Button
                content={data.listening ? 'On' : 'Off'}
                selected={data.listening}
                onClick={() => act('toggle_talk', { nowindow: 1 })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Frequency">
              <Button
                content="--"
                onClick={() => act('set_freq', { freq: -10, nowindow: 1 })}
              />
              <Button
                content="-"
                onClick={() => act('set_freq', { freq: -2, nowindow: 1 })}
              />
              {data.frequency}
              <Button
                content="+"
                onClick={() => act('set_freq', { freq: 2, nowindow: 1 })}
              />
              <Button
                content="++"
                onClick={() => act('set_freq', { freq: 10, nowindow: 1 })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Range">
              <Slider
                value={data.radio_range}
                minValue={0}
                maxValue={4}
                onDrag={(e, value) =>
                  act('radio_range', { radio_range: value })
                }
              />
            </LabeledList.Item>
          </LabeledList>
          <Section title="Channels">
            <LabeledList>
              {data.channels.map((channel) => (
                <LabeledList.Item key={channel.name} label={channel.name}>
                  <Button
                    content={channel.listening ? 'On' : 'Off'}
                    selected={channel.listening}
                    onClick={() =>
                      act('toggle_listen', {
                        channel_name: channel.name,
                        nowindow: 1,
                      })
                    }
                  />
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
