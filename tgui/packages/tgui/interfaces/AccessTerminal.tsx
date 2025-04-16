import { useBackend } from '../backend';
import { Window } from '../layouts';
import { BooleanLike } from '../../common/react';
import { Button, LabeledList, NoticeBox, Section } from '../components';

export type AccessTerminalData = {
  is_card_in: BooleanLike;
  card_name: string;
  card_assignment: string;
  card_rank: string;
  is_agent_id: BooleanLike;
  available_accesses: { desc: string; id: number }[];
  card_accesses: number[];
};

export const AccessTerminal = (props, context) => {
  const { act, data } = useBackend<AccessTerminalData>(context);

  return (
    <Window resizable>
      <Window.Content scrollable>
        <Section
          title="Inserted ID Card"
          buttons={
            data.is_card_in ? (
              <Button content="Eject Card" onClick={() => act('eject_id')} />
            ) : (
              <Button content="Insert Card" onClick={() => act('insert_id')} />
            )
          }>
          {data.is_card_in ? (
            <LabeledList>
              <LabeledList.Item label="Registered Name">
                {data.card_name}
              </LabeledList.Item>
              <LabeledList.Item label="Assignment">
                {data.card_assignment}
              </LabeledList.Item>
              <LabeledList.Item label="Rank">{data.card_rank}</LabeledList.Item>
              {data.is_agent_id ? (
                <LabeledList.Item label="Agent ID?">YES</LabeledList.Item>
              ) : (
                ''
              )}
            </LabeledList>
          ) : (
            <NoticeBox>Error! No ID Card Found</NoticeBox>
          )}
        </Section>
        <Section title="ID Card Accesses">
          <LabeledList>
            {data.available_accesses
              ?.filter((a) => data.card_accesses.includes(a.id))
              .map((access) => (
                <LabeledList.Item label={access.desc} key={access.id}>
                  <Button
                    content="Remove from Card"
                    onClick={() =>
                      act('toggle_access', { toggle_access: access.id })
                    }
                  />
                </LabeledList.Item>
              ))}
          </LabeledList>
        </Section>
        <Section title="Available Accesses">
          {data.available_accesses
            ?.filter((a) => !data.card_accesses.includes(a.id))
            .map((access) => (
              <LabeledList.Item label={access.desc} key={access.id}>
                <Button
                  content="Add to Card"
                  onClick={() =>
                    act('toggle_access', { toggle_access: access.id })
                  }
                />
              </LabeledList.Item>
            ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
