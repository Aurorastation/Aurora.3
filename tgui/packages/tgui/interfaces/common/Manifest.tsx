import { BooleanLike } from '../../../common/react';
import { useBackend } from '../../backend';
import { Section, Table } from '../../components';
import { TableCell, TableRow } from '../../components/Table';

type ManifestData = {
  manifest: { department: Crew[] };
};

type Crew = {
  name: string;
  rank: string;
  active: BooleanLike;
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
          <Section key={dept} title={dept} textAlign="center">
            <Table>
              {deptCrew.map((crewmate) => {
                return (
                  <TableRow key={crewmate.name}>
                    <TableCell width="50%">{crewmate.name}</TableCell>
                    <TableCell width="35%">{crewmate.rank}</TableCell>
                    <TableCell>{crewmate.active}</TableCell>
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
