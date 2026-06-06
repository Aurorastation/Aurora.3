import { Button, Icon, Section, Table, Tooltip } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../../backend';
import { departmentClass, departmentStyle } from './departmentClass';

type ManifestData = {
  manifest: Record<string, Crew[]>;
  allow_follow: BooleanLike;
  show_ooc_roles: BooleanLike;
};

type Crew = {
  name: string;
  rank: string;
  active: string;
  head: BooleanLike;
  ooc_role: BooleanLike;
};

export const ManifestSection = (props) => {
  const { act, data } = useBackend<ManifestData>();
  const manifest = data.manifest || {};
  const allow_follow = data.allow_follow;
  const show_ooc_roles = data.show_ooc_roles;
  const manifestEntries = Object.entries(manifest)
    .map(([dept, crew]) => [
      dept,
      show_ooc_roles ? crew : crew.filter((crewmate) => !crewmate.ooc_role),
    ] as const)
    .filter(([, crew]) => crew.length > 0);
  return (
    <Section>
      {manifestEntries.length === 0 && 'There are no crew active.'}
      {manifestEntries.map(([dept, deptCrew]) => {
        return (
          <Section
            key={dept}
            title={dept}
            textAlign="center"
            className={departmentClass()}
            style={departmentStyle(dept)}
            backgroundColor="rgba(10, 10, 10, 0.75)"
          >
            <Table>
              {deptCrew.map((crewmate) => {
                return (
                  <Table.Row
                    key={crewmate.name}
                    bold={crewmate.head}
                    overflow="hidden"
                  >
                    <Table.Cell width="50%" textAlign="center" pt="10px" nowrap>
                      {crewmate.name}
                    </Table.Cell>
                    <Table.Cell
                      width="45%"
                      textAlign="right"
                      pr="2%"
                      pt="10px"
                      nowrap
                    >
                      {crewmate.rank}
                    </Table.Cell>
                    <Table.Cell textAlign="right" width="5%" pr="3%" pt="10px">
                      <Tooltip content={crewmate.active}>
                        <Icon
                          name="circle"
                          className={
                            'manifest-indicator-' +
                            crewmate.active
                              .toLowerCase()
                              .replace(/\*/g, '') // removes asterisks
                              .replace(/\s/g, '-') // replaces spaces with a dash
                              .replace(/:.*?$/, '') // matches and removes : to the end of the string, so it catches Away Mission(: ShuttleName)
                          }
                        />
                      </Tooltip>
                    </Table.Cell>
                    {allow_follow ? (
                      <Table.Cell textAlign="right">
                        <Tooltip content="Follow Mob">
                          <Button
                            content="F"
                            onClick={() =>
                              act('follow', { name: crewmate.name })
                            }
                          />
                        </Tooltip>
                      </Table.Cell>
                    ) : (
                      ''
                    )}
                  </Table.Row>
                );
              })}
            </Table>
          </Section>
        );
      })}
    </Section>
  );
};
