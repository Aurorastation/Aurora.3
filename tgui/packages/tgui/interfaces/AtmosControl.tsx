import { useBackend } from '../backend';
import { Section, LabeledList, NoticeBox } from '../components';
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

export const AtmosControl = (props) => {
  const { act, data } = useBackend<AtmosData>();
  return data.sensors.length ? (
    <SensorData />
  ) : (
    <NoticeBox>No sensors connected.</NoticeBox>
  );
};

export const SensorData = (props) => {
  const { act, data } = useBackend<AtmosData>();
  return (
    <>
      {data.sensors.map((sensor) => (
        <Section title={sensor.name} key={sensor.id_tag}>
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
        </Section>
      ))}
    </>
  );
};
