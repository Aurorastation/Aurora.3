import { useBackend } from '../backend';
import { Box, Section, Table } from 'tgui-core/components';
import { Window } from '../layouts';

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

export const HivenetManifest = (props) => {
  const { act, data } = useBackend<HivenetManifestData>();

  return (
    <Window theme="vaurca">
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
                    <Table.Row
                      pb={1}
                      key={vaurca.name}
                      bold={vaurca.bold}
                      overflow="hidden">
                      <Table.Cell>
                        <Box fontSize="1.5rem" textAlign="center">
                          {' - '}
                          {vaurca.name}
                          {' - '}
                        </Box>
                      </Table.Cell>
                    </Table.Row>
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
