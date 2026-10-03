import {
  Box,
  Button,
  Input,
  NoticeBox,
  Stack,
  TextArea,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { NtosWindow } from '../layouts';

type CameraData = {
  photo?: string;
  name: string;
  description: string;
  caption: string;
  error?: string;
  hasPrinter: BooleanLike;
  paper: number;
  maxNameLength: number;
  maxDescLength: number;
  maxCaptionLength: number;
};

export const NtosCamera = (props) => {
  const { act, data } = useBackend<CameraData>();

  return (
    <NtosWindow width={480} height={650}>
      <NtosWindow.Content scrollable>
        <Stack vertical fill>
          <Stack.Item>
            <NoticeBox>
              With this app open, use the PDA on a visible target to take a
              photograph. Captures are saved at 96×96 pixels for NanoPaint.
            </NoticeBox>
          </Stack.Item>
          {!!data.error && (
            <Stack.Item>
              <NoticeBox danger>{data.error}</NoticeBox>
            </Stack.Item>
          )}
          {data.photo ? (
            <>
              <Stack.Item>
                <Box textAlign="center">
                  <img
                    alt="Latest PDA camera capture"
                    src={`data:image/png;base64,${data.photo}`}
                    style={{ imageRendering: 'pixelated', maxWidth: '100%' }}
                  />
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Box bold mb={0.5}>
                  File name
                </Box>
                <Input
                  fluid
                  value={data.name}
                  maxLength={data.maxNameLength}
                  onChange={(value) => act('setName', { value })}
                />
              </Stack.Item>
              <Stack.Item>
                <Box bold mb={0.5}>
                  Description
                </Box>
                <TextArea
                  fluid
                  height="5rem"
                  value={data.description}
                  maxLength={data.maxDescLength}
                  onChange={(value) => act('setDescription', { value })}
                />
              </Stack.Item>
              <Stack.Item>
                <Box bold mb={0.5}>
                  Printed caption
                </Box>
                <Input
                  fluid
                  value={data.caption}
                  maxLength={data.maxCaptionLength}
                  onChange={(value) => act('setCaption', { value })}
                />
              </Stack.Item>
              <Stack.Item>
                <Stack justify="center">
                  <Stack.Item>
                    <Button icon="save" onClick={() => act('savePhoto')}>
                      Save PNG
                    </Button>
                  </Stack.Item>
                  {!!data.hasPrinter && (
                    <Stack.Item>
                      <Button
                        icon="print"
                        disabled={!data.paper}
                        onClick={() => act('printPhoto')}
                      >
                        Print Photo ({data.paper} paper)
                      </Button>
                    </Stack.Item>
                  )}
                </Stack>
              </Stack.Item>
            </>
          ) : (
            <Stack.Item grow>
              <Box textAlign="center" color="label" mt={8}>
                No photograph captured.
              </Box>
            </Stack.Item>
          )}
        </Stack>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
