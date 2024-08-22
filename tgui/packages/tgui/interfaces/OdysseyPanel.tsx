import { useBackend } from '../backend';
import { Button, NoticeBox, Section } from '../components';
import { Window } from '../layouts';

export type OdysseyData = {
  scenario_name: string;
  scenario_desc: string;
  scenario_canonicity: string;

  scenario_roles: Role[];
};

type Role = {
  name: string;
  desc: string;
  outfit: string;
};

export const OdysseyPanel = (props, context) => {
  const { act, data } = useBackend<OdysseyData>(context);

  return (
    <Window resizable theme="malfunction" width={500} height={600}>
      <Window.Content scrollable>
        <Section title={data.scenario_name}>
          <NoticeBox>{data.scenario_desc}</NoticeBox>
          This is a {data.scenario_canonicity} scenario.
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
      <NoticeBox>
        Remember that you are not beholden to following the role names and
        descriptions. You can use their equipment and change up the premises or
        what your objective is as you like! These are just guidelines in the
        end, or how the developer envisioned the story. Your creativity is the
        limit!
      </NoticeBox>
      {data.scenario_roles.map((role) => (
        <Section
          title={role.name}
          key={role.name}
          buttons={
            <Button
              content="Equip"
              color="green"
              icon="star"
              onClick={() => act('equip_outfit', { outfit_type: role.outfit })}
            />
          }>
          {role.desc}
        </Section>
      ))}
    </Section>
  );
};
