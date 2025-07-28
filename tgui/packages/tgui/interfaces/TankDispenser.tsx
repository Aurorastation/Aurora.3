import { useBackend } from '../backend';
import { Button, Flex, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export type TankDispenserData = {
  tanks_oxygen: number;
  tanks_phoron: number;
};

export const TankDispenser = (props, context) => {
  const { act, data } = useBackend<TankDispenserData>(context);

  return (
    <Window width="321" height="132">
      <Window.Content>
        <Flex direction="row" align="stretch">
          <Flex.Item grow={1}>
            <Section fill title="Oxygen Tanks">
              <LabeledList>
                <LabeledList.Item label="Inventory">
                  {data.tanks_oxygen ? data.tanks_oxygen : 'NO TANKS'}
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button
                    content="Dispense"
                    disabled={data.tanks_oxygen === 0}
                    onClick={() => act('dispense_oxygen')}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Flex.Item>
          <Flex.Item grow={1}>
            <Section fill title="Phoron Tanks">
              <LabeledList>
                <LabeledList.Item label="Inventory">
                  {data.tanks_phoron ? data.tanks_phoron : 'NO TANKS'}
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button
                    content="Dispense"
                    disabled={data.tanks_phoron === 0}
                    onClick={() => act('dispense_phoron')}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};
