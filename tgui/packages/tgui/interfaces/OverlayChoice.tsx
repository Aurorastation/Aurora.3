import { useBackend } from '../backend';
import { Box, Button, Flex, Section } from '../components';
import { Window } from '../layouts';

export type IconData = {
  contents: Item[];
};

export type Item = {
  display_name: string;
  icon?: string | null;
  icon_name: string;
  singleton_path: string;
};

export const OverlayChoice = (props, context) => {
  const { act, data } = useBackend<IconData>(context);

  return (
    <Window width={500} height={500}>
      <Window.Content scrollable>
        <Section title="Choose your overlay">
          <Box
            style={{
              color: 'rgba(255,255,255,0.4)',
            }}
          >
            {data.contents ? <ContentsWindow /> : 'No contents loaded.'}
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};

export const ContentsWindow = (props, context) => {
  const { act, data } = useBackend<IconData>(context);
  const { contents } = data;

  return (
    <Flex wrap="wrap" gap="8px">
      {contents.map((item) => (
        <Flex.Item
          key={`${item.icon}-${item.display_name}`}
          style={{ width: 'calc(25% - 5px)' }}
        >
          <Button
            fluid
            color="transparent"
            onClick={() =>
              act('select_overlay', {
                choice: item.icon_name,
                singleton_path: item.singleton_path,
              })
            }
            style={{
              height: '100%',
              padding: '8px 0',
              border: '1px solid rgba(255,255,255,0.07)',
              borderRadius: '4px',
              background: 'rgba(255,255,255,0.03)',
              transition: 'border-color 0.15s, background 0.15s',
            }}
          >
            <Flex
              direction="column"
              align="center"
              justify="center"
              width="100%"
            >
              {/* Icon Container */}
              <Flex.Item
                style={{
                  height: '40px',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  marginBottom: '6px',
                }}
              >
                {item.icon ? (
                  <Box
                    as="img"
                    src={`data:image/png;base64,${item.icon}`}
                    style={{
                      width: '64px',
                      height: '32px',
                      imageRendering: 'pixelated',
                      margin: '0 auto 4px auto',
                    }}
                  />
                ) : null}
              </Flex.Item>

              {/* Label Container */}
              <Flex.Item width="100%" textAlign="center">
                <Box
                  style={{
                    fontSize: '10px',
                    lineHeight: '1.1',
                    wordBreak: 'break-word',
                    whiteSpace: 'normal',
                    margin: '0 auto',
                  }}
                >
                  {item.display_name}
                </Box>
              </Flex.Item>
            </Flex>
          </Button>
        </Flex.Item>
      ))}
    </Flex>
  );
};
