import { BooleanLike } from 'common/react';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export type OdysseyData = {
  scenario_name: string;
  scenario_desc: string;
  scenario_canonicity: string;
  is_storyteller: BooleanLike;

  scenario_roles: Role[];
};

type Role = {
  name: string;
  desc: string;
  outfit: string;
  type: string;
};

export const OdysseyPanel = (props, context) => {
  const { act, data } = useBackend<OdysseyData>(context);

  return (
    <Window resizable theme="admin" width={500} height={600}>
      <Window.Content scrollable>
        <Section
          title={
            <Button
              content={data.scenario_name}
              icon="pencil"
              color="green"
              tooltip="Edit Name"
              disabled={!data.is_storyteller}
              onClick={() => act('edit_scenario_name')}
            />
          }>
          {data.scenario_desc}{' '}
          <Button
            icon="pencil"
            color="green"
            tooltip="Edit Description"
            disabled={!data.is_storyteller}
            onClick={() => act('edit_scenario_desc')}
          />
          <NoticeBox danger>
            This is a{' '}
            <Box
              as="span"
              color={
                data.scenario_canonicity === 'Non-Canon' ? 'orange' : 'green'
              }>
              {data.scenario_canonicity}
            </Box>{' '}
            scenario. Please remember that the one thing you cannot change about
            the round is its canonicity! Stay within the bounds of the
            scenario&apos;s intended canon status.
          </NoticeBox>
        </Section>
        {data.scenario_roles && data.scenario_roles.length ? (
          <RoleDisplay />
        ) : (
          <NoticeBox>There are no roles for this scenario.</NoticeBox>
        )}
      </Window.Content>
    </Window>
  );
};

export const RoleDisplay = (props, context) => {
  const { act, data } = useBackend<OdysseyData>(context);

  return (
    <Section title="Roles">
      <NoticeBox info>
        You are not beholden to following the role names and descriptions. You
        can use their equipment and change up the premises or what your
        objective is as you like! These are just guidelines in the end, or how
        the author envisioned the story. Your creativity is the limit!
      </NoticeBox>
      <NoticeBox color="grey">
        You are not locked into the first outfit you equip, you can try
        different outfits. Some roles also have outfits with randomly picked
        items, and you can equip the same outfit multiple times to see the
        different variations.
      </NoticeBox>
      {data.scenario_roles.map((role) => (
        <Section
          title={
            data.is_storyteller ? (
              <Button
                content={role.name}
                icon="pencil"
                color="red"
                tooltip="Edit Role Name"
                disabled={!data.is_storyteller}
                onClick={() =>
                  act('edit_role', { new_name: 1, role_type: role.type })
                }
              />
            ) : (
              <Box as="span">{role.name}</Box>
            )
          }
          key={role.name}
          buttons={
            !data.is_storyteller ? (
              <Button
                content="Equip"
                color="green"
                disabled={data.is_storyteller}
                icon="star"
                onClick={() =>
                  act('equip_outfit', { outfit_type: role.outfit })
                }
              />
            ) : (
              ''
            )
          }>
          {role.desc}{' '}
          {data.is_storyteller ? (
            <Button
              icon="pencil"
              color="green"
              disabled={!data.is_storyteller}
              onClick={() =>
                act('edit_role', { new_desc: 1, role_type: role.type })
              }
            />
          ) : (
            ''
          )}
          {data.is_storyteller ? (
            <LabeledList>
              <LabeledList.Item label="Outfit">
                <Button
                  content={role.outfit}
                  icon="pencil"
                  color="blue"
                  onClick={() =>
                    act('edit_role', { edit_outfit: 1, role_type: role.type })
                  }
                />
              </LabeledList.Item>
            </LabeledList>
          ) : (
            ''
          )}
        </Section>
      ))}
    </Section>
  );
};
