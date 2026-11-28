import {
  Box,
  Button,
  LabeledList,
  NumberInput,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
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

  powered: BooleanLike;
  uses_cell: BooleanLike;
  has_cell: BooleanLike;
  charge: number;
  audio_accessory?: string;
  route_to_accessory: BooleanLike;
  audio_accessory_available: BooleanLike;

  has_loudspeaker?: BooleanLike;
  has_subspace?: BooleanLike;
  loudspeaker?: BooleanLike;
  subspace?: BooleanLike;
};

export const Radio = (props) => {
  const { act, data } = useBackend<RadioData>();
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
    powered,
    uses_cell,
    has_cell,
    charge,
    audio_accessory,
    route_to_accessory,
    audio_accessory_available,
  } = data;
  const tunedChannel = channels?.find((channel) => channel.chan === freq);
  // Calculate window height
  let height = 133;
  if (channels && channels.length > 0) {
    height += channels.length * 30 + 8;
  } else {
    height += 24;
  }
  if (uses_cell) {
    height += 88;
  }

  return (
    <Window width={376} height={height}>
      <Window.Content>
        <Section>
          <LabeledList>
            {uses_cell && (
              <>
                <LabeledList.Item label="Power">
                  <Button
                    icon="power-off"
                    selected={powered}
                    color={powered ? 'good' : 'bad'}
                    content={powered ? 'ON' : 'OFF'}
                    disabled={!has_cell}
                    onClick={() => act('toggle_power')}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Battery">
                  {has_cell ? (
                    <ProgressBar value={charge / 100}>
                      {Math.round(charge)}%
                    </ProgressBar>
                  ) : (
                    'No cell installed'
                  )}
                </LabeledList.Item>
                <LabeledList.Item label="Audio route">
                  <Button
                    icon={route_to_accessory ? 'headphones' : 'volume-up'}
                    selected={route_to_accessory}
                    color={
                      route_to_accessory && !audio_accessory_available
                        ? 'bad'
                        : undefined
                    }
                    content={
                      route_to_accessory
                        ? audio_accessory_available
                          ? audio_accessory
                          : 'Connected radio unavailable'
                        : 'Built-in speaker'
                    }
                    disabled={!audio_accessory && !route_to_accessory}
                    onClick={() => act('toggle_audio_route')}
                  />
                </LabeledList.Item>
              </>
            )}
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
                disabled={!powered}
                format={(value) => toFixed(value, 1)}
                onChange={(value) =>
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
                disabled={spk_cut || !powered}
                onClick={() => act('toggle_listen')}
              />
              <Button
                textAlign="center"
                width="37px"
                icon={mic_status ? 'microphone' : 'microphone-slash'}
                selected={mic_status}
                disabled={mic_cut || !powered}
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
                    <span className={channel.chan_span}>
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
                      disabled={!powered}
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
                      disabled={!powered}
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
