import { Button, Icon, Section, Table, Tooltip } from 'tgui-core/components';
import { useBackend } from '../../backend';
import type { BooleanLike } from '../tgui-core/react';

type ManifestData = {
  manifest: { department: Crew[] };
  allow_follow: BooleanLike;
};

type Crew = {
  name: string;
  rank: string;
  active: string;
  head: BooleanLike;
};

export const ManifestSection = (props) => {
  const { act, data } = useBackend<ManifestData>();
  const manifest = data.manifest || {};
  const allow_follow = data.allow_follow;
  return (
    <Section>
      {Object.keys(manifest).length === 0 && 'There are no crew active.'}
      {Object.keys(manifest).map((dept) => {
        const deptCrew = manifest[dept];
        return (
          <Section
            key={dept}
            title={dept}
            textAlign="center"
            className={'border-dept-' + dept.toLowerCase()}
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
