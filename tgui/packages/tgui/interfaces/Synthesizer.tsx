import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type SynthesizerData = {
  playback: {
    playing: BooleanLike;
    autorepeat: BooleanLike;
    wait: BooleanLike;
  };
  basic_options: {
    cur_instrument: string;
    volume: number;
    bpm: number;
    transposition: number;
    octave_range: { min: number; max: number };
  };
  advanced_options: {
    all_environments: string[];
    selected_environment: string;
    apply_echo: BooleanLike;
    can_use_custom: BooleanLike;
  };
  sustain: {
    linear_decay_active: BooleanLike;
    sustain_timer: number;
    soft_coeff: number;
  };
  show: {
    playback: BooleanLike;
    custom_env_options: BooleanLike;
    env_settings: BooleanLike;
  };
  status: {
    channels: number;
    events: number;
    max_channels: number;
    max_events: number;
  };
};

export const Synthesizer = (props, context) => {
  const { act, data } = useBackend<SynthesizerData>();
  const { playback, basic_options, advanced_options, sustain, show, status } =
    data;

  return (
    <Window width={520} height={680}>
      <Window.Content scrollable>
        <Section>
          <Button
            icon="file"
            content="Start new song"
            onClick={() => act('newsong')}
          />
          <Button
            ml={1}
            icon="file-import"
            content="Import song"
            onClick={() => act('import')}
          />
        </Section>

        {!!show.playback && (
          <Section title="Player">
            <LabeledList>
              <LabeledList.Item label="Playback">
                <Button
                  selected={!!playback.playing}
                  content="Play"
                  onClick={() => act('play', { value: 1 })}
                />
                <Button
                  selected={!playback.playing}
                  content="Stop"
                  onClick={() => act('play', { value: 0 })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Autorepeat">
                <Button
                  selected={!!playback.autorepeat}
                  content="On"
                  onClick={() => act('autorepeat', { value: 1 })}
                />
                <Button
                  selected={!playback.autorepeat}
                  content="Off"
                  onClick={() => act('autorepeat', { value: 0 })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Wait">
                <Button
                  selected={!!playback.wait}
                  content="On"
                  onClick={() => act('wait', { value: 1 })}
                />
                <Button
                  selected={!playback.wait}
                  content="Off"
                  onClick={() => act('wait', { value: 0 })}
                />
              </LabeledList.Item>
            </LabeledList>
          </Section>
        )}

        <Section title="Basic options">
          <LabeledList>
            <LabeledList.Item label="Volume">
              <Button
                content="--"
                onClick={() => act('volume', { value: -10 })}
              />
              <Button
                content="-"
                onClick={() => act('volume', { value: -1 })}
              />
              <Box inline width="120px" mx={0.5}>
                <ProgressBar
                  value={basic_options.volume}
                  minValue={0}
                  maxValue={100}
                />
              </Box>
              <Button content="+" onClick={() => act('volume', { value: 1 })} />
              <Button
                content="++"
                onClick={() => act('volume', { value: 10 })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Instrument">
              <Button
                content={basic_options.cur_instrument}
                onClick={() => act('instrument')}
              />
            </LabeledList.Item>
            <LabeledList.Item label="BPM">
              <Button icon="minus" onClick={() => act('tempo', { value: 1 })} />
              <Box inline mx={1} width="40px" textAlign="center">
                {basic_options.bpm}
              </Box>
              <Button icon="plus" onClick={() => act('tempo', { value: -1 })} />
            </LabeledList.Item>
            <LabeledList.Item label="Transposition">
              <Button
                icon="minus"
                onClick={() => act('transposition', { value: -1 })}
              />
              <Box inline mx={1} width="20px" textAlign="center">
                {basic_options.transposition}
              </Box>
              <Button
                icon="plus"
                onClick={() => act('transposition', { value: 1 })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Octave (min)">
              <Button
                icon="minus"
                onClick={() => act('min_octave', { value: -1 })}
              />
              <Box inline mx={1} width="20px" textAlign="center">
                {basic_options.octave_range.min}
              </Box>
              <Button
                icon="plus"
                onClick={() => act('min_octave', { value: 1 })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Octave (max)">
              <Button
                icon="minus"
                onClick={() => act('max_octave', { value: -1 })}
              />
              <Box inline mx={1} width="20px" textAlign="center">
                {basic_options.octave_range.max}
              </Box>
              <Button
                icon="plus"
                onClick={() => act('max_octave', { value: 1 })}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>

        <Section title="Sustain">
          <LabeledList>
            <LabeledList.Item label="Exponential decay">
              <Button
                selected={!sustain.linear_decay_active}
                content="On"
                onClick={() => act('decay', { value: 0 })}
              />
              <Button
                selected={!!sustain.linear_decay_active}
                content="Off"
                onClick={() => act('decay', { value: 1 })}
              />
            </LabeledList.Item>
            {!!sustain.linear_decay_active && (
              <LabeledList.Item label="Sustain timer">
                <Button
                  content="--"
                  onClick={() => act('sustain_timer', { value: -10 })}
                />
                <Button
                  content="-"
                  onClick={() => act('sustain_timer', { value: -1 })}
                />
                <Box inline mx={1} width="40px" textAlign="center">
                  {sustain.sustain_timer}
                </Box>
                <Button
                  content="+"
                  onClick={() => act('sustain_timer', { value: 1 })}
                />
                <Button
                  content="++"
                  onClick={() => act('sustain_timer', { value: 10 })}
                />
              </LabeledList.Item>
            )}
            {!sustain.linear_decay_active && (
              <LabeledList.Item label="Exponential coefficient">
                <Box inline mr={1}>
                  {sustain.soft_coeff}
                </Box>
                <Button content="Change" onClick={() => act('soft_coeff')} />
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>

        <Section title="Advanced options">
          {!!show.custom_env_options && !!show.env_settings && (
            <Button
              fluid
              mb={0.5}
              icon="cogs"
              content="Open virtual environment editor"
              onClick={() => act('show_env_editor')}
            />
          )}
          <Button
            fluid
            mb={0.5}
            icon="wave-square"
            content="Open echo editor"
            onClick={() => act('show_echo_editor')}
          />
          <Button
            fluid
            mb={0.5}
            icon="music"
            content="Open song editor"
            onClick={() => act('show_song_editor')}
          />
          <Button
            fluid
            icon="volume-down"
            selected={!!advanced_options.apply_echo}
            content={advanced_options.apply_echo ? 'Echo: On' : 'Echo: Off'}
            onClick={() =>
              act('echo', { value: advanced_options.apply_echo ? 0 : 1 })
            }
          />
          {!!show.env_settings && (
            <Box mt={1}>
              <Box bold mb={0.5}>
                Virtual environment
              </Box>
              {advanced_options.all_environments.map((envName, i) => {
                const isSelected =
                  advanced_options.selected_environment === envName;
                const isCustom = envName === 'Custom';
                const customLocked =
                  isCustom && !isSelected && !advanced_options.can_use_custom;
                return (
                  <Button
                    key={envName}
                    mb={0.25}
                    mr={0.25}
                    selected={isSelected}
                    disabled={customLocked}
                    content={envName}
                    onClick={() => act('select_env', { value: i - 1 })}
                  />
                );
              })}
            </Box>
          )}
        </Section>

        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Channels Used (this instrument)">
              {status.max_channels - status.channels} / {status.max_channels}
            </LabeledList.Item>
            <LabeledList.Item label="Active Events (this instrument)">
              {status.events} / {status.max_events}
            </LabeledList.Item>
          </LabeledList>
          <Button
            mt={1}
            icon="info-circle"
            content="Open usage info (station-wide)"
            onClick={() => act('show_usage')}
          />
        </Section>
      </Window.Content>
    </Window>
  );
};
