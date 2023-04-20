import { BooleanLike } from '../../../common/react';
import { useBackend } from '../../backend';
import { Icon, Section, Table, Tooltip } from '../../components';
import { TableCell, TableRow } from '../../components/Table';

type ManifestData = {
  manifest: { department: Crew[] };
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
