import { sortBy } from 'es-toolkit';
import { Button, LabeledList, Section, Table } from '../components';
import type { BooleanLike } from '../../common/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Song = {
  name: string;
  length: string;
};

export type Data = {
  active: BooleanLike;
  selection: string | null;
  playlist: Song[];
};

export const Jukebox = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { active, selection, playlist } = data;

  const playlist_sorted: Song[] = sortBy(playlist, [(song: Song) => song.name]);
  const song_selected: Song | undefined = playlist.find(
    (song) => song.name === selection
  );

  return (
    <Window resizable width={250} height={480}>
      <Window.Content>
        <Section
          title="Music Player"
          buttons={
            <>
              <Button
                icon={'play'}
                content="Play"
                selected={active}
                onClick={() => act('play')}
              />
              <Button
                icon={'pause'}
                content="Stop"
                disabled={!active}
                onClick={() => act('stop')}
              />
            </>
          }>
          <LabeledList>
            <LabeledList.Item label="Track Name">
              {song_selected?.name || 'No Track Selected'}
            </LabeledList.Item>
            <LabeledList.Item label="Track Length">
              {song_selected?.length || ''}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Playlist">
          <Table>
            <Table.Row color="blue">
              <Table.Cell>Title</Table.Cell>
              <Table.Cell>Length</Table.Cell>
            </Table.Row>
            {playlist_sorted.sort().map((song) => (
              <Table.Row key={song}>
                <Table.Cell>
                  {''}
                  <Button
                    minWidth={12}
                    content={song.name}
                    backgroundColor={
                      song === song_selected && !active
                        ? 'rgba(255, 255, 0, 0.3)'
                        : song === song_selected
                          ? 'rgba(100, 255, 100, 0.3)'
                          : 'rgba(128, 128, 128, 0.3)'
                    }
                    selected={song === song_selected}
                    icon="play"
                    onClick={(track: Song) =>
                      act('change_track', { track: song.name })
                    }
                  />
                </Table.Cell>
                <Table.Cell
                  color={
                    song === song_selected && !active
                      ? 'yellow'
                      : song === song_selected
                        ? 'green'
                        : ''
                  }>
                  {song.length}
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
