import { Window } from '../layouts';
import { Button } from '../components';
import { useBackend } from '../backend';

export type ConsciousnessExchangerData = {
  linked_target: string;
  jolt_before_transfer: boolean;
  jolt_after_transfer: boolean;
};

export const ConsciousnessExchanger = (props, context) => {
  const { act, data } = useBackend<ConsciousnessExchangerData>(context);
  // const { programs = [], services = [] } = data;
  return (
    <Window
      resizable
      theme="zenghu"
      title={'Exchange Device Configuration'}
      width={400}
      height={500}>
      <Window.Content scrollable>
        {data.linked_target
          ? 'Linked Target: ' + data.linked_target
          : 'No Linked Target'}
        <br />
        <ToggleJoltBeforeButton />
        <br />
        <ToggleJoltAfterButton />
        <br />
      </Window.Content>
    </Window>
  );
};

export const ToggleJoltBeforeButton = (props, context) => {
  const { act, data } = useBackend<ConsciousnessExchangerData>(context);
  return (
    <Button onClick={() => act('toggleJoltBefore')}>
      {data.jolt_before_transfer ? 'Jolt' : "Don't Jolt"} Before
    </Button>
  );
};

export const ToggleJoltAfterButton = (props, context) => {
  const { act, data } = useBackend<ConsciousnessExchangerData>(context);
  return (
    <Button onClick={() => act('toggleJoltAfter')}>
      {data.jolt_after_transfer ? 'Jolt' : "Don't Jolt"} After
    </Button>
  );
};
