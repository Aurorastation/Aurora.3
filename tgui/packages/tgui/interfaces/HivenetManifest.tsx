import { useBackend } from '../backend';
import { Box, Divider, NoticeBox, ProgressBar, Section, Table } from '../components';
import { capitalize } from '../../common/string';
import { Window } from '../layouts';
import { TableCell, TableRow } from '../components/Table';

export type VaurcaData = {
  name: string;
  bold: boolean;
};

export type VaurcaListData = {
  vaurca: VaurcaData[];
  color: string;
};

export type HivenetManifestData = {
  all_vaurca: VaurcaListData[];
};

export const HivenetManifest = (props, context) => {
  const { act, data } = useBackend<HivenetManifestData>(context);

  return (
    <Window resizable theme="vaurca">
      <Window.Content scrollable>
        {Object.keys(data.all_vaurca).map((hive) => {
          const hiveData = data.all_vaurca[hive];
          return hiveData.vaurca.length ? (
            <Section
              key={hive}
              title={hive}
              textAlign="center"
              className={'border-dept-' + hiveData.color.toLowerCase()}
              backgroundColor="rgba(10, 10, 10, 0.7)">
              <Table>
                {hiveData.vaurca.map((vaurca) => {
                  return (
                    <TableRow
                      pb={1}
                      key={vaurca.name}
                      bold={vaurca.bold}
                      overflow="hidden">
                      <TableCell>
                        <Box fontSize="1.5rem" textAlign="center">
                          {' - '}
                          {vaurca.name}
                          {' - '}
                        </Box>
                      </TableCell>
                    </TableRow>
                  );
                })}
              </Table>
            </Section>
          ) : null;
        })}
      </Window.Content>
    </Window>
  );
};
