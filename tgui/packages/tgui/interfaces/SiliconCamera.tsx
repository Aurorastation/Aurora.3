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
  local: BooleanLike;
};

type SiliconCameraData = {
  on: BooleanLike;
  focus: number;
  photos: CameraPhoto[];
};

export const SiliconCamera = () => {
  const { act, data } = useBackend<SiliconCameraData>();
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
            <Section title="Integrated Digital Camera">
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
                Gallery: {data.photos.length} photos. Use a photocopier to print.
              </Box>
            </Section>
          </Stack.Item>
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
                      <Button.Confirm
                        key={selected.id}
                        icon="trash"
                        disabled={!selected.local}
                        color="bad"
                        onClick={() => act('delete', { id: selected.id })}
                      >
                        Delete
                      </Button.Confirm>
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
                      Enable capture, then click a subject to save a photo. View
                      saved photos here and use a photocopier to print them.
                    </NoticeBox>
                  )}
                  {selected && !selected.local && (
                    <NoticeBox mt={1}>
                      This photo is stored in the connected AI's album. Only
                      local photos can be deleted here.
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
