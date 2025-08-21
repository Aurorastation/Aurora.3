import { useBackend } from '../backend';
import { Table, Section, Box, Button, LabeledList, Flex } from '../components';
import { Window } from '../layouts';

export type MobTrackerData = {
  areas_containing_mobs: Record<string, number>;
  areas_containing_objects: Record<string, number>;
  tgui_theme: string;
  description_text: string;
};

export const MobTracker = (props, context) => {
  const { act, data } = useBackend<MobTrackerData>(context);

  const totalEntities = Object.values(data.areas_containing_mobs || {})
    .reduce((sum, count) => sum + count, 0);

  const totalObjects = Object.values(data.areas_containing_objects || {})
    .reduce((sum, count) => sum + count, 0);

  return (
    <Window resizable theme={ data.tgui_theme || 'default' }>
      <Window.Content scrollable>
        <Section
        fontFamily="monospace"
        style={{
          padding: '8px',
          lineHeight: '1.2'
        }}
        >
        <Box>
          <div dangerouslySetInnerHTML={{ __html: data.description_text }} />
        </Box>
        </Section>
        <Flex direction="row" align="stretch">
          <Flex.Item grow={1}>
            <Section
              fill title="System Status"
              fontFamily="monospace"
              style={{
                padding: '8px',
                lineHeight: '1.2'
              }}
            >
              <LabeledList>
                <LabeledList.Item label="SCANNED AREAS">
                  {Object.keys(data.areas_containing_mobs || {}).length}
                </LabeledList.Item>
                <LabeledList.Item label="DETECTED ENTITIES">
                  {totalEntities}
                </LabeledList.Item>
                <LabeledList.Item label="SCANNER STATUS">
                  ONLINE
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Flex.Item>
          <Flex.Item grow={2}>
            <Section
              fill title="Facility-wide Sensors"
              fontFamily="monospace"
              style={{
                padding: '8px',
                lineHeight: '1.2'
              }}
              buttons={
                <>
                  <Button
                    content="Refresh"
                    icon="refresh"
                    onClick={() => act('refresh_the_ui')}
                  />
                </>
              }>
              <LabeledList>
                {Object.entries(data.areas_containing_mobs || {}).map(([areaName, count]) => (
                  <LabeledList.Item
                    label={areaName.toUpperCase().padEnd(20)} color={count >= 5 ? 'red' : 'yellow'}
                  >
                    {count} ENTITY(S) FOUND
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </Section>
          </Flex.Item>
        </Flex>

        <Flex direction="row" align="stretch">
          <Flex.Item grow={1}>
            <Section
              fill title="System Status"
              fontFamily="monospace"
              style={{
                padding: '8px',
                lineHeight: '1.2'
              }}
            >
              <LabeledList>
                <LabeledList.Item label="SCANNED AREAS">
                  {Object.keys(data.areas_containing_objects || {}).length}
                </LabeledList.Item>
                <LabeledList.Item label="DETECTED OBJECTS">
                  {totalObjects}
                </LabeledList.Item>
                <LabeledList.Item label="SCANNER STATUS">
                  ONLINE
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Flex.Item>
          <Flex.Item grow={2}>
            <Section
              fill title="Tracking Sensors"
              fontFamily="monospace"
              style={{
                padding: '8px',
                lineHeight: '1.2'
              }}>
              <LabeledList>
                {Object.entries(data.areas_containing_objects || {}).map(([areaName, count]) => (
                  <LabeledList.Item
                    label={areaName.toUpperCase().padEnd(20)}
                  >
                    {count} OBJECT(S) FOUND
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};
