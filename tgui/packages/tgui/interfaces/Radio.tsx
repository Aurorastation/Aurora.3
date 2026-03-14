import { toFixed } from 'common/math';
import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Section, LabeledList, Button, Box, NumberInput } from '../components';
import { Window } from '../layouts';

type Channel = {
  chan: number;
  display_name: string;
  chan_span: string;
  secure_channel?: BooleanLike;
  sec_channel_listen?: BooleanLike;
};

type RadioData = {
  mic_status: BooleanLike;
  speaker: BooleanLike;
  freq: number;
  default_freq: number;
  rawfreq: number;

  min_freq: number;
  max_freq: number;

  mic_cut: BooleanLike;
  spk_cut: BooleanLike;

  channels?: Channel[];

  syndie?: BooleanLike;

  has_loudspeaker?: BooleanLike;
  has_subspace?: BooleanLike;
  loudspeaker?: BooleanLike;
  subspace?: BooleanLike;
};

export const Radio = (props, context) => {
  const { act, data } = useBackend<RadioData>(context);
  const {
    mic_status,
    speaker,
    freq,
    default_freq,
    rawfreq,
    min_freq,
    max_freq,
    has_loudspeaker,
    loudspeaker,
    has_subspace,
    subspace,
    channels,
    mic_cut,
    spk_cut,
  } = data;
  const tunedChannel = channels?.find((channel) => channel.chan === freq);
  // Calculate window height
  let height = 133;
  if (channels && channels.length > 0) {
    height += channels.length * 30 + 8;
  } else {
    height += 24;
  }

  return (
    <Window width={376} height={height}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Frequency">
              <NumberInput
                animated
                tickWhileDragging
                unit="kHz"
                step={0.2}
                stepPixelSize={10}
                minValue={min_freq / 10}
                maxValue={max_freq / 10}
                value={freq / 10}
                format={(value) => toFixed(value, 1)}
                onChange={(_, value) =>
                  act('set_freq', {
                    freq: value * 10,
                  })
                }
              />
              {default_freq && (
                <Box inline ml={1}>
                  <Button
                    textAlign="center"
                    width="24px"
                    icon="redo"
                    disabled={default_freq === freq}
                    onClick={() => act('reset_freq')}
                  />
                </Box>
              )}
              {tunedChannel && (
                <Box inline className={tunedChannel.chan_span} ml={1}>
                  [{tunedChannel.display_name}]
                </Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Audio">
              <Button
                textAlign="center"
                width="37px"
                icon={speaker ? 'volume-up' : 'volume-mute'}
                selected={speaker}
                disabled={spk_cut}
                onClick={() => act('toggle_listen')}
              />
              <Button
                textAlign="center"
                width="37px"
                icon={mic_status ? 'microphone' : 'microphone-slash'}
                selected={mic_status}
                disabled={mic_cut}
                onClick={() => act('toggle_talk')}
              />
              {has_loudspeaker && (
                <Button
                  ml={1}
                  icon="bullhorn"
                  selected={loudspeaker}
                  content={`Loudspeaker ${loudspeaker ? 'ON' : 'OFF'}`}
                  onClick={() => act('shutup')}
                />
              )}
              {has_subspace && (
                <Button
                  ml={1}
                  icon="bullhorn"
                  selected={subspace}
                  content={`Subspace Transmission ${subspace ? 'ON' : 'OFF'}`}
                  onClick={() => act('mode')}
                />
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {channels && (
          <Section title="Channels">
            <LabeledList>
              {channels.map((channel) => (
                <LabeledList.Item
                  key={channel.chan}
                  label={
                    <span class={channel.chan_span}>
                      {channel.display_name}
                    </span>
                  }
                >
                  {channel.secure_channel ? (
                    <Button
                      icon={
                        channel.sec_channel_listen ? 'volume-up' : 'volume-mute'
                      }
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
                      selected={rawfreq === channel.chan}
                      onClick={() => act('spec_freq', { freq: channel.chan })}
                    />
                  )}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
