import { useBackend } from '../backend';
import { Section, Box, LabeledList } from '../components';
import { capitalize } from '../../common/string';

export type AtmosData = {
  sensors: Sensor[];
  maxrate: number;
  maxpressure: number;
};

type Sensor = {
  id_tag: string;
  name: string;
  datapoints: Datapoint[];
};

type Datapoint = {
  datapoint: string;
  data: string;
  unit: string;
};

export const AtmosControl = (props, context) => {
  const { act, data } = useBackend<AtmosData>(context);
  return (
    <Section title="Sensor Data">
      {data.sensors.length ? <SensorData /> : 'No sensors connected.'}
    </Section>
  );
};

export const SensorData = (props, context) => {
  const { act, data } = useBackend<AtmosData>(context);
  return (
    <Section>
      {data.sensors.map((sensor) => (
        <Box bold key={sensor.id_tag}>
          {sensor.name}
          <LabeledList>
            {sensor.datapoints.map((datapoint) =>
              datapoint.data !== null ? (
                <LabeledList.Item
                  key={datapoint.datapoint}
                  label={capitalize(datapoint.datapoint)}>
                  {datapoint.data} {datapoint.unit}
                </LabeledList.Item>
              ) : (
                ''
              )
            )}
          </LabeledList>
        </Box>
      ))}
    </Section>
  );
};
