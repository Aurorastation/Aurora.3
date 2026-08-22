import type { CSSProperties } from 'react';

import { Box, Section, Table } from 'tgui-core/components';
import { useBackend } from '../backend';
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
  all_vaurca: Record<string, VaurcaListData>;
};

type HiveColorStyle = CSSProperties & {
  '--hive-color': string;
};

export const HivenetManifest = () => {
  const { data } = useBackend<HivenetManifestData>();

  return (
    <Window theme="vaurca">
      <Window.Content scrollable>
        {Object.entries(data.all_vaurca || {}).map(([hive, hiveData]) => {
          return hiveData.vaurca.length ? (
            <Section
              key={hive}
              title={hive}
              textAlign="center"
              className="HivenetManifest__Hive"
              style={{ '--hive-color': hiveData.color } as HiveColorStyle}
              backgroundColor="rgba(10, 10, 10, 0.7)"
            >
              <Table>
                {hiveData.vaurca.map((vaurca) => {
                  return (
                    <Table.Row
                      pb={1}
                      key={vaurca.name}
                      bold={vaurca.bold}
                      overflow="hidden"
                    >
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
