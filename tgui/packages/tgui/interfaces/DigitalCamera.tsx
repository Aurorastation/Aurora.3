import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';

type CameraPhoto = {
  id: number;
  name: string;
  image: string;
  description: string | null;
  taken_at: string;
  location: string;
  taken_by: string;
  size: number;
};

type DigitalCameraData = {
  capacity: number;
  prints_left: number;
  on: BooleanLike;
  focus: number;
  printing: BooleanLike;
  photos: CameraPhoto[];
};

export const DigitalCamera = () => {
  const { act, data } = useBackend<DigitalCameraData>();
  const [selectedId, setSelectedId] = useLocalState<number | null>(
    'selected_photo',
    null,
  );
  const selected =
    data.photos.find((photo) => photo.id === selectedId) ??
    data.photos[data.photos.length - 1];

  return (
    <Window width={760} height={600} theme="nanotrasen">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section title="Digital Camera">
              <Stack align="center" justify="space-between">
                <Stack.Item>
                  <Button
                    icon="power-off"
                    selected={!!data.on}
                    onClick={() => act('toggle_power')}
                  >
                    Capture {data.on ? 'enabled' : 'disabled'}
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  Focus:{' '}
                  {[1, 3, 5, 7].map((size) => (
                    <Button
                      key={size}
                      selected={data.focus === size}
                      onClick={() => act('set_focus', { size })}
                    >
                      {size}×{size}
                    </Button>
                  ))}
                </Stack.Item>
              </Stack>
              <Box mt={1} color="label">
                Memory: {data.photos.length} / {data.capacity} photos | Prints
                remaining: {data.prints_left}
              </Box>
            </Section>
          </Stack.Item>
          {data.photos.length >= data.capacity && (
            <Stack.Item>
              <NoticeBox color="yellow">
                Memory full. Delete a photo to take another.
              </NoticeBox>
            </Stack.Item>
          )}
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item basis="180px">
                <Section title="Gallery" fill scrollable>
                  {!data.photos.length && (
                    <Box color="label">No photos saved.</Box>
                  )}
                  {data.photos.map((photo) => (
                    <Button
                      key={photo.id}
                      fluid
                      ellipsis
                      icon="image"
                      selected={selected?.id === photo.id}
                      onClick={() => setSelectedId(photo.id)}
                    >
                      {photo.name}
                    </Button>
                  ))}
                </Section>
              </Stack.Item>
              <Stack.Item grow>
                <Section
                  title={selected?.name || 'Photo Preview'}
                  fill
                  scrollable
                  buttons={
                    selected && (
                      <>
                        <Button
                          icon="print"
                          disabled={!data.prints_left || !!data.printing}
                          onClick={() => act('print', { id: selected.id })}
                        >
                          Print
                        </Button>
                        <Button.Confirm
                          key={selected.id}
                          icon="trash"
                          color="bad"
                          onClick={() => act('delete', { id: selected.id })}
                        >
                          Delete
                        </Button.Confirm>
                      </>
                    )
                  }
                >
                  {selected ? (
                    <>
                      <Box textAlign="center" mb={2}>
                        <img
                          src={selected.image}
                          alt={selected.name}
                          style={{
                            width: `${64 * selected.size}px`,
                            maxWidth: '100%',
                            imageRendering: 'pixelated',
                          }}
                        />
                      </Box>
                      <LabeledList>
                        <LabeledList.Item label="Taken by">
                          {selected.taken_by}
                        </LabeledList.Item>
                        <LabeledList.Item label="Time">
                          {selected.taken_at}
                        </LabeledList.Item>
                        <LabeledList.Item label="Location">
                          {selected.location}
                        </LabeledList.Item>
                      </LabeledList>
                      {!!selected.description && (
                        <Box mt={1}>{selected.description}</Box>
                      )}
                    </>
                  ) : (
                    <NoticeBox>
                      Click a subject with the camera to save a photo, then use
                      the gallery to view, delete, or print it.
                    </NoticeBox>
                  )}
                  {!data.prints_left && (
                    <NoticeBox mt={1}>
                      Printer empty. Insert a film cartridge to refill it. Saved
                      photos can still be viewed and new photos can still be
                      taken.
                    </NoticeBox>
                  )}
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
