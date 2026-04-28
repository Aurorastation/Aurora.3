import { useBackend } from '../backend';
import { Box, Button, LabeledList, ProgressBar, Section } from '../components';
import { round } from 'common/math';
import { Window } from '../layouts';
import { BooleanLike } from '../../common/react';

type Data = {
  scan_progress: number;
  scanning: BooleanLike;
  bloodsamp: string;
  bloodsamp_desc: string;
  lid_closed: BooleanLike;
};

export const DnaForensics = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const hasItem = !!data.bloodsamp;

  return (
    <Window width={540} height={326}>
      <Window.Content>
        <Section title="Machine Status">
          <LabeledList>
            <LabeledList.Item label="Controls">
              <Button
                icon="signal"
                disabled={!hasItem || !data.lid_closed}
                onClick={() => act('scanItem')}
              >
                {data.scanning ? 'Halt Scan' : 'Begin Scan'}
              </Button>

              <Button
                icon={data.lid_closed ? 'unlock' : 'lock'}
                onClick={() => act('toggleLid')}
              >
                {data.lid_closed ? 'Open Lid' : 'Close Lid'}
              </Button>

              <Button
                icon="eject"
                disabled={!hasItem || data.scanning || data.lid_closed}
                onClick={() => act('ejectItem')}
              >
                Eject swab
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>

        <Section title="Scanner">
          <LabeledList>
            <LabeledList.Item label="Scan progress">
              <ProgressBar
                value={data.scan_progress}
                minValue={0}
                maxValue={100}
              />
              <Box mt={0.5}>{round(data.scan_progress, 1)}%</Box>
            </LabeledList.Item>
            {data.scan_progress >= 100 && (
              <LabeledList.Item>
                <Box color="good">Scan completed successfully.</Box>
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>

        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Item">
              {hasItem ? (
                <Box color="good">{data.bloodsamp}</Box>
              ) : (
                <Box color="bad">No item inserted</Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Heuristic analysis">
              {data.bloodsamp_desc ? (
                <Box color="average">{data.bloodsamp_desc}</Box>
              ) : (
                <Box />
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
