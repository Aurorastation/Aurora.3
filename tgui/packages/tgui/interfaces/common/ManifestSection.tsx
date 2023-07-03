import { BooleanLike } from '../../../common/react';
import { useBackend } from '../../backend';
import { Button, Icon, Section, Table, Tooltip } from '../../components';
import { TableCell, TableRow } from '../../components/Table';

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

export const ManifestSection = (props, context) => {
  const { act, data } = useBackend<ManifestData>(context);
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
            backgroundColor="rgba(10, 10, 10, 0.75)">
            <Table>
              {deptCrew.map((crewmate) => {
                return (
                  <TableRow
                    key={crewmate.name}
                    bold={crewmate.head}
                    overflow="hidden">
                    <TableCell width="50%" textAlign="center" pt="10px" nowrap>
                      {crewmate.name}
                    </TableCell>
                    <TableCell
                      width="45%"
                      textAlign="right"
                      pr="2%"
                      pt="10px"
                      nowrap>
                      {crewmate.rank}
                    </TableCell>
                    <TableCell textAlign="right" width="5%" pr="3%" pt="10px">
                      <Tooltip content={crewmate.active}>
                        <Icon
                          name="circle"
                          className={
                            'manifest-indicator-' +
                            crewmate.active.toLowerCase()
                          }
                        />
                      </Tooltip>
                    </TableCell>
                    {allow_follow ? (
                      <TableCell textAlign="right">
                        <Tooltip content="Follow Mob">
                          <Button
                            content="F"
                            onClick={() =>
                              act('follow', { name: crewmate.name })
                            }
                          />
                        </Tooltip>
                      </TableCell>
                    ) : (
                      ''
                    )}
                  </TableRow>
                );
              })}
            </Table>
          </Section>
        );
      })}
    </Section>
  );
};
