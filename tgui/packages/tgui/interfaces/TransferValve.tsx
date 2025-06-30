import { useBackend } from '../backend';
import { Button, Section, LabeledList, Flex } from '../components';
import { Window } from '../layouts';
import { BooleanLike } from '../../common/react';

export type TransferValveData = {
  tankOne: String[];
  tankTwo: String[];
  valveAttachment: String[];
  valveOpen: BooleanLike;
};

export const TransferValve = (props, context) => {
  const { act, data } = useBackend<TransferValveData>(context);

  return (
    <Window resizable>
      <Window.Content>
        <Flex direction="row" align="stretch">
          <Flex.Item grow={1}>
            <Section fill title="Tank 1">
              <LabeledList>
                <LabeledList.Item label="Name">
                  {data.tankOne ? data.tankOne : 'NOT ATTACHED'}
                </LabeledList.Item>
                <LabeledList.Item label="Actions">
                  <Button
                    content="Interact"
                    disabled={!data.tankOne}
                    onClick={() => act('interact', { object: 'tankOne' })}
                  />
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button
                    content="Detach"
                    disabled={!data.tankOne}
                    onClick={() => act('remove', { object: 'tankOne' })}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Flex.Item>
          <Flex.Item grow={1}>
            <Section fill title="Valve Attachment">
              <LabeledList>
                <LabeledList.Item label="Name">
                  {data.valveAttachment ? data.valveAttachment : 'NOT ATTACHED'}
                </LabeledList.Item>
                <LabeledList.Item label="Actions">
                  <Button
                    content="Interact"
                    disabled={!data.valveAttachment}
                    onClick={() => act('interact', { object: 'device' })}
                  />
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button
                    content="Detach"
                    disabled={!data.valveAttachment}
                    onClick={() => act('remove', { object: 'device' })}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Flex.Item>
          <Flex.Item grow={1}>
            <Section fill title="Tank 2">
              <LabeledList>
                <LabeledList.Item label="Name">
                  {data.tankTwo ? data.tankTwo : 'NOT ATTACHED'}
                </LabeledList.Item>
                <LabeledList.Item label="Actions">
                  <Button
                    content="Interact"
                    disabled={!data.tankTwo}
                    onClick={() => act('interact', { object: 'tankTwo' })}
                  />
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button
                    content="Detach"
                    disabled={!data.tankTwo}
                    onClick={() => act('remove', { object: 'tankTwo' })}
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
