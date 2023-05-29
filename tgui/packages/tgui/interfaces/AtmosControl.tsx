import { useBackend } from '../backend';
import { Section } from '../components';
import { Window } from '../layouts';

export type AtmosData = {
  sensors: Sensor[];
  control: string;
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
};

export const AtmosControl = (props, context) => {
  const { act, data } = useBackend<AtmosData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section title="Title" />
      </Window.Content>
    </Window>
  );
};
