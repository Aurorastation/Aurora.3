import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section, Table } from '../components';
import { NtosWindow } from '../layouts';
import { sortBy } from 'es-toolkit';

export type PowerData = {
  all_sensors: Sensor[];
  focus: SensorReading;
};

type Sensor = {
  name: string;
  alarm: BooleanLike;
};

type SensorReading = {
  name: string;
  error: string;
  alarm: BooleanLike;
  apc_data: APCData[];
  total_avail: string;
  total_used_apc: string;
  total_used_other: string;
  total_used_all: string;
  load_percentage: number;
};

type APCData = {
  s_equipment: string;
  s_lighting: string;
  s_environment: string;
  cell_charge: number;
  cell_status: number;
  total_load: string;
  name: string;
};

export const PowerMonitor = (props, context) => {
  const { act, data } = useBackend<PowerData>(context);

  return (
    <NtosWindow resizable width={800}>
      <NtosWindow.Content scrollable>
        {data.focus ? <SensorMonitoring /> : <ShowMasterList />}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const ShowMasterList = (props, context) => {
  const { act, data } = useBackend<PowerData>(context);

  return (
    <Section
      title="Sensor Monitoring"
      buttons={<Button content="Scan" onClick={() => act('refresh')} />}>
      {data.all_sensors && data.all_sensors.length ? (
        data.all_sensors.map((sensor) => (
          <Box key={sensor.name}>
            <Button
              content={sensor.name}
              color={sensor.alarm ? 'average' : ''}
              onClick={() => act('setsensor', { setsensor: sensor.name })}
            />
          </Box>
        ))
      ) : (
        <NoticeBox>No sensors found.</NoticeBox>
      )}
    </Section>
  );
};

export const SensorMonitoring = (props, context) => {
  const { act, data } = useBackend<PowerData>(context);
  const { apc_data = [] } = data.focus;
  const apcs_sorted: APCData[] = sortBy(apc_data, [
    (APCData: APCData) => APCData.name,
  ]);

  return (
    <Section
      title={'Network Information: ' + data.focus.name}
      buttons={<Button content="Return" onClick={() => act('clear')} />}>
      <LabeledList>
        <LabeledList.Item label="Network Load">
          {data.focus.load_percentage}%
        </LabeledList.Item>
        <LabeledList.Item label="Network Security Status">
          {data.focus.alarm ? <Box color="red">Abnormal</Box> : 'Optimal'}
        </LabeledList.Item>
        <LabeledList.Item label="Available Power">
          {data.focus.total_avail}
        </LabeledList.Item>
        <LabeledList.Item label="APC Power Usage">
          {data.focus.total_used_apc}
        </LabeledList.Item>
        <LabeledList.Item label="Other Power Usage">
          {data.focus.total_used_other}
        </LabeledList.Item>
        <LabeledList.Item label="Total Power Usage">
          {data.focus.total_used_all}
        </LabeledList.Item>
      </LabeledList>
      <Section title="Sensor Readings">
        <Table>
          <Table.Row header>
            <Table.Cell>APC Name</Table.Cell>
            <Table.Cell>Equipment</Table.Cell>
            <Table.Cell>Lighting</Table.Cell>
            <Table.Cell>Environment</Table.Cell>
            <Table.Cell>Cell Status</Table.Cell>
            <Table.Cell>APC Load</Table.Cell>
          </Table.Row>
          {apcs_sorted && apcs_sorted.length ? (
            apcs_sorted.map((apc) => (
              <Table.Row key={apc.name}>
                <Table.Cell>{apc.name}</Table.Cell>
                <Table.Cell>{apc.s_equipment}</Table.Cell>
                <Table.Cell>{apc.s_lighting}</Table.Cell>
                <Table.Cell>{apc.s_environment}</Table.Cell>
                <Table.Cell>
                  {apc.cell_status !== 0 ? (
                    <Box
                      color={
                        apc.cell_charge > 80
                          ? 'good'
                          : apc.cell_charge > 50
                            ? 'average'
                            : 'bad'
                      }>
                      {apc.cell_charge + '%'}
                    </Box>
                  ) : (
                    'Discharged'
                  )}
                </Table.Cell>
                <Table.Cell>{apc.total_load}</Table.Cell>
              </Table.Row>
            ))
          ) : (
            <NoticeBox>No APC detected.</NoticeBox>
          )}
        </Table>
      </Section>
    </Section>
  );
};
