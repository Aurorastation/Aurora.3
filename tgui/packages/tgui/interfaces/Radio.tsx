import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Section, LabeledList, Button } from '../components';
import { Window } from '../layouts';

type Channel = {
  chan: string;
  display_name: string;
  chan_span: string;
  secure_channel?: BooleanLike;
  sec_channel_listen?: BooleanLike;
};

type RadioData = {
  mic_status: BooleanLike;
  speaker: BooleanLike;
  freq: string;
  default_freq: string;
  rawfreq: string;

  mic_cut: BooleanLike;
  spk_cut: BooleanLike;

  channels?: Channel[];
  channels_length?: number;

  syndie?: BooleanLike;

  has_loudspeaker?: BooleanLike;
  has_subspace?: BooleanLike;
  loudspeaker?: BooleanLike;
  subspace?: BooleanLike;
};

export const Radio = (props, context) => {
  const { act, data } = useBackend<RadioData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Radio Configuration">
          <LabeledList>
            <LabeledList.Item label="Microphone">
              <Button
                content={data.mic_status ? 'On' : 'Off'}
                selected={data.mic_status}
                onClick={() => act('toggle_talk')}
                disabled={data.mic_cut}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Speaker">
              <Button
                content={data.speaker ? 'On' : 'Off'}
                selected={data.speaker}
                onClick={() => act('toggle_listen')}
                disabled={data.spk_cut}
              />
            </LabeledList.Item>
            {data.has_subspace && (
              <LabeledList.Item label="Subspace Transmission">
                <Button
                  content={data.subspace ? 'On' : 'Off'}
                  selected={data.subspace}
                  onClick={() => act('mode')}
                />
              </LabeledList.Item>
            )}
            {data.has_loudspeaker && (
              <LabeledList.Item label="Loudspeaker">
                <Button
                  content={data.loudspeaker ? 'On' : 'Off'}
                  selected={data.loudspeaker}
                  onClick={() => act('shutup')}
                />
              </LabeledList.Item>
            )}
            <LabeledList.Item label="Frequency">
              <Button
                content="--"
                onClick={() => act('set_freq', { freq: -10 })}
              />
              <Button
                content="-"
                onClick={() => act('set_freq', { freq: -2 })}
              />
              {data.freq}
              <Button
                content="+"
                onClick={() => act('set_freq', { freq: 2 })}
              />
              <Button
                content="++"
                onClick={() => act('set_freq', { freq: 10 })}
              />
            </LabeledList.Item>
          </LabeledList>
          {data.channels && (
            <Section title="Channels">
              <LabeledList>
                {data.channels.map((channel) => (
                  <LabeledList.Item
                    key={channel.chan}
                    label={channel.display_name}
                    className={channel.chan_span}
                  >
                    {channel.secure_channel ? (
                      <Button
                        content={channel.sec_channel_listen ? 'On' : 'Off'}
                        selected={channel.sec_channel_listen}
                        onClick={() =>
                          act('toggle_listen', {
                            channel_name: channel.chan,
                          })
                        }
                      />
                    ) : (
                      <Button
                        content={'Switch'}
                        selected={data.rawfreq === channel.chan}
                        onClick={() => act('spec_freq', { freq: channel.chan })}
                      />
                    )}
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </Section>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
