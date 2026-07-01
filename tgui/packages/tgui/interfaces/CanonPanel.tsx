import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type CanonData = {
  name: string;
  desc: string;

  round_canon_info: string[];
  antagonist_actions_canon_info: string[];
  character_death_canon_info: string[];

  is_storyteller: BooleanLike;
  is_admin: BooleanLike;
};

export const CanonPanel = (props) => {
  const { act, data } = useBackend<CanonData>();
  return (
    <Window theme="admin">
      <Window.Content scrollable>
        <Section
          title="Canon Panel"
          buttons={
            data.is_admin ? (
              <Button
                content="Edit"
                icon="pencil"
                disabled={!data.is_admin && !data.is_storyteller}
                onClick={() => act('edit_round_canon_type')}
              />
            ) : undefined
          }
        >
          <NoticeBox color="red">
            This round's canonicity is {data.name}.
          </NoticeBox>
          <Box italic>{data.desc}</Box>
          <Section title="Round Canon">
            <LabeledList>
              {data.round_canon_info.map((info, index) => (
                <LabeledList.Item key={index} label={index + 1}>
                  {info}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
          <Section title="Antagonist Actions">
            <LabeledList>
              {data.antagonist_actions_canon_info.map((info, index) => (
                <LabeledList.Item key={index} label={index + 1}>
                  {info}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
          <Section title="Character Deaths">
            <LabeledList>
              {data.character_death_canon_info.map((info, index) => (
                <LabeledList.Item key={index} label={index + 1}>
                  {info}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </Section>
        </Section>
      </Window.Content>
    </Window>
  );
};
