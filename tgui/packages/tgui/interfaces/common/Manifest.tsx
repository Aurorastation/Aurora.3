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

export const Manifest = (props, context) => {
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
            className={'border-dept-' + dept.toLowerCase()}>
            <Table>
              {deptCrew.map((crewmate) => {
                return (
                  <TableRow key={crewmate.name} bold={crewmate.head}>
                    <TableCell width="50%" overflow="hidden">
                      {crewmate.name}
                    </TableCell>
                    <TableCell width="50%" overflow="hidden">
                      {crewmate.rank}
                    </TableCell>
                    <TableCell textAlign="right">
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
                        <Tooltip content="Follow mob">
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
