import { sortBy } from 'es-toolkit';
import { Box, Button, Dropdown, Knob, LabeledControls, LabeledList, Section } from '../components';
import type { BooleanLike } from '../../common/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Song = {
  name: string;
  length: string;
};

type Data = {
  active: BooleanLike;
  sound_loops: BooleanLike;
  volume: number;
  track_selected: string | null;
  playlist: Song[];
};

export const Jukebox = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { active, sound_loops, track_selected, volume, playlist } = data;

  const songs_sorted: Song[] = sortBy(playlist, [(song: Song) => song.name]);
  const song_selected: Song | undefined = playlist.find(
    (song) => song.name === track_selected
  );

  return (
    <Window width={370} height={313}>
      <Window.Content>
        <Section
          title="Song Player"
          buttons={
            <>
              <Button
                icon={active ? 'pause' : 'play'}
                content={active ? 'Stop' : 'Play'}
                selected={active}
                onClick={() => act('toggle')}
              />
              <Button.Checkbox
                icon={'arrow-rotate-left'}
                content="Repeat"
                disabled={active}
                checked={sound_loops}
                onClick={() => act('loop', { sound_loops: !sound_loops })}
              />
            </>
          }>
          <LabeledList>
            <LabeledList.Item label="Track Selected">
              <Dropdown
                width="240px"
                options={songs_sorted.map((song) => song.name)}
                disabled={!!active}
                selected={song_selected?.name || 'Select a Track'}
                onSelected={(value) =>
                  act('select_track', {
                    track: value,
                  })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="Track Length">
              {song_selected?.length || 'No Track Selected'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Machine Settings">
          <LabeledControls justify="center">
            <LabeledControls.Item label="Volume">
              <Box position="relative">
                <Knob
                  size={3.2}
                  color={volume >= 60 ? 'red' : 'green'}
                  value={volume}
                  unit="%"
                  minValue={0}
                  maxValue={80}
                  step={1}
                  stepPixelSize={1}
                  onChange={(e, value) =>
                    act('set_volume', {
                      volume: value,
                    })
                  }
                />
                <Button
                  fluid
                  position="absolute"
                  top="-2px"
                  right="-22px"
                  color="transparent"
                  icon="fast-backward"
                  onClick={() =>
                    act('set_volume', {
                      volume: 'min',
                    })
                  }
                />
                <Button
                  fluid
                  position="absolute"
                  top="16px"
                  right="-22px"
                  color="transparent"
                  icon="fast-forward"
                  onClick={() =>
                    act('set_volume', {
                      volume: 'max',
                    })
                  }
                />
                <Button
                  fluid
                  position="absolute"
                  top="34px"
                  right="-22px"
                  color="transparent"
                  icon="undo"
                  onClick={() =>
                    act('set_volume', {
                      volume: 'reset',
                    })
                  }
                />
              </Box>
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
      </Window.Content>
    </Window>
  );
};
