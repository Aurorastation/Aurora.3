import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type Cell = {
  name: string;
  charge: number;
  charging: BooleanLike;
  ref: string;
};

type CellChargerRackData = {
  cells: Cell[];
  max_cells: number;
  operational: BooleanLike;
  current_cell_eta: number;
  all_cells_eta: number;
};

export const CellChargerRack = (props) => {
  const { act, data } = useBackend<CellChargerRackData>();

  return (
    <Window>
      <Window.Content scrollable>
        {!data.operational && (
          <NoticeBox danger>The charger is not operational.</NoticeBox>
        )}
        <Section title="Estimated Time Remaining">
          <LabeledList>
            <LabeledList.Item label="Current Cell">
              {formatEta(
                data.current_cell_eta,
                data.operational,
                data.cells.length,
              )}
            </LabeledList.Item>
            <LabeledList.Item label="All Cells">
              {formatEta(
                data.all_cells_eta,
                data.operational,
                data.cells.length,
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title={`Stored Batteries (${data.cells.length}/${data.max_cells})`}
        >
          {data.cells.length === 0 ? (
            <Box color="label">The rack is empty.</Box>
          ) : (
            <Stack vertical>
              {data.cells.map((cell) => (
                <Stack.Item key={cell.ref}>
                  <Stack align="center">
                    <Stack.Item grow>
                      <ProgressBar
                        value={cell.charge}
                        minValue={0}
                        maxValue={100}
                        ranges={{
                          good: [80, 100],
                          average: [20, 80],
                          bad: [0, 20],
                        }}
                      >
                        {cell.name}: {cell.charge.toFixed(1)}%
                        {cell.charging ? ' (Charging)' : ''}
                      </ProgressBar>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="eject"
                        content="Eject"
                        onClick={() => act('eject', { ref: cell.ref })}
                      />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              ))}
            </Stack>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};

const formatEta = (
  seconds: number,
  operational: BooleanLike,
  cellCount: number,
) => {
  if (cellCount === 0) {
    return 'No cells loaded';
  }
  if (seconds === 0) {
    return 'Charged';
  }

  const duration = formatDuration(seconds);
  return operational ? duration : `Paused (${duration} remaining)`;
};

const formatDuration = (totalSeconds: number) => {
  const seconds = Math.max(0, Math.ceil(totalSeconds));
  const hours = Math.floor(seconds / 3600);
  const minutes = Math.floor((seconds % 3600) / 60);
  const remainingSeconds = seconds % 60;

  if (hours > 0) {
    return `${hours}:${minutes.toString().padStart(2, '0')}:${remainingSeconds
      .toString()
      .padStart(2, '0')}`;
  }
  if (minutes > 0) {
    return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`;
  }
  return `${remainingSeconds}s`;
};
